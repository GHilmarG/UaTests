function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs) 

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


tolerance=1;

xmax=max(F.x) ; ymax=max(F.y) ; xmax=min(F.x) ;  ymin=min(F.y) ; 

UpperEdgeNodes= MUA.Boundary.Nodes(abs(F.y(MUA.Boundary.Nodes)-ymax) <tolerance) ; 
LowerEdgeNodes= MUA.Boundary.Nodes(abs(F.y(MUA.Boundary.Nodes)-ymin) <tolerance) ; 

BCs.ubFixedNode=[UpperEdgeNodes; LowerEdgeNodes] ;  BCs.ubFixedValue=BCs.ubFixedNode*0;
BCs.vbFixedNode=[UpperEdgeNodes ; LowerEdgeNodes] ; BCs.vbFixedValue=[UpperEdgeNodes*0 ; LowerEdgeNodes*0-5000]; 
% BCs.ubFixedNode=1 ;  BCs.ubFixedValue=BCs.ubFixedNode*0;





end