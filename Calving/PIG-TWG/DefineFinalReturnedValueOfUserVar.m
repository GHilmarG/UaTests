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

UserVar.Test.Norm.expValue= -1950.00614403724;   % C23000099 - Office HP Z8: 27/10/2023




end