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

UserVar.Test.Norm.actValue=norm(F.ub+F.vb);

   % expSolution = 95982.7181182457;  % this was with the old bedmap2 data
    % expSolution = 9757675340.83092 ;   % this is with the new Bedmachine data, 10/09/2021
    % expSolution = 202912           ;     % this is with the new Bedmachine data and a new boundary, 01/11/2021
    
UserVar.Test.Norm.expValue=201932.019377657   ; %  Z840   
UserVar.Test.Norm.expValue=198335.949259139   ; % HP C20503924 24/06/2023

end