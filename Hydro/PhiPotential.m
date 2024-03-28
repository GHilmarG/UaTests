
function Phi=PhiPotential(CtrlVar,MUA,F)



if CtrlVar.WaterFilm.Potential=="-Bs-"

    Phi=F.g.* ( (F.rhow-F.rho).*F.B + F.rho.*F.s) ;

elseif CtrlVar.WaterFilm.Potential=="-bs-"

    Phi=F.g.* ( (F.rhow-F.rho).*F.b + F.rho.*F.s) ;

elseif CtrlVar.WaterFilm.Potential=="-b-"

    Phi=F.g.*F.rhow*F.b ;
    
else
    error(" case not found ")
end

end