
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


UserVar.InterpolantDirectory='../Interpolants/CS_Data';


CtrlVar.Experiment='ChhotaShigri';
CtrlVar.TimeDependentRun=1 ;  % any of [0|1].  
CtrlVar.time=0 ; 
CtrlVar.dt=0.001; 
CtrlVar.TotalNumberOfForwardRunSteps=10;  
CtrlVar.TotalTime=10;
CtrlVar.AdaptiveTimeStepping=1 ; 
CtrlVar.ATStimeStepTarget=1  ;

CtrlVar.Restart=0;   CtrlVar.ResetTimeStep=0;  
%CtrlVar.NameOfRestartFiletoRead='Restartfile_Run1.mat';
%CtrlVar.NameOfRestartFiletoWrite='Ua2D_Restartfile.mat';
CtrlVar.UaOutputsDt=1;  % 

CtrlVar.FlowApproximation='SSTREAM';   %  'SSHEET';


%% Thickness
CtrlVar.ThickMin=1;
CtrlVar.ThicknessConstraintsInfoLevel=1;
CtrlVar.ResetThicknessToMinThickness=0;
CtrlVar.ThicknessConstraints=1;

%%
CtrlVar.ReadInitialMesh=1;    % if true then read FE mesh (coordinates, connectivity) directly from a .mat file
CtrlVar.ReadInitialMeshFileName='MUA_Initial';
CtrlVar.FEmeshAdvanceRetreat=1;
CtrlVar.FEmeshAdvanceRetreatDT=0;
%CtrlVar.FEmeshAdvanceRetreatBackgroundMeshFileName='BackgroundMeshfile';
CtrlVar.FEmeshAdvanceRetreatBackgroundMeshFileName='Backgroundmesh';
CtrlVar.InfoLevelAdaptiveMeshing=100;

%%

load('BoundaryCoordinates.mat','BoundaryCoordinates');
MeshBoundaryCoordinates=BoundaryCoordinates;

CtrlVar.OnlyMeshDomainAndThenStop=0; 
CtrlVar.OnlyDoFirstTransientPlotAndThenStop=0; 
    
    
CtrlVar.TriNodes=3;   % [3,6,10]
CtrlVar.MeshSize=0.25e3;
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.MaxNumberOfElements=100000;

%%

%%
CtrlVar.PlotXYscale=1000;
CtrlVar.doplots=1;  CtrlVar.doAdaptMeshPlots=1; 
CtrlVar.PlotMesh=0; CtrlVar.PlotBCs=0; CtrlVar.PlotNodes=1;


end
