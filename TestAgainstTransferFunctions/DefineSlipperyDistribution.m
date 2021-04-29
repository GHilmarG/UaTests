function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
    
    %m=3 ; C=0.0145300017528364 ; % m=3
    %m=1 ; C=1.13263129082193    ; % m=1

    
    rho=900 ; h=1000 ; alpha=0.05 ; g=9.81/1000 ; ub=100; taud=rho*g*sin(alpha)*h ; m=3; 
    
    C0=ub/taud^m ; 


    C=C0 ; 

end
