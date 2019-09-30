function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
    AGlen=AGlenVersusTemp(0)+zeros(MUA.Nnodes,1);
    
    %AGlen=0.7e-25*1e9*365.25*24*60*60+zeros(Nele,1);
    
    n=3;
    
    
end

