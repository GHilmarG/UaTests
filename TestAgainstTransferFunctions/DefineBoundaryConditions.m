function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)
%%
% BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)
%
% BC is a matlab object with the following fields 
%
%   BCs = 
% 
%   BoundaryConditions with properties:
% 
%              ubFixedNode: []
%             ubFixedValue: []
%              vbFixedNode: []
%             vbFixedValue: []
%              ubTiedNodeA: []
%              ubTiedNodeB: []
%              vbTiedNodeA: []
%              vbTiedNodeB: []
%      ubvbFixedNormalNode: []
%     ubvbFixedNormalValue: []
%              udFixedNode: []
%             udFixedValue: []
%              vdFixedNode: []
%             vdFixedValue: []
%              udTiedNodeA: []
%              udTiedNodeB: []
%              vdTiedNodeA: []
%              vdTiedNodeB: []
%      udvdFixedNormalNode: []
%     udvdFixedNormalValue: []
%               hFixedNode: []
%              hFixedValue: []
%               hTiedNodeA: []
%               hTiedNodeB: []
%                 hPosNode: []
%                hPosValue: []
%       
%
% see also BoundaryConditions.m
% 
% Examples:
%
%  To set velocities at all grounded nodes along the boundary to zero:
%
%   GroundedBoundaryNodes=MUA.Boundary.Nodes(GF.node(MUA.Boundary.Nodes)>0.5);
%   BCs.vbFixedNode=GroundedBoundaryNodes; 
%   BCs.ubFixedNode=GroundedBoundaryNodes; 
%   BCs.ubFixedValue=BCs.ubFixedNode*0;
%   BCs.vbFixedValue=BCs.vbFixedNode*0;
%
% 
%%
x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
xd=max(x(:)) ; xu=min(x(:)); yl=max(y(:)) ; yr=min(y(:));


% find nodes along boundary 
% Here we are using the fact that all nodes along the boundary in the list:
%
%   MUA.Boundary.Nodes
%
% And we only limit the search to those nodes along the boundary.
%
L=min(sqrt(MUA.EleAreas)/1000); % set a distance tolerance which is a fraction of smallest element size

nodesd=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,1)-xd)<L) ;
nodesu=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,1)-xu)<L) ;
nodesl=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,2)-yl)<L);
nodesr=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,2)-yr)<L);


% set the boundary condtions for basal velocities
BCs.ubTiedNodeA=[nodesu;nodesl]; BCs.ubTiedNodeB=[nodesd;nodesr];
BCs.vbTiedNodeA=nodesu; BCs.vbTiedNodeB=nodesd;
BCs.vbFixedNode=[nodesl;nodesr];   BCs.vbFixedValue=BCs.vbFixedNode*0; 

% Note: I'm applying the same BCs twice becaus some nodes in nodesl and nodes u are the same!


 % FigBCs=FindOrCreateFigure("-BCs-") ;
 % PlotBoundaryConditions(CtrlVar,MUA,BCs)








end