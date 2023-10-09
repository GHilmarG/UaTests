


function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar,varargin)

% close all ; job=batch("Ua","Pool",1)

%% Select the type of run by uncommenting one of the following options:

if isempty(UserVar) || ~isfield(UserVar,'RunType')

    UserVar.RunType='Inverse-MatOpt';
    %  UserVar.RunType='Inverse-UaOpt';
    % UserVar.RunType='Inverse-MatOpt-FixPoint';
    % UserVar.RunType='Inverse-ConjGrad';
    % UserVar.RunType='Inverse-TestAdjoint';
    % UserVar.RunType='Inverse-SteepestDesent';
    % UserVar.RunType='Inverse-ConjGrad-FixPoint';
    % UserVar.RunType='Forward-Diagnostic';
    % UserVar.RunType='Forward-Transient';
    % UserVar.RunType='TestingMeshOptions';
end

%%
% This run requires some additional input files. They are too big to be kept on Github so you
% will have to get those separately.
%
% You can get these files on OneDrive using the link:
%
%   https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg?e=yMZEOs
%
% Put the OneDrive folder `Interpolants' into a local data repository directory.
%
%

%% UserVar
UserVar.ConstantIceShelfMeltRate=0;
UserVar.n=3; UserVar.m=3;


UserVar.DataRepositoryDirectory="../../Work/Ua/Antarctic Global Data Sets/MatlabInterpolants/" ;  % This is the path to your local data repository direcory with respect to the folder where you do your runs
UserVar.DataRepositoryDirectory="../../Interpolants/" ;  % This is the path to your local data repository direcory with respect to the folder where you do your runs


UserVar.GeometryAndDensityInterpolants=UserVar.DataRepositoryDirectory+"BedMachineGriddedInterpolants.mat";
UserVar.SurfaceVelocityInterpolant=UserVar.DataRepositoryDirectory+"L8Velocities-2014-AlexGardnerWithoutPolarGap-Spacing2400m";
UserVar.SurfaceMassBalanceInterpolant=UserVar.DataRepositoryDirectory+"FasRACMO.mat";
UserVar.BoundaryFile=UserVar.DataRepositoryDirectory+"MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine.mat";
UserVar.CFileName=[];
UserVar.AGlenFileName=[];
UserVar.Plots="-CreateFiguresInDefineOutputs-";

UserVar.DataFileWithPriors="Priors-panAntartica-Weertman-m3-n3-54kElements-28kNodes.mat"; %
UserVar.DataFileWithPriors="";




Reg=1e5; 
RegString=num2str(Reg); 


UserVar.DataFileWithInverseStartA="A-panAntarctic-m3-n3-Weertman-Nod3-Cga1-Cgs"+RegString+"-Aga1-Ags"+RegString+"-logC-logA-N111k-E218k-.mat";
UserVar.DataFileWithInverseStartC="C-panAntarctic-m3-n3-Weertman-Nod3-Cga1-Cgs"+RegString+"-Aga1-Ags"+RegString+"-logC-logA-N111k-E218k-.mat";


UserVar.DataFileWithInverseStartA="A-panAntarctic-m3-n3-Weertman-Nod3-Cga1-Cgs"+RegString+"-Aga1-Ags"+RegString+"-logC-logA-N1754k-E3494k-.mat";
UserVar.DataFileWithInverseStartC="C-panAntarctic-m3-n3-Weertman-Nod3-Cga1-Cgs"+RegString+"-Aga1-Ags"+RegString+"-logC-logA-N1754k-E3494k-.mat";







if ~isfield(UserVar,'m')
    UserVar.m=3;
end

if ~isfield(UserVar,'n')
    UserVar.n=3;
end

%%

CtrlVar.Experiment=UserVar.RunType;


CtrlVar.PlotsXaxisLabel='xps (km)' ;  CtrlVar.PlotsYaxisLabel='yps (km)' ; %

switch UserVar.RunType

    case {'Inverse-MatOpt','Inverse-UaOpt','Inverse-TestAdjoint'}

       
        CtrlVar.InverseRun=1;

        CtrlVar.Restart=0;
        
        CtrlVar.Inverse.Iterations=1;

        if contains(UserVar.RunType,"MatOpt")
            CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased";
            % CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased";
            CtrlVar.Inverse.InvertFor='-logC-logA-' ;
            CtrlVar.Inverse.Measurements='-uv-dhdt-' ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
        else
            CtrlVar.Inverse.MinimisationMethod='UaOptimization-HessianBased';
            CtrlVar.Inverse.InvertFor='-logA-';
            CtrlVar.Inverse.Measurements='-uv-' ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
            CtrlVar.Inverse.DataMisfit.GradientCalculation='adjoint';
        end

        CtrlVar.InfoLevelNonLinIt=0;
        CtrlVar.InfoLevel=0;

        % This is used in DefineAGlen and DefineSlipperiness,
        % and also to set the initial start value in an inverse run.

        UserVar.ReadSlipperinessFromFile=0;
        UserVar.ReadAGlenEstFromFile=0;
        CtrlVar.ReadInitialMesh=1; CtrlVar.ReadInitialMeshFileName="AntarcticaMUAwith54kElements";                    Nele=54596 ; Nnodes=28278;
        CtrlVar.ReadInitialMesh=1; CtrlVar.ReadInitialMeshFileName="AntarcticaMUAwith218kElements111kNodes.mat";      Nele=218383 ; Nnodes=111151;
        CtrlVar.ReadInitialMesh=1; CtrlVar.ReadInitialMeshFileName="AntarcticaMUAwith873kElements440kNodes.mat";      Nele=873000 ; Nnodes=440000;
        CtrlVar.ReadInitialMesh=1; CtrlVar.ReadInitialMeshFileName="AntarcticaMUAwith3494kElements1754kNodes.mat" ;   Nele=3494000 ; Nnodes=1754000;


        CtrlVar.AdaptMesh=0;       % CtrlVar.ReadInitialMeshFileName



        CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;

   

        CtrlVar.Inverse.Regularize.logC.ga=1;
        CtrlVar.Inverse.Regularize.logC.gs=Reg ;
        CtrlVar.Inverse.Regularize.logAGlen.ga=1;
        CtrlVar.Inverse.Regularize.logAGlen.gs=Reg;



        if contains(UserVar.RunType,'TestAdjoint')

            CtrlVar.Inverse.TestAdjoint.isTrue=1; % If true then perform a brute force calculation
            % of the directional derivative of the objective function.
            %
            % The brute-force gradient can be calculated using first-order forward
            % differences, second-order central differences, or fourth-order central
            % differences.
            CtrlVar.Inverse.SaveSlipperinessEstimateInSeperateFile=false ;
            CtrlVar.Inverse.SaveAGlenEstimateInSeperateFile=false ;
            CtrlVar.InfoLevelNonLinIt=0;
            CtrlVar.Restart=1;
            CtrlVar.Inverse.InvertFor='-logA-logC-';
            CtrlVar.Inverse.Measurements='-uv-dhdt-' ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
            CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
            CtrlVar.Inverse.AdjointGradientPreMultiplier='I'; % {'I','M'}

            CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=0.01 ; % 0.1 reasonable for logA and logC


            CtrlVar.TestAdjointFiniteDifferenceType="central-second-order" ;
            % CtrlVar.TestAdjointFiniteDifferenceType="forward-second-order" ;
            % CtrlVar.TestAdjointFiniteDifferenceType="central-fourth-order" ;

            CtrlVar.Inverse.TestAdjoint.iRange=[100 1000 5000 10000 20000] ;  % range of nodes/elements over which brute force gradient is to be calculated.
            %
            % if left empty, values are calculated for every node/element within the mesh.
            % If set to for example [1,10,45] values are calculated for these three
            % nodes/elements.
        end





    case 'Forward-Transient'

        % Job=batch("Ua",1,{},"Pool",4)
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=1;
        CtrlVar.Restart=1;
        CtrlVar.InfoLevelNonLinIt=1;
        UserVar.ReadSlipperinessFromFile=1;
        UserVar.ReadAGlenEstFromFile=1;
        CtrlVar.AdaptMesh=0;

        if ~CtrlVar.Restart
            CtrlVar.ReadInitialMesh=1; CtrlVar.ReadInitialMeshFileName="AntarcticaMUAwith54kElements";
        end

        CtrlVar.TotalNumberOfForwardRunSteps=2;
        CtrlVar.TotalTime=100;
        CtrlVar.dt=0.0001;
        CtrlVar.DefineOutputsDt=0.1;  % time interval between calls to DefineOutputs

        CtrlVar.AdaptMesh=1;
        CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';

        CtrlVar.MeshAdapt.GLrange=...
            [25000 5000 ; ...
            5000 500 ];


        %         CtrlVar.ThicknessConstraints=0;
        %         CtrlVar.ResetThicknessToMinThickness=1;

    case 'Forward-Diagnostic'

        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=0;
        CtrlVar.Restart=0;
        CtrlVar.InfoLevelNonLinIt=1;

        UserVar.ReadSlipperinessFromFile=1;
        UserVar.ReadAGlenEstFromFile=1;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        CtrlVar.ReadInitialMesh=1; CtrlVar.ReadInitialMeshFileName="AntarcticaMUAwith54kElements";

    case 'TestingMeshOptions'


        CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
        CtrlVar.InverseRun=0;
        CtrlVar.Restart=0;
        CtrlVar.ReadInitialMesh=0;
        UserVar.ReadSlipperinessFromFile=1;
        UserVar.ReadAGlenEstFromFile=1;
        CtrlVar.AdaptMesh=1;
        CtrlVar.AdaptMeshInitial=1  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshRunStepInterval)~=0.
        CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
        CtrlVar.AdaptMeshMaxIterations=10;
        % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
        CtrlVar.InfoLevelAdaptiveMeshing=100;

        % Use explicit option when creating the initial mesh and base that mesh on features that you do not expect to change too much during a
        % transient run
        CtrlVar.MeshRefinementMethod='explicit:global';

        % One you have a good initial mesh, switch to local mesh refinement during a transient run, and add here aspects of the run you expect
        % to change during the run, for example the grounding line position.  Use as an inital mesh, the one obtained using the initial global
        % remeshing excercise.
        %CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';
        %CtrlVar.MeshAdapt.GLrange=[40000 10000; 10000 5000 ; 5000 1000];
end



CtrlVar.time=0;


%% Sliding law
% CtrlVar.MustBe.SlidingLaw=["Weertman","Budd","Tsai","Coulomb","Cornford","Umbi","W","W-N0","minCW-N0","C","rpCW-N0","rCW-N0"]  ;

CtrlVar.SlidingLaw="Cornford" ;  CtrlVar.NRitmax=150;       %  With sliding laws that include Coulomb behaviour, convergence might be slow and more iterations needed
CtrlVar.SlidingLaw="Weertman" ;  CtrlVar.NRitmax=50;


%% Ploting
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=true;



%% Meshing

CtrlVar.TriNodes=3 ;

factor=2;
CtrlVar.MeshSize=factor*50e3;
CtrlVar.MeshSizeMax=150e3;   % reasonable number for a quick calculation on the labtop is 40e3
CtrlVar.MeshSizeMin=factor*1000;

% These are used in the DefineDesiredEleSize
UserVar.MeshSizeIceShelves=factor*10e3;
UserVar.MeshSizeFastFlow=10e3;
UserVar.DistanceBetweenPointsAlongBoundary=20e3; % used when creating MeshBoundaryCoordinates

CtrlVar.MaxNumberOfElements=1.2e6;

MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForAntarctica(UserVar,CtrlVar);


%% Output Filenames and related options

if CtrlVar.InverseRun
    CtrlVar.Experiment="Antarctica-Inverse-"...
        +CtrlVar.ReadInitialMeshFileName...
        +CtrlVar.Inverse.InvertFor...
        +CtrlVar.Inverse.MinimisationMethod...
        +"-"+CtrlVar.Inverse.AdjointGradientPreMultiplier...
        +CtrlVar.Inverse.DataMisfit.GradientCalculation...
        +CtrlVar.Inverse.Hessian...
        +"-"+CtrlVar.SlidingLaw...
        +"-"+num2str(CtrlVar.DevelopmentVersion);
else
    CtrlVar.Experiment="Antarctica-Forward"...
        +CtrlVar.ReadInitialMeshFileName;

end

CtrlVar.Experiment=replace(CtrlVar.Experiment," ","-");
CtrlVar.Experiment=replace(CtrlVar.Experiment,".","k");


CtrlVar.NameOfRestartFiletoWrite=CtrlVar.Experiment+"-ForwardRestartFile.mat";
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;

PreString="-panAntarctic-m3-n3-"  ;
[InverseRestartFile,InverseCFile,InverseAFile,InversePriorsFile]=CreateFilenamesForInverseRunOuputs(PreString,CtrlVar,Nele,Nnodes) ;

CtrlVar.Inverse.NameOfRestartOutputFile=InverseRestartFile;
CtrlVar.Inverse.NameOfRestartInputFile=InverseRestartFile ;


CtrlVar.NameOfFileForSavingSlipperinessEstimate=InverseCFile ;
CtrlVar.NameOfFileForSavingAGlenEstimate=InverseAFile ;


UserVar.CFileName="NoFile" ; % Cest-AntarcticaMUAwith54kElements-Weertman-n3-m3-Cga0-Cgs1000-Aga0-Ags1000-I";
UserVar.AGlenFileName="NoFile" ; % Aest-AntarcticaMUAwith54kElements-Weertman-n3-m3-Cga0-Cgs1000-Aga0-Ags1000-I";


UserVar.OutputFile="UserOutputFile.mat";
CtrlVar.SaveAdaptMeshFileName='MeshFileAdaptTest';    %  file name for saving adapt mesh. If left empty, no file is written



end
