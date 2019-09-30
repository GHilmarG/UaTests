function [UserVar,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=DefineInputsForInverseRun(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo)

narginchk(12,12) 
nargoutchk(6,6)

x=MUA.coordinates(:,1) ; y=MUA.coordinates(:,2);
Lx=max(x)-min(x); Ly=max(y)-min(y);

if CtrlVar.CisElementBased
    xC=mean(reshape(x(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
    yC=mean(reshape(y(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
else
    xC=x; yC=y;
end


if CtrlVar.AGlenisElementBased
    xA=mean(reshape(x(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
    yA=mean(reshape(y(MUA.connectivity,1),MUA.Nele,MUA.nod),2);
else
    xA=x ; yA=y;
end
%

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
if CtrlVar.AGlenisElementBased
    CAGlen=sparse(1:MUA.Nele,1:MUA.Nele,1,MUA.Nele,MUA.Nele);
else
    CAGlen=sparse(1:MUA.Nnodes,1:MUA.Nnodes,1,MUA.Nnodes,MUA.Nnodes);
end

if strcmpi(CtrlVar.Inverse.Regularize.Field,'cov')
    Err=1e-2 ; Sigma=1e3 ; DistanceCutoff=10*Sigma;
    
    if CtrlVar.CisElementBased
        [CC]=SparseCovarianceDistanceMatrix(xC,yC,Err,Sigma,DistanceCutoff);
    else
        [CC]=SparseCovarianceDistanceMatrix(xC,yC,Err,Sigma,DistanceCutoff);
    end
    
else
    if CtrlVar.CisElementBased
        CC=sparse(1:MUA.Nele,1:MUA.Nele,1,MUA.Nele,MUA.Nele);
    else
        CC=sparse(1:MUA.Nnodes,1:MUA.Nnodes,1,MUA.Nnodes,MUA.Nnodes);
    end
end

<<<<<<< HEAD
=======


>>>>>>> alpha
Priors.CovAGlen=CAGlen;
Priors.CovC=CC;


Priors.B=F.B;
Priors.Bmin=F.B-1000 ;  
Priors.Bmax=F.s-5 ;

%Priors.Bmin=F.B-10000 ;  
%Priors.Bmax=F.s+10000 ;



[UserVar,Priors.C,Priors.m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,CtrlVar.time,F.s,F.b,F.s-F.b,F.S,F.B,F.rho,F.rhow,GF);
[UserVar,Priors.AGlen,Priors.n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,CtrlVar.time,F.s,F.b,F.s-F.b,F.S,F.B,F.rho,F.rhow,GF);

[Priors.AGlen,Priors.n]=TestAGlenInputValues(CtrlVar,MUA,Priors.AGlen,Priors.n);
[Priors.C,Priors.m]=TestSlipperinessInputValues(CtrlVar,MUA,Priors.C,Priors.m);

Priors.rho=F.rho;
Priors.rhow=F.rhow;

%% Define start values
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

[UserVar,F.s,F.b,F.S,F.B,F.alpha]=DefineGeometry(UserVar,CtrlVar,MUA,CtrlVar.time);
[UserVar,F.C,F.m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,CtrlVar.time,F.s,F.b,F.s-F.b,F.S,F.B,F.rho,F.rhow,GF);
[UserVar,F.AGlen,F.n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,CtrlVar.time,F.s,F.b,F.s-F.b,F.S,F.B,F.rho,F.rhow,GF);
UserVar.Inverse.CreateSyntData=1;

[UserVar,RunInfo,F,l,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l);
[UserVar,F.dhdt]=dhdtExplicit(UserVar,CtrlVar,MUA,F,BCs) ;

Priors.TrueC=F.C;
Priors.TrueAGlen=F.AGlen;
Priors.TrueB=F.B;

Meas.s=F.s ;
Meas.us=F.ub ;
Meas.vs=F.vb;
Meas.dhdt=F.dhdt;

VelScale=max(F.ub)-min(F.ub);
% dhdtScale=(max(Meas.dhdt)-min(Meas.dhdt));  % this might not be a good idea if Meas.dhdt=0 everywhere
dhdtScale=1 ; 


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
