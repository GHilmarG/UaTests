
%%
Klear
load TestSave2.mat
close all

nnn=30;
gammaTestVector=zeros(nnn,1) ; rForceTestvector=zeros(nnn,1);  rWorkTestvector=zeros(nnn,1); rD2Testvector=zeros(nnn,1);
Upper=2.2;
Lower=-0.5 ;
if gamma>0.7*Upper ; Upper=2*gamma; end
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfor I=1:nnn
    gammaTest=(Upper-Lower)*(I-1)/(nnn-1)+Lower
    [rTest,~,~,rForceTest,rWorkTest,D2Test]=Func(gammaTest);
    gammaTestVector(I)=gammaTest ; rForceTestvector(I)=rForceTest; rWorkTestvector(I)=rWorkTest;  rD2Testvector(I)=D2Test;
end

gammaZero=min(abs(gammaTestVector)) ;
if gammaZero~=0
    [rTest,~,~,rForceTest,rWorkTest,D2Test]=Func(0);
    gammaTestVector(nnn+1)=0 ; rForceTestvector(nnn+1)=rForceTest; rWorkTestvector(nnn+1)=rWorkTest;  rD2Testvector(nnn+1)=D2Test;
end

[gammaTestVector,ind]=unique(gammaTestVector) ; rForceTestvector=rForceTestvector(ind) ; rWorkTestvector=rWorkTestvector(ind) ; rD2Testvector=rD2Testvector(ind) ;
[gammaTestVector,ind]=sort(gammaTestVector) ; rForceTestvector=rForceTestvector(ind) ; rWorkTestvector=rWorkTestvector(ind) ; rD2Testvector=rD2Testvector(ind) ;


SlopeForce=-2*rForce0;
SlopeWork=-2*rWork0;
SlopeD2=-D20;
CtrlVar.MinimisationQuantity=CtrlVar.LSFMinimisationQuantity;
[ForceFig,WorkFig]=PlotCostFunctionsVersusGamma(CtrlVar,RunInfo,gamma,r,iteration,"-LSF-",...
    gammaTestVector,rForceTestvector,rWorkTestvector,rD2Testvector,...
    SlopeForce,SlopeWork,SlopeD2,rForce,rWork,D2);