function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
    
    
    m=3 ; C=0.0125 ; 
    % m=3  units kPa a,  C=u C^{-3}=100 m/a (20kPa)^(-3)=0.0125
    %m=1 ; C=1.13263129082193    ; % m=1

    C=C+zeros(MUA.Nnodes,1);
    
end
