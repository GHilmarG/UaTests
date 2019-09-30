
%%

load  IR-Inversion-Meas-uv--MatlabOptimization-Nod3-I-Adjoint-Cga1-Cgs1-Aga1-Ags1-0-0--logA-logC-.mat



UserVar=UserVarInRestartFile ; CtrlVar=CtrlVarInRestartFile;
PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);

%%


load IR-Inversion-Meas-uv-dhdt--MatlabOptimization-Nod3-I-Adjoint-Cga1-Cgs1-Aga1-Ags1-0-0--logA-logC-.mat
UserVar=UserVarInRestartFile ; CtrlVar=CtrlVarInRestartFile;
PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);

%%
c1=-100 ; c2=100 ; xl=-1700 ; lr=-1450 ; yd=-400 ; yu=-100;
figure(12); title('Inversion using uv') ; caxis([c1 c2])   ; axis( [xl xr yd yu ]) 
figure(28); title('Inversion using uv and dh/dt') ; caxis([c1 c2])  ; axis( [xl xr yd yu ]) 