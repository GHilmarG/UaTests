

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%% Select the type of run by uncommenting one of the following options:
%
%
% close all ; job=batch("Ua;","Pool",1) ;
%


if isempty(UserVar) || ~isfield(UserVar,'RunType')


    % UserVar.RunType='Forward-Diagnostic' ;

    UserVar.RunType='-FT-I-' ;  % 'Forward-Transient-Initialisation' ;
    UserVar.RunType='-FT-C-I-' ;  % 'Forward-Transient-Calving-Initialisation' ;
    UserVar.RunType="-FT-C-MR4-SM-" ;  % 'Forward-Transient-Calving with surface mass balance based on rachmo
   
    UserVar.RunType="-FT-C-RR-BMCF-MR4-SM-" ;  % 'Forward-Transient , Retreat-Rate prescribed , Initial calving fronts are Bedmachine grounding lines , ocean melt param #4
    UserVar.RunType="-FT-C-AC-BMGL-MR4-SM-" ;  % 'Forward-Transient , Anna Crawford


    % UserVar.RunType="-FT-C-I-Duvh-" ;  % 'Forward-Transient-Calving-Initialisation-Deactivate ahead of uvh solve' ;

    % Thwaites ice shelf experiments
    % UserVar.RunType="-FT-P-TWIS-MR4-SM-" ;  % -P-TWIS- is Thwaites Ice Shelf unmodified, ie all fronts kept as is, not calving not, simply a referene run
    %  UserVar.RunType="-FT-P-TWIS-MR4-SM-Clim-Alim-" ;   % Thwaites Ice Shelf unmodified, ie all fronts kept as is, not calving not, simply a referene run
    %UserVar.RunType="-FT-P-TWISC0-MR4-SM-Clim-Alim-" ;  % Thwaites Ice Shelf calved off


    % UserVar.RunType="-FT-P-TWIS-Duvh-MR4-SM-" ;  % -P-TWIS- is Thwaites Ice Shelf unmodified, ie all fronts kept as is, not calving not, simply a referene run, Deactive Elements
    % UserVar.RunType="-FT-P-TWISC-MR4-SM-" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off,
    % UserVar.RunType="-FT-P-TWISC10-MR4-SM-" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 10km away
    % UserVar.RunType="-FT-P-TWISC5-MR4-SM-" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 5km away
    % UserVar.RunType="-FT-P-TWISC2-MR4-SM-" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 2km away
    UserVar.RunType="-FT-P-TWISC0-MR4-SM-10km" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 0km away
    % the "-P-" stands for prescribed calving fronts
    UserVar.RunType="-FT-P-TWIS-MR4-SM-10km" ;         % not calved off

    UserVar.RunType="-FT-P-TWIS-MR4-SM-10km-Alim-" ;   % not calved off
    UserVar.RunType="-FT-P-TWISC0-MR4-SM-10km-Alim" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 0km away



    
    % UserVar.RunType='GenerateMesh' ;
    % UserVar.RunType='Inverse-MatOpt';

end

FileNameFormat="new" ; 

%% UserVar

UserVar.Region="PIG-TWG" ; "PIG" ; % "PIG-TWG" ;

if contains(UserVar.RunType,"-C-NV-")
    UserVar.CalvingLaw.Type="-NV-"  ;  % "-ScalesWithNormalVelocity+1.0-"  ;
    UserVar.CalvingLaw.Factor=1.1;
elseif contains(UserVar.RunType,"-C-RR-")
    UserVar.CalvingLaw.Type="-RR-"  ;  %  prescribed retreat rate
    UserVar.CalvingLaw.Factor="";
elseif contains(UserVar.RunType,"-C-AC-")
    UserVar.CalvingLaw.Type="-AC-"  ;  % Anna Crawford
    UserVar.CalvingLaw.Factor="";
     CtrlVar.Implicituvh=false;
else
    UserVar.CalvingLaw.Type="-NoCalving-"  ;  % "-ScalesWithNormalVelocity+1.0-"  ;
    UserVar.CalvingLaw.Factor=0 ;
end



