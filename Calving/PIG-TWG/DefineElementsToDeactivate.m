





function [UserVar,ElementsToBeDeactivated]=DefineElementsToDeactivate(UserVar,RunInfo,CtrlVar,MUA,F,BCs,ElementsToBeDeactivated)

%%  Manually deactivate elements within a mesh.
%
% This file is called within each run step if CtrlVar.ManuallyDeactivateElements=true
%
%   ElementsToBeDeactivated  : a list of elements to be deactivated.
%                              this can either be a logical variable of a vector with element numbers that are to be
%                              deactivated.
%
% *Example:* To deactivate elements 10 and 23, set:
%
%   ElementsToBeDeactivated=[10;23];
%
% *Example:* To deactivate elements with element x coordinates larger than 1000, set:
%
%  ElementsToBeDeactivated=MUA.xEle > 1000
%
%
%
%
% *Example:*  To deactivate all elements outside of the region bounded by
% BoundaryCoordinates in run-step 2:
%
%
%   if CtrlVar.CurrentRunStepNumber==2
%
%       BoundaryCoordinates=[0 0 ; 10e3 0 ; 10e3 20e3 ; -5e3 15e3 ] ;
%       In=inpoly([MUA.xEle MUA.yEle],BoundaryCoordinates);
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
% *Example:* To deactivate elements where none of the nodes have ice thickness greater
% than 2*CtrlVar.ThickMin :
%
%   AboveMinThickNodes = F.h > 2*CtrlVar.ThickMin ;
%   MinThickElements=AllElementsContainingGivenNodes(MUA.connectivity,AboveMinThickNodes) ;
%   ElementsToBeDeactivated=~MinThickElements ;
%
%   FindOrCreateFigure("min thick elements") ;
%   PlotMuaMesh(CtrlVar,MUA);
%   hold on
%   PlotMuaMesh(CtrlVar,MUA,ElementsToBeDeactivated,"r")
%
%
% Note that the x and y coordinates of the elements, defined as the mean x and y values of nodes, can be found in :
%
%   MUA.xEle
%   MUA.yEle
%
%%

% Find all nodes for which the deactivation criterion is not fulfilled. Then find all elements containing one or more of
% those nodes. These elements should not be deactivated. And then select the remaining elements for deactivation. 


AboveMinThickNodes = find(F.h > 2*CtrlVar.ThickMin) ; 

% Additionally, do not deactivate elements with nodes that are part of boundary conditions.
%
% Include all, but without duplicates 
AboveMinThickNodes= unique([AboveMinThickNodes;BCs.ubFixedNode;BCs.vbFixedNode;BCs.hFixedNode]); 

MinThickElements=AllElementsContainingGivenNodes(MUA.connectivity,AboveMinThickNodes) ;
NewElementsToBeDeactivated=~MinThickElements ;


if islogical(ElementsToBeDeactivated)
    ElementsToBeDeactivated=ElementsToBeDeactivated | NewElementsToBeDeactivated ;
else
    ElementsToBeDeactivated=unique([NewElementsToBeDeactivated;NewElementsToBeDeactivated]) ;
end


cbar=UaPlots(CtrlVar,MUA,F,F.h,GetRidOfValuesDownStreamOfCalvingFronts=false,FigureTitle="Deactive elements"); 
set(gca,'ColorScale','log') 
clim([CtrlVar.ThickMin/10 , CtrlVar.ThickMin*10])
title(cbar,"$h$",interpreter="latex")
hold on 

PlotMuaMesh(CtrlVar,MUA,nan,DisplayName="Mesh")
hold on
PlotMuaMesh(CtrlVar,MUA,ElementsToBeDeactivated,color="r",LineWidth=2,DisplayName="Elements to be deactivated")

I=F.h== CtrlVar.ThickMin;
plot(F.x(I)/CtrlVar.PlotXYscale,F.y(I)/CtrlVar.PlotXYscale,MarkerFaceColor="y",Marker="pentagram",MarkerEdgeColor="y",LineStyle="none",DisplayName="Nodes at thick min")

I=F.h <  CtrlVar.ThickMin;
plot(F.x(I)/CtrlVar.PlotXYscale,F.y(I)/CtrlVar.PlotXYscale,MarkerFaceColor="g",Marker="pentagram",MarkerEdgeColor="g",LineStyle="none",DisplayName="Nodes below thick min")

nEleDeactivated=numel(find(ElementsToBeDeactivated)); 

title(sprintf("%i elements to be deactivated shown in red",nEleDeactivated))
lg=legend;
lg.String{1}="ice thickness";

end