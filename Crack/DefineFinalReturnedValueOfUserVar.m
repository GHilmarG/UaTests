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
UserVar.Test.Norm.expValue=5034.37163446407;   % 5026.37861939423;
UserVar.Test.Norm.expValue=5033.4404813878   ; % 10/09/2021 on WS-HO
UserVar.Test.Norm.expValue=5034.04624348311  ; % HP C20503924 24/06/2023

end