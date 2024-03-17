function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%
%
%%

if isempty(UserVar) || ~isfield(UserVar,"RunType")

    UserVar.RunType="-MismipPlus-C-DP-Ini5-c0isGL0-5km-" ;
end


CtrlVar.Experiment=UserVar.RunType;


UserVar.ResultsFileDirectory="./ResultsFiles/"; % This I use in UaOutputs
UserVar.MassBalanceCase='ice0';

if contains(UserVar.RunType,"-MismipPlus-") % Extract info on geometry from RunType, can be extended later to include other geometries
    UserVar.InitialGeometry="-MismipPlus-";
else
    error("What geometry? ")
end

if isempty(UserVar) || ~isfield(UserVar,"Plots")
    UserVar.Plots="-plot-save-";  % this is used in DefineOutputs to control if plots are generated and/or data saved
end

if batchStartupOptionUsed
    CtrlVar.doplots=0;   % disable plotting if running as batch
    fprintf("disabling plotting as this is a batch job\n")
    if contains(UserVar.Plots,"save")
        UserVar.Plots="-save-";  % disable plotting in DefineOutputs as well
    end
end



UserVar.DoNotPlotVelocitiesDownstreamOfCalvingFronts=true; % Also used in DefineOutputs, has not impact on the actual solution

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


%% Initial calving front location:

if contains(UserVar.RunType,"-c0isGL0-")
    % here the initial calving front location (c0) will be based on the initial grounding line location (GL0)
    % this is done in DefineCalving.m

    UserVar.CalvingFront0.Xc=[];
    UserVar.CalvingFront0.Yc=[];

else
    
    % Initial calving front, this needs to be a closed region, inside the ice, outside the "ice-free" region.
    % Here the initial calving front is simply a straight line across at x=500km.
    LargeDistance=1000e3  ;
    CalvingFrontBoundary0=[500e3 -LargeDistance ; 500e3 LargeDistance ; -LargeDistance LargeDistance ; -LargeDistance  -LargeDistance ] ;
    UserVar.CalvingFront0.Xc=CalvingFrontBoundary0(:,1);
    UserVar.CalvingFront0.Yc=CalvingFrontBoundary0(:,2);
end


%% Calving law
if contains(UserVar.RunType,"-P-")
    CtrlVar.LevelSetEvolution="-Prescribed-"   ; % "-prescribed-",
elseif contains(UserVar.RunType,"-C-")

    CtrlVar.LevelSetEvolution="-By solving the level set equation-"   ;

    % Extract the info on calving law from UserVar.RunType, this can then be expanded to include other sliding laws later
    if contains(UserVar.RunType,"-Fq")
        
        UserVar.CalvingLaw.Type="-Fqk-"  ;
        UserVar.CalvingLaw.Fqk.q=str2double(extract(extract(UserVar.RunType,"-Fq"+digitsPattern+"Fk"),digitsPattern));
        UserVar.CalvingLaw.Fqk.k=str2double(extract(extract(UserVar.RunType,"Fk"+digitsPattern+"Fmin"),digitsPattern));
        UserVar.CalvingLaw.Fqk.Fmin=str2double(extract(extract(UserVar.RunType,"Fmin"+digitsPattern+"cmin"),digitsPattern));
        UserVar.CalvingLaw.Fqk.cmin=str2double(extract(extract(UserVar.RunType,"cmin"+digitsPattern+"Fmax"),digitsPattern));
        UserVar.CalvingLaw.Fqk.Fmax=str2double(extract(extract(UserVar.RunType,"Fmax"+digitsPattern+"cmax"),digitsPattern));
        UserVar.CalvingLaw.Fqk.cmax=str2double(extract(extract(UserVar.RunType,"cmax"+digitsPattern+"-"),digitsPattern));
    
    elseif contains(UserVar.RunType,"-C-DP-")

        UserVar.CalvingLaw.Type="-DP-"  ;  % Robert DeConto and David Pollard

    else
        error(" what sliding law")
    end

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




CtrlVar.CalvingLaw.Evaluation="-int-";                     % evaluate the calving law at integration points using a call to : DefineCalvingAtIntegrationPoints.m  
CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=0;   % Automatically deactivate elements used in the uv and uvh solvers downstream of calving fronts
CtrlVar.LevelSetMethodSolveOnAStrip=1;                     % Solve the level-set equaition on a strip around the zero level (ie that calving front)
CtrlVar.LevelSetMethodStripWidth=30e3;                    % Width of that strip

