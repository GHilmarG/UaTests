


%%
load("DomainOutline.mat","xp","yp");

xp=xp(:)*1000;  yp=yp(:)*1000;  % Because these coordinates are in km


CtrlVar=Ua2D_DefaultParameters();
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;


CtrlVar.MeshSize=0.25e3;
CtrlVar.MeshSizeMin=0.25e3;
CtrlVar.MeshSizeMax=0.25e3;

MeshBoundaryCoordinates=[xp yp(:)]; 
UserVar=[];

[UserVar,MUA]=genmesh2d(UserVar,CtrlVar,MeshBoundaryCoordinates);
figure ; PlotMuaMesh(CtrlVar,MUA); drawnow


save("MeshFile250m.mat","MUA","MeshBoundaryCoordinates")