function  [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)


        
    n=3 ;  AGlen=3.0e-9+zeros(MUA.Nnodes,1) ; % kPa year about -20 degrees Celsius
    
    %if time>110 ; AGlen=100*AGlen ; end
    
    %n=1 ;  AGlen=1e-15*1e3*365.25*24*60*60+zeros(Nnodes,1) ; % kPa year about -20 degrees Celsius

end

