
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)




%% Select the type of run by uncommenting one of the following options:

if isempty(UserVar) || ~isfield(UserVar,'RunType')
    
    UserVar.RunType='Inverse-MatOpt';
    % UserVar.RunType='Inverse-ConjGrad';
    % UserVar.RunType='Inverse-SteepestDesent';
    % UserVar.RunType='Inverse-ConjGrad-FixPoint';
    % UserVar.RunType='Inverse-MatOpt-FixPoint';
    UserVar.RunType='Forward-Diagnostic';
    UserVar.RunType='Forward-Transient';
    UserVar.RunType='Forward-Transient-group-';
    UserVar.RunType='Forward-Transient-group-dt0.1-';
    UserVar.RunType='Forward-Transient-dt0.1-';
    UserVar.RunType='Forward-Transient-uv-h-group-';
    
    % UserVar.RunType='TestingMeshOptions';
end

if isempty(UserVar) || ~isfield(UserVar,'m')
    UserVar.m=3;
end

if contains(UserVar.RunType,"-group-")
    CtrlVar.uvGroupAssembly=true;
    CtrlVar.uvhGroupAssembly=true;
else
    CtrlVar.uvGroupAssembly=false;
    CtrlVar.uvhGroupAssembly=false;
end

 

if contains(UserVar.RunType,"-dt")
    CtrlVar.AdaptiveTimeStepping=0 ;
    Key='-dt'; 
    index=strfind(UserVar.RunType,Key) ;
    Values=sscanf(UserVar.RunType(index(1)+length(Key)+1:end),'%f') ;
    CtrlVar.dt=Values(1) ;
else
    CtrlVar.AdaptiveTimeStepping=1 ;
    CtrlVar.dt=0.1 ; 
end

CtrlVar.FlowApproximation="SSTREAM" ; % "SSTREAM-rho" ;
%%
% This run requires some additional input files. They are too big to be kept on Github so you
% will have to get those separately. 
%
% You can https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg?e=yMZEOs
% 
% Put the OneDrive folder `Interpolants' into you directory so that it can be reaced as ../../Interpolants with respect to you rundirectory. 
%
%


% Interpolant paths: this assumes you have downloaded the OneDrive folder `Interpolants'.
% UserVar.GeometryInterpolant='../../Interpolants/Bedmap2GriddedInterpolantModifiedBathymetry.mat';
UserVar.GeometryInterpolant='../../Interpolants/BedMachineGriddedInterpolants.mat';                       
UserVar.SurfaceVelocityInterpolant='../../Interpolants/SurfVelMeasures990mInterpolants.mat';
UserVar.MeshBoundaryCoordinatesFile='../../Interpolants/MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine'; 
UserVar.DistanceBetweenPointsAlongBoundary=5e3 ; 

CtrlVar.SlidingLaw="Weertman" ; % "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"

switch CtrlVar.SlidingLaw
    
    case "Weertman"
        UserVar.CFile='FC-Weertman.mat'; UserVar.AFile='FA-Weertman.mat';
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

CtrlVar.Experiment=UserVar.RunType;
CtrlVar.TotalNumberOfForwardRunSteps=1;

if contains(UserVar.RunType,'Inverse')

    %switch UserVar.RunType
    %    case {'Inverse-MatOpt','Inverse-ConjGrad','Inverse-MatOpt-FixPoint','Inverse-ConjGrad-FixPoint','Inverse-SteepestDesent'}

    CtrlVar.InverseRun=1;
    CtrlVar.Restart=0;

    CtrlVar.InfoLevelNonLinIt=0;
    CtrlVar.Inverse.InfoLevel=1;
    CtrlVar.InfoLevel=0;

    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    CtrlVar.ReadInitialMesh=1;
    CtrlVar.AdaptMesh=0;

    CtrlVar.Inverse.Iterations=100;
    CtrlVar.Inverse.InvertFor='logA-logC' ; % '-logAGlen-logC-' ; % {'-C-','-logC-','-AGlen-','-logAGlen-'}
    CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;

    CtrlVar.Inverse.Measurements='-uv-' ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}



    if contains(UserVar.RunType,'FixPoint')

        % FixPoint inversion is an ad-hoc method of estimating the gradient of the cost function with respect to C.
        % It can produce quite good estimates for C using just one or two inversion iterations, but then typically stagnates.
        % The FixPoint method can often be used right at the start of an inversion to get a reasonably good C estimate,
        % after which in a restart step one can switch to gradient calculation using the adjoint method
        CtrlVar.Inverse.DataMisfit.GradientCalculation='FixPoint' ;
        CtrlVar.Inverse.InvertFor='logC' ;
        CtrlVar.Inverse.Iterations=1;
        CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;

    end

