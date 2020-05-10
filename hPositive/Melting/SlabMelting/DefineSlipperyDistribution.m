function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
     
   
    m=3 ; C=0.0145300017528364 ; % m=3
    %m=1 ; C=1.13263129082193    ; % m=1

    m=3 ; C=100; % creating high velocities 
    C=C+zeros(MUA.Nnodes,1);
    
end
