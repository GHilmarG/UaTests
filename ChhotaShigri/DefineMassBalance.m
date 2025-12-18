

function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
x=MUA.coordinates(:,1) ;
y=MUA.coordinates(:,2) ;

beta=0.006 ; ELA=4000;  asMax=5 ;



as=beta*(s-ELA);
ab=s*0 ;

as(as>asMax)=asMax;

%yLimit=3037e3;
%as(y>yLimit)=0;

end
