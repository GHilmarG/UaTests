function Phi=PhiPotential(CtrlVar,MUA,F)



if CtrlVar.WaterFilm.Potential=="-Bs-"
    Phi=F.g.* ( (F.rhow-F.rho).*F.B + F.rho.*F.s) ;
elseif CtrlVar.WaterFilm.Potential=="-bs-"
    Phi=F.g.* ( (F.rhow-F.rho).*F.b + F.rho.*F.s) ;
else
    error(" case not found ")
end

end