if isempty(UserVar) || ~isfield(UserVar,'MeshResolution')

    pat="-"+digitsPattern+"km";
    MR=str2double(extract(extract(UserVar.RunType,pat),digitsPattern));

    if ~isempty(MR)
        UserVar.MeshResolution=MR*1000;   % MESH RESOLUTION
    else
        UserVar.MeshResolution=5e3;   % MESH RESOLUTION
    end
end


% 30km = 14km
% 20km = 9.3km
% 10km = 4.6km
%  5km = 2.3km
% 2.5km = 1.16km


if contains(UserVar.RunType,"-TWISC")
    UserVar.CalvingFront0=extract(UserVar.RunType,"-TWISC"+digitsPattern+"-");
elseif contains(UserVar.RunType,"-BMGL-")
    UserVar.CalvingFront0="-BMGL-";
else
    UserVar.CalvingFront0="-BMCF-"; "-BedMachineCalvingFronts-"  ;  % "-GL0-" ; % "-BedMachineCalvingFronts-"  ;
end

CtrlVar.CalvingLaw.Evaluation="-int-"  ; % nodal or integration-point evaluation  ["-int-","-node-"]
UserVar.CalvingLaw.String=UserVar.CalvingLaw.Type+num2str(UserVar.CalvingLaw.Factor)+UserVar.CalvingFront0+CtrlVar.CalvingLaw.Evaluation;
UserVar.DefineOutputs="-ubvb-LSF-h-dhdt-speed-save-AC-"; % '-ubvb-LSF-h-save-';
% UserVar.DefineOutputs="-ubvb-LSF-h-dhdt-speed-"; %
% UserVar.DefineOutputs="-save-"; %

CtrlVar.LimitRangeInUpdateFtimeDerivatives=true ;

%% Set output files directory
[~,hostname]=system('hostname') ;
if contains(hostname,"DESKTOP-G5TCRTD")

    UserVar.ResultsFileDirectory="F:\Runs\Calving\PIG-TWG\ResultsFiles\";
elseif contains(hostname,"DESKTOP-BU2IHIR")

    UserVar.ResultsFileDirectory="D:\Runs\Calving\PIG-TWG\ResultsFiles\";

else
    error("case not implemented")
end


%%
% This run requires some additional input files. They are too big to be kept on Github so you
% will have to get those separately.
%
% You can get these files on OneDrive using the link:
%
%   https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg?e=yMZEOs
%
% Put the OneDrive folder `Interpolants' into you directory so that it can be reached as ../Interpolants with respect to you rundirectory.
%
%
%UserVar.GeometryInterpolant='../../Interpolants/Bedmap2GriddedInterpolantModifiedBathymetry.mat'; % this assumes you have downloaded the OneDrive folder `Interpolants'.
UserVar.GeometryInterpolant='../../../Interpolants/BedMachineGriddedInterpolants.mat';
UserVar.SurfaceVelocityInterpolant='../../../Interpolants/SurfVelMeasures990mInterpolants.mat';
UserVar.MeshBoundaryCoordinatesFile='../../../Interpolants/MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine';
load(UserVar.MeshBoundaryCoordinatesFile,"Boundary") ; UserVar.BedMachineBoundary=Boundary;
UserVar.DistanceBetweenPointsAlongBoundary=5e3 ;

UserVar.FasFile="Fas_SMB_RACMO2k3_1979_2011.mat" ; %  surface mass balance




%% uvh tau;
CtrlVar.uvh.SUPG.tau="taus" ; % default,  issues with uvh convergence in the beginning
% CtrlVar.uvh.SUPG.tau="tau1" ; % testing


%%

CtrlVar.kH=10; 

%%  Level-set parameters

CtrlVar.LevelSetMethod=1;

if contains(UserVar.RunType,"-P-")  || contains(UserVar.RunType,"-Inverse-")
    CtrlVar.LevelSetEvolution="-Prescribed-"   ; % "-prescribed-",
else
    CtrlVar.LevelSetEvolution="-By solving the level set equation-"   ; % "-prescribed-",
end

CtrlVar.LevelSetInitialisationInterval=100 ;