elseif contains(UserVar.RunType,'Forward-Transient')   %case {'Forward-Transient','Forward-Transient-uv-h'}

    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=1;
    CtrlVar.Restart=0;
    CtrlVar.InfoLevelNonLinIt=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    CtrlVar.ReadInitialMesh=1;
    CtrlVar.AdaptMesh=0;

    if contains(UserVar.RunType,'-uv-h')
        CtrlVar.Implicituvh=0;           % 0: prognostic run is semi-implicit (implicit with respect to h only)
        CtrlVar.TotalNumberOfForwardRunSteps=inf;
        CtrlVar.etaZero=100 ;  % it turned out that setting this lower value to the effective viscosity, had almost no impact on the calculate viscosity distrbution
        % but greatly improved numerical
        % convergence. With etaZero=0, there
        % were a few localized nodes with very high
        % velocities, resulting in high strain
        % rates, and very small effective
        % viscosity over this area

    else
        CtrlVar.Implicituvh=1;                 % 1: prognostic run is fully-implicit (implicit with respect to uvh)
        CtrlVar.TotalNumberOfForwardRunSteps=inf;
        CtrlVar.etaZero=100 ;  % it turned out that setting this lower value to the effective viscosity, had almost no impact on the calculate viscosity distrbution
    end

elseif contains(UserVar.RunType,'Forward-Diagnostic')  %case 'Forward-Diagnostic'

    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=0;
    CtrlVar.Restart=0;
    CtrlVar.InfoLevelNonLinIt=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    CtrlVar.ReadInitialMesh=1;
    CtrlVar.AdaptMesh=0;

elseif contains(UserVar.RunType,'TestingMeshOptions')  %case 'TestingMeshOptions'

    CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
    CtrlVar.InverseRun=0;
    CtrlVar.Restart=0;
    CtrlVar.ReadInitialMesh=0;
    CtrlVar.AdaptMesh=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    CtrlVar.AdaptMesh=1;
    CtrlVar.AdaptMeshInitial=1  ;
    CtrlVar.AdaptMeshRunStepInterval=1 ;
    CtrlVar.AdaptMeshAndThenStop=0;    % if true, then mesh will be adapted but no further calculations performed
    % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
    CtrlVar.InfoLevelAdaptiveMeshing=10;

else
    error("Case not found")
end



CtrlVar.time=0 ; 
CtrlVar.TotalTime=10;

% Element type
CtrlVar.TriNodes=3 ;


%%
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5;
%%

CtrlVar.ReadInitialMeshFileName='PIG-TWG-Mesh.mat';
CtrlVar.ReadInitialMeshFileName='PIG-TWG-Mesh-withThwaitesIceshelfWestDeleted.mat';
CtrlVar.SaveInitialMeshFileName='MeshFile.mat';
CtrlVar.MaxNumberOfElements=70e3;




%% Meshing 


CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';   
%CtrlVar.MeshRefinementMethod='explicit:local:red-green';
CtrlVar.MeshRefinementMethod='explicit:global';   

CtrlVar.MeshGenerator='gmsh' ; % 'mesh2d';
%CtrlVar.MeshGenerator='mesh2d' ; % 'mesh2d';
CtrlVar.GmshMeshingAlgorithm=8; 
CtrlVar.MeshSizeMax=20e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;
UserVar.MeshSizeIceShelves=CtrlVar.MeshSizeMax/5;
MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar);
                                         
CtrlVar.AdaptMeshInitial=1  ;   
CtrlVar.AdaptMeshMaxIterations=5;
CtrlVar.SaveAdaptMeshFileName='MeshFileAdapt';    %  file name for saving adapt mesh. If left empty, no file is written




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
                                                        
%%  Bounds on C and AGlen
%CtrlVar.AGlenmin=1e-10; CtrlVar.AGlenmax=1e-5;

CtrlVar.Cmin=1e-20;  CtrlVar.Cmax=1e20;        

