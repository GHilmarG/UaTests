
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


%%
%
% CalvingJobDW30=batch('Ua')  
%%



if isempty(UserVar)
    UserVar.RunType="-ManuallyDeactivateElements-ManuallyModifyThickness-";
    UserVar.RunType="-ManuallyModifyThickness-";  
    UserVar.RunType="-1dAnalyticalIceShelf-"; CtrlVar.doplots=0;
    UserVar.RunType="-Calving-1dAnalyticalIceShelf-"; CtrlVar.doplots=0;
    

    CtrlVar.AdaptiveTimeStepping=1 ; 
    CtrlVar.LevelSetMethodReinitializeInterval=10;
    CtrlVar.UaOutputsDt=1;
end

CtrlVar.dt=0.01; 

if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
    
    
    CtrlVar.doplots=0;
    CtrlVar.LevelSetMethod=0;
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    CtrlVar.TotalTime=100;
    UserVar.Plots="-plot-flowline-";
    if contains(UserVar.RunType,"Test-")
        CtrlVar.TotalTime=10;
    end
    CtrlVar.UaOutputsDt=1;
end

if contains(UserVar.RunType,"-Calving-")
   CtrlVar.LevelSetMethod=1; 
   CtrlVar.UaOutputsDt=0;  % because I'm testing
   CtrlVar.dt=1e-5; 
end

CtrlVar.InfoLevelNonLinIt=1; CtrlVar.uvhMinimisationQuantity="Force Residuals";
%%

UserVar.Outputsdirectory='ResultsFiles'; % This I use in UaOutputs
UserVar.MassBalanceCase='ice0';

UserVar.CalvingDeltaWidth=30e3 ; 
%%

CtrlVar.Experiment="Ex"+UserVar.RunType+"-MB"+UserVar.MassBalanceCase+"-CW"+UserVar.CalvingDeltaWidth; 
CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");

%% Types of run
%
CtrlVar.TimeDependentRun=1; 



CtrlVar.time=0; 




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

