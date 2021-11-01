function   [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
    
    m=3 ; C=1e-5 ; % m=3
    % m=1 ; C=0.1   ; % m=1
    
    factor=1;   %  You can investigate the sensitivity of the results to C by selecting other values for the 'factor'
    C=factor*C ; %  For example setting factor=2 and then re-running will show you the effect of doubling the value of C. 
    
    
    C=C+zeros(MUA.Nnodes,1);
   
end
