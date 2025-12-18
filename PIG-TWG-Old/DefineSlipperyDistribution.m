function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

persistent FC

if ~UserVar.Slipperiness.ReadFromFile
    
    
    m=3;
    ub=10 ; tau=80 ; % units meters, year , kPa
    C0=ub/tau^m;
    C=C0;
    
    
else
    
    
    if isempty(FC)
        fprintf('DefineSlipperyDistribution: loading file: %-s ',UserVar.Slipperiness.FileName)
        load(UserVar.Slipperiness.FileName,'C','m','xC','yC')
        fprintf(' done \n')
        FC=scatteredInterpolant(xC,yC,C);
    end
    
    x=MUA.coordinates(:,1);
    y=MUA.coordinates(:,2);
    
    C=FC(x,y);
    
    m=3;
    
    
end