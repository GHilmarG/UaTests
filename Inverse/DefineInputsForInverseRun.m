




function [UserVar,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=DefineInputsForInverseRun(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo)

narginchk(12,12)
nargoutchk(6,6)


%% Define boundary conditions of adjoint problem
% Generally there is nothing that needs to be done here.
%
% If BCsAdjoint is not modified, then Ua will define the BCs of the adjoint
% problem based on the BCs of the forward problem.
%
% BCsAdjoint=BCs; % periodic BCs of forward model -> periodic BCs of adjoint
% model


% BCsAdjoint.ubFixedNode=MUA.Boundary.Nodes;
% BCsAdjoint.vbFixedNode=MUA.Boundary.Nodes;
% BCsAdjoint.ubFixedValue=BCsAdjoint.ubFixedNode*0;
% BCsAdjoint.vbFixedValue=BCsAdjoint.vbFixedNode*0;
%%  Covariance matrices of priors
%

CAGlen=sparse(1:MUA.Nnodes,1:MUA.Nnodes,1,MUA.Nnodes,MUA.Nnodes);


if strcmpi(CtrlVar.Inverse.Regularize.Field,'cov')
    Err=1e-2 ; Sigma=1e3 ; DistanceCutoff=10*Sigma;
    CC=SparseCovarianceDistanceMatrix(F.x,F.y,Err,Sigma,DistanceCutoff);
else
    CC=sparse(1:MUA.Nnodes,1:MUA.Nnodes,1,MUA.Nnodes,MUA.Nnodes);
end

Priors.CovAGlen=CAGlen;
Priors.CovC=CC;


Priors.B=F.B;
Priors.Bmin=F.B-1000 ;  
Priors.Bmax=F.s-5 ;


[UserVar,Priors.C,Priors.m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F); 
[UserVar,Priors.AGlen,Priors.n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F);

[Priors.AGlen,Priors.n]=TestAGlenInputValues(CtrlVar,MUA,Priors.AGlen,Priors.n);
[Priors.C,Priors.m]=TestSlipperinessInputValues(CtrlVar,MUA,Priors.C,Priors.m);

Priors.rho=F.rho;
Priors.rhow=F.rhow;

%% Define start values for the inversion
% 
InvStartValues.C=Priors.C ; % + 0.5* sin(xC*2*pi/Lx)*mean(Priors.C) ; 
InvStartValues.m=Priors.m;

InvStartValues.AGlen=Priors.AGlen ;  % +0.5*sin(xA*2*pi/Lx)*mean(Priors.AGlen) ; 
InvStartValues.n=Priors.n;

InvStartValues.B=Priors.B  ; % + 0.1*mean(F.h)*sin(x*2*pi/Lx) ; 


%% Define measurements and measurement errors

fprintf(' Creating synthetic data. \n')

if UserVar.Inverse.CreateSyntData==1
    UserVar.Inverse.CreateSyntData=2;
end


[UserVar,F.s,F.b,F.S,F.B,F.rho,F.rhow,F.g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,"-s-b-S-B-rho-");
[UserVar,F.C,F.m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F);
[UserVar,F.AGlen,F.n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F);
UserVar.Inverse.CreateSyntData=1;

[UserVar,RunInfo,F,l]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l);
[UserVar,F.dhdt]=dhdtExplicit(UserVar,CtrlVar,MUA,F,BCs) ;

% Define 'true' fields, these must be the input fields that were used in the forward model to create the measurements. That
% is, this must be the A, C, and geometry that were used to generate the velocities data and dh/dt data.
Priors.TrueC=F.C;
Priors.TrueAGlen=F.AGlen;
Priors.TrueB=F.B;
Priors.Trueh=F.h;
Meas.s=F.s ;
Meas.us=F.ub ;
Meas.vs=F.vb;
Meas.dhdt=F.dhdt;

usError=UserVar.uError;
vsError=UserVar.uError;
dhdtError=UserVar.dhdtError;

Meas.usCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,usError.^2,MUA.Nnodes,MUA.Nnodes);
Meas.vsCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,vsError.^2,MUA.Nnodes,MUA.Nnodes);
Meas.dhdtCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,dhdtError.^2,MUA.Nnodes,MUA.Nnodes);

% if add errors

Meas.us=Meas.us+UserVar.AddDataErrors*usError.*randn(MUA.Nnodes,1);
Meas.vs=Meas.vs+UserVar.AddDataErrors*vsError.*randn(MUA.Nnodes,1);
Meas.dhdt=Meas.dhdt+UserVar.AddDataErrors*dhdtError.*randn(MUA.Nnodes,1);




end
