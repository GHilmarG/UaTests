function [u, dudy, d2udy2]=LateralDragMeanVelocity(Y,C0,eta,h0,taud,W)
% LateralDragMeanVelocity   Returns analytical solution of the surface velocity 
% (and its derivatives)
% when lateral drag is applied to a uniform inclined slab 
% by tying the velocity to zero at the margins
%
% Y: y-coordinate either a scalar, vector or matrix quantity 
% (so long as the value of each cell represents the y-coord at that cell) 
% u: horizontal velocity along the x-direction

lambd = 1/sqrt(C0*eta*h0);

u = C0*taud*(1-cosh(lambd*Y)/cosh(lambd*W));
dudy = -C0*taud*lambd*sinh(lambd*Y)/cosh(lambd*W);
d2udy2 = -C0*taud*lambd^2*(cosh(lambd*Y)/cosh(lambd*W));
 
end
