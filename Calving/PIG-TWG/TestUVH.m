
%%
load TestUVH.mat


%%

CtrlVar.theta=0.5; 
CtrlVar.ThicknessConstraints=1; CtrlVar.ResetThicknessToMinThickness=0;  
CtrlVar.dt=1e-5;
[UserVar,RunInfo,F,l,BCs,dt]=uvh(UserVar,RunInfo,CtrlVar,MUA,F0,F,l,l,BCs);