%CtrlVar.CisElementBased=0;   
%CtrlVar.AGlenisElementBased=0;   


%% Testing adjoint parameters, start:
CtrlVar.Inverse.TestAdjoint.isTrue=0; % If true then perform a brute force calculation 
                                      % of the directional derivative of the objective function.  
CtrlVar.Inverse.TestAdjointFiniteDifferenceType='second-order' ; % {'central','forward'}
CtrlVar.Inverse.TestAdjointFiniteDifferenceStepSize=1e-8 ;
CtrlVar.Inverse.TestAdjoint.iRange=[100,121] ;  % range of nodes/elements over which brute force gradient is to be calculated.
                                         % if left empty, values are calulated for every node/element within the mesh. 
                                         % If set to for example [1,10,45] values are calculated for these three
                                         % nodes/elements.
% end, testing adjoint parameters. 


if contains(UserVar.RunType,'MatOpt')
    CtrlVar.Inverse.MinimisationMethod='MatlabOptimization';
else
    CtrlVar.Inverse.MinimisationMethod='UaOptimization';
    if contains(UserVar.RunType,'ConjGrad')
        CtrlVar.Inverse.GradientUpgradeMethod='ConjGrad' ; %{'SteepestDecent','ConjGrad'}
    else
        CtrlVar.Inverse.GradientUpgradeMethod='SteepestDecent' ; %{'SteepestDecent','ConjGrad'}
    end
    
end

                                                    
UserVar.AddDataErrors=0;


CtrlVar.Inverse.Regularize.C.gs=1;
CtrlVar.Inverse.Regularize.C.ga=1;
CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1e3 ;

CtrlVar.Inverse.Regularize.logC.ga=0;  % testing for Budd
CtrlVar.Inverse.Regularize.logC.gs=1e3 ; % testing for Budd

CtrlVar.Inverse.Regularize.AGlen.gs=1;
CtrlVar.Inverse.Regularize.AGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1e3 ;


%%
CtrlVar.ThicknessConstraints=0;
CtrlVar.ResetThicknessToMinThickness=1;  % change this later on
CtrlVar.ThickMin=1;

%% Filenames

CtrlVar.NameOfFileForSavingSlipperinessEstimate="C-Estimate"+CtrlVar.SlidingLaw+".mat";
CtrlVar.NameOfFileForSavingAGlenEstimate=   "AGlen-Estimate"+CtrlVar.SlidingLaw+".mat";

if CtrlVar.InverseRun
    CtrlVar.Experiment="PIG-TWG-Inverse-"...
        +CtrlVar.ReadInitialMeshFileName...
        +CtrlVar.Inverse.InvertFor...
        +CtrlVar.Inverse.MinimisationMethod...
        +"-"+CtrlVar.Inverse.AdjointGradientPreMultiplier...
        +CtrlVar.Inverse.DataMisfit.GradientCalculation...
        +CtrlVar.Inverse.Hessian...
        +"-"+CtrlVar.SlidingLaw...
        +"-"+num2str(CtrlVar.DevelopmentVersion);
else
    CtrlVar.Experiment="PIG-TWG-Forward"...
        +CtrlVar.ReadInitialMeshFileName;
end

if CtrlVar.InverseRun
    filename=sprintf('IR-%s-%s-Nod%i-%s-%s-Cga%f-Cgs%f-Aga%f-Ags%f-m%i-%s',...
        UserVar.RunType,...
        CtrlVar.Inverse.MinimisationMethod,...
        CtrlVar.TriNodes,...
        CtrlVar.Inverse.AdjointGradientPreMultiplier,...
        CtrlVar.Inverse.DataMisfit.GradientCalculation,...
        CtrlVar.Inverse.Regularize.logC.ga,...
        CtrlVar.Inverse.Regularize.logC.gs,...
        CtrlVar.Inverse.Regularize.logAGlen.ga,...
        CtrlVar.Inverse.Regularize.logAGlen.gs,...
        UserVar.m,...
        CtrlVar.Inverse.InvertFor);
else

    filename=UserVar.RunType ;

end

CtrlVar.Experiment=replace(CtrlVar.Experiment," ","-");
filename=replace(filename,'.','k');
filename=replace(filename,'--','-');

CtrlVar.Inverse.NameOfRestartOutputFile=filename;
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;

CtrlVar.NameOfRestartFiletoWrite="FR-"+filename ; 

end
