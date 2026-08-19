
function [UserVar,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=...
    DefineInputsForInverseRun(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo)

%%
% *Note: This m-file is just an example of how to define inputs for an inverse run. You will need to modify to fit your own problem.*
%
% What you need to define are:
%
%
% # Measurements and data errors (data errors are specified as diagonal covariance matrices.)
% # Start values for inversion. (These are some values for the model parameters that you want to invert for.)
% # Priors for the inverted fields. (Currently the only priors that are used the the priors for C and AGlen.)
%
%
%%

%% Define true A and C fields

% Sinusoidal perturbation in A
n=1 ;
eta0=1/(2*UserVar.AGlen0);

Lx=max(F.x)-min(F.x); Ly=max(F.y)-min(F.y); 


if contains(CtrlVar.Inverse.InvertFor,"A") % only add perturbation to A, if inverting for A
    phase = pi;
    nx=UserVar.nxA; ny=UserVar.nyA;
    deta = UserVar.ampl_eta.*eta0.*sin(2*pi*nx*F.x/Lx + 2*pi*ny*F.y/Ly+phase);
    deta=deta-mean(deta(:));
    
else
    deta=zeros(MUA.Nnodes,1);
end

eta=eta0+deta;

Priors.TrueAGlen=1./(2.*eta);
Priors.Truen=n;

% Sinusoidal perturbation in C

m=1;

if contains(CtrlVar.Inverse.InvertFor,"C") % only add perturbation to C, if inverting for C
    nxC=UserVar.nxC; nyC=UserVar.nyC;
    phase = 0.0;
    dc = UserVar.ampl_c.*UserVar.C0.*sin(2*pi*nxC*F.x/Lx + 2*pi*nyC*F.y/Ly+phase);
    dc=dc-mean(dc(:));
else
    dc=zeros(MUA.Nnodes,1);
end

C=UserVar.C0 + dc;

Priors.TrueC= C ;
Priors.Truem= m ;


%% Define Priors

Priors.AGlen=Priors.TrueAGlen;
Priors.n=Priors.Truen;

Priors.C=Priors.TrueC;
Priors.m=Priors.Truem;



%% Define Start Values
% This is only used at the very start of the inversion. (In an inverse restart run the initial value is always the last values from
% previous run.)



if contains(UserVar.RunType,"CstartSetToMeanOfTrueC")
    InvStartValues.C=mean(Priors.TrueC) ;
elseif contains(UserVar.RunType,"CstartSetToTrueC")
    InvStartValues.C=Priors.TrueC ;
else
    error("case not found")
end

if contains(UserVar.RunType,"AstartSetToMeanOfTrueA")
    InvStartValues.AGlen=mean(Priors.TrueAGlen) ;
elseif contains(UserVar.RunType,"AstartSetToTrueA")
    InvStartValues.AGlen=Priors.TrueAGlen ;
else
    error("case not found")
end


InvStartValues.m=Priors.Truem;
InvStartValues.n=Priors.Truen ; 

InvStartValues.q=nan;
InvStartValues.muk=nan ;
%% Create synthetic measurements based on true A and C values


F.C=Priors.TrueC; 
F.AGlen=Priors.TrueAGlen;
F.n=Priors.Truen;
F.m=Priors.Truem;

[UserVar,RunInfo,F,l]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l);
[UserVar,F.dhdt]=dhdtExplicit(UserVar,CtrlVar,MUA,F,BCs) ; 

sigma=mean(abs(F.ub))*UserVar.NoiseAmplitude ; 

Noise=sigma*randn(MUA.Nnodes,1);
Meas.us=F.ub+Noise;

Noise=sigma*randn(MUA.Nnodes,1);
Meas.vs=F.vb+Noise; 

Err=zeros(MUA.Nnodes,1)+1; 

usError=zeros(MUA.Nnodes,1)+sigma ; 
vsError=usError ; 

Meas.usCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,usError.^2,MUA.Nnodes,MUA.Nnodes);
Meas.vsCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,vsError.^2,MUA.Nnodes,MUA.Nnodes);

%Also specify the dhdt to help
Meas.dhdt = F.dhdt;
Meas.dhdtCov = sparse(1:MUA.Nnodes,1:MUA.Nnodes,Err.^2,MUA.Nnodes,MUA.Nnodes);


%% Adjoint Boundary conditions

xd=max(F.x) ; xu=min(F.x); yl=max(F.y) ; yr=min(F.y);

% find nodes along boundary 
L=min(sqrt(MUA.EleAreas)/1000); % set a distance tolerance which is a fraction of smallest element size
nodesd=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,1)-xd)<L);
nodesu=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,1)-xu)<L);
nodesl=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,2)-yl)<L);
nodesr=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,2)-yr)<L);

% nodesu=setdiff(nodesu,[nodesr;nodesl]);
% nodesd=setdiff(nodesd,[nodesr;nodesl]);



%% set lambda to zero where forward problem uses fixed velocities, and periodic where forward problem uses periodic BCs

BCsAdjoint.ubFixedNode=[nodesl;nodesr];   BCsAdjoint.ubFixedValue=BCsAdjoint.ubFixedNode*0; 
BCsAdjoint.vbFixedNode=[nodesl;nodesr];   BCsAdjoint.vbFixedValue=BCsAdjoint.vbFixedNode*0; 

BCsAdjoint.vbTiedNodeA=nodesu; BCsAdjoint.vbTiedNodeB=nodesd;
BCsAdjoint.ubTiedNodeA=nodesu; BCsAdjoint.ubTiedNodeB=nodesd;

% Use periodic BCs for the adjoint problem (wrong approach but did this for testing
% BCsAdjoint.vbTiedNodeA=[nodesu;nodesl]; BCsAdjoint.vbTiedNodeB=[nodesd;nodesr];
% BCsAdjoint.ubTiedNodeA=[nodesu;nodesl]; BCsAdjoint.ubTiedNodeB=[nodesd;nodesr];

BCsAdjoint.hTiedNodeA=[nodesu;nodesl]; BCsAdjoint.hTiedNodeB=[nodesd;nodesr];  % gradient BCs.

%




    
end
