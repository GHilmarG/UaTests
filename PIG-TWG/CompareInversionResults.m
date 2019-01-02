
%%

load IR-Inversion-uv--MatlabOptimization-Nod3-I-Adjoint-Cga1-Cgs1-Aga1-Ags1-0-0-logAGlenlogC
UserVar=UserVarInRestartFile ; CtrlVar=CtrlVarInRestartFile;
PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);

%%


load IR-Inversion-uv-dhdt--MatlabOptimization-Nod3-I-Adjoint-Cga1-Cgs1-Aga1-Ags1-0-0-logAGlenlogC
UserVar=UserVarInRestartFile ; CtrlVar=CtrlVarInRestartFile;
PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);

%%

load IR-Inversion-dhdt--MatlabOptimization-Nod3-I-Adjoint-Cga1-Cgs1-Aga1-Ags1-0-0-logAGlenlogC
UserVar=UserVarInRestartFile ; CtrlVar=CtrlVarInRestartFile;
PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);