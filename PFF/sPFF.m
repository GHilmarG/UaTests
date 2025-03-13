

function [s,h]=sPFF(CtrlVar,S,b,rhoi,rhow,phi)


% Calculates upper ice surface elevation, s, from flotation, given lower surface and densities.
%
%
% Does not conserve ice thickness!

narginchk(6,6)


% rhoE=DensityEffectivePFF(CtrlVar,rhoi,rhow,phi) ;



gphi=DegradationFunction(CtrlVar,phi) ;

% CtrlVar.PhaseFieldFracture.RiftsAre="-thin ice above inviscid water-"; 

switch CtrlVar.PhaseFieldFracture.RiftsAre

    case "-thin ice above inviscid water-"

        h0=(S-b).*rhow./rhoi; 
        h=gphi.*h0+(1-gphi)*CtrlVar.ThickMin ;
        s=h+b;

    case "-viscous water columns-"

        % flotation:  (s-b) rhoE = (S-b) rhow
        h0=(S-b).*rhow./rhoi; 
        s=b+h0 ;
        h=s-b ;

    otherwise

        error("case not found")

end

