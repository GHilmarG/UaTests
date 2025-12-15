


%%  Creating priors for Weertma n=3 by useing previous inversion results


load("Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile.mat")


CtrlVar=CtrlVarInRestartFile;
A=InvFinalValues.AGlen;
C=InvStartValues.C ; 


UaPlots(CtrlVar,MUA,F,log10(C),FigureTitle="log10(C)")

UaPlots(CtrlVar,MUA,F,log10(A),FigureTitle="log10(A)")

%% Now I do some additonal modifications, for example after inspecting the histograms of A and C, I limit the range
% to what I think will get rid of clear outliers. 




%%  Expanding the C fields in some sensible downstream of grounding lines
% Here I simply extrapolate from the values over grounded ice.


[GF,GLgeo,GLnodes,GLele]=IceSheetIceShelves(CtrlVar,MUA,GF) ; 


I=GF.NodesUpstreamOfGroundingLines; 


FClog=scatteredInterpolant(F.x(I),F.y(I),log10(C(I))) ; FClog.ExtrapolationMethod='nearest';

ClogNew=FClog(F.x,F.y);
CPrior=10.^ClogNew;


UaPlots(CtrlVar,MUA,F,log10(CPrior),FigureTitle="log10(C) New")





APrior=A ; 
nPrior=InvFinalValues.n ;
mPrior=InvFinalValues.m ;

FCPrior=scatteredInterpolant(F.x,F.y,CPrior);
FAPrior=scatteredInterpolant(F.x,F.y,APrior);

InfoText="Weertman sliding law, Glen/Steineman flow law" ;


PreString="panAntarctic-m3-n3-54kElements-28kNodes";

[InverseRestartFile,InverseCFile,InverseAFile,InversePriorsFile]=CreateFilenamesForInverseRunOuputs(PreString,CtrlVar);


save(InversePriorsFile,"FCPrior","FAPrior") ;


%%