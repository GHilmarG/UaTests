function [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


persistent FC


q=3 ;   % Only needed in Budd sliding law.
muk=0.5 ; 


if CtrlVar.AdaptMeshAndThenStop
    fprintf(' C set to zero \n ')
    C=0;
    m=3;
    return
end




if UserVar.ReadSlipperinessFromFile==0
    
    fprintf(' uniform slipperiness distribution \n')
    m=UserVar.m;
    ub=10 ; tau=80 ; % units meters, year , kPa
    C0=ub/tau^m;
    C=C0;
    
    
else
    
    
    if isempty(FC)
        
        fprintf('DefineSlipperyDistribution: loading file: %-s ',UserVar.CFileName)
        load(UserVar.CFileName,'C','m','xC','yC')
        fprintf(' done \n')
        FC=scatteredInterpolant(xC,yC,C);
        
    else
        m=UserVar.m ;
        C=FC(MUA.coordinates(:,1),MUA.coordinates(:,2)) ; 
    end
    
 
  
    
    
end
    
