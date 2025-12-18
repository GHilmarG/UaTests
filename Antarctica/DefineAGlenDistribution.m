function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

persistent FA

if CtrlVar.AdaptMeshAndThenStop
    fprintf('setting AGlen to zero. \n');
    AGlen=0;
    n=3;
    return
end


if ~UserVar.ReadAGlenEstFromFile
    
    
    fprintf('Uniform AGlen distribution \n ')
    n=UserVar.n;
    
    tau=80;
    eps=1e-3;
    
    AGlen=eps/tau^n;
    
    
    if n==3
        AGlen=AGlenVersusTemp(-10)+zeros(MUA.Nnodes,1);
    end
    
else
        
    if isempty(FA)
        
        fprintf('DefineAGlen: loading file: %-s ',UserVar.AGlenFileName)
        load(UserVar.AGlenFileName,'AGlen','xA','yA')
        fprintf(' done \n')
        
        FA=scatteredInterpolant(xA,yA,AGlen);
        
    end
    
    n=UserVar.n;
    AGlen=FA(MUA.coordinates(:,1),MUA.coordinates(:,2));
    
    
    
end

