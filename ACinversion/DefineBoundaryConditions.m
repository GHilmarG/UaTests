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
L=min(sqrt(MUA.EleAreas)/1000); % set a distance tolerance which is a fraction of smallest element size
nodesd=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,1)-xd)<L);
nodesu=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,1)-xu)<L);
nodesl=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,2)-yl)<L);
nodesr=MUA.Boundary.Nodes(abs(MUA.coordinates(MUA.Boundary.Nodes,2)-yr)<L);

nodesu=setdiff(nodesu,[nodesr;nodesl]);
nodesd=setdiff(nodesd,[nodesr;nodesl]);


% Set the boundary conditions for basal velocities
BCs.vbFixedNode=[nodesl;nodesr];   BCs.vbFixedValue=BCs.vbFixedNode*0; 
BCs.vbTiedNodeA=nodesu; BCs.vbTiedNodeB=nodesd;
BCs.ubTiedNodeA=nodesu; BCs.ubTiedNodeB=nodesd;
% and thickness
BCs.hTiedNodeA=nodesu; BCs.hTiedNodeB=nodesd;

%Also set the  u velocity to zero along the lateral margins

%@ y=12000; not zero if the edge of the domain is not at the lateral margin 
%lat_vel = 909.118; %if uc = 1000 
% lat_vel = 2238.0; %if uc = 3000.

lat_vel=0.0;  %@y=+/-W

BCs.ubFixedNode=[nodesl;nodesr];   BCs.ubFixedValue=BCs.ubFixedNode*0 + lat_vel; 

BCs.hFixedNode=[nodesl;nodesr]; BCs.hFixedValue=BCs.hFixedNode*0+1000; 

% elseif strcmp(UserVar.configuration, 'ICE_SHELF')
%     BCs.ubFixedNode=nodesu ; 
%     BCs.ubFixedValue=BCs.ubFixedNode*0+1000; % Set B.C. ugl=1000 for steady state
%     BCs.vbFixedNode=[nodesu;nodesl;nodesr] ; 
%     BCs.vbFixedValue=BCs.vbFixedNode*0;

  




end