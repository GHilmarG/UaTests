
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


%%
% Variables that I create and that are only of relevance to this particular run and only used in user input
% m-files, ie not by Ua itself

CtrlVar.Outputsdirectory='ResultsFiles'; % This I use in UaOutputs
%%

CtrlVar.Experiment='nVariable'; 
CtrlVar.UaOutputFormat='structures';
%% Types of run
%
CtrlVar.TimeDependentRun=0; 
CtrlVar.TotalNumberOfForwardRunSteps=1;
CtrlVar.TotalTime=100;

CtrlVar.InverseRun=0;         
CtrlVar.Restart=0;  


CtrlVar.dt=0.01; 
CtrlVar.time=0; 

CtrlVar.UaOutputsDt=0; % interval between calling UaOutputs. 0 implies call it at each and every run step.
                       % setting CtrlVar.UaOutputsDt=1; causes UaOutputs to be called every 1 years.
                       % This is a more reasonable value once all looks OK.

CtrlVar.ATStimeStepTarget=1;
CtrlVar.WriteRestartFile=1;

%% Reading in mesh
CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
                              % unless the adaptive meshing option is used, no further meshing is done.
CtrlVar.ReadInitialMeshFileName='AdaptMesh.mat';
CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
%% Plotting options
CtrlVar.doplots=1;
CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
CtrlVar.doRemeshPlots=1;
CtrlVar.PlotXYscale=1000; 
%%

CtrlVar.kH=1;
CtrlVar.TriNodes=3;
CtrlVar.niph=7 ;  % 
CtrlVar.nip=7  ;

CtrlVar.NameOfRestartFiletoWrite=['Restart',CtrlVar.Experiment,'.mat'];
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;


%%
CtrlVar.MeshSize=20e3;                       % over-all desired element size (however if gmsh is used without adaptive meshing
                                             % only CtrlVar.MeshSizeMin and CtrlVar.MeshSizeMax are used)
                                             % 
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;    % min element size
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;    
%% adapt mesh

CtrlVar.AdaptMesh=1  ; 
CtrlVar.AdaptMeshInitial=1  ; % remesh in first run-step irrespecitivy of the value of AdaptMeshInterval
CtrlVar.AdaptMeshInterval=1 ; % Number of run-steps between mesh adaptation 
CtrlVar.AdaptMeshMaxIterations=30;  % Number of adapt mesh iterations within each run-step.
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=0;  
CtrlVar.LocalAdaptMeshSmoothingIterations=0;  % Number of Laplace mesh smoothing iterations used in local mesh refinement
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';
CtrlVar.InfoLevelAdaptiveMeshing=10;  
CtrlVar.GmshMeshingAlgorithm=8;    
%% Mesh refinement criteria

I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001/100;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='flotation';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='thickness gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='upper surface gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='lower surface gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.01;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='|dhdt|';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=10;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='dhdt gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=1/1000;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=CtrlVar.MeshSizeMin;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;

                                                         
%% grounding-line mesh refinement      
%
%
%
CtrlVar.RefineDiracDeltaWidth=100;
CtrlVar.RefineDiracDeltaOffset=0;



CtrlVar.MeshAdapt.GLrange=[];                                                    

%% Pos. thickness constraints
CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=5  ; 

%%

xd=640e3; xu=0e3 ; yr=0 ; yl=80e3 ;  
MeshBoundaryCoordinates=[xu yr ; xu yl ; xd yl ; xd yr];

 
end
