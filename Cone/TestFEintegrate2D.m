CtrlVar=Ua2D_DefaultParameters();
CtrlVar.fidlog=1;
CtrlVar.MeshSizeMax=500;
CtrlVar.MeshSizeMin=500;
MeshBoundaryCoordinates=[0 0 ; 10000 0 ; 10000 2000 ; 0 2000];

%[coordinates,connectivity]=genmesh2d(' ',MeshBoundaryCoordinates,CtrlVar);
[MUA,FEmeshTriRep]=genmesh2d(CtrlVar,MeshBoundaryCoordinates); % ,edge,face,GmeshBackgroundScalarField);

CtrlVar.PlotMesh=1; 
figure ; PlotFEmesh(MUA.coordinates,MUA.connectivity,CtrlVar)

f=MUA.coordinates(:,1)*0+1;

format long g
Int=FEintegrate2D(CtrlVar,MUA,f) ; sum(Int)




 