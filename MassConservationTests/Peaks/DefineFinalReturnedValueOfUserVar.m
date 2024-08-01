



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

UserVar.Test.Norm.actValue=mean(sqrt(F.ub.^2+F.vb.^2)) ; 
UserVar.Test.Norm.expValue=22.7017835039198 ;            % 16 March 2024, DESKTOP-BU2IHIR



end