
CtrlVar=Ua2D_DefaultParameters;

CtrlVar.GmshFile='GeoInputFile.geo';

%CtrlVar.GmshMeshingMode='create new gmesh .geo input file and mesh domain and load .msh';
CtrlVar.GmshMeshingMode='read existing gmesh. geo input file and mesh domain and load .msh';


CtrlVar.PlotXYscale=1000;
GmeshBackgroundScalarField=[];
MeshBoundaryCoordinates=[];
[coordinates,connectivity]=GmeshInterfaceRoutine(CtrlVar,MeshBoundaryCoordinates,GmeshBackgroundScalarField);


figure
PlotFEmesh(coordinates,connectivity,CtrlVar);


return
%%
% now create background scalar field

GmeshBackgroundScalarField.xy=coordinates;
GmeshBackgroundScalarField.TRI=connectivity;
GmeshBackgroundScalarField.EleSize=zeros(length(coordinates),1)+abs(coordinates(:,1)-5000)+10;

[coordinates,connectivity]=GmeshInterfaceRoutine(CtrlVar,MeshBoundaryCoordinates,GmeshBackgroundScalarField);

figure ; PlotFEmesh(coordinates,connectivity,CtrlVar);

