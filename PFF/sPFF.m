

function [s,h]=sPFF(CtrlVar,S,b,rhoi,rhow,phi)


% Calculates upper ice surface elevation, s, from flotation, given lower surface and densities.
%
%
% Does not conserve ice thickness!

narginchk(6,6)


rhoE=DensityEffectivePFF(CtrlVar,rhoi,rhow,phi) ; 

% flotation:  (s-b) rhoE = (S-b) rhow
s=b+(S-b).*rhow./rhoE ; 
h=s-b ; 


end

