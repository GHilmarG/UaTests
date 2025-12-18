
%%
load UaDefaultRun-InverseRestartFile.mat 

figure ; PlotMeshScalarVariable(CtrlVarInRestartFile,MUA,log10(F.AGlen));


UserVar=UserVarInRestartFile;

io=inpoly2([F.x F.y],UserVar.BedMachineBoundary);
NodesOutsideBoundary=~io ;



Priors.AGlen= AGlenVersusTemp(-10);
F.AGlen(NodesOutsideBoundary) =  AGlenVersusTemp(-10);
InvFinalValues.AGlen(NodesOutsideBoundary) =    AGlenVersusTemp(-10);
InvStartValues.AGlen(NodesOutsideBoundary) =    AGlenVersusTemp(-10);


figure ; PlotMeshScalarVariable(CtrlVarInRestartFile,MUA,log10(F.AGlen));


save UaDefaultRun-InverseRestartFile.mat 

