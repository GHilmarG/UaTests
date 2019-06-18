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


fprintf(' DefineElementsToDeactivate \n')
[GF,GLgeo,GLnodes,GLele]=IceSheetIceShelves(CtrlVar,MUA,GF);


CutOff=1e10;

if contains(UserVar.RunType,"-ManuallyDeactivateElements-")
    
    if CtrlVar.time < 0.1
        CutOff=400e3;  % t < 0.1
    elseif CtrlVar.time < 0.2
        CutOff=500e3;  % 0.1 <= t <0.2
    else
        CutOff=300e3;  % t >= 0.2
    end
    
end

ElementsToBeDeactivated=GF.ElementsDownstreamOfGroundingLines & (MUA.xEle>CutOff) ;







end