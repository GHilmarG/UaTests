
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)

% This run illustraites the horizontal asymmetry in GL migration
% over tides
%
%
% Run this for UserVar.geo set to a suitable value (see below) and then plot the results uinsg PlotGL
%
% This is really a rather rough coding and not a polised example, but it does work. 
%
%%


UserVar.geo='dsdx'; % {'dsdx','dhdx'}  % dsdx -> surface slope (dsdx) is constant
% dhdx -> thickness gradient (dhdx) is constant

%%

CtrlVar.Experiment='TestTides';

xd=30e3; xu=-100e3 ; yl=2.5e3 ; yr=-2.5e3;
MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);

CtrlVar.kH=100;
%% Types of runs
CtrlVar.TimeDependentRun=1 ;
CtrlVar.time=0 ;
CtrlVar.dt=0.025/365.25;   % the time unit is years

CtrlVar.TotalNumberOfForwardRunSteps=100;

CtrlVar.AdaptiveTimeStepping=0 ;         % true if time step should potentially be modified
CtrlVar.ResetTime=0 ;                    % set to 1 to reset (model) time at start of restart run
CtrlVar.RestartTime=NaN;                 % if ResetTime is true, then this is the model time at the start of the restart run
CtrlVar.ResetTimeStep=1;                 % 1 if time step should be reset to dt given in the Ua2D_InitialUserInputFile
CtrlVar.Restart=0;
CtrlVar.ReadInitialMesh=0;  CtrlVar.AdaptMesh=1;

CtrlVar.ReadInitialMeshFileName='InitialMesh.mat';

CtrlVar.GeometricalVarsDefinedEachTransienRunStepByDefineGeometry="S";  % this needs to be defined if ocean surface (S) is to be modified in the transient run (ie tides)


%% Solver
CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
CtrlVar.InfoLevelNonLinIt=1;
CtrlVar.LineSeachAllowedToUseExtrapolation=1;

%% Restart

CtrlVar.WriteRestartFile=1;
CtrlVar.NameOfRestartFiletoRead='IceStream-Restart.mat';
CtrlVar.NameOfRestartFiletoWrite='IceStream-Restart.mat';



%% Mesh generation 

CtrlVar.TriNodes=3 ;
CtrlVar.MeshSize=2.5e3;
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.MaxNumberOfElements=10000;

%% for adaptive meshing
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';
CtrlVar.AdaptMeshAndThenStop=0;
CtrlVar.AdaptMeshMaxIterations=10;
CtrlVar.AdaptMeshRunStepInterval=1;
CtrlVar.MeshAdapt.GLrange=[5000 5*CtrlVar.MeshSizeMin ; 2000 2*CtrlVar.MeshSizeMin ; 500 CtrlVar.MeshSizeMin];

%% plotting
CtrlVar.doplots=0;       % 
CtrlVar.doRemeshPlots=1; %  
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=0;
CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes



end
