


%%

load("C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Runs\Antarctica\Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile.mat","CtrlVarInRestartFile","MUA","F")


Fold=F;




load("Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile.mat","CtrlVarInRestartFile","MUA","F")



CtrlVar=CtrlVarInRestartFile;

CtrlVar.VelPlotIntervalSpacing='log10';
CtrlVar.QuiverColorSpeedLimits=[10 5000]; 
UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="-uv new-") 
UaPlots(CtrlVar,MUA,Fold,"-uv-",FigureTitle="-uv old-")


%%