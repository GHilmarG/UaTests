function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


%%
UserVar.MisExperiment='ice0';  % This I use in DefineMassBalance

UserVar.BCs='1HD';


UserVar.Outputsdirectory='ResultsFiles'; % This I use in UaOutputs
%%
CtrlVar.DevelopmentVersion=1;
Experiment=['MismipPlus-',UserVar.MisExperiment];   
%% Types of run
%
CtrlVar.IncludeMelangeModelPhysics=1;

CtrlVar.TimeDependentRun=1; 
CtrlVar.TotalNumberOfForwardRunSteps=100;
CtrlVar.TotalTime=100000;
CtrlVar.Restart=1;  

CtrlVar.dt=1; 
CtrlVar.time=0; 

CtrlVar.UaOutputsDt=0; % interval between calling UaOutputs. 0 implies call it at each and every run step.
                       % setting CtrlVar.UaOutputsDt=1; causes UaOutputs to be called every 1 years.
                       % This is a more reasonable value once all looks OK.

CtrlVar.ATStimeStepTarget=1000;
CtrlVar.WriteRestartFile=1;

%% Reading in mesh
CtrlVar.ReadInitialMesh=1;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
                              % unless the adaptive meshing option is used, no further meshing is done.
CtrlVar.ReadInitialMeshFileName='AdaptMesh.mat';
CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
%% Plotting options
CtrlVar.doplots=1;
CtrlVar.PlotMesh=1; 
CtrlVar.PlotBCs=1;
CtrlVar.PlotNodes=1;
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
CtrlVar.doRemeshPlots=1;
CtrlVar.PlotXYscale=1000; 
%%

CtrlVar.kH=1;
CtrlVar.TriNodes=6;
CtrlVar.niph=7 ;  % 
CtrlVar.nip=7  ;

CtrlVar.NameOfRestartFiletoWrite=['Restart',Experiment,'.mat'];
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;




%% adapt mesh
%CtrlVar.InfoLevelAdaptiveMeshing=100;


% very coarse mesh resolution
CtrlVar.MeshSize=2e3;       % over-all desired element size
CtrlVar.MeshSizeMax=20e3;    % max element size
CtrlVar.MeshSizeMin=0.2*CtrlVar.MeshSize;     % min element size

% reasonably fine mesh resolution
%CtrlVar.MeshSize=8e3;       % over-all desired element size
%CtrlVar.MeshSizeMax=8e3;    % max element size
%CtrlVar.MeshSizeMin=200;    % min element size

CtrlVar.MaxNumberOfElements=250e3;           % max number of elements. If #elements larger then CtrlMeshSize/min/max are changed

CtrlVar.AdaptMesh=0;           % 
CtrlVar.SaveAdaptMeshFileName='AdaptMesh.mat'; 



CtrlVar.AdaptMeshInitial=1 ;       % if true, then a remeshing will always be performed at the inital step
CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed
                                   % usefull, for example, when trying out different remeshing options (then use CtrlVar.doRemeshPlots=1 to get plots)
CtrlVar.doAdaptMeshPlots=0;       % if true and if CtrlVar.doplots true also, then do some extra plotting related to adapt meshing

%CtrlVar.RefineCriteria={'flotation','thickness curvature','||grad(dhdt)||'};
%CtrlVar.RefineCriteriaWeights=[1,1,1];                %  
CtrlVar.RefineCriteriaFlotationLimit=[NaN];     

CtrlVar.RefineCriteria={'flotation'};
CtrlVar.RefineCriteriaWeights=[1];                %  
  
CtrlVar.AdaptMeshInterval=1;  % number of run-steps between mesh adaptation
CtrlVar.AdaptMeshMaxIterations=1;

CtrlVar.RefineDiracDeltaWidth=50;





%% Pos. thickness constraints
CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=5  ; 

%%

xd=100e3; xu=0e3 ; yr=-10 ; yl=10e3 ;  
MeshBoundaryCoordinates=[xu yr ; xu yl ; xd yl ; xd yr];
CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';  %
 
end
