%% Examples of local mesh refinement

UserVar=[];
RunInfo=UaRunInfo;
F=UaFields;
CtrlVar=Ua2D_DefaultParameters(); %
CtrlVar.PlotXYscale=1; 
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
% Note; When creating this mesh using Úa, only the following 
% three lines are required in the Ua2D_InitialUserInput.m
CtrlVar.MeshSizeMax=1; 
CtrlVar.MeshSizeMin=0.2;
CtrlVar.MeshSize=0.025;

MeshBoundaryCoordinates=[-1 -1 ; -1 0 ; 0 1 ; 1 0 ; 1 -1 ; 0 0];

CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
% Now generate mesh (When using Úa this is done internally, no such call
% then needed).


[UserVar,MUA]=genmesh2d(UserVar,CtrlVar);





%% Refine all elements using the local newest red-green method

MUAold=MUA;
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
tiledlayout(1,2)

nexttile ; UaPlots(CtrlVar,MUAold,F,ValuesOld) ; hold on ; PlotMuaMesh(CtrlVar,MUAold) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ;




%% Refine all elements using the local newest vertex bisection method


ElementsToBeCoarsened=false(MUAold.Nele,1);
ElementsToBeRefined=true(MUAold.Nele,1);

CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection' ; 
[MUAnew,RunInfo]=LocalMeshRefinement(CtrlVar,RunInfo,MUAold,ElementsToBeRefined,ElementsToBeCoarsened) ; 

CtrlVar.InfoLevelAdaptiveMeshing=1000;
OutsideValues=[] ; 
tic
[RunInfo,ValuesNew]=MapNodalVariablesFromMesh1ToMesh2UsingShapeAndScattered(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,ValuesOld);
toc

FindOrCreateFigure("old and new values: Ex2")
tiledlayout(1,2)

nexttile ; UaPlots(CtrlVar,MUAold,F,ValuesOld) ; hold on ; PlotMuaMesh(CtrlVar,MUAold) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ;

%% Refine about half of the elements 





ElementsToBeCoarsened=false(MUAold.Nele,1);
ElementsToBeRefined=MUA.xEle< 0 ; 

CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection' ; 
[MUAnew,RunInfo]=LocalMeshRefinement(CtrlVar,RunInfo,MUAold,ElementsToBeRefined,ElementsToBeCoarsened) ; 



CtrlVar.InfoLevelAdaptiveMeshing=1000;
OutsideValues=[] ; 
tic
[RunInfo,ValuesNew]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,ValuesOld);
toc

FindOrCreateFigure("old and new values: Ex3")
tiledlayout(1,2)

nexttile ; UaPlots(CtrlVar,MUAold,F,ValuesOld) ; hold on ; PlotMuaMesh(CtrlVar,MUAold) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ;


%% And now unrefine again.  Unrefinement can only be done using newest vertex bisection and for those elements that previously where refined



MUAold=MUAnew;
ValuesOld=MUAold.coordinates(:,1) ; 

ElementsToBeCoarsened=true(MUAold.Nele,1); ElementsToBeRefined=false(MUAold.Nele,1);





CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection' ; 

MUAnewTemp=MUAold;  % to get back to original level I may need to do several unrefinements
for I=1:4
    [MUAnewTemp,RunInfo]=LocalMeshRefinement(CtrlVar,RunInfo,MUAnewTemp,ElementsToBeRefined,ElementsToBeCoarsened) ;
    ElementsToBeCoarsened=true(MUAnewTemp.Nele,1); ElementsToBeRefined=false(MUAnewTemp.Nele,1);
end
MUAnew=MUAnewTemp;

CtrlVar.InfoLevelAdaptiveMeshing=1000;
OutsideValues=[] ; 
tic
[RunInfo,ValuesNew]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,ValuesOld);
toc

FindOrCreateFigure("old and new values: Ex4")
tiledlayout(1,2)

nexttile ; UaPlots(CtrlVar,MUAold,F,ValuesOld) ; hold on ; PlotMuaMesh(CtrlVar,MUAold) ;
nexttile ; UaPlots(CtrlVar,MUAnew,F,ValuesNew) ; hold on ; PlotMuaMesh(CtrlVar,MUAnew) ;

FindOrCreateFigure("residuals") ; UaPlots(CtrlVar,MUA,F,ValuesNew-MUAnew.coordinates(:,1));




