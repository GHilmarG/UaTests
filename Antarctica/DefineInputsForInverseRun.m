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

Error=1+Error*0;   % Here I'm overwriting the error values in the data file. I found those to be somewhat unrealistic and decided to use uniform velocity errors
    
Meas.usCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,Error.^2,MUA.Nnodes,MUA.Nnodes);
Meas.vsCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,Error.^2,MUA.Nnodes,MUA.Nnodes);


% And here I set all erros along the boundary to a high value. I do this as a simple way of partially dealing with mismatch
% between the coverage of the velocity data and the boundary that I use. It would be better to carfully look at how the
% velocity data coverage and the computational domain that I use match up.

Nodes=MUA.Boundary.Nodes;
for k=1:numel(Nodes)  % This could be vectorized...
    ii=Nodes(k);
    Meas.usCov(ii,ii)=1e+5;
    Meas.vsCov(ii,ii)=1e+5;
end

% Meas.vsCov(Meas.vsCov>100)=100 ;
 
Meas.dhdt=Meas.us*0;
Error=10+zeros(MUA.Nnodes,1);  % prescribed error in dh/dt .
Meas.dhdtCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,Error.^2,MUA.Nnodes,MUA.Nnodes);




%% Define Priors

if ~(isempty(UserVar.DataFileWithPriors)  || UserVar.DataFileWithPriors=="")

    

    load(UserVar.DataFileWithPriors,"FCPrior","FAPrior") ;

    Priors.n=3 ; 
    Priors.m=3 ;
    Priors.C=FCPrior(F.x,F.y);
    Priors.AGlen=FAPrior(F.x,F.y);

else

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
 

end

Priors.q=3 ;
Priors.muk=0.5 ; 


%%
%% Define Start Values of Inversion

if ~isempty(UserVar.DataFileWithInverseStartC)

    load(UserVar.DataFileWithInverseStartC,"C","xC","yC") ;

    FCstart=scatteredInterpolant(xC,yC,C);
    InvStartValues.C=FCstart(F.x,F.y);

else

    InvStartValues.C=Priors.C ;
    


end

if ~isempty(UserVar.DataFileWithInverseStartA)

    load(UserVar.DataFileWithInverseStartA,"AGlen","xA","yA") ;
    FAstart=scatteredInterpolant(xA,yA,AGlen);
    InvStartValues.AGlen=FAstart(F.x,F.y);

else

    InvStartValues.AGlen=Priors.AGlen ;
    

end

InvStartValues.n=F.n ;
InvStartValues.m=F.m ;
InvStartValues.q=F.q; 
InvStartValues.muk=F.muk ; 



%% Adjoint BCs



end
