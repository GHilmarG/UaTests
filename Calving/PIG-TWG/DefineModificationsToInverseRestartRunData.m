


function [UserVar,MUA,BCs,F,l,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=DefineModificationsToInverseRestartRunData(UserVar,CtrlVar,MUA,BCs,F,l,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo) 

%%
%
%

 [UserVar,BCs]=GetBoundaryConditions(UserVar,CtrlVar,MUA,BCs,F) ; 



%
%
% [F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow);
%
% 
% WriteAdjointRestartFile(UserVarInRestartFile,CtrlVarInRestartFile,MUA,BCs,F,F.GF,l,RunInfo,InvStartValues,Priors,Meas,BCsAdjoint,InvFinalValues);
%
%


return



