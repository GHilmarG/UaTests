function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%%  This input file is used if Ua is run directly from the source code folder.
%  
% You will always need to create your own version of this file and put it into
% you working directory together with the other user-input m-files. 
%
%


%%
UserVar.Outputsdirectory='ResultsFiles'; % This I use in DefineOutputs

%%

CtrlVar.Experiment="RadialDome" ;
%% Types of run
%
CtrlVar.TimeDependentRun=1; 
CtrlVar.Restart=0;  
%%
CtrlVar.FlowApproximation="SSHEET" ;  
%% Info levels 
% higher numbers results in more information
CtrlVar.InfoLevelNonLinIt=1;        % info on non-linear solution
                                    % 1 give basic information. Usually good to set to 1
                                    % except in an inverse run where you might want to set
                                    % it to 0 to reduce info clutter
CtrlVar.InfoLevelAdaptiveMeshing=1; % for 5=> some plots are generated as well (but only if
                                    % both CtrlVar.doplots and CtrlVar.doAdaptMeshPlots
                                    % are set to true.)
%% Run-stop criteria
% The run stops once either forward run steps or (model) time has reached prescribed
% values. 
CtrlVar.TotalNumberOfForwardRunSteps=inf;
CtrlVar.TotalTime=100;
CtrlVar.UseUserDefinedRunStopCriterion=false; % one can also introduce UserDefined run stop criterion
                                              % through DefineRunStopCriterion.m

%% Sliding law
CtrlVar.SlidingLaw="W" ; 
    % "W" is the Weertman sliding law
    % "W-N0" is the Bud sliding law.
    % "minCW-N0" is the Tsai sliding law
    % "rCW-N0" ;  is the Cornford sliding law. This uses a 'reciprocal sum' of Coulomb and Weertman sliding laws. 
    % For description of further options and definitions, see Ua2D_DefaultParameters and
    % the UaCompendium.pdf 
%% time and time step
CtrlVar.dt=0.001; 
CtrlVar.time=0; 

CtrlVar.DefineOutputsDt=1; % interval between calling DefineOutputs. 0 implies call it at each and every run step.
                       % setting CtrlVar.DefineOutputsDt=1; causes DefineOutputs to be called every 1 years.
                       % This is a more reasonable value once all looks OK.

CtrlVar.AdaptiveTimeStepping=1 ;  % Adaptive time stepping. Almost always a good idea to 
                                  % use adaptive time stepping in transient runs.
CtrlVar.ATSdtMax=1; % max allowed time step when using ATS (Adaptive Time Stepping)

%%
CtrlVar.WriteRestartFile=1;

%% Reading in mesh
CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
                              % unless the adaptive meshing option is used, no further meshing is done.
CtrlVar.ReadInitialMeshFileName='AdaptMesh.mat';
CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
%% Plotting options
% Some plots can be generated automatically. However, once model is running, these plots
% are typically disabled. 
CtrlVar.doplots=1;  % set to 0 to suppress all plots. 
CtrlVar.PlotMesh=1; 
CtrlVar.PlotBCs=0;
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
CtrlVar.doRemeshPlots=1;
CtrlVar.PlotXYscale=1000; 
%%

CtrlVar.TriNodes=3;  % 3/linear, 6/quadratic or 10/cubic node elements


CtrlVar.NameOfRestartFiletoWrite="Restart"+CtrlVar.Experiment+".mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;



%% mesh generation
CtrlVar.MeshGenerator="mesh2d";  % this is the default option 
CtrlVar.AdaptMesh=1;         %



CtrlVar.MeshSizeMax=10e3; % max element size (coarse resolution)
CtrlVar.MeshSize=10e3;       % over-all desired element size
CtrlVar.MeshSizeMin=2e3;   % min ele size (coarse resolution)

% reasonably fine mesh resolution
%
%CtrlVar.MeshSizeMax=8e3;    % max element size
%CtrlVar.MeshSizeMin=200;    % min element size

CtrlVar.MaxNumberOfElements=250e3;           % max number of elements. If #elements larger then CtrlMeshSize/min/max are changed


CtrlVar.SaveAdaptMeshFileName='AdaptMesh.mat';
CtrlVar.SaveAdaptMeshFileName=[];          % file name for saving adapt mesh. If left empty, no file is written

CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';
%CtrlVar.MeshRefinementMethod='explicit:local:red-green';


CtrlVar.AdaptMeshInitial=1 ;       % if true, then a remeshing will always be performed at the inital step
CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed





%% Pos. thickness constraints
CtrlVar.ThickMin=0; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=5  ; 

%%
UserVar.R=100e3 ;
theta=linspace(0,2*pi,100); theta=theta(:) ; theta=theta(1:end-1) ;
MeshBoundaryCoordinates=[UserVar.R*sin(theta)  UserVar.R*cos(theta)];

 
end