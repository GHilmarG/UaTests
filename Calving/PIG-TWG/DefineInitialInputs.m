
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%% Select the type of run by uncommenting one of the following options:
%
%  
% close all ; job=batch("Ua;","Pool",1) ; 
%


if isempty(UserVar) || ~isfield(UserVar,'RunType')
    
    UserVar.RunType='Inverse-MatOpt';
    % UserVar.RunType='Forward-Diagnostic' ; 
    UserVar.RunType='Forward-Transient' ;
    UserVar.RunType='Forward-Transient-Initialisation' ;
    UserVar.RunType='-FT-I-' ;  % 'Forward-Transient-Initialisation' ;
    UserVar.RunType='-FT-C-I-' ;  % 'Forward-Transient-Initialisation' ;
    % UserVar.RunType='GenerateMesh' ;
    % UserVar.RunType='Inverse-UaOpt';meshb    % UserVar.RunType='Forward-Transient';

end


%% UserVar

UserVar.Region="PIG-TWG" ; "PIG" ; % "PIG-TWG" ; 


UserVar.CalvingLaw.Scale="-NV-"  ;  % "-ScalesWithNormalVelocity+1.0-"  ;
UserVar.CalvingLaw.Factor=1;  
CtrlVar.CalvingLaw.Evaluation="-int-";  


% UserVar.CalvingLaw="-CliffHeight-Crawford"  ;


UserVar.MeshResolution=30e3;



UserVar.CalvingFront0="-BMCF-"; "-BedMachineCalvingFronts-"  ;  % "-GL0-" ; % "-BedMachineCalvingFronts-"  ;
UserVar.CalvingLaw.String=UserVar.CalvingLaw.Scale+num2str(UserVar.CalvingLaw.Factor)+UserVar.CalvingFront0+CtrlVar.CalvingLaw.Evaluation;


UserVar.Experiment=UserVar.CalvingLaw ; 
UserVar.DefineOutputs="-ubvb-LSF-h-save-"; % '-ubvb-LSF-h-save-';

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



%%

CtrlVar.LevelSetMethod=1;
CtrlVar.LevelSetEvolution="-By solving the level set equation-"   ; % "-prescribed-", 
CtrlVar.LevelSetInitialisationInterval=Inf ; CtrlVar.LevelSetReinitializePDist=true ; 
CtrlVar.LevelSetFixPointSolverApproach="-PTS-" ;   % pseudo forward stepping
CtrlVar.LevelSetPseudoFixPointSolverTolerance=100;
CtrlVar.LevelSetPseudoFixPointSolverMaxIterations=100;
CtrlVar.DevelopmentVersion=true; 
CtrlVar.LevelSetFABmu.Scale="-ucl-" ; % "-constant-"; 
CtrlVar.LevelSetFABmu.Value=0.1;
CtrlVar.LevelSetInfoLevel=1 ; 
CtrlVar.MeshAdapt.CFrange=[20e3 5e3 ; 10e3 2e3] ; % This refines the mesh around the calving front, but must set


% The melt is decribed as a= a_1 (h-hmin)
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-10;  % This is the constant a1, it has units 1/time.
% Default value is -1

CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin+1;    % this is the hmin constant, i.e. the accepted min ice thickness
% over the 'ice-free' areas.
% Default value is CtrlVar.ThickMin+1

CtrlVar.LevelSetEvolution="-By solving the level set equation-"  ; % "-prescribed-", 



%%
CtrlVar.SaveInitialMeshFileName='MeshFile';
CtrlVar.SlidingLaw="Weertman" ; % "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"

switch CtrlVar.SlidingLaw

    case "Weertman"

        AFile="AWeertman-"+UserVar.Region+num2str(UserVar.MeshResolution/1000)+"km.mat";   %
        CFile="CWeertman-"+UserVar.Region+num2str(UserVar.MeshResolution/1000)+"km.mat";   %

        UserVar.AFile="FA-"+AFile;
        UserVar.CFile="FC-"+CFile;


        CtrlVar.NameOfFileForSavingSlipperinessEstimate="InvEstimate-"+CFile;
        CtrlVar.NameOfFileForSavingAGlenEstimate="InvEstimate-"+AFile;




    case "Umbi"
        UserVar.CFile='FC-Umbi.mat'; UserVar.AFile='FA-Umbi.mat';
    otherwise
        error('A and C fields not available')
end

if ~isfile(UserVar.GeometryInterpolant) || ~isfile(UserVar.SurfaceVelocityInterpolant)

    fprintf('\n This run requires the additional input files: \n %s \n %s \n %s  \n \n',UserVar.GeometryInterpolant,UserVar.DensityInterpolant,UserVar.SurfaceVelocityInterpolant)
    fprintf('You can download these file from : https://1drv.ms/f/s!Anaw0Iv-oEHTloRzWreBMDBFCJ0R4Q \n')

end

%%






