function Phi=PhiPotential(CtrlVar,MUA,F)


Phi=F.g.* ( (F.rhow-F.rho).*F.b + F.rho.*F.s) ;
% Phi=F.g.* ( (F.rhow-F.rho).*F.B + F.rho.*F.s) ;


if CtrlVar.WaterFilm.PotentialExtended

    % GF=F.GF.node;

    Phi=F.g.* ( (F.rhow-F.rho).*F.B + F.rho.*F.s) ;

end

end