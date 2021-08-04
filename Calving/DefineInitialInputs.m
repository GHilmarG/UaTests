
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%%
%
%   23/03/3021: New test with a constant prescribed constant calving rate
%
%
%
%
%
%%


%%
%
% CalvingJobDW30=batch('Ua')
%%

% UserVar.RunType="Test-1dAnalyticalIceShelf-";

CtrlVar.LevelSetInfoLevel=100;

if isempty(UserVar)
    UserVar.RunType="-ManuallyDeactivateElements-ManuallyModifyThickness-";
    UserVar.RunType="-ManuallyModifyThickness-";
    UserVar.RunType="-1dAnalyticalIceShelf-"; CtrlVar.doplots=0;
    
    UserVar.RunType="-MeltFeedback-1dIceShelf-"; CtrlVar.doplots=0;
    UserVar.RunType="CFAa10000CFAb2000CFBa5000CFBb500-RTinf-FAB0k01-CFp2q4-CubicMF-CAisNumTau-LevelSetWithMeltFeedback-1dIceShelf-";
    UserVar.RunType="CFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB0k01-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-";
    UserVar.RunType="CFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB0k001-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-";
    UserVar.RunType="CFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB0k0001-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-";
    UserVar.RunType="CFAa10000CFAb2000CFBa5000CFBb500-RTinf-FAB0k0001-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-";
    
    UserVar.RunType="-RT10-FAB1-1dAnalyticalIceShelf-CAisConstant-";
    
    CtrlVar.doplots=0;
    %UserVar.RunType="-TravellingFront-1dAnalyticalIceShelf-"; CtrlVar.doplots=0;
    
    CtrlVar.AdaptiveTimeStepping=1 ;
    
    CtrlVar.LevelSetInitialisationInterval=10;
    CtrlVar.DefineOutputsDt=1;
end


UserVar.Plots="-plot-save-Calving1dIceShelf-plotcalving-";
% UserVar.Plots="-save-";


CtrlVar.dt=0.01;
CtrlVar.TriNodes=3;
UserVar.InitialGeometry="-MismipPlus-" ;  % default)

if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
    UserVar.InitialGeometry="-1dAnalyticalIceShelf-" ;
end

CtrlVar.Restart=0;

if CtrlVar.Restart
    CtrlVar.AdaptMesh=0;  % trying to speed things up by having not adapt in a restart
else
    CtrlVar.AdaptMesh=1;
end


CtrlVar.TotalTime=5;
CtrlVar.TotalNumberOfForwardRunSteps=inf;
CtrlVar.AdaptMeshMaxIterations=1;  % Number of adapt mesh iterations within each run-step.
CtrlVar.doplots=1;




CtrlVar.LevelSetMethod=1; CtrlVar.DevelopmentVersion=1;


CtrlVar.LevelSetInitialisationInterval=str2double(replace(extractBetween(UserVar.RunType,"-RT","-"),"k","."));
CtrlVar.LevelSetFAB=str2double(replace(extractBetween(UserVar.RunType,"-FAB","-"),"k","."));
CtrlVar.LevelSetFABCostFunction=extractBetween(UserVar.RunType,"-CF","-") ;

CtrlVar.DefineOutputsDt=1;  % because I'm testing
CtrlVar.dt=1e-3;

CtrlVar.ATSdtMin=1e-2;
CtrlVar.TotalNumberOfForwardRunSteps=inf;

% UserVar.Plots="-save-";
CtrlVar.AdaptMeshMaxIterations=20;  % Number of adapt mesh iterations within each run-step.
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=20;


CAis=extractBetween(UserVar.RunType,"-CAis","-") ;
if CAis=="Ana"
    UserVar.Calving="Function of analytical thickness" ; % "Function of analytical thickness" ;
elseif CAis=="Num"
    UserVar.Calving="Function of numerical thickness";
elseif CAis=="NumTau"
    UserVar.Calving="Function of numerical tauxx";
elseif CAis=="Constant"
    UserVar.Calving="Constant calving rate";
elseif CAis=="Zero"
    UserVar.Calving="Zero calving rate";
end








CtrlVar.InfoLevelNonLinIt=1; CtrlVar.uvhMinimisationQuantity="Force Residuals";
%%

