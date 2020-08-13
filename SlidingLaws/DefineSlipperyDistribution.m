
function [UserVar,C,m,q,mu]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
    
    m=3;
    q=3;
    mu=0.5;
    C0=3.16e6^(-m)*1000^m*365.2422*24*60*60;
    
    C=C0+zeros(MUA.Nnodes,1);
    
    % N= He(h-h_f) \rho g  (h-h_f)
    
    if CtrlVar.SlidingLaw=="Budd"
        
        h=s-b;
        hf=(S-B).*rhow./rhow;
        N=GF.node.*rho.*9.81.*(h-hf);
        N(N<0)=eps; 
        Nqm=N.^(q/m) ;
        C=C./(Nqm+eps); 
        
    end
    
    
end
