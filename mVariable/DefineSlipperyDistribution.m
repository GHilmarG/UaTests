
function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


m=3+zeros(MUA.Nnodes,1) ;

x=MUA.coordinates(:,1);

m(x>100e3 & x<200e3)=4;

C0=3.16e6.^(-m).*(1000.^m).*365.2422.*24.*60.*60;

C=C0+zeros(MUA.Nnodes,1);


end
