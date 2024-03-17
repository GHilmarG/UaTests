%%
clearvars File
File(1)="Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-GradientBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile";
File(2)="Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-GradientBased-IAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile";
File(3)="Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile";



fig=FindOrCreateFigure('Inverse Parameter Optimisation');
clf(fig)

for I=1:numel(File)
    load(File(I))
    
    semilogy(RunInfo.Inverse.Iterations,RunInfo.Inverse.J,'-o','LineWidth',2)
    hold on
    
end


ylabel('J')
legend('Gradient-M AC','Gradient-I AC','Hessian AC')

xlabel('Inverse iteration') ;

%%

load(File(3)); 
PlotResultsFromInversion(UserVarInRestartFile,CtrlVarInRestartFile,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo) ; 