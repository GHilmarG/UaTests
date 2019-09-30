

function [UserVar,AGlen,n]=DefineAGlenDistribution(Experiment,coordinates,connectivity,s,b,h,S,B,rho,rhow,Itime,time,CtrlVar)
        
    
    Nnodes=length(coordinates);
        
    n=3 ;  AGlen=3.0e-9+zeros(Nnodes,1) ; % kPa year about -20 degrees Celcius
    
    %if time>110 ; AGlen=100*AGlen ; end
    
    %n=1 ;  AGlen=1e-15*1e3*365.25*24*60*60+zeros(Nnodes,1) ; % kPa year about -20 degrees Celcius

end

