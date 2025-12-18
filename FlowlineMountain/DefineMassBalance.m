
function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

%  as   is the upper surface (local) mass balance in the units m/a
%  ab   is the lower surface (local) mass balance in the units m/a

% I create a surface mass balance profile which is a linear function of horizontal distance
%

%  a=a0+a1*x  => a0*l0+0.5*a1*l0^2=0  ->  l0=-2*a0/a1
%  my domain is from 0 to 100km
%  I want l0=50km -> a1=-2 a0/l0
%
x=MUA.coordinates(:,1) ;


l0=50e3;
a0=5 ;
a1=-2*a0/l0;



as=a0+a1*abs(x);

ab=x*0 ;

end

