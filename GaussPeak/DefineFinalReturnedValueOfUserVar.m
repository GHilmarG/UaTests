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
%UserVar.Test.Norm.expValue=10549.9140055382;
UserVar.Test.Norm.expValue=10612.5262353633 ; % labtop 11/05/2021
UserVar.Test.Norm.expValue=10640.6286124885 ; % Z840 08/03/2023
% DegreeDiagnostic=[  3 10597.8479167837 ... 
%                     4 10612.526235275 ...
%                     5 10612.5262353632 ...
%                     6 10612.5262353633  ... 
%                     8 10612.5262353633


end