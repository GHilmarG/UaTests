

function rhoE=DensityEffectivePFF(CtrlVar,rhoi,rhow,phi)

narginchk(4,4)


gphi=DegradationFunction(CtrlVar,phi) ;

rhoE=gphi.*rhoi+(1-gphi).*rhow ;


end
