


%%
load("PIG-TWG-RestartFile.mat","CtrlVarInRestartFile","MUA","F","RunInfo")
[dsdxInt,dsdyInt,xint,yint]=calcFEderivativesMUA(F.s,MUA) ; 
[dsdx,dsdy]=ProjectFintOntoNodes(MUA,dsdxInt,dsdyInt) ;
SurfaceGradient=sqrt(dsdx.*dsdx+dsdy.*dsdy); 
FindOrCreateFigure("surface gradient")
UaPlots(CtrlVarInRestartFile,MUA,F,SurfaceGradient) ;

%%