
function ElementSize=ElementSizeCorrection(ElementSize)



%% Somehow I managed to get the sizing of the elements wrong, with the result that the names of the mesh files:
%
%   MeshFile??km-PIG-TWG
% 
% are off by a factor of about two. 
%
%       "-leg of an isosceles right triangle-"               -side of a perfect square of equal area-
% 30km =         14km                                                        9.806 km
% 20km =        9.3km                                                        6.559 km
% 10km =        4.6km                                                        3.28  km
%  5km =        2.3km                                                        1.64  km
% 2.5km =       1.16km                                                       0.821 km
%
% ElementSize  : on input this is the (wrong) overall element size in km.
%                on return this is the (corrected) length of the sides of a perfect square of equal area to that of the triangles.
%
%%

ES=round(1000*ElementSize);

if ES == 30000
    ElementSize=9.806 ;
elseif ES == 20000
    ElementSize=6.559 ;
elseif ES == 10000
    ElementSize=3.28 ;
elseif ES == 5000
    ElementSize=1.64 ;
elseif ES == 2500
    ElementSize=0.821  ;
else
    error("case not found.")

end