UserVar.Outputsdirectory='ResultsFiles'; % This I use in DefineOutputs
UserVar.MassBalanceCase='ice0';

%%



%% Types of run
%
CtrlVar.TimeDependentRun=1;
CtrlVar.time=0;
CtrlVar.ATSdtMax=1;
CtrlVar.ATSdtMin=0.01;
CtrlVar.WriteRestartFile=1;

%% Reading in mesh
CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
% unless the adaptive meshing option is used, no further meshing is done.
% CtrlVar.ReadInitialMeshFileName='AdaptMesh.mat';
% CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
%% Plotting options
CtrlVar.PlotMesh=1;
CtrlVar.PlotBCs=1;
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;

CtrlVar.PlotXYscale=1000;
%%




%% adapt mesh


CtrlVar.MeshGenerator='mesh2d'   ;   % 'gmsh';  % possible values: {mesh2d|gmsh}
CtrlVar.GmshMeshingAlgorithm=8;     % see gmsh manual
% 1=MeshAdapt
% 2=Automatic
% 5=Delaunay
% 6=Frontal
% 7=bamg
% 8=DelQuad (experimental)
% very coarse mesh resolution
CtrlVar.MeshSize=10e3;       % over-all desired element size
CtrlVar.MeshSizeMax=10e3;    % max element size
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;     % min element size

% reasonably fine mesh resolution
%CtrlVar.MeshSize=8e3;       % over-all desired element size
%CtrlVar.MeshSizeMax=8e3;    % max element size
%CtrlVar.MeshSizeMin=200;    % min element size

CtrlVar.MaxNumberOfElements=250e3;           % max number of elements. If #elements larger then CtrlMeshSize/min/max are changed

CtrlVar.AdaptMeshRunStepInterval=1;  % number of run-steps between mesh adaptation
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=5;
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';    % can have any of these values:
% 'explicit:global'
% 'explicit:local'
% 'explicit:local:red-green'
% 'explicit:local:newest vertex bisection';
%
CtrlVar.SaveAdaptMeshFileName=[] ; % no file written if left empty "AdaptMesh"+CtrlVar.Experiment+".mat";
CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed
% usefull, for example, when trying out different remeshing options (then use CtrlVar.doRemeshPlots=1 to get plots)


CtrlVar.MeshAdapt.GLrange=[20000 5000 ; 5000 2000];


L1=str2double(replace(extractBetween(UserVar.RunType,"CFAa","CFAb"),"k","."));
l1=str2double(replace(extractBetween(UserVar.RunType,"CFAb","CFBa"),"k","."));
L2=str2double(replace(extractBetween(UserVar.RunType,"CFBa","CFBb"),"k","."));
l2=str2double(replace(extractBetween(UserVar.RunType,"CFBb","-"),"k","."));
% CtrlVar.MeshAdapt.CFrange=[10000 2000 ; 5000 1000];

if CtrlVar.LevelSetMethod
    CtrlVar.MeshAdapt.CFrange=[L1 l1 ; L2 l2];
end



if contains(UserVar.RunType,"-1dIceShelf-") || contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
    I=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
    CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001/1000;
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[]; 
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).p=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;
end
%% Pos. thickness constr


CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=5  ;

%% MeshBoundaryCoordinates

if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
    xd=640e3; xu=0e3 ; yr=-10e3 ; yl=10e3 ;
else
    xd=640e3; xu=0e3 ; yr=0 ; yl=80e3 ;
end
MeshBoundaryCoordinates=[xu yr ; xu yl ; xd yl ; xd yr];




%% Experiment and file name

CtrlVar.Experiment="Ex"+UserVar.RunType+"-MB"+UserVar.MassBalanceCase+"-SUPG"+CtrlVar.uvh.SUPG.tau+"-Adapt"+num2str(CtrlVar.AdaptMesh);
CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
CtrlVar.NameOfRestartFiletoWrite="Restart"+CtrlVar.Experiment+".mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;

CtrlVar.NameOfRestartFiletoRead="RestartExCFAa10000CFAb2000CFBa5000CFBb500-RTinf-FAB0k01-CFp2q4-CubicMF-CAisNumTau-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1" ;

end

