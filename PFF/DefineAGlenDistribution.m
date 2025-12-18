
function  [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)


%%
%
% User input m-file to define A and n in the Glenn-Steinemann flow law
%
%   [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)
% 
%   [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
%
% Note: Use
%
%   [AGlen,B]=AGlenVersusTemp(T)
%
% to get A in the units kPa^{-3} yr^{-1} for some temperature T (degrees Celsius) 
%
%% 

AGlen=zeros(MUA.Nnodes,1)+AGlenVersusTemp(-10) ;
n=zeros(MUA.Nnodes,1)+3;



end

