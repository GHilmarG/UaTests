function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%%

UserVar.Outputsdirectory='ResultsFiles'; % This I use in UaOutputs
UserVar.MassBalanceCase='ice0';
UserVar.InitialGeometry="-MismipPlus-"; 
UserVar.CalvingLaw="-FixedRate100-"  ;
% UserVar.CalvingLaw="-IceThickness10-"  ;
% UserVar.CalvingLaw="-CliffHeight10-"  ;
UserVar.MisExperiment=UserVar.CalvingLaw ; 
%%

CtrlVar.SlidingLaw="W" ;  % options:  "W","W-N0","minCW-N0","C","rpCW-N0", and "rCW-N0"  
CtrlVar.Experiment="MismipPlus-"+UserVar.MisExperiment;   

CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-"); 
%% Types of run
%
CtrlVar.TimeDependentRun=1; 
CtrlVar.TotalNumberOfForwardRunSteps=inf;
CtrlVar.TotalTime=100;
CtrlVar.Restart=0;  

%% time, time-step, output interval


CtrlVar.time=0; 
CtrlVar.dt=0.1;  

CtrlVar.DefineOutputsDt=1; % interval between calling UaOutputs. 0 implies call it at each and every run step.
                       % setting CtrlVar.DefineOutputsDt=1; causes UaOutputs to be called every 1 years.
                       % This is a more reasonable value once all looks OK.

CtrlVar.ATSdtMax=1;
CtrlVar.ATSdtMin=0.01;
CtrlVar.WriteRestartFile=1;

%% Reading in mesh
CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
                              % unless the adaptive meshing option is used, no further meshing is done.
CtrlVar.ReadInitialMeshFileName='AdaptMesh.mat';
CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
%% Plotting options
CtrlVar.doplots=1;
CtrlVar.PlotMesh=1; 
CtrlVar.PlotBCs=1;
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
CtrlVar.doRemeshPlots=1;
CtrlVar.PlotXYscale=1000; 
%%

CtrlVar.TriNodes=3;


CtrlVar.NameOfRestartFiletoWrite="Restart"+CtrlVar.Experiment+".mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;

%% Calving options

CtrlVar.LevelSetMethod=1;
CtrlVar.LevelSetEvolution="-By solving the level set equation-"   ; % "-prescribed-", 
CtrlVar.LevelSetInitialisationInterval=inf ; CtrlVar.LevelSetReinitializePDist=true ; 
CtrlVar.DevelopmentVersion=true; 

CtrlVar.LevelSetInfoLevel=1 ; 
CtrlVar.MeshAdapt.CFrange=[20e3 5e3 ; 10e3 2e3] ; % This refines the mesh around the calving front, but must set


% The melt is decribed as a= a_1 (h-hmin)
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-1;  % This is the constant a1, it has units 1/time.
% Default value is -1

CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin+1;    % this is the hmin constant, i.e. the accepted min ice thickness
% over the 'ice-free' areas.
% Default value is CtrlVar.ThickMin+1

CtrlVar.LevelSetEvolution="-By solving the level set equation-"  ; % "-prescribed-", 


%% adapt mesh
CtrlVar.AdaptMesh=1;         
CtrlVar.AdaptMeshInitial=0 ;       % if true, then a remeshing will always be performed at the inital step
CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed
                                   % usefull, for example, when trying out different remeshing options (then use CtrlVar.doRemeshPlots=1 to get plots)


CtrlVar.InfoLevelAdaptiveMeshing=1;
CtrlVar.doAdaptMeshPlots=1; 
CtrlVar.MeshGenerator='mesh2d' ; % 'gmsh';  % possible values: {mesh2d|gmsh}
% very coarse mesh resolution
CtrlVar.MeshSize=10e3;       % over-all desired element size
CtrlVar.MeshSizeMax=10e3;    % max element size
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;     % min element size

% reasonably fine mesh resolution
%CtrlVar.MeshSize=8e3;       % over-all desired element size
%CtrlVar.MeshSizeMax=8e3;    % max element size
%CtrlVar.MeshSizeMin=200;    % min element size

CtrlVar.MaxNumberOfElements=250e3;           % max number of elements. If #elements larger then CtrlMeshSize/min/max are changed


CtrlVar.AdaptMeshMaxIterations=2;  % Number of adapt mesh iterations within each run-step.
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';    % can have any of these values:
                                                   % 'explicit:global' 
                                                   % 'explicit:local'
                                                   % 'explicit:local:red-green'
                                                   % 'explicit:local:newest vertex bisection';
%  
CtrlVar.SaveAdaptMeshFileName='AdaptMesh.mat'; 



CtrlVar.AdaptMeshRunStepInterval=1;  % number of run-steps between mesh adaptation

% CtrlVar.MeshAdapt.GLrange=[20000 5000 ; 10000 500 ];



%% Pos. thickness constraints
CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=5  ; 

%%

xd=640e3; xu=0e3 ; yr=0 ; yl=80e3 ;  
MeshBoundaryCoordinates=[xu yr ; xu yl ; xd yl ; xd yr];

 
end
