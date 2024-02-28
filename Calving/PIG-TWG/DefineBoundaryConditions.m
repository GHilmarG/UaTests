function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)



MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar);
[I,AlongDist,NormDist] = DistanceToLineSegment([F.x(MUA.Boundary.Nodes) F.y(MUA.Boundary.Nodes)],MeshBoundaryCoordinates,[],1000);

% switch UserVar.Region
% 
% 
%     case "PIG"
% 
%         I=F.x(MUA.Boundary.Nodes) >-1650e3 & F.x(MUA.Boundary.Nodes) <-1580e3 & F.y(MUA.Boundary.Nodes) < -300e3 ;
% 
%     case "PIG-TWG"
% 
%         I=F.x(MUA.Boundary.Nodes) <-1605e3 ...
%             & F.y(MUA.Boundary.Nodes) < -400e3 ;
%        [I,AlongDist,NormDist] = DistanceToLineSegment([x(Boundary.Nodes) y(Boundary.Nodes)],[xx(:) yy(:)],[],tolerance);
% 
% 
% end


BCs.vbFixedNode=MUA.Boundary.Nodes(I);
BCs.ubFixedNode=MUA.Boundary.Nodes(I);

% [BCs.ubFixedValue,BCs.vbFixedValue]=EricVelocities(CtrlVar,[x(Boundary.Nodes(I)) y(Boundary.Nodes(I))]);

BCs.ubFixedValue=BCs.ubFixedNode*0;
BCs.vbFixedValue=BCs.vbFixedNode*0;




%% Adding fixed h constraints over PIG iceshelf


Box=[-1642.6   -1546 -340.78 -236.91]*1000;

In=IsInBox(Box,F.x,F.y) ; 
isPIGIS=In & F.GF.node <0.5 ;

BCs.hFixedNode=find(isPIGIS);
BCs.hFixedValue=F.h(isPIGIS);

return




%% Testing added fixed vel at boundary if grounded


BoundaryNodesGrounded=intersect(MUA.Boundary.Nodes,find(F.GF.node>0.1));
BoundaryNodesGrounded=intersect(MUA.Boundary.Nodes,find(F.h>10));

BoundaryNodesGroundedNotAlreadyIncluded=setdiff(BoundaryNodesGrounded,BCs.ubFixedNode);

if ~isempty(BoundaryNodesGroundedNotAlreadyIncluded)

    BCs.ubFixedNode=[BCs.ubFixedNode ; BoundaryNodesGroundedNotAlreadyIncluded];
    BCs.vbFixedNode=[BCs.vbFixedNode ; BoundaryNodesGroundedNotAlreadyIncluded];
    BCs.ubFixedValue=BCs.ubFixedNode*0;
    BCs.vbFixedValue=BCs.vbFixedNode*0;

end




%% Testing
% Box=[-1735  -1690 -405. -375.]*1000;
% 
% In=find(IsInBox(Box,F.x,F.y)) ;
% 
% 
% 
% BCs.vbFixedNode=[BCs.ubFixedNode ; In];
% BCs.ubFixedNode=[BCs.vbFixedNode ; In];
% BCs.ubFixedValue=BCs.ubFixedNode*0;
% BCs.vbFixedValue=BCs.vbFixedNode*0;


%
%FindOrCreateFigure("BCs") ; PlotBoundaryConditions(CtrlVar,MUA,BCs);

end