if UserVar.CalvingLaw.Type=="-AC-"   % Anna Crawford
    CtrlVar.LevelSetInitialisationInterval=1 ;
    CtrlVar.DefineOutputsDt=0;
    CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-1000;  % This is the constant a1, it has units 1/time.
    CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffCubic=-1; 
else
    CtrlVar.DefineOutputsDt=0.25;

    CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-10;  % This is the constant a1, it has units 1/time.
    CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffCubic=0; 
end

CtrlVar.LevelSetInitialisationMethod="-geo-" ;

CtrlVar.LevelSetReinitializePDist=true ;
CtrlVar.LevelSetFixPointSolverApproach="-PTS-" ;   % pseudo forward stepping
CtrlVar.LevelSetPseudoFixPointSolverTolerance=100;
CtrlVar.LevelSetPseudoFixPointSolverMaxIterations=100;
CtrlVar.DevelopmentVersion=true;
CtrlVar.LevelSetFABmu.Scale="-u-cl-" ; % "-constant-";
CtrlVar.LevelSetFABmu.Value=0.1;
CtrlVar.CalvingLaw.Evaluation="-int-";
CtrlVar.LevelSetMethodSolveOnAStrip=1; CtrlVar.LevelSetMethodStripWidth=100e3;

if contains(UserVar.RunType,"-Duvh-")   % 'Forward-Transient-Calving-Initialisation' ;
    CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=1 ;
else
    CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=0 ;
end

CtrlVar.LevelSetInfoLevel=1 ;
CtrlVar.MeshAdapt.CFrange=[20e3 5e3 ; 10e3 2e3] ; % This refines the mesh around the calving front, but must set


% The melt is decribed as a= a_1 (h-hmin)

% Default value is 1
CtrlVar.ThickMin=1;
CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin+1;    % this is the hmin constant, i.e. the accepted min ice thickness
% over the 'ice-free' areas.
% Default value is CtrlVar.ThickMin+1





%%
CtrlVar.SaveInitialMeshFileName='MeshFile';


if contains(UserVar.RunType,"Cornford")
    CtrlVar.SlidingLaw="Cornford" ;
else
    CtrlVar.SlidingLaw="Weertman" ;
end
% "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"

switch CtrlVar.SlidingLaw

    case "Weertman"


        InvFile=CtrlVar.SlidingLaw...
            +"-Ca"+num2str(CtrlVar.Inverse.Regularize.logC.ga)...
            +"-Cs"+num2str(CtrlVar.Inverse.Regularize.logC.gs)...
            +"-Aa"+num2str(CtrlVar.Inverse.Regularize.logAGlen.ga)...
            +"-As"+num2str(CtrlVar.Inverse.Regularize.logAGlen.gs)...
            +"-"+num2str(UserVar.MeshResolution/1000)+"km";

        if contains(UserVar.RunType,"-Alim-")
            InvFile=InvFile+"-Alim-";
        end
        InvFile=replace(InvFile,".","k");

        UserVar.AFile="FA-"+InvFile;
        UserVar.CFile="FC-"+InvFile;


     

    case "Cornford"

        AFile="Cornford-"+UserVar.Region+"-"+num2str(UserVar.MeshResolution/1000)+"km";   %
        CFile="Cornford-"+UserVar.Region+"-"+num2str(UserVar.MeshResolution/1000)+"km";   %

        UserVar.AFile="FA-"+AFile;
        UserVar.CFile="FC-"+CFile;


       


    case "Umbi"
        UserVar.CFile='FC-Umbi'; UserVar.AFile='FA-Umbi';
    otherwise
        error('A and C fields not available')
end

if ~isfile(UserVar.GeometryInterpolant) || ~isfile(UserVar.SurfaceVelocityInterpolant)

    fprintf('\n This run requires the additional input files: \n %s \n %s \n %s  \n \n',UserVar.GeometryInterpolant,UserVar.DensityInterpolant,UserVar.SurfaceVelocityInterpolant)
    fprintf('You can download these file from : https://1drv.ms/f/s!Anaw0Iv-oEHTloRzWreBMDBFCJ0R4Q \n')

end

%% UserVar.RunType

