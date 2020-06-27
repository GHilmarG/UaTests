
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%%
%
% CalvingJobDW30=batch('Ua')  
%%




if isempty(UserVar)
    UserVar.RunType="-ManuallyDeactivateElements-ManuallyModifyThickness-";
    UserVar.RunType="-ManuallyModifyThickness-";  
    UserVar.RunType="-1dAnalyticalIceShelf-"; CtrlVar.doplots=0;
    
    UserVar.RunType="-MeltFeedback-1dIceShelf-"; CtrlVar.doplots=0;
    UserVar.RunType="-Reinitialize-RT1000-FAB0k1-LevelSetWithMeltFeedback-1dIceShelf-"; CtrlVar.doplots=0;
    %UserVar.RunType="-TravellingFront-1dAnalyticalIceShelf-"; CtrlVar.doplots=0;

    CtrlVar.AdaptiveTimeStepping=1 ; 
    CtrlVar.LevelSetMethodReinitializeInterval=inf;
    CtrlVar.DefineOutputsDt=1;
end


CtrlVar.AdaptMesh=1;         
CtrlVar.dt=0.01; 
CtrlVar.TriNodes=3;
UserVar.InitialGeometry="-MismipPlus-" ;  % default  
CtrlVar.AdaptMeshMaxIterations=1;  % Number of adapt mesh iterations within each run-step.

if contains(UserVar.RunType,"-LevelSetWithMeltFeedback-1dIceShelf-")
    UserVar.InitialGeometry="-1dAnalyticalIceShelf-" ;
    
    CtrlVar.LevelSetMethod=1;
    
    if contains(UserVar.RunType,"-Reinitialize-")
        CtrlVar.LevelSetReinitializeTimeInterval=str2double(replace(extractBetween(UserVar.RunType,"RT","-"),"k",".")); 
    else
        CtrlVar.LevelSetReinitializeTimeInterval=inf;
    end
    
    CtrlVar.LevelSetFAB=str2double(replace(extractBetween(UserVar.RunType,"FAB","-"),"k","."));

    CtrlVar.DefineOutputsDt=1;  % because I'm testing
    CtrlVar.dt=1e-3;
    CtrlVar.AdaptMesh=1;
    CtrlVar.doplots=0; CtrlVar.LevelSetInfoLevel=1;
    CtrlVar.uvh.SUPG.tau="taus" ;
    CtrlVar.ATSdtMin=1e-2;
    CtrlVar.TotalTime=2000;
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    UserVar.Plots="-save-" ; % plot-Calving1dIceShelf-";
    % UserVar.Plots="-save-";
    CtrlVar.AdaptMeshMaxIterations=20;  % Number of adapt mesh iterations within each run-step.
    CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=20;
    CtrlVar.TriNodes=3;
    
    CtrlVar.Restart=0;
 
    UserVar.Calving="Function of analytical thickness" ; % "Function of analytical thickness" ;
    
end



if contains(UserVar.RunType,"-MeltFeedback-1dIceShelf-")
    UserVar.InitialGeometry="-1dAnalyticalIceShelf-" ;
    CtrlVar.MassBalanceGeometryFeedback=3;
    CtrlVar.LevelSetMethod=0;
    CtrlVar.DefineOutputsDt=0;  % because I'm testing
    CtrlVar.dt=1e-3;
    CtrlVar.AdaptMesh=1;
    CtrlVar.doplots=0; CtrlVar.LevelSetInfoLevel=0;
    CtrlVar.uvh.SUPG.tau="taus" ;
    CtrlVar.ATSdtMin=1e-2;
    CtrlVar.TotalTime=10;
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    UserVar.Plots="-plot-Calving1dIceShelf-";
    % UserVar.Plots="-save-";
    CtrlVar.AdaptMeshMaxIterations=20;  % Number of adapt mesh iterations within each run-step.
    CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=20;
    CtrlVar.TriNodes=3;
    
    CtrlVar.Restart=1;
    CtrlVar.LevelSetFAB=true ;
    CtrlVar.LevelSetReinitializeTimeInterval=inf;
    UserVar.Calving=[];
    
end

if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
    
    UserVar.InitialGeometry="-Constant-" ; 
    CtrlVar.doplots=0;
    CtrlVar.LevelSetMethod=0;
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    CtrlVar.TotalTime=500;
    UserVar.Plots="-plot-flowline-";
    if contains(UserVar.RunType,"Test-")
        CtrlVar.TotalTime=10;
    end
    CtrlVar.DefineOutputsDt=1;
end

if contains(UserVar.RunType,"-Calving-1dIceShelf-")
    UserVar.InitialGeometry="-1dAnalyticalIceShelf-" ;
    CtrlVar.LevelSetMethod=1;
    CtrlVar.DefineOutputsDt=1;  % because I'm testing
    CtrlVar.dt=1e-3;
    CtrlVar.AdaptMesh=1;
    CtrlVar.doplots=0; CtrlVar.LevelSetInfoLevel=1;
    CtrlVar.uvh.SUPG.tau="taus" ;
    CtrlVar.ATSdtMin=1e-2;
    CtrlVar.TotalTime=4000;
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    UserVar.Plots="-Calving1dIceShelf-";
    UserVar.Plots="-save-";
    CtrlVar.AdaptMeshMaxIterations=20;  % Number of adapt mesh iterations within each run-step.
    CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=20;
    CtrlVar.TriNodes=6;
    
    CtrlVar.Restart=0;
    CtrlVar.LevelSetFAB=true ;
    CtrlVar.LevelSetReinitializeTimeInterval=inf;
    
    if contains(UserVar.RunType,"-Calving-1dIceShelf-CalvingNumerical-")
        UserVar.Calving="Function of numerical thickness" ; % "Function of analytical thickness" ;
    elseif contains(UserVar.RunType,"-Calving-1dIceShelf-CalvingAnalytical-")
        UserVar.Calving="Function of analytical thickness" ; % "Function of analytical thickness" ;
    else
        error('asfd')
    end
end

if contains(UserVar.RunType,"-TravellingFront-")
    % Here I set a 'calving front' within the domain to see how it evolves with time.
    UserVar.InitialGeometry="-Constant-" ;
    CtrlVar.LevelSetMethod=0;
    CtrlVar.dt=1e-3;
    CtrlVar.AdaptMesh=1;
    CtrlVar.doplots=1;
    CtrlVar.DefineOutputsDt=0.1;     UserVar.Plots="-plot-flowline-";
    CtrlVar.TotalTime=201;
    CtrlVar.uvh.SUPG.tau="tau2" ; % {'tau1','tau2','taus','taut'}  % taus works fine!  tau2 is the default
    CtrlVar.ResetTimeStep=1; CtrlVar.ATSdtMin=1e-3;
    CtrlVar.Restart=1;
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
CtrlVar.MeshAdapt.CFrange=[10000 2000 ; 5000 1000];

I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001/1000;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;

%% Pos. thickness constr


CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=5  ; 

%%

if contains(UserVar.RunType,"-1dIceShelf-")
    xd=640e3; xu=0e3 ; yr=-10e3 ; yl=10e3 ;
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


CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=5;

%% Experiment and file name

CtrlVar.Experiment="Ex"+UserVar.RunType+"-MB"+UserVar.MassBalanceCase+"-SUPG"+CtrlVar.uvh.SUPG.tau+"-Adapt"+num2str(CtrlVar.AdaptMesh);         
CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
CtrlVar.NameOfRestartFiletoWrite="Restart"+CtrlVar.Experiment+".mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;



end

