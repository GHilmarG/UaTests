



function [UserVar,ElementsToBeDeactivated]=...
    DefineElementsToDeactivate(UserVar,RunInfo,CtrlVar,MUA,xEle,yEle,ElementsToBeDeactivated,s,b,S,B,rho,rhow,ub,vb,ud,vd,GF)

%%  Manually deactivate elements within a mesh.   
%
% This file is called within each run step if CtrlVar.ManuallyDeactivateElements=true
%  
%
%   [UserVar,ElementsToBeDeactivated]=...
%       DefineElementsToDeactivate(UserVar,RunInfo,CtrlVar,MUA,xEle,yEle,ElementsToBeDeactivated,s,b,S,B,rho,rhow,ub,vb,ud,vd,GF)
%
% *Example:*  To deactivate all elements outside of the region bounded by
% BoundaryCoordinats in run-step 2:
%
% 
%   if CtrlVar.CurrentRunStepNumber==2
%
%       BoundaryCoordinates=[0 0 ; 10e3 0 ; 10e3 20e3 ; -5e3 15e3 ] ;    
%       In=inpoly([xEle yEle],BoundaryCoordinates);
%       ElementsToBeDeactivated=~In;
%     
%     
%       figure
%       PlotMuaMesh(CtrlVar,MUA,ElementsToBeDeactivated,'r')
%       hold on
%       PlotMuaMesh(CtrlVar,MUA,~ElementsToBeDeactivated,'k')
%  
%   end
% 
% 


rEle=sqrt(xEle.*xEle+yEle.*yEle);

x=MUA.coordinates(:,1) ; y=MUA.coordinates(:,2) ; 
r=sqrt(x.*x+y.*y);
[rSorted,iSort]=sort(r) ;
h=s-b; 
hSorted=h(iSort) ;

ih=hSorted>0.0005; 

R=max(rSorted(ih)) ; 

R=max(R,0.02) + 0.01 ; 

% R=0.02;

ElementsToBeDeactivated=rEle > R ; 




end