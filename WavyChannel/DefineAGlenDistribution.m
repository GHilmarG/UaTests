

function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

n=3 ; AGlen=AGlenVersusTemp(0)+zeros(MUA.Nnodes,1) ;

%n=1 ; AGlen=1e-6+zeros(MUA.Nnodes,1) ;    %  ud=2 A (rho g sin(alpha))^n h^{n+1} /(n+2) -> A= ud= (n+1) ud / ( 2 (rho g sin(alpha))^n h^{n+1} )

end