if contains(UserVar.RunType,"Inverse")

    if contains(UserVar.RunType,"Inverse-UaOpt")
        % Testing
        CtrlVar.Inverse.MinimisationMethod='UaOptimization-Hessian'; % {'MatlabOptimization','UaOptimization'}
    end

    UserVar.DefineOutputs="-"; %
    CtrlVar.InverseRun=1;

    CtrlVar.Restart=0;
    CtrlVar.Inverse.InfoLevel=1;
    CtrlVar.InfoLevelNonLinIt=0;
    CtrlVar.InfoLevel=0;

    UserVar.Slipperiness.ReadFromFile=0;
    UserVar.AGlen.ReadFromFile=0;

    CtrlVar.ReadInitialMesh=1;
    CtrlVar.AdaptMesh=0;

    CtrlVar.Inverse.Iterations=2;

    CtrlVar.Inverse.InvertFor="-logA-logC-" ; % {'C','logC','AGlen','logAGlen'}
    CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
    CtrlVar.Inverse.DataMisfit.GradientCalculation="-adjoint-" ; % "-FixpointC-"; "adjoint";
    CtrlVar.Inverse.Measurements="-uv-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}

  

    
    CtrlVar.NameOfFileForSavingSlipperinessEstimate="InvC-"+InvFile;
    CtrlVar.NameOfFileForSavingAGlenEstimate="InvA-"+InvFile;

    CtrlVar.Inverse.NameOfRestartOutputFile="InverseRestartFile-"+InvFile;








    % [----------- Testing adjoint gradents
    CtrlVar.Inverse.TestAdjoint.isTrue=0; % If true then perform a brute force calculation
    % of the directional derivative of the objective function.
    CtrlVar.TestAdjointFiniteDifferenceType="central-second-order" ;
    CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=0.01 ;
    CtrlVar.Inverse.TestAdjoint.iRange=[100,121] ;  % range of nodes/elements over which brute force gradient is to be calculated.
    % if left empty, values are calulated for every node/element within the mesh.
    % If set to for example [1,10,45] values are calculated for these three
    % nodes/elements.
    % ----------------------- ]end, testing adjoint parameters.


elseif contains(UserVar.RunType,"-FT-")

    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=1;
    CtrlVar.Restart=0;
    CtrlVar.InfoLevelNonLinIt=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    if ~CtrlVar.Restart
        CtrlVar.ReadInitialMesh=1;
    end
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
    %CtrlVar.MeshSizeMax=20e3/16;  CtrlVar.SaveInitialMeshFileName="MeshFile1k25km"+CtrlVar.MeshGenerator ;


    CtrlVar.OnlyMeshDomainAndThenStop=1;


    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    CtrlVar.TotalNumberOfForwardRunSteps=1;
    CtrlVar.AdaptMesh=0;
    CtrlVar.AdaptMeshInitial=0  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshRunStepInterval)~=0.
    CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
    % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
    CtrlVar.InfoLevelAdaptiveMeshing=10;

else

    error("case not found")


end

CtrlVar.MeshSizeMax=UserVar.MeshResolution ;
CtrlVar.SaveInitialMeshFileName=...
    "MeshFile"...
    +num2str(CtrlVar.MeshSizeMax/1000) ...
    +"km-"...  ; %%            +CtrlVar.MeshGenerator ...
    +UserVar.Region ;

%% Time step, total run time, run steps

CtrlVar.dt=0.00001;   
CtrlVar.ATSdtMax=0.1;
CtrlVar.ATSdtMin=0.0001;

if contains(UserVar.RunType,"-I-")
    CtrlVar.time=-0.1;  % If I'm using a mass-balance initialisation set start time to a slighly neg value
    % In DefineMassBaloance, the initialisation is done for negative times.
else
    CtrlVar.time=0;
end

CtrlVar.TotalTime=100;

% Element type
CtrlVar.TriNodes=3 ;


%%
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5;

%% Meshing



CtrlVar.ReadInitialMeshFileName=...
    "MeshFile"...
    +num2str(UserVar.MeshResolution/1000) ...
    +"km-"...  ; %%            +CtrlVar.MeshGenerator ...
    +UserVar.Region ;

CtrlVar.ReadInitialMeshFileName=replace(CtrlVar.ReadInitialMeshFileName,".","k");

CtrlVar.MaxNumberOfElements=700e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;

UserVar.MeshSizeIceShelves=CtrlVar.MeshSizeMax/5;

MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar);

%% Adapting mesh

CtrlVar.AdaptMeshInitial=0  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshRunStepInterval)~=0.
CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed
% useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
CtrlVar.AdaptMeshMaxIterations=5;
CtrlVar.SaveAdaptMeshFileName='MeshFileAdapt';    %  file name for saving adapt mesh. If left empty, no file is written
CtrlVar.AdaptMeshRunStepInterval=1 ; % remesh whenever mod(Itime,CtrlVar.AdaptMeshRunStepInterval)==0



%%
CtrlVar.ThicknessConstraints=1;
CtrlVar.ResetThicknessToMinThickness=0;

%% A C constraints
if contains(UserVar.RunType,"-Alim-")
    CtrlVar.AGlenmin=AGlenVersusTemp(-20) ;
end
%%
if batchStartupOptionUsed
    CtrlVar.doplots=0;   % disable plotting if running as batch
    fprintf("disabling plotting as this is a batch job\n")
    if contains(UserVar.DefineOutputs,"save")
        UserVar.DefineOutputs="-save-";  % disable plotting in DefineOutputs as well
    end
end

%%


if FileNameFormat=="new"
    CtrlVar.Experiment=UserVar.RunType ;
else
    CtrlVar.Experiment= ...
        UserVar.RunType...
        +CtrlVar.LevelSetFABmu.Scale....
        +"-mu"+num2str(CtrlVar.LevelSetFABmu.Value)...
        +"-Ini"+CtrlVar.LevelSetInitialisationMethod+num2str(CtrlVar.LevelSetInitialisationInterval)...
        +"-Strip"+num2str(CtrlVar.LevelSetMethodSolveOnAStrip)...
        +"-SW="+num2str(CtrlVar.LevelSetMethodStripWidth/1000)+"km"...
        +"-AD="+num2str(CtrlVar.LevelSetMethodAutomaticallyDeactivateElements)...
        +UserVar.CalvingLaw.String...
        +"-kH="+num2str(CtrlVar.kH)...
        +"-asRacmo"...
        +"-dhdtLim"+num2str(CtrlVar.LimitRangeInUpdateFtimeDerivatives)...
        +"-"+UserVar.Region...
        +"-"+CtrlVar.ReadInitialMeshFileName;

end
CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
CtrlVar.Experiment=replace(CtrlVar.Experiment,".","k");
CtrlVar.Experiment=replace(CtrlVar.Experiment,"+","p");

if startsWith(CtrlVar.Experiment,"-")
    CtrlVar.Experiment=replaceBetween(CtrlVar.Experiment,1,1,"");
end





CtrlVar.Inverse.NameOfRestartOutputFile=replace(CtrlVar.Inverse.NameOfRestartOutputFile,"--","-");
CtrlVar.Inverse.NameOfRestartOutputFile=replace(CtrlVar.Inverse.NameOfRestartOutputFile,".","k");
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;

if CtrlVar.InverseRun
    fprintf(" Inverse restart file: %s \n",CtrlVar.Inverse.NameOfRestartOutputFile)
end

if isfile(CtrlVar.Inverse.NameOfRestartInputFile+".mat")
    CtrlVar.Restart=1;
else
    CtrlVar.Restart=0;
    fprintf("No restart file found. Starting a new run. \n")
end


CtrlVar.ReadInitialMeshFileName=replace(CtrlVar.ReadInitialMeshFileName,".","k");
CtrlVar.SaveInitialMeshFileName=replace(CtrlVar.SaveInitialMeshFileName,".","k");



UserVar.CFile=replace(UserVar.CFile,".","k");
UserVar.AFile=replace(UserVar.AFile,".","k");


CtrlVar.NameOfRestartFiletoWrite="Restart-"+UserVar.RunType+".mat";
CtrlVar.NameOfRestartFiletoWrite=replace(CtrlVar.NameOfRestartFiletoWrite,"--","-");
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;




CtrlVar.WriteRestartFileInterval=100;

end
