function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%
%
%%


UserVar.RunType="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-" ;  
CtrlVar.Experiment=UserVar.RunType; 

UserVar.Outputsdirectory='ResultsFiles'; % This I use in UaOutputs
UserVar.MassBalanceCase='ice0';

if contains(UserVar.RunType,"-MismipPlus-") % Extract info on geometry from RunType, can be extended later to include other geometries
    UserVar.InitialGeometry="-MismipPlus-";
else
    error("What geometry? ")  
end


%% Calving law and level set options
%
% Specify a cliff-height dependent calving law where calving rate depends on cliff height as:
%
%   c=k F^q
%
% where k and q are some parameters, and F is the cliff height:
%
%   F=min((s-S),h)
%
% In addition both upper and lower limits are set to the calving rate:
%
%
%        c(F<Fmin)= cmin;
%        c(F>Fmax)= cmax;
%
%


CtrlVar.LevelSetMethod=1;

% Extract the info on calving law from UserVar.RunType, this can then be expanded to include other sliding laws later
if contains(UserVar.RunType,"-Fq")
    UserVar.CalvingLaw.Type="-Fqk-"  ;
    UserVar.CalvingLaw.Fqk.q=str2double(extract(extract(UserVar.RunType,"-Fq"+digitsPattern+"Fk"),digitsPattern));
    UserVar.CalvingLaw.Fqk.k=str2double(extract(extract(UserVar.RunType,"Fk"+digitsPattern+"Fmin"),digitsPattern));
    UserVar.CalvingLaw.Fqk.Fmin=str2double(extract(extract(UserVar.RunType,"Fmin"+digitsPattern+"cmin"),digitsPattern));
    UserVar.CalvingLaw.Fqk.cmin=str2double(extract(extract(UserVar.RunType,"cmin"+digitsPattern+"Fmax"),digitsPattern));
    UserVar.CalvingLaw.Fqk.Fmax=str2double(extract(extract(UserVar.RunType,"Fmax"+digitsPattern+"cmax"),digitsPattern));
    UserVar.CalvingLaw.Fqk.cmax=str2double(extract(extract(UserVar.RunType,"cmax"+digitsPattern+"-"),digitsPattern));
else
    error(" what sliding law")
end





% Initial calving front, this needs to be a closed region, inside the ice, outside the "ice-free" region.
LargeDistance=1000e3  ;
CalvingFrontBoundary0=[500e3 -LargeDistance ; 500e3 LargeDistance ; -LargeDistance LargeDistance ; -LargeDistance  -LargeDistance ] ; 
UserVar.CalvingFront0.Xc=CalvingFrontBoundary0(:,1);
UserVar.CalvingFront0.Yc=CalvingFrontBoundary0(:,2); 



if contains(UserVar.RunType,"-P-")  
    CtrlVar.LevelSetEvolution="-Prescribed-"   ; % "-prescribed-",
elseif contains(UserVar.RunType,"-C-")  
    CtrlVar.LevelSetEvolution="-By solving the level set equation-"   ; 
else
    error(" which calving implmentation to use? ")
 
end

% user re-initialisation? And if so, at what interval? 
CtrlVar.LevelSetReinitializePDist=true ; CtrlVar.LevelSetInitialisationInterval=inf;
if contains(UserVar.RunType,"-Ini")  % the re-initialisation intervale is set by looking for "-Ini" substring in RunType
    IniInt=str2double(extract(extract(UserVar.RunType,"-Ini"+digitsPattern+"-"),digitsPattern));
    if ~isempty(IniInt)
        CtrlVar.LevelSetInitialisationInterval=IniInt;
    end
end


CtrlVar.DevelopmentVersion=true; 
CtrlVar.LevelSetFABmu.Scale="-u-cl-" ; % "-constant-"; 
CtrlVar.LevelSetFABmu.Value=0.1;
CtrlVar.LevelSetInfoLevel=1 ; 

CtrlVar.MeshAdapt.CFrange=[20e3 5e3 ; 10e3 2e3] ; % This refines the mesh around the calving front, provided CtrlVar.AdaptMesh=true;         


CtrlVar.CalvingLaw.Evaluation="-int-";                     % evaluate the calving law at integration points using a call to : DefineCalvingAtIntegrationPoints.m  
CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=0;   % Automatically deactivate elements used in the uv and uvh solvers downstream of calving fronts
CtrlVar.LevelSetMethodSolveOnAStrip=1;                     % Solve the level-set equaition on a strip around the zero level (ie that calving front)
CtrlVar.LevelSetMethodStripWidth=150e3;                    % Width of that strip

% The melt is decribed as a= a_1 (h-hmin)
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-10;  % This is the constant a1, it has units 1/time.
% Default value is -10
CtrlVar.ThickMin=0.1;                                   % minimum allowed thickness without (potentially) doing something about it
CtrlVar.LevelSetMinIceThickness=2*CtrlVar.ThickMin;    % this is the hmin constant, i.e. the accepted min ice thickness over the 'ice-free' areas.


%%

CtrlVar.SlidingLaw="W" ;  % options:  "W","W-N0","minCW-N0","C","rpCW-N0", and "rCW-N0"


CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
%% Types of run
%
CtrlVar.TimeDependentRun=1;
CtrlVar.TotalNumberOfForwardRunSteps=inf;
CtrlVar.TotalTime=200;
CtrlVar.Restart=0;

%% time, time-step, output interval


CtrlVar.time=0; 
CtrlVar.dt=1e-5;  

CtrlVar.DefineOutputsDt=0; % interval between calling UaOutputs. 0 implies call it at each and every run step.
                       % setting CtrlVar.DefineOutputsDt=1; causes UaOutputs to be called every 1 years.
                       % This is a more reasonable value once all looks OK.

CtrlVar.ATSdtMax=1;
CtrlVar.ATSdtMin=0.01;
CtrlVar.WriteRestartFile=1;


%% There seems to be an issue with the explicit estimated d/dt being very large
% over a few nodes, and possibly (needs to be tested) this is causing an increased number in 
% Newton-Raphson iterations. One possibily is to limit the d/dt calculations to selected nodes
% or simply setting to zero.
CtrlVar.inUpdateFtimeDerivatives.SetAllTimeDerivativesToZero=0; 
CtrlVar.inUpdateFtimeDerivatives.SetTimeDerivativesDowstreamOfCalvingFrontsToZero=1 ; 
CtrlVar.inUpdateFtimeDerivatives.SetTimeDerivativesAtMinIceThickToZero=1 ; 

%% Reading in mesh
CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
                              % unless the adaptive meshing option is used, no further meshing is done.
CtrlVar.ReadInitialMeshFileName='AdaptMesh.mat';
CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';
%% Plotting options
CtrlVar.doplots=0;
CtrlVar.PlotMesh=1; 
CtrlVar.PlotBCs=1;
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
CtrlVar.doRemeshPlots=1;
CtrlVar.PlotXYscale=1000; 
%%

CtrlVar.TriNodes=3;

CtrlVar.NameOfRestartFiletoWrite="Restart"+CtrlVar.Experiment+".mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;




%% adapt mesh
CtrlVar.AdaptMesh=0;         
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

CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=5  ; 

%%

xd=640e3; xu=0e3 ; yr=0 ; yl=80e3 ;  
MeshBoundaryCoordinates=[xu yr ; xu yl ; xd yl ; xd yr];

 
end
