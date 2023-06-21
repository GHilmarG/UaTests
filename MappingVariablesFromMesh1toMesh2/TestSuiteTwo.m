
I = imread('Ua.png'); BW = imbinarize(I); 
% imshow(BW);
[B,L] = bwboundaries(BW,'holes');
% imshow(label2rgb(L, @jet, [.5 .5 .5]))

for k = 1:5  % length(B)
   boundary = B{k};
  % plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end

N=3;
MeshBoundaryCoordinates=...
    [1 NaN ;  B{1}(1:N:end,:) ; ...
%    1 NaN ; B{2}(1:N:end,:) ; ...
    1 NaN ; B{3}(1:N:end,:) ; ...
    1 NaN ; B{4}(1:N:end,:) ; ...
    1 NaN ; B{14}(1:N:end,:) ; ...
    1 NaN ; B{17}(1:N:end,:) ; ...
    1 NaN ; B{18}(1:N:end,:)];

CtrlVar=Ua2D_DefaultParameters(); CtrlVar.PlotXYscale=1; 
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=false; 
CtrlVar.MeshSizeMax=10; 
CtrlVar.MeshSize=5; 
CtrlVar.MeshSizeMin=1; 
CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
CtrlVar.MeshGenerator='mesh2d';  

[UserVar,MUA]=genmesh2d([],CtrlVar); 


x=MUA.coordinates(:,1) ; y=MUA.coordinates(:,2);
MUA.coordinates(:,1)=y ; MUA.coordinates(:,2)=-x;

% Since I've changed the coordinates, I must re-create MUA
MUA=CreateMUA(CtrlVar,MUA.connectivity,MUA.coordinates);


FindOrCreateFigure("UA Logo") ; PlotMuaMesh(CtrlVar,MUA,'k') ; axis xy on ; title(' ')


FindOrCreateFigure("ele sizes histogram") ; histogram( sqrt(2*MUA.EleAreas)) ; xlabel("Element size")


MUAlogo=MUA;
%% red-green refinement

RunInfo=UaRunInfo; F=UaFields;


MUAold=MUAlogo;
ValuesOld=MUAold.coordinates(:,1) ; 

ElementsToBeCoarsened=false(MUAold.Nele,1);
ElementsToBeRefined=true(MUAold.Nele,1);

CtrlVar.MeshRefinementMethod='explicit:local:red-green' ;
[MUAnew,RunInfo]=LocalMeshRefinement(CtrlVar,RunInfo,MUAold,ElementsToBeRefined,ElementsToBeCoarsened) ; 



CtrlVar.InfoLevelAdaptiveMeshing=1000;
OutsideValues=[] ; 
tic
[RunInfo,ValuesNew]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,ValuesOld);
toc

FindOrCreateFigure("old and new values: Ex1")
tiledlayout(1,3)

nexttile ; UaPlots(CtrlVar,MUAold,F,ValuesOld) ; hold on ; PlotMuaMesh(CtrlVar,MUAold) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew-MUAnew.coordinates(:,1)) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ; title("residuals")



%%

MUAold=MUAlogo;
ElementsToBeCoarsened=false(MUAold.Nele,1);
ElementsToBeRefined=true(MUAold.Nele,1);

CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection' ; 
[MUAnew,RunInfo]=LocalMeshRefinement(CtrlVar,RunInfo,MUAold,ElementsToBeRefined,ElementsToBeCoarsened) ; 

CtrlVar.InfoLevelAdaptiveMeshing=1000;
OutsideValues=[] ; 
tic
[RunInfo,ValuesNew]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,ValuesOld);

toc

FindOrCreateFigure("old and new values: Ex2")
tiledlayout(1,3)

nexttile ; UaPlots(CtrlVar,MUAold,F,ValuesOld) ; hold on ; PlotMuaMesh(CtrlVar,MUAold) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew-MUAnew.coordinates(:,1)) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ; title("residuals")

























