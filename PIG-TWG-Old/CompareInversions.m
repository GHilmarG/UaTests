
%%
load('IR-Inversion-Meas-uv--MatlabOptimization-Nod3-I-Adjoint-Cga1-Cgs1-Aga1-Ags1-0-0--logC-.mat');
PlotResultsFromInversion(UserVarInRestartFile,CtrlVarInRestartFile,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);
 
%%
load('IR-Inversion-Meas-uv-dhdt--MatlabOptimization-Nod3-I-Adjoint-Cga1-Cgs1-Aga1-Ags1-0-0--logC-.mat');
PlotResultsFromInversion(UserVarInRestartFile,CtrlVarInRestartFile,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);
%%
load('IR-Inversion-Meas-dhdt--MatlabOptimization-Nod3-I-Adjoint-Cga1-Cgs1-Aga1-Ags1-0-0--logC-.mat');
PlotResultsFromInversion(UserVarInRestartFile,CtrlVarInRestartFile,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);