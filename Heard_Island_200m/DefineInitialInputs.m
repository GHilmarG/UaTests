function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%% Run type

CtrlVar.Experiment = UserVar.RunType;

switch UserVar.RunType

    case 'inverse_run'
        CtrlVar.InverseRun=1;
        UserVar.ys=2000;
        UserVar.ye=2019;
        UserVar.Outputsdirectory='inverse_run';

    case 'spin-up'
        CtrlVar.InverseRun=0;
        CtrlVar.TotalTime=20;
        UserVar.Outputsdirectory='spin-up';

    case 'forward_run'
        CtrlVar.InverseRun=0;
        CtrlVar.TotalTime=2100-2000+1; %2100 or equilibrium
        UserVar.Outputsdirectory='forward_run';

end

CtrlVar.TimeDependentRun=1;
CtrlVar.Restart=0;
CtrlVar.WriteRestartFile=1;
CtrlVar.Inverse.NameOfRestartOutputFile='Restart.mat';
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;

%% Run-stop criteria

CtrlVar.TotalNumberOfForwardRunSteps=inf; %inf
CtrlVar.time=0;
CtrlVar.UseUserDefinedRunStopCriterion=false;
CtrlVar.AdaptiveTimeStepping=true;
CtrlVar.dt=0.01;
CtrlVar.dtmin=1e-12;

%% Inversion

CtrlVar.Inverse.DataMisfit.GradientCalculation='Adjoint';
CtrlVar.Inverse.Methodology="-Tikhonov-";
CtrlVar.Inverse.InvertFor='-logA-logC-' ; 
CtrlVar.Inverse.Regularize.Field='-logA-logC-';
CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased";
CtrlVar.Inverse.Hessian="RHA=E RHC=E IHC=FP IHA=FP";

CtrlVar.Inverse.Iterations=500;
CtrlVar.Inverse.SaveSlipperinessEstimateInSeperateFile=true;
CtrlVar.Inverse.SaveAGlenEstimateInSeperateFile=true ;
CtrlVar.NameOfFileForSavingSlipperinessEstimate='C-Estimate.mat';
CtrlVar.NameOfFileForSavingAGlenEstimate='AGlen-Estimate.mat';

CtrlVar.Inverse.Measurements='-uv-';
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=10000;

CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=10000;

CtrlVar.Inverse.DataMisfit.Multiplier=1;
CtrlVar.Inverse.Regularize.Multiplier=1;
CtrlVar.Inverse.dFuvdClambda=false;

%% Ice flow approximation and sliding law

CtrlVar.FlowApproximation='SSTREAM';
CtrlVar.alpha=0;
CtrlVar.SlidingLaw="W";

%% Calving

CtrlVar.LevelSetMethod=true;
CtrlVar.LevelSetEvolution="-Prescribed-"; % -Prescribed-; -By solving the level set equation-
CtrlVar.LevelSetMethodAutomaticallyResetIceThickness=0;
CtrlVar.LevelSetMethodAutomaticallyApplyMassBalanceFeedback=1;
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-1;
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffCubic=-0;
CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin;

%% Reading in mesh

CtrlVar.ReadInitialMeshFileName='InitialMesh.mat';
CtrlVar.SaveInitialMeshFileName='InitialMesh.mat';

%% mesh generation

CtrlVar.AdaptMesh=0;
CtrlVar.AdaptMeshRunStepInterval=1;
CtrlVar.AdaptMeshMaxIterations=1;
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=5;
CtrlVar.MeshRefinementMethod='explicit:global';
CtrlVar.SaveAdaptMeshFileName='InitialMesh.mat';
CtrlVar.AdaptMeshAndThenStop=1;

%% MeshBoundaryCoordinates

CtrlVar.TriNodes=3;
CtrlVar.MeshSize=200;
CtrlVar.MeshSizeMax=200;
CtrlVar.MeshSizeMin=200;

m = readtable('point_200m.csv');       % (Hilmar: is this in lat lon? Does this not need to be projected to a local coordinate system?)
MeshBoundaryCoordinates(:,1) = m.lon;  % (Hilmar: the units of the (x,y) coordinates need to be in meters)
MeshBoundaryCoordinates(:,2) = m.lat;

%% Info levels

CtrlVar.Inverse.InfoLevel=1;
CtrlVar.Inverse.InfoLevelBackTrack=1;
CtrlVar.InfoLevelNonLinIt=1;
CtrlVar.InfoLevelAdaptiveMeshing=1;

%% Pos. thickness constraints

CtrlVar.ThickMin=1;
CtrlVar.ResetThicknessToMinThickness=0;
CtrlVar.ThicknessConstraints=1;
CtrlVar.ThicknessConstraintsItMax=0;  % if iterations set to zero, just solve then update but do not solve again

%% Plotting options

CtrlVar.PlotXYscale=1000;
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
CtrlVar.PlotGroundingLines = true;
CtrlVar.PlotCalvingFronts = true;


%% Parallel options


CtrlVar.Parallel.uvhAssembly.spmd.isOn=false;        % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.uvAssembly.spmd.isOn=false;         % assembly in parallel using spmd over sub-domain (domain decomposition)  

CtrlVar.Parallel.isTest=false;                 % Runs both with and without parallel approach, and prints out some information on relative performance. 
                                               % Good for testing if switching on the parallel options speeds things up, and by how much.

CtrlVar.Parallel.Distribute=false;       

%% Outputs

CtrlVar.DefineOutputsDt=1;
CtrlVar.DefineOutputsMaxNrOfCalls=NaN;
CtrlVar.DefineOutputsInfostring=0;
CtrlVar.Outputsdirectory=UserVar.Outputsdirectory;
 
end
