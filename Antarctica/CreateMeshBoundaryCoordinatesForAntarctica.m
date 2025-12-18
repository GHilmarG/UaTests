function MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForAntarctica(UserVar,CtrlVar)

% load ZeroIceThicknessContour.mat

load(UserVar.BoundaryFile,"Boundary") 

CtrlVar.GLtension=1e-12; % tension of spline, 1: no smoothing; 0: straight line
CtrlVar.GLds=UserVar.DistanceBetweenPointsAlongBoundary;
[xB,yB] = Smooth2dPos(Boundary(:,1),Boundary(:,2),CtrlVar);
MeshBoundaryCoordinates=[xB(:) yB(:)] ;


% fc=FindOrCreateFigure('MeshBoundaryCoordinates') ;  
% plot(MeshBoundaryCoordinates(:,1),MeshBoundaryCoordinates(:,2),'.-') ; axis equal
% title("MeshBoundaryCoordinates")


end
