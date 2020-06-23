
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


%%
%
% CalvingJobDW30=batch('Ua')  
%%



if isempty(UserVar)
    UserVar.RunType="-ManuallyDeactivateElements-ManuallyModifyThickness-";
    UserVar.RunType="-ManuallyModifyThickness-";  
    UserVar.RunType="-Calving-1dAnalyticalIceShelf-"; 
    
    
    CtrlVar.LevelSetMethod=0; 
    CtrlVar.AdaptiveTimeStepping=1 ; 
    CtrlVar.LevelSetMethodReinitializeInterval=10;
    CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=1; 
    CtrlVar.LevelSetMethodAutomaticallyDeactivateElementsThreshold=-100e3; 
    CtrlVar.doAdaptMeshPlots=1;
    CtrlVar.InfoLevelAdaptiveMeshing=100;
end


%%
UserVar.MisExperiment='ice0';  % This I use in DefineMassBalance
UserVar.Outputsdirectory='ResultsFiles'; % This I use in UaOutputs
UserVar.MassBalanceCase='ice0';

UserVar.CalvingDeltaWidth=30e3 ; 
%%

CtrlVar.Experiment="MismipPlus-"+"MB"+UserVar.MassBalanceCase+"-CW"+UserVar.CalvingDeltaWidth; 
%% Types of run
%
CtrlVar.TimeDependentRun=1; 
CtrlVar.InfoLevelNonLinIt=1; 

%% [--------------  Testing residuals definition 
CtrlVar.TimeDependentRun=1;  % testing  
CtrlVar.TotalNumberOfForwardRunSteps=50000; CtrlVar.TotalTime=5000;
CtrlVar.InfoLevelNonLinIt=1;
CtrlVar.doplots=1;
CtrlVar.uvCostFunction="Work Residuals" ; % ["Work","Increments"] 
CtrlVar.uvhCostFunction="Work Residuals" ; % ["Work","Increments"] 
CtrlVar.AdaptiveTimeStepping=1 ; CtrlVar.ATSTargetIterations=6; 
CtrlVar.Restart=0;  
CtrlVar.NLtol=1e-10; % tolerance for the square of the norm of the residual error
%% ---------- ] 

CtrlVar.dt=0.01; 
CtrlVar.time=0; 

CtrlVar.UaOutputsDt=1; % interval between calling UaOutputs. 0 implies call it at each and every run step.
                       % setting CtrlVar.UaOutputsDt=1; causes UaOutputs to be called every 1 years.
                       % This is a more reasonable value once all looks OK.

CtrlVar.ATStimeStepTarget=1;
CtrlVar.WriteRestartFile=1;

%% Reading in mesh
CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
                              % unless the adaptive meshing option is used, no further meshing is done.
% CtrlVar.ReadInitialMeshFileName='AdaptMesh.mat';
% CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
%% Plotting options
CtrlVar.PlotMesh=1; 
CtrlVar.PlotBCs=1;
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;

CtrlVar.PlotXYscale=1000; 
%%

CtrlVar.TriNodes=3;


CtrlVar.NameOfRestartFiletoWrite="Restart"+CtrlVar.Experiment+".mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;




%% adapt mesh


CtrlVar.MeshGenerator='gmsh';  % possible values: {mesh2d|gmsh}

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

CtrlVar.AdaptMesh=1;         
CtrlVar.AdaptMeshMaxIterations=10;  % Number of adapt mesh iterations within each run-step.
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';    % can have any of these values:
                                                   % 'explicit:global' 
                                                   % 'explicit:local'
                                                   % 'explicit:local:red-green'
                                                   % 'explicit:local:newest vertex bisection';
%  
CtrlVar.SaveAdaptMeshFileName=[] ; % no file written if left empty "AdaptMesh"+CtrlVar.Experiment+".mat";



CtrlVar.AdaptMeshInitial=1 ;       % if true, then a remeshing will always be performed at the inital step
CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed
                                   % usefull, for example, when trying out different remeshing options (then use CtrlVar.doRemeshPlots=1 to get plots)


CtrlVar.AdaptMeshInterval=1;  % number of run-steps between mesh adaptation
CtrlVar.MeshAdapt.GLrange=[20000 5000 ; 5000 2000];
%CtrlVar.MeshAdapt.GLrange=[20000 5000 ];
CtrlVar.MeshAdapt.CFrange=[10000 2000];

I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001/1000;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;



%% Pos. thickness constr


CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=5  ; 

%%

if contains(UserVar.RunType,"-Calving-1dAnalyticalIceShelf-")
    xd=640e3; xu=0e3 ; yr=-20e3 ; yl=20e3 ;
else
    xd=640e3; xu=0e3 ; yr=0 ; yl=80e3 ;
end
MeshBoundaryCoordinates=[xu yr ; xu yl ; xd yl ; xd yr];

%% Things that I´m testing and that are specifically realted to ideas around implementing calving

if contains(UserVar.RunType,"-ManuallyDeactivateElements-")
    CtrlVar.ManuallyDeactivateElements=1 ;
else
    CtrlVar.ManuallyDeactivateElements=0 ;
    
end

if contains(UserVar.RunType,"-ManuallyModifyThickness-")
    CtrlVar.GeometricalVarsDefinedEachTransienRunStepByDefineGeometry="sb";
else
    CtrlVar.GeometricalVarsDefinedEachTransienRunStepByDefineGeometry="";
end



CtrlVar.AdaptMesh=1;         
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=5;

end

