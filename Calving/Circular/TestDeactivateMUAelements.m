%%


UserVar=[];
CtrlVar=Ua2D_DefaultParameters(); %
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
% Note; When creating this mesh using Úa, only the following
% three lines are required in the Ua2D_InitialUserInput.m
CtrlVar.MeshSizeMax=100;
CtrlVar.MeshSizeMin=100;
CtrlVar.MeshSize=100;


MeshBoundaryCoordinates=1000*[-1 -1 ; -1 0 ; 0 1 ; 1 0 ; 1 -1 ; 0 0];
CtrlVar.PlotXYscale=1;
CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
% Now generate mesh (When using Úa this is done internally, no such call
% then needed).


[UserVar,MUA]=genmesh2d(UserVar,CtrlVar);


F.x=MUA.coordinates(:,1) ; 


ElementsToBeDeactivated=MUA.xEle< 0 & MUA.yEle>0 ; 

CtrlVar.sweep=1; % CtrlVar.SweepAngle=-1;

[MUAnew,K]=DeactivateMUAelements(CtrlVar,MUA,ElementsToBeDeactivated) ;
Fnew.x=F.x(K,1);


CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;

FindOrCreateFigure("MUA before"); PlotMuaMesh(CtrlVar,MUA); 
hold on ; PlotMuaBoundary(CtrlVar,MUA,'r',LineWidth=2)

FindOrCreateFigure("x before") ; PlotMeshScalarVariable(CtrlVar,MUA,F.x)  ; caxis([-1000 1000])

FindOrCreateFigure("MUA after") ; PlotMuaMesh(CtrlVar,MUAnew); 
hold on ; PlotMuaBoundary(CtrlVar,MUAnew,'r',LineWidth=2)
FindOrCreateFigure("x after") ; PlotMeshScalarVariable(CtrlVar,MUAnew,Fnew.x)  ; caxis([-1000 1000])



