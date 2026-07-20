function UserVar=DefineFinalReturnedValueOfUserVar(UserVar,CtrlVar,MUA,BCs,F,l,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

%% 
%
%   UserVar=DefineFinalReturnedValueOfUserVarByUa2D(UserVar,CtrlVar,MUA,BCs,F,l,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);
%
% This m-file is called by Ua2D at the end of the run. It can be used to do
% some final user modification to the returned UserVar
%
% 
%

UserVar.Test.Norm.actValue=mean(F.ub+F.vb);
UserVar.Test.Norm.expValue=1551.02724753795  ; % HP HO, 06/05/2025
UserVar.Test.Norm.expValue=1539.3           ; % HP HO, 20/07/2026

end