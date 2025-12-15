
function  [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)



%%
%
% User input m-file to define A and n in the Glenn-Steinemann flow law
%
%   [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
%
% Usually A is defined on the nodes (but sometimes in an inverse run A might be
% defined as an element variable.)
% 
%% 

n=3 ;
AGlen=AGlenVersusTemp(-20)+F.x*0 ; 


end

