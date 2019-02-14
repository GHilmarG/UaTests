
function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


switch UserVar.m
    
    case 3
        
        m=3;
        C0=3.16e6^(-m)*1000^m*365.2422*24*60*60;
        C=C0+zeros(MUA.Nnodes,1);
        
    case 0.1
        
        m=0.1 ;
        % u=C tau^m - > C=U/tau^m
        u0=100 ; tau0=10;
        C=u0/tau0^m;
        
    otherwise
        
        error('case not found')
        
end




end
