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
V=5000 ; % This is the +/- v velocity applied at upper and lower boundaries 


xmax=max(F.x) ; ymax=max(F.y) ; xmin=min(F.x) ;  ymin=min(F.y) ; 

UpperEdgeNodes= MUA.Boundary.Nodes(abs(F.y(MUA.Boundary.Nodes)-ymax) <tolerance) ; 
LowerEdgeNodes= MUA.Boundary.Nodes(abs(F.y(MUA.Boundary.Nodes)-ymin) <tolerance) ; 
LeftEdgeNodes= MUA.Boundary.Nodes(abs(F.x(MUA.Boundary.Nodes)-xmin) <tolerance) ; 

BCs.ubFixedNode=[UpperEdgeNodes; LowerEdgeNodes ; LeftEdgeNodes] ;  BCs.ubFixedValue=BCs.ubFixedNode*0;
BCs.vbFixedNode=[UpperEdgeNodes ; LowerEdgeNodes] ; BCs.vbFixedValue=[UpperEdgeNodes*0+V ; LowerEdgeNodes*0-V]; 


% BCs.ubFixedNode=1 ;  BCs.ubFixedValue=BCs.ubFixedNode*0;





end