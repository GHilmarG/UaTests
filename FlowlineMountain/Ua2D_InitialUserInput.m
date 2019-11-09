

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


CtrlVar.TimeDependentRun=1; 
CtrlVar.Experiment='FlowLineMountain';
CtrlVar.time=0 ; 
CtrlVar.dt=1; 
CtrlVar.TotalNumberOfForwardRunSteps=50;  
CtrlVar.TotalTime=2000;


CtrlVar.AdaptiveTimeStepping=1 ; CtrlVar.ATStimeStepTarget=1.0  ;
CtrlVar.Restart=0;   CtrlVar.ResetTimeStep=0;  CtrlVar.WriteRestartFileInterval=100;
CtrlVar.WriteRestartFile=1;

CtrlVar.FlowApproximation='SSHEET';
CtrlVar.UpdateBoundaryConditionsAtEachTimeStep=1;

%% Thickness
CtrlVar.ThickMin=1;
CtrlVar.ThicknessConstraintsInfoLevel=0;
CtrlVar.ResetThicknessToMinThickness=0;
CtrlVar.ThicknessConstraints=1;

%%
CtrlVar.FEmeshAdvanceRetreat=1;
CtrlVar.FEmeshAdvanceRetreatDT=0;
CtrlVar.FEmeshAdvanceRetreatBackgroundMeshFileName='MUA_Background';

%%
xd=70e3; xu=-70e3 ; yl=1e3 ; yr=-1e3;
MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];
CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';  % these lines are added to the gmsh .geo input file each time such a file is created
CtrlVar.GmshMeshingAlgorithm=8;  % see gmsh manual 
CtrlVar.OnlyMeshDomainAndThenStop=0; % if true then only meshing is done and no further calculations. Usefull for checking if mesh is reasonable  

CtrlVar.TriNodes=3;   % [3,6,10]    
    

CtrlVar.MeshSize=0.25e3;  % Rather fine mesh


CtrlVar.MeshSize=1e3;  %
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.MaxNumberOfElements=100000;

%%
CtrlVar.ReadInitialMesh=1;    % if true then read FE mesh (coordinates, connectivity) directly from a .mat file
CtrlVar.ReadInitialMeshFileName='MUA_Background';
%%


CtrlVar.PlotXYscale=1000;
CtrlVar.doplots=1;  CtrlVar.doAdaptMeshPlots=1; 
CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1; CtrlVar.PlotNodes=0;

end