switch UserVar.RunType
    
    case {'Inverse-MatOpt','Inverse-UaOpt'}
        
        CtrlVar.InverseRun=1;
        
        CtrlVar.Restart=1;
        CtrlVar.Inverse.InfoLevel=1;
        CtrlVar.InfoLevelNonLinIt=0;
        CtrlVar.InfoLevel=0;
        
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        
        CtrlVar.ReadInitialMesh=0;
        CtrlVar.AdaptMesh=0;
        
        CtrlVar.Inverse.Iterations=500;
        
        CtrlVar.Inverse.InvertFor="-logA-logC-" ; % {'C','logC','AGlen','logAGlen'}
        CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
        CtrlVar.Inverse.DataMisfit.GradientCalculation="-adjoint-" ; % "-FixpointC-"; "adjoint";
        CtrlVar.Inverse.Measurements="-uv-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
  
        
        CtrlVar.Inverse.Regularize.logC.ga=1;
        CtrlVar.Inverse.Regularize.logC.gs=1e3 ;
        CtrlVar.Inverse.Regularize.logAGlen.ga=1;
        CtrlVar.Inverse.Regularize.logAGlen.gs=1e3 ;
        
        
        if contains(UserVar.RunType,"UaOpt")
            
            
            CtrlVar.Inverse.InvertFor="-logA-" ;
            CtrlVar.Inverse.Iterations=5;
            CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
            CtrlVar.Inverse.MinimisationMethod='UaOptimization-Hessian'; % {'MatlabOptimization','UaOptimization'}
            
            
            CtrlVar.Inverse.DataMisfit.Multiplier=1;
            CtrlVar.Inverse.Regularize.Multiplier=1;
        end
        
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
        
        
    case {"FT-I","FT-C","-FT-C-I-"}

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

    case 'Forward-Diagnostic'
               
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=0;
        CtrlVar.Restart=0;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
    case 'GenerateMesh'
        
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

    otherwise

        error("case not found")


end

CtrlVar.MeshSizeMax=UserVar.MeshResolution ;  
CtrlVar.SaveInitialMeshFileName=...
    "MeshFile"...
    +num2str(CtrlVar.MeshSizeMax/1000) ...
    +"km-"...  ; %%            +CtrlVar.MeshGenerator ...
    +UserVar.Region ;

%% Time step, total run time, run steps

CtrlVar.dt=0.01;   CtrlVar.DefineOutputsDt=0.5;

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


CtrlVar.MaxNumberOfElements=700e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;

UserVar.MeshSizeIceShelves=CtrlVar.MeshSizeMax/5;

MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar);
                          
%% Adapting mesh 

CtrlVar.AdaptMeshInitial=0  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshRunStepInterval)~=0.
CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
                                   % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
CtrlVar.AdaptMeshMaxIterations=5;
CtrlVar.SaveAdaptMeshFileName='MeshFileAdapt';    %  file name for saving adapt mesh. If left empty, no file is written
CtrlVar.AdaptMeshRunStepInterval=1 ; % remesh whenever mod(Itime,CtrlVar.AdaptMeshRunStepInterval)==0



%%
CtrlVar.ThicknessConstraints=0;
CtrlVar.ResetThicknessToMinThickness=1;  % change this later on
CtrlVar.ThickMin=5;

%%
if batchStartupOptionUsed
    CtrlVar.doplots=0;   % disable plotting if running as batch
    if contains(UserVar.DefineOutputs,"save")
        UserVar.DefineOutputs="-save-";  % disable plotting in DefineOutputs as well
    end
end

%%





CtrlVar.Experiment= ...
    UserVar.RunType...
    +CtrlVar.LevelSetFABmu.Scale....
    +"-mu"+num2str(CtrlVar.LevelSetFABmu.Value)...
    +"-Ini"+num2str(CtrlVar.LevelSetInitialisationInterval)...
    +"-PDist"+num2str(CtrlVar.LevelSetReinitializePDist)...
    +UserVar.CalvingLaw.String...
    +"-"+UserVar.Region...
    +"-"+CtrlVar.ReadInitialMeshFileName;

CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
CtrlVar.Experiment=replace(CtrlVar.Experiment,".","k");
CtrlVar.Experiment=replace(CtrlVar.Experiment,"+","p");

if startsWith(CtrlVar.Experiment,"-")
    CtrlVar.Experiment=replaceBetween(CtrlVar.Experiment,1,2,"");
end

CtrlVar.Inverse.NameOfRestartOutputFile="InverseRestartFile-"...
    +UserVar.Region...
    +"-"+num2str(UserVar.MeshResolution/1000)+"km";

CtrlVar.Inverse.NameOfRestartOutputFile=replace(CtrlVar.Inverse.NameOfRestartOutputFile,"--","-");
CtrlVar.Inverse.NameOfRestartOutputFile=replace(CtrlVar.Inverse.NameOfRestartOutputFile,".","k");


CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile; 

CtrlVar.NameOfRestartFiletoWrite=CtrlVar.Experiment+"-FR.mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;

CtrlVar.WriteRestartFileInterval=10;

end
