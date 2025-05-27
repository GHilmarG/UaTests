

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%                       -side of a perfect square of equal area-
% 30km = 14km                        9.806 km
% 20km = 9.3km                       6.559 km
% 10km = 4.6km                       3.28  km
%  5km = 2.3km                       1.64  km
% 2.5km = 1.16km                     0.821 km


%%

if ~isfield(UserVar,"RunType") || isempty(UserVar.RunType)

    error(" input needed ")
    
end


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
CtrlVar.Parallel.uvAssembly.spmd.isOn=true;
CtrlVar.Parallel.Distribute=false;
CtrlVar.Parallel.isTest=false;
%% Data input files
% This run requires some additional input files. They are too big to be kept on Github so you
% will have to get those separately.
%
% You can get these files on OneDrive using the link:
%
%   https://livenorthumbriaac-my.sharepoint.co
% m/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg?e=yMZEOs
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
CtrlVar.DefineOutputsDt=0.5;
CtrlVar.dt=1e-3;
CtrlVar.ATSdtMax=0.01;
CtrlVar.ATSdtMin=1e-5;
CtrlVar.ATSTargetIterations=6;



CtrlVar.ExplicitEstimationMethod="-no extrapolation-";

%%


%%  Level-set parameters

CtrlVar.LevelSetInitialisationInterval=100 ;
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffCubic=CtrlVar.ThicknessPenaltyMassBalanceFeedbackCoeffCubic ;
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=CtrlVar.ThicknessPenaltyMassBalanceFeedbackCoeffLin ;
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



    CtrlVar.Inverse.InfoLevel=1;
    CtrlVar.InfoLevelNonLinIt=0;  CtrlVar.InfoLevel=0;


    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;

    CtrlVar.ReadInitialMesh=1;

    CtrlVar.AdaptMesh=0;


    CtrlVar.Inverse.Iterations=UserVar.Inverse.Iterations;

    CtrlVar.Inverse.OptimalityTolerance=0.01;
    CtrlVar.Inverse.StepTolerance=0.001;

    CtrlVar.Inverse.InvertFor="-logA-logC-" ; % {'C','logC','AGlen','logAGlen'}
    CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
    CtrlVar.Inverse.DataMisfit.GradientCalculation="-adjoint-" ; % "-FixpointC-"; "adjoint";

    CtrlVar.NameOfFileForSavingSlipperinessEstimate= UserVar.CFile;
    CtrlVar.NameOfFileForSavingAGlenEstimate= UserVar.AFile;

   

elseif  CtrlVar.TimeDependentRun

    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=1;

    CtrlVar.InfoLevelNonLinIt=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;

    CtrlVar.AdaptMesh=0;
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    %CtrlVar.LevelSetMethod=0;

elseif contains(UserVar.RunType,"Forward-Diagnostic")

    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=0;

    CtrlVar.InfoLevelNonLinIt=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    CtrlVar.ReadInitialMesh=1;
    CtrlVar.AdaptMesh=0;

elseif contains(UserVar.RunType,"GenerateMesh")

    CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
    CtrlVar.InverseRun=0;

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
CtrlVar.PlotBCs=0 ;
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
CtrlVar.Cmin=1e-8; % This is based on having done some inversions for C for m=3 where no such constraint was used
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





%% If an inverse rund, make it a restart run if corresponding restart files already exists



if CtrlVar.InverseRun

    if isfile(CtrlVar.Inverse.NameOfRestartInputFile)
        fprintf("Inverse restart file found. Starting a restart run. \n")
        fprintf("Inverse restart file to read: %s \n",CtrlVar.Inverse.NameOfRestartInputFile)
        CtrlVar.Restart=1;
    else
        CtrlVar.Restart=0;
        fprintf("No INVERSE restart file found. Starting a new INVERSE run. \n")
    end
