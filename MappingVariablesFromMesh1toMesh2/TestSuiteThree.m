
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
RunInfo=UaRunInfo; F=UaFields;
%% Deactivate elements, 
% Here the interpolation error should be numerically zero as all new nodes are contained in the old mesh 

CtrlVar.MapOldToNew.method="scatteredInterpolant" ; 
CtrlVar.MapOldToNew.method="ShapeAndScattered" ; 

MUAold=MUAlogo;
ValuesOld=MUAold.coordinates(:,1) ; OutsideValues=[] ; 

ElementsToBeDeactivated=MUAold.xEle<200 ;   

[MUAnew,k,l]=DeactivateMUAelements(CtrlVar,MUAold,ElementsToBeDeactivated) ;


FindOrCreateFigure("UA Logo") ; PlotMuaMesh(CtrlVar,MUAnew,'k') ; axis xy on ; title(' ')



CtrlVar.InfoLevelAdaptiveMeshing=1000;

tic
 [RunInfo,ValuesNew]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,ValuesOld);
toc

FindOrCreateFigure("old and new values: Ex1")
tiledlayout(1,3)

nexttile ; UaPlots(CtrlVar,MUAold,F,ValuesOld) ; hold on ; PlotMuaMesh(CtrlVar,MUAold) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ;
Residuals=ValuesNew-MUAnew.coordinates(:,1);
nexttile ; UaPlots(CtrlVar,MUAnew,F,Residuals) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ; 
Res=norm(Residuals)/sqrt(numel(Residuals));
title(sprintf("residuals: norm=%g",Res))

MUAdeactivated=MUAnew;

%% Now add local mesh refinement to the previously deactivated mesh


MUAold=MUAdeactivated;
ValuesOld=MUAold.coordinates(:,1) ; OutsideValues=[] ; 
ElementsToBeCoarsened=false(MUAold.Nele,1);
ElementsToBeRefined=true(MUAold.Nele,1);

CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection' ; 
[MUAnew,RunInfo]=LocalMeshRefinement(CtrlVar,RunInfo,MUAold,ElementsToBeRefined,ElementsToBeCoarsened) ; 

CtrlVar.InfoLevelAdaptiveMeshing=1000;

tic
[RunInfo,ValuesNew]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,ValuesOld);
toc

FindOrCreateFigure("old and new values: Ex2")
tiledlayout(1,3)

nexttile ; UaPlots(CtrlVar,MUAold,F,ValuesOld) ; hold on ; PlotMuaMesh(CtrlVar,MUAold) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ;
Residuals=ValuesNew-MUAnew.coordinates(:,1);
nexttile ; UaPlots(CtrlVar,MUAnew,F,Residuals) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ; 
Res=norm(Residuals)/sqrt(numel(Residuals));
title(sprintf("residuals: norm=%g",Res))

MUADR=MUAnew;  % Deactivated and Refined
%% Now map from the previously deactivated and refined mesh onto the original MUAlogo mesh
% this involves extrapolation onto outside nodes


MUAold=MUADR;
ValuesOld=MUAold.coordinates(:,1) ; OutsideValues=-100 ; 


MUAnew=MUAlogo ; 

CtrlVar.MapOldToNew.method="scatteredInterpolant" ; 
CtrlVar.MapOldToNew.method="ShapeAndScattered" ; 
CtrlVar.InfoLevelAdaptiveMeshing=1000;

tic
[RunInfo,ValuesNew]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,ValuesOld);
toc

FindOrCreateFigure("old and new values: Ex3")
tiledlayout(1,3)

nexttile ; UaPlots(CtrlVar,MUAold,F,ValuesOld) ; hold on ; PlotMuaMesh(CtrlVar,MUAold) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ;

nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew-MUAnew.coordinates(:,1)) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ; 

title("residuals")




























