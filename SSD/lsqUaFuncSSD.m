


function [RR,KK,UserVar]=lsqUaFuncSSD(x,UserVar,CtrlVar,MUA,F0,F1,eta,DNye)

narginchk(8,8)
nargoutchk(1,3)

F1.D=x ;

[UserVar,RR,KK]=SSDAssembly(UserVar,CtrlVar,MUA,F0,F1,eta,DNye) ;




end