else

    if isfield(UserVar.Assimilation,"tEnd") && CtrlVar.time < UserVar.Assimilation.tEnd

        fprintf("The start model time (t=%f)  of this forward run is within the assimilation period (from t=%f to t=%f) \n",CtrlVar.time,UserVar.Assimilation.tStart,UserVar.Assimilation.tEnd)
        fprintf(" Therefore this can not be a forward restart run.\n")
        CtrlVar.Restart=0;

    else

        fprintf("The start model time (t=%f)  of this forward run is after the assimilation period (from t=%f to t=%f) \n",CtrlVar.time,UserVar.Assimilation.tStart,UserVar.Assimilation.tEnd)
        fprintf("This will now be a restart run, provided a restart file is found.\n")

        if isfile(CtrlVar.NameOfRestartFiletoRead)


            CtrlVar.Restart=1;
            fprintf("Forward restart file found. Starting a restart run. \n")
            fprintf("Forward restart file to read %s :\n",CtrlVar.NameOfRestartFiletoRead)

        else
            CtrlVar.Restart=0;
            fprintf("No FORWARD restart file found. Starting a new FORWARD run. \n")
        end
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


CtrlVar.UpdateBoundaryConditionsAtEachTimeStep=true;

%% Thickness Constraints
CtrlVar.ThickMin=0.2 ;

CtrlVar.ThicknessConstraints=1;
CtrlVar.ThicknessConstraintsInfoLevel=1;

CtrlVar.MinNumberOfNewlyIntroducedActiveThicknessConstraints=0;

if contains(UserVar.RunType,"-uv-h-")
    CtrlVar.ThicknessConstraintsItMax=2;
else
    CtrlVar.ThicknessConstraintsItMax=0;
end

CtrlVar.ThicknessPenalty=0;
CtrlVar.ThicknessPenaltyMassBalanceFeedbackCoeffCubic=-0 ; CtrlVar.ThicknessPenaltyMassBalanceFeedbackCoeffLin=-1000;

CtrlVar.LevelSetMethodAutomaticallyApplyMassBalanceFeedback=0;
CtrlVar.LevelSetMethodThicknessConstraints=1;
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffCubic=-0      ; CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-1000;


%%

if contains(UserVar.RunType,"-FR")  && contains(UserVar.RunType,"-uv-h-")
     CtrlVar.InfoLevelNonLinIt=1 ; 

end

% development version?  Using the development version is by default set to true
% this can be disabled by adding "-DV0-" to the run-string
if contains(UserVar.RunType,"-DV0-") 

    CtrlVar.DevelopmentVersion=false; 

else

    CtrlVar.DevelopmentVersion=true ; % Internal variable, always set to 0 

end

if contains(UserVar.RunType,"-TH1-") 

    CtrlVar.theta=1;

else

    CtrlVar.theta=0.5;

end


if contains(UserVar.RunType,"-SUPGtaus-") 

    CtrlVar.theta=1;

else

    CtrlVar.theta=0.5;

end

%% rhubarb 
CtrlVar.ManuallyDeactivateElements=true; % rhubarb
CtrlVar.IncludeMelangeModelPhysics=true; % rhubarb
CtrlVar.LocateAndDeleteDetachedIslandsAndRegionsConnectedByOneNodeOnly=true;  % rhubarb

CtrlVar.ActiveSet.ExcludeNodesOfBoundaryElements=false;
CtrlVar.AdaptMeshRunStepInterval=10 ;

CtrlVar.ThicknessPenaltyMassBalanceFeedbackCoeffLin=0; 
CtrlVar.ThicknessPenaltyMassBalanceFeedbackCoeffQuad=1e5;  
CtrlVar.ThicknessPenaltyMassBalanceFeedbackCoeffCubic=0; 

CtrlVar.CtrlVar.ThicknessBarrierMassBalanceFeedbackCoeffLog=0; 

CtrlVar.ThicknessConstraints=true;  CtrlVar.ThicknessConstraintsItMax=10; CtrlVar.MaxNumberOfNewlyIntroducedActiveThicknessConstraints=20; 
CtrlVar.ThicknessBarrier=0;         CtrlVar.ThicknessBarrierMassBalanceFeedbackCoeffLog=0.001;  
CtrlVar.ThicknessPenalty=1;         CtrlVar.ThicknessBarrierMassBalanceFeedbackCoeffLin=0 ; CtrlVar.ThicknessBarrierMassBalanceFeedbackCoeffQuad=1e6; CtrlVar.ThicknessBarrierMassBalanceFeedbackCoeffCubic=0 ;




end

