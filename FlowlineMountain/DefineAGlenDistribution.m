

function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


    %n=3 ;  AGlen=1.0e-6+zeros(Nnodes,1) ; % kPa
    %n=1 ;  AGlen=1e-15*1e3*365.25*24*60*60+zeros(Nnodes,1) ; % kPa year about -20 degrees Celcius
    n=1 ;  AGlen=1e-13*1e3*365.25*24*60*60+zeros(MUA.Nnodes,1) ; % 

end

