
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%% Select the type of run by uncommenting one of the following options:
%
%  
% close all ; job=batch("Ua","Pool",1)
% 
if isempty(UserVar) || ~isfield(UserVar,'RunType')
    
    UserVar.RunType='Inverse-MatOpt';
    % UserVar.RunType='Forward-Diagnostic' ; 
    UserVar.RunType='Forward-Transient' ;
    % UserVar.RunType='Inverse-UaOpt';meshb    % UserVar.RunType='Forward-Transient';
    % UserVar.RunType='TestingMeshOptions';
end

UserVar.Region="PIG" ; % "PIG-TWG" ; 
UserVar.CalvingLaw="-FixedRate1-"  ;
UserVar.CalvingLaw="-ScalesWithSpeed2-"  ;
UserVar.CalvingRateExtrapolated=1; 
% UserVar.CalvingLaw="-IceThickness10-"  ;
UserVar.CalvingLaw="-CliffHeight-Crawford"  ;
UserVar.CalvingFront0="-GL0-" ; % "-BedMachineCalvingFronts-"  ;
UserVar.Experiment=UserVar.CalvingLaw ; 
UserVar.DefineOutputs="-ubvb-LSF-h-"; % '-ubvb-LSF-h-save-';

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
UserVar.BasalMeltRate="MeltRate0" ;


%%

CtrlVar.LevelSetMethod=1;
CtrlVar.LevelSetEvolution="-By solving the level set equation-"   ; % "-prescribed-", 
CtrlVar.LevelSetInitialisationInterval=1 ; CtrlVar.LevelSetReinitializePDist=true ; 
CtrlVar.DevelopmentVersion=true; 
CtrlVar.LevelSetFABmu.Scale="-ucl-" ; % "-constant-"; 
CtrlVar.LevelSetFABmu.Value=1;
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

CtrlVar.SlidingLaw="Weertman" ; % "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"

switch CtrlVar.SlidingLaw

    case "Weertman"

        UserVar.CFile='FC-Weertman.mat'; UserVar.AFile='FA-Weertman.mat';

        if UserVar.Region=="PIG-TWG" 
            UserVar.AFile="FA-Weertman-PIG-TWG-20km.mat";
            UserVar.CFile="FC-Weertman-PIG-TWG-20km.mat";
        end
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
        
        UserVar.Slipperiness.ReadFromFile=0;
        UserVar.AGlen.ReadFromFile=0;
        
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        
        CtrlVar.Inverse.Iterations=100;
        
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
        
        
    case 'Forward-Transient'
        
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=1;
        CtrlVar.Restart=0;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.ReadInitialMesh=1;
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
        
    case 'TestingMeshOptions'
        
        CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
        CtrlVar.InverseRun=0;
        CtrlVar.Restart=0;
        CtrlVar.ReadInitialMesh=0;
        
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
        CtrlVar.TotalNumberOfForwardRunSteps=1; 
        CtrlVar.AdaptMesh=0;
        CtrlVar.AdaptMeshInitial=0  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshRunStepInterval)~=0.
        CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
        % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
        CtrlVar.InfoLevelAdaptiveMeshing=10;
end


CtrlVar.dt=0.01;   CtrlVar.DefineOutputsDt=0.05;
CtrlVar.time=0;

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


switch UserVar.Region

    case "PIG-TWG"
        CtrlVar.ReadInitialMeshFileName="MeshFile-20km-PIG-TWG.mat";
        % CtrlVar.ReadInitialMeshFileName='PIG-TWG-Mesh';
    case "PIG"
        CtrlVar.ReadInitialMeshFileName='MeshFile10km';
end


CtrlVar.SaveInitialMeshFileName='MeshFile';
CtrlVar.MaxNumberOfElements=70e3;

CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';   
% CtrlVar.MeshRefinementMethod='explicit:local:red-green';
CtrlVar.MeshRefinementMethod='explicit:global';   


CtrlVar.MeshGenerator='mesh2d' ; % 'mesh2d';


CtrlVar.MeshSizeMax=20e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;

UserVar.MeshSizeIceShelves=CtrlVar.MeshSizeMax/5;

MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar);
                                         
CtrlVar.AdaptMeshInitial=0  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshRunStepInterval)~=0.
CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
                                   % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
CtrlVar.AdaptMeshMaxIterations=5;
CtrlVar.SaveAdaptMeshFileName='MeshFileAdapt';    %  file name for saving adapt mesh. If left empty, no file is written
CtrlVar.AdaptMeshRunStepInterval=1 ; % remesh whenever mod(Itime,CtrlVar.AdaptMeshRunStepInterval)==0



I=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.001;
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;


I=I+1;
CtrlVar.ExplicitMeshRefinementCriteria(I).Name='flotation';
CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=0.0001;
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



%%
UserVar.AddDataErrors=0;



%%
CtrlVar.ThicknessConstraints=0;
CtrlVar.ResetThicknessToMinThickness=1;  % change this later on
CtrlVar.ThickMin=50;

%%


CtrlVar.NameOfRestartFiletoWrite=CtrlVar.Experiment+"-ForwardRestartFile.mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;

CtrlVar.Inverse.NameOfRestartOutputFile=CtrlVar.Experiment+"-InverseRestartFile.mat";
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile; 

CtrlVar.Experiment=CtrlVar.LevelSetFABmu.Scale+"-muValue"+num2str(CtrlVar.LevelSetFABmu.Value)...
    +"-Ini"+num2str(CtrlVar.LevelSetInitialisationInterval)...
    +"-PDist"+num2str(CtrlVar.LevelSetReinitializePDist)...
    +UserVar.CalvingLaw...
    +UserVar.CalvingFront0...
    +"-cExtrapolation"+num2str(UserVar.CalvingRateExtrapolated)...
    +"-"+UserVar.Region ;
CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-"); 
CtrlVar.Experiment=replace(CtrlVar.Experiment,".","k"); 

end