% The melt is decribed as a= a_1 (h-hmin)
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-10;  % This is the constant a1, it has units 1/time.
% Default value is -10
CtrlVar.ThickMin=0.1;                                   % minimum allowed thickness without (potentially) doing something about it
CtrlVar.LevelSetMinIceThickness=2*CtrlVar.ThickMin;    % this is the hmin constant, i.e. the accepted min ice thickness over the 'ice-free' areas.

% Optionally, AGlen can be set to some prescribed, usually small, value downstream of all calving fronts.
CtrlVar.LevelSetDownstreamAGlen=nan;                      % Since the value is here set to nan, there AGlen will NOT be modified
CtrlVar.LevelSetDownstreamAGlen=10*AGlenVersusTemp(0);  % Here AGlen will be set to this numerical value downstream of all
                                                          % calving fronts. This will be done automatically and replaces 
                                                          % any values defined by the user in DefineAGlen.,
%%

CtrlVar.SlidingLaw="W" ;  % options:  "W","W-N0","minCW-N0","C","rpCW-N0", and "rCW-N0"


CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
%% Types of run
%
CtrlVar.TimeDependentRun=1;
CtrlVar.TotalNumberOfForwardRunSteps=inf;
CtrlVar.TotalTime=201;


%% time, time-step, output interval


CtrlVar.time=0; 
CtrlVar.dt=1e-5;  

CtrlVar.DefineOutputsDt=0.25; % interval between calling UaOutputs. 0 implies call it at each and every run step.
                       % setting CtrlVar.DefineOutputsDt=1; causes UaOutputs to be called every 1 years.
                       % This is a more reasonable value once all looks OK.

CtrlVar.ATSdtMax=1;
CtrlVar.ATSdtMin=0.0001;
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
CtrlVar.AdaptMesh=1;
CtrlVar.AdaptMeshInitial=0 ;       % if true, then a remeshing will always be performed at the inital step
CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed
% usefull, for example, when trying out different remeshing options (then use CtrlVar.doRemeshPlots=1 to get plots)


CtrlVar.InfoLevelAdaptiveMeshing=1;
CtrlVar.doAdaptMeshPlots=1;
CtrlVar.MeshGenerator='mesh2d' ; % 'gmsh';  % possible values: {mesh2d|gmsh}
% very coarse mesh resolution

if contains(UserVar.RunType,"km-")
    CtrlVar.MeshSize=1000*str2double(extract(extract(UserVar.RunType,"-"+digitsPattern+"km-"),digitsPattern));
else
    CtrlVar.MeshSize=10e3;       % over-all desired element size
end

CtrlVar.MeshSizeMax=CtrlVar.MeshSize ; 
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;     % min element size

 % This refines the mesh around the calving front, provided CtrlVar.AdaptMesh=true;         
CtrlVar.MeshAdapt.CFrange=[2*CtrlVar.MeshSize   CtrlVar.MeshSize/2 ; ...
                             CtrlVar.MeshSize   CtrlVar.MeshSize/5] ;

% reasonably fine mesh resolution
%CtrlVar.MeshSize=8e3;       % over-all desired element size
%CtrlVar.MeshSizeMax=8e3;    % max element size
%CtrlVar.MeshSizeMin=200;    % min element size

CtrlVar.MaxNumberOfElements=250e3;           % max number of elements. If #elements larger then CtrlMeshSize/min/max are changed


CtrlVar.AdaptMeshMaxIterations=2;  % Number of adapt mesh iterations within each run-step.
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';    % can have any of these values:

CtrlVar.SaveAdaptMeshFileName='AdaptMesh.mat';
CtrlVar.AdaptMeshRunStepInterval=1;  % number of run-steps between mesh adaptation

% CtrlVar.MeshAdapt.GLrange=[20000 5000 ; 10000 500 ];




if isfile(CtrlVar.NameOfRestartFiletoRead)
    CtrlVar.Restart=1;
    fprintf("Restart file %s found. \n Starting a restart run. \n",CtrlVar.NameOfRestartFiletoRead)
else
    CtrlVar.Restart=0;
    fprintf("No restart file found. Starting a new run. \n")
    fprintf("Name of restart file will be: %s \n",CtrlVar.NameOfRestartFiletoRead)
end


%% Pos. thickness constraints

CtrlVar.ResetThicknessToMinThickness=1;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=0  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=5  ;

%%

xd=640e3; xu=0e3 ; yr=0 ; yl=80e3 ;
MeshBoundaryCoordinates=[xu yr ; xu yl ; xd yl ; xd yr];

 
end
