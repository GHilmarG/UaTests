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


%% Testing
Box=[-1735  -1690 -405. -375.]*1000;

In=find(IsInBox(Box,F.x,F.y)) ;



BCs.vbFixedNode=[BCs.ubFixedNode ; In];
BCs.ubFixedNode=[BCs.vbFixedNode ; In];
BCs.ubFixedValue=BCs.ubFixedNode*0;
BCs.vbFixedValue=BCs.vbFixedNode*0;


%
%FindOrCreateFigure("BCs") ; PlotBoundaryConditions(CtrlVar,MUA,BCs);

end