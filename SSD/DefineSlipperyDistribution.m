





function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F)


persistent FC mInFile

x=F.x ; y=F.y;


if isempty(FC)

    load("../Calving/PIG-TWG/InverseRestartFile-Weertman-Ca1-Cs100000-Aa1-As100000-5km-Alim-.mat","F")
    FC=scatteredInterpolant(F.x,F.y,F.C);
    mInFile=F.m;

end

C=FC(x,y) ;
m=mInFile(1)+zeros(MUA.Nnodes,1) ; 



end

