





function [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)

persistent FA nInFile

x=F.x ; y=F.y; 

if isempty(FA)

    load("../Calving/PIG-TWG/InverseRestartFile-Weertman-Ca1-Cs100000-Aa1-As100000-5km-Alim-.mat","F")
    FA=scatteredInterpolant(F.x,F.y,F.AGlen);
    nInFile=F.n;

end

AGlen=FA(x,y) ;
n=nInFile(1)+zeros(MUA.Nnodes,1) ; 


end

