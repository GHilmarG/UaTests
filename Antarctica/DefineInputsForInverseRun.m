function [UserVar,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=DefineInputsForInverseRun(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo)

persistent  Fvx Fvy Ferr

if isempty(Fvx)
    load(UserVar.SurfaceVelocityInterpolant,'Fvx','Fvy','Ferr') ;
end

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

Meas.us=double(Fvx(x,y)) ;
Meas.vs=double(Fvy(x,y)) ;
Error=double(Ferr(x,y)) ;
ErrorMax=100 ; 
Error(Error>ErrorMax)=ErrorMax ; 

    
Meas.usCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,Error.^2,MUA.Nnodes,MUA.Nnodes);
Meas.vsCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,Error.^2,MUA.Nnodes,MUA.Nnodes);

% Meas.usCov(Meas.usCov>100)=100 ;
% Meas.vsCov(Meas.vsCov>100)=100 ;
 
Meas.dhdt=Meas.us*0;
Error=10+zeros(MUA.Nnodes,1);  % prescribed error in dh/dt .

%if ~contains(CtrlVar.Inverse.InvertFor,"AGlen") 
%     Error(F.GF.node<0.5)=1e10 ; 
% end

Meas.dhdtCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,Error.^2,MUA.Nnodes,MUA.Nnodes);




%% Define Priors

Priors.AGlen=AGlenVersusTemp(-10);


Priors.n=F.n;

% use measured speed to help finding a resonable prior
MeasuredSpeed=sqrt(Meas.us.*Meas.us+Meas.vs.*Meas.vs);
SpeedMin=10;
SpeedMax=1000;
MeasuredSpeed(MeasuredSpeed>SpeedMax)=SpeedMax;
MeasuredSpeed(MeasuredSpeed<SpeedMin)=SpeedMin;

switch CtrlVar.SlidingLaw
    
    case {"Weertman","Tsai","Cornford","Umbi"}
        
        % u=C tau^m
        
        tau=100 ; % units meters, year , kPa
        
        Priors.m=F.m;
        C0=MeasuredSpeed./(tau.^Priors.m);
        Priors.C=C0;
        
        
    case {"Budd","W-N0"}
        
        hf=F.rhow.*(F.S-F.B)./F.rho;
        hf(hf<eps)=0;
        Dh=(F.s-F.b)-hf; Dh(Dh<eps)=0;
        N=F.rho.*F.g.*Dh;
        
        tau=100+zeros(MUA.Nnodes,1) ;
        C0=N.^F.q.*MeasuredSpeed./(tau.^F.m);
        Priors.C=C0 ;
        Priors.m=F.m ;
        
    otherwise
        
        error('asfd')
end


Priors.C=C0;
Priors.q=3 ;
Priors.muk=0.5 ; 


%%
%% Define Start Values of Inversion
InvStartValues.C=Priors.C ; 
InvStartValues.m=F.m ; 
InvStartValues.q=F.q; 
InvStartValues.muk=F.muk ; 
InvStartValues.AGlen=Priors.AGlen; 
InvStartValues.n=F.n ; 


%% Adjoint BCs



end
