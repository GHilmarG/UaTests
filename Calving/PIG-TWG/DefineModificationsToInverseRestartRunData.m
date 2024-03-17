function UserVar=DefineModificationsToInverseRestartRunData(UserVar,CtrlVar)

%%
%
%


load(CtrlVar.Inverse.NameOfRestartInputFile,...
    'CtrlVarInRestartFile','UserVarInRestartFile','MUA','BCs','F','GF','l','RunInfo',...
    'InvStartValues','Priors','Meas','BCsAdjoint','InvFinalValues');



io=inpoly2([F.x F.y],UserVar.BedMachineBoundary);
NodesOutsideBoundary=~io ;
F.h(NodesOutsideBoundary)=CtrlVar.ThickMin ;


[F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow);


WriteAdjointRestartFile(UserVarInRestartFile,CtrlVarInRestartFile,MUA,BCs,F,F.GF,l,RunInfo,InvStartValues,Priors,Meas,BCsAdjoint,InvFinalValues);



return



