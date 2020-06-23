function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


persistent FA


if ~UserVar.AGlen.ReadFromFile
    
    
    AGlen=AGlenVersusTemp(-10);
    n=3;
    
else
    
    if isempty(FA)
        fprintf('DefineSlipperyDistribution: loading file: %-s ',UserVar.AGlen.FileName)
        load(UserVar.AGlen.FileName,'AGlen','n','xA','yA')
        fprintf(' done \n')
        FA=scatteredInterpolant(xA,yA,AGlen);
    end
    
    x=MUA.coordinates(:,1);
    y=MUA.coordinates(:,2);
    
    AGlen=FA(x,y);

    n=3;
    
end

