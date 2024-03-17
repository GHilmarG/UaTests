



function [u,v]=DefineVelocities(UserVar,CtrlVar,MUA,F)


persistent Fu Fv


x=F.x ; y=F.y;

if isempty(Fu)


    load("../Calving/PIG-TWG/InverseRestartFile-Weertman-Ca1-Cs100000-Aa1-As100000-5km-Alim-.mat","F")

    Fu=scatteredInterpolant(F.x,F.y,F.ub);
    Fv=scatteredInterpolant(F.x,F.y,F.vb);


end


u=Fu(x,y);
v=Fv(x,y);


end



