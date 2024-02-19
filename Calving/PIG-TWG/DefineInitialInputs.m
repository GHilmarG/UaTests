

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%%




% initial inverse run using ITS120 velocities and Bedmachine2 geometry.
UserVar.RunType="-IR-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";

% forward run from t=0 to t=1, using inversion products FA and FC from t=0, which implies using the initial inversion
UserVar.RunType="-FR0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";

% inverse run using forward run results from t=1. This implies using the geometry from t=1 instead of Bedmachine2  geometry.
UserVar.RunType="-IR0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";

% forward restart run continuing from t=1 and using inversion products from t=1, ie "-IRt1-".
% UserVar.RunType="-FR1to2-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";



% Create_AC_ScatteredInterpolants([],UserVar)
%%

UserVar=FileDirectories(UserVar) ;

UserVar.Region="PIG-TWG" ; "PIG" ; % "PIG-TWG" ;
UserVar.DefineOutputs="-ubvb-LSF-h-dhdt-speed-save-AC-";
CtrlVar.LimitRangeInUpdateFtimeDerivatives=true ;
%% Parse UserVar

[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ; 

%%

[CtrlVar,UserVar]=FindAndCreateInterpolants(CtrlVar,UserVar) ; 

%% Parallel options
CtrlVar.Parallel.uvhAssembly.spmd.isOn=true; 
CtrlVar.Distribute=true;
CtrlVar.Parallel.isTest=false;
%% Data input files
% This run requires some additional input files. They are too big to be kept on Github so you
% will have to get those separately.
%
% You can get these files on OneDrive using the link:
%
%   https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg?e=yMZEOs
%
% Put the OneDrive folder `Interpolants' into you directory so that it can be reached as ../Interpolants with respect to you rundirectory.
%


UserVar.MeshBoundaryCoordinatesFile='../../../Interpolants/MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine';
load(UserVar.MeshBoundaryCoordinatesFile,"Boundary") ; UserVar.BedMachineBoundary=Boundary;
UserVar.DistanceBetweenPointsAlongBoundary=5e3 ;

if ~isfile(UserVar.GeometryInterpolant) || ~isfile(UserVar.SurfaceVelocityInterpolant)

    fprintf('\n This run requires the additional input files: \n %s \n %s  \n \n',UserVar.GeometryInterpolant,UserVar.SurfaceVelocityInterpolant)
    fprintf('You can download these file from : https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwBF0SQnJdXtucDHKtPnv7G9Q?e=5aLX7T \n')
end

%% Files with or for inversion products

% UserVar.AFile and UserVAr.CFile defined in ParseRunTypeString





%% Times, time steps, output interval

% time and TotalTime already extracted from UserVar.RunType
CtrlVar.DefineOutputsDt=1;
CtrlVar.dt=1e-5;   
CtrlVar.ATSdtMax=0.1;
CtrlVar.ATSdtMin=1e-5;  
CtrlVar.ATSTargetIterations=6;

CtrlVar.ExplicitEstimationMethod="-no extrapolation-";

%%  Level-set parameters

CtrlVar.LevelSetInitialisationInterval=100 ;
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-10;  % This is the constant a1, it has units 1/time.
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffCubic=0;
CtrlVar.LevelSetInfoLevel=1 ;
CtrlVar.LevelSetInitialisationMethod="-geo-" ;
CtrlVar.LevelSetReinitializePDist=true ;
CtrlVar.LevelSetFixPointSolverApproach="-PTS-" ;   % pseudo forward stepping
CtrlVar.LevelSetPseudoFixPointSolverTolerance=100;
CtrlVar.LevelSetPseudoFixPointSolverMaxIterations=100;
CtrlVar.DevelopmentVersion=false;
CtrlVar.LevelSetFABmu.Scale="-u-cl-" ; % "-constant-";
CtrlVar.LevelSetFABmu.Value=0.1;
CtrlVar.CalvingLaw.Evaluation="-int-";
CtrlVar.LevelSetMethodSolveOnAStrip=1; 



%% UserVar.RunType

if CtrlVar.InverseRun

    if contains(UserVar.RunType,"Inverse-UaOpt")
        % Testing
        CtrlVar.Inverse.MinimisationMethod='UaOptimization-Hessian'; % {'MatlabOptimization','UaOptimization'}
    end

    % CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased";     CtrlVar.Inverse.AdjointGradientPreMultiplier="I"; % {'I','M'}
    % CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased";     CtrlVar.Inverse.AdjointGradientPreMultiplier="M"; % {'I','M'}

    UserVar.DefineOutputs="-"; %


    CtrlVar.Restart=0;
    CtrlVar.Inverse.InfoLevel=1;
    CtrlVar.InfoLevelNonLinIt=0;  CtrlVar.InfoLevel=0;
   

    UserVar.Slipperiness.ReadFromFile=0;
    UserVar.AGlen.ReadFromFile=0;

    CtrlVar.ReadInitialMesh=1;
    CtrlVar.AdaptMesh=0;
   

    CtrlVar.Inverse.Iterations=5;
    CtrlVar.Inverse.OptimalityTolerance=0.01; 
    CtrlVar.Inverse.StepTolerance=0.001;

    CtrlVar.Inverse.InvertFor="-logA-logC-" ; % {'C','logC','AGlen','logAGlen'}
    CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
    CtrlVar.Inverse.DataMisfit.GradientCalculation="-adjoint-" ; % "-FixpointC-"; "adjoint";
    
    CtrlVar.NameOfFileForSavingSlipperinessEstimate= UserVar.CFile;
    CtrlVar.NameOfFileForSavingAGlenEstimate= UserVar.AFile;

    CtrlVar.Inverse.NameOfRestartOutputFile=UserVar.InverseRestartFile;

elseif  CtrlVar.TimeDependentRun

    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=1;
    CtrlVar.Restart=0;
    CtrlVar.InfoLevelNonLinIt=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
  
    CtrlVar.AdaptMesh=0;
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    %CtrlVar.LevelSetMethod=0;

elseif contains(UserVar.RunType,"Forward-Diagnostic")

    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=0;
    CtrlVar.Restart=0;
    CtrlVar.InfoLevelNonLinIt=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    CtrlVar.ReadInitialMesh=1;
    CtrlVar.AdaptMesh=0;

elseif contains(UserVar.RunType,"GenerateMesh")

    CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
    CtrlVar.InverseRun=0;
    CtrlVar.Restart=0;
    CtrlVar.ReadInitialMesh=0;
    CtrlVar.MeshGenerator="mesh2d" ; % "mesh2d" ; % 'mesh2d';

    CtrlVar.OnlyMeshDomainAndThenStop=0;
    CtrlVar.AdaptMeshAndThenStop=1; 

    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    CtrlVar.TotalNumberOfForwardRunSteps=1;

    if contains(UserVar.RunType,"-AM-")
        CtrlVar.AdaptMesh=1;
        CtrlVar.AdaptMeshMaxIterations=5;
        CtrlVar.MeshRefinementMethod='explicit:global'; 
    else
        CtrlVar.AdaptMesh=0;
    end


     CtrlVar.MeshAdapt.CFrange=[5*CtrlVar.MeshSize   CtrlVar.MeshSize/2 ; ...
                                2*CtrlVar.MeshSize   CtrlVar.MeshSize/5 ; ...
                                 CtrlVar.MeshSize   CtrlVar.MeshSize/10 ];
  
    

    CtrlVar.AdaptMeshInitial=1  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshRunStepInterval)~=0.
    
    
    CtrlVar.InfoLevelAdaptiveMeshing=1;



    CtrlVar.SaveInitialMeshFileName=...
        "NewMeshFile"...
        +num2str(CtrlVar.MeshSizeMax/1000) ...
        +"km-"...  ; %%            +CtrlVar.MeshGenerator ...
        +UserVar.Region ;

else

    error("case not found")


end


%% Plotting
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5;
CtrlVar.PlotsXaxisLabel="xps (km)";
CtrlVar.PlotsYaxisLabel="yps (km)";
%% Meshing

CtrlVar.SaveInitialMeshFileName="MeshFile";
CtrlVar.ReadInitialMeshFileName=...
    UserVar.MeshFileDirectory...
    +"MeshFile"...
    +num2str(UserVar.MeshResolution/1000) ...
    +"km-"...  ; %%            +CtrlVar.MeshGenerator ...
    +UserVar.Region ;


CtrlVar.ReadInitialMeshFileName=replace(CtrlVar.ReadInitialMeshFileName,".","k");
MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar);




%% Thickness constraints
CtrlVar.ThicknessConstraints=1;
CtrlVar.ResetThicknessToMinThickness=0;
CtrlVar.ThicknessConstraintsItMax=0  ; % only update active-set, then move to next time step

%% A C constraints
if contains(UserVar.RunType,"-Alim-")
    CtrlVar.AGlenmin=AGlenVersusTemp(-20) ;
end
CtrlVar.Cmin=1e-8; % This is based on having done some inversions for C for m=3 where no such contraint was used
                   % and finding that only inverted values where
                   % velocity data was available, where higher than this.
               
     
%%
if batchStartupOptionUsed
    CtrlVar.doplots=0;   % disable plotting if running as batch
    fprintf("disabling plotting as this is a batch job\n")
    if contains(UserVar.DefineOutputs,"save")
        UserVar.DefineOutputs="-save-";  % disable plotting in DefineOutputs as well
    end
end

%%  Run files, names of run files etc.

CtrlVar.SaveInitialMeshFileName=[] ; % Do not create a new initial mesh file each time




CtrlVar.ReadInitialMeshFileName=replace(CtrlVar.ReadInitialMeshFileName,".","k");
if ~isempty(CtrlVar.SaveInitialMeshFileName)
    CtrlVar.SaveInitialMeshFileName=replace(CtrlVar.SaveInitialMeshFileName,".","k");
end





%% Make this automatically a restart run if corresponding restart files already exists

if CtrlVar.InverseRun
    fprintf(" Inverse restart file: %s \n",CtrlVar.Inverse.NameOfRestartOutputFile)
end

if CtrlVar.InverseRun
    if isfile(CtrlVar.Inverse.NameOfRestartInputFile)
        CtrlVar.Restart=1;
    else
        CtrlVar.Restart=0;
        fprintf("No restart file found. Starting a new run. \n")
    end
else
    if isfile(CtrlVar.NameOfRestartFiletoRead)
        CtrlVar.Restart=1;
    else
        CtrlVar.Restart=0;
    end
end

if ~CtrlVar.InverseRun
    if contains(UserVar.RunType,"-LSDRlin-")

        CtrlVar.LevelSetDownstream_nGlen=1;
        eta= 1e12  / (1000*365.25*24*60*60);
        CtrlVar.LevelSetDownstreamAGlen=1/(2*eta);

    end
end

if contains(UserVar.RunType,"GenerateMesh")
    CtrlVar.Restart=0;
    CtrlVar.ReadInitialMesh=0;
elseif CtrlVar.Restart
    CtrlVar.ReadInitialMesh=0;
else
    CtrlVar.ReadInitialMesh=1;
end


CtrlVar.WriteRestartFileInterval=20;




