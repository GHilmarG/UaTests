function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)

%%
% BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)
%
% BC is a matlab object with the following fields 
%
% BCs = 
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



% find nodes along boundary 
dx=10;
u0=UserVar.u0; % in-flow velocity


Iu=F.x(MUA.Boundary.Nodes)<(min(F.x)+dx);   nodesu=MUA.Boundary.Nodes(Iu);
Id=F.x(MUA.Boundary.Nodes)<(max(F.x)-dx);   nodesd=MUA.Boundary.Nodes(Id);

Il=F.y(MUA.Boundary.Nodes)>(max(F.y)-dx);   nodesl=MUA.Boundary.Nodes(Il);
Ir=F.y(MUA.Boundary.Nodes)<(min(F.y)+dx);   nodesr=MUA.Boundary.Nodes(Ir);



BCs.ubFixedNode=nodesu ; 
BCs.ubFixedValue=nodesu*0+u0 ;

BCs.vbFixedNode=[nodesu; nodesd ; nodesl; nodesr ] ; 
BCs.vbFixedValue=BCs.vbFixedNode*0;

% BCs.hFixedNode = nodesu ;
% BCs.hFixedValue = InitialIceShelfSurfaceGeometry(UserVar,F.x(nodesu),F.y(nodesu));


end



