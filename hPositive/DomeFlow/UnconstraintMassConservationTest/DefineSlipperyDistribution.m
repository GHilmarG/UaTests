function [UserVar,C,m]=DefineSlipperyDistribution(Experiment,coordinates,connectivity,s,b,h,S,B,rho,rhow,Itime,time,CtrlVar);
    
    
    
    m=3 ; C=0.0125 ; % m=3  units kPa a,  C=u C^{-3}=100 m/a (20kPa)^(-3)=0.0125
    %m=1 ; C=1.13263129082193    ; % m=1
    Nnodes=size(coordinates,1);
    C=C+zeros(Nnodes,1);
    
end
