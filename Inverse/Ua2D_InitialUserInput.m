function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)

%
% Klear ; UserVar.RunType='IceStream' ; Ua(UserVar)
%

if ~isfield(UserVar,'RunType')
    UserVar.RunType='IceShelf';   %  either 'IceStream' or  'IceShelf'
end

UserVar.Inverse.SynthData.Pert="-b-" ; %  {"-b-","-C-","-A-"}
UserVar.Inverse.CreateSyntData=1;  % This field 

%%

CtrlVar.doplots=1;

xd=200e3; xu=-200e3 ; yl=200e3 ; yr=-200e3;
MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];
MeshBoundaryCoordinates=flipud(MeshBoundaryCoordinates);
%% Types of runs
CtrlVar.InverseRun=1;  
CtrlVar.TriNodes=3;


%% Restart
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;
CtrlVar.NameOfRestartFiletoRead=['Nod',num2str(CtrlVar.TriNodes),'-iC-Restart.mat'];
CtrlVar.NameOfRestartFiletoWrite=CtrlVar.NameOfRestartFiletoRead;


%% Inverse   -inverse
CtrlVar.Inverse.Measurements='-uv-dhdt-' ;   % {'-dhdt-,'-uv-dhdt-','-dhdt-'}

CtrlVar.Inverse.MinimisationMethod='MatlabOptimization'; % {'MatlabOptimization','UaOptimization'}
%CtrlVar.Inverse.MinimisationMethod='UaOptimization';
CtrlVar.Inverse.Iterations=1;
CtrlVar.Inverse.InvertFor='-B-' ; % {'-C-','-logC-','-AGlen-','-logAGlen-'}



% UaOptimization parameters, start :
CtrlVar.Inverse.GradientUpgradeMethod='conjgrad' ; %{'SteepestDecent','conjgrad'}
CtrlVar.ConjugatedGradientsUpdate='HS'; % (FR|PR|HS|DY)
CtrlVar.Inverse.InitialLineSearchStepSize=[];
CtrlVar.Inverse.MinimumAbsoluteLineSearchStepSize=1e-20; % minimum step size in backtracking
CtrlVar.Inverse.MinimumRelativelLineSearchStepSize=1e-5; % minimum fractional step size relative to initial step size
CtrlVar.Inverse.MaximumNumberOfLineSeachSteps=50;
% end, UaOptimization parameters


CtrlVar.Inverse.InfoLevel=1;  % Set to 1 to get some basic information,
% >=2 for additional info on backtracking,
% >=100 for further info and plots

CtrlVar.InfoLevelNonLinIt=0; CtrlVar.InfoLevel=0;
%CtrlVar.InfoLevelNonLinIt=1; CtrlVar.InfoLevel=1;

CtrlVar.Inverse.DataMisfit.GradientCalculation='Adjoint' ; % {'Adjoint','FixPoint'}
CtrlVar.Inverse.AdjointGradientPreMultiplier='I'; % {'I','M'}

%CtrlVar.EpsZero=1e-16;
% Testing adjoint parameters, start:
CtrlVar.Inverse.TestAdjoint.isTrue=1; % If true then perform a brute force calculation 
                                      % of the dirctional derivative of the objective function.  
CtrlVar.Inverse.TestAdjoint.FiniteDifferenceType='fourth-order' ; % {'first-order','second-order','fourth-order'}
                                                 
CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=1e-6 ;
CtrlVar.Inverse.TestAdjoint.iRange=[200:220] ;  % range of parameters over which brute force gradient is to be calculated.
                                         % if left empty, values are calulated for every node/element within the mesh. 
                                         % If set to for example [1,10,45]
                                         % values are calculated for these
                                         % parameters
                                        
% end, testing adjoint parameters. 
                                                    
UserVar.AddDataErrors=0;

CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;

CtrlVar.Inverse.Regularize.b.gs=1;
CtrlVar.Inverse.Regularize.b.ga=0;

CtrlVar.Inverse.Regularize.C.gs=1;
CtrlVar.Inverse.Regularize.C.ga=1;

CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=10;
CtrlVar.Inverse.Regularize.AGlen.gs=1;
CtrlVar.Inverse.Regularize.AGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1000 ;


CtrlVar.Inverse.DataMisfit.HessianEstimate='0'; % {'0','I','MassMatrix'}

CtrlVar.Inverse.DataMisfit.Multiplier=1;
CtrlVar.Inverse.Regularize.Multiplier=1;


%% Mesh generation and remeshing parameters

CtrlVar.meshgeneration=1;
CtrlVar.GmshMeshingAlgorithm=8;    % see gmsh manual
% 1=MeshAdapt
% 2=Automatic
% 5=Delaunay
% 6=Frontal
% 7=bamg
% 8=DelQuad (experimental)

CtrlVar.ReadInitialMesh=1;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
% unless the adaptive meshing option is used, no further meshing is done.

if CtrlVar.Inverse.TestAdjoint.isTrue
    CtrlVar.ReadInitialMeshFileName='UniformMesh';
else
    CtrlVar.ReadInitialMeshFileName='AdaptMeshFile10k';
end

CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';



CtrlVar.MeshSize=10e3;
CtrlVar.MeshSize=50e3;
%CtrlVar.MeshSize=20e3;
%CtrlVar.MeshSize=2.5e3;   
CtrlVar.MeshSizeMin=0.1*CtrlVar.MeshSize;    % min element size
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;

CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';
CtrlVar.AdaptMesh=0;
CtrlVar.SaveAdaptMeshFileName='AdaptMeshFile';



%% plotting
CtrlVar.PlotXYscale=1000;
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=0;


%%
filename=sprintf('IR-%s-%s-Nod%i-%s-Cga%f-Cgs%f-Aga%f-Ags%f-%i-%i-%s',...
    UserVar.RunType,...
    CtrlVar.Inverse.MinimisationMethod,...
    CtrlVar.TriNodes,...
    CtrlVar.Inverse.AdjointGradientPreMultiplier,...
    CtrlVar.Inverse.Regularize.logC.ga,...
    CtrlVar.Inverse.Regularize.logC.gs,...
    CtrlVar.Inverse.Regularize.logAGlen.ga,...
    CtrlVar.Inverse.Regularize.logAGlen.gs,...
    CtrlVar.CisElementBased,...
    CtrlVar.AGlenisElementBased,...
    CtrlVar.Inverse.InvertFor);
filename=replace(filename,'.','k');
CtrlVar.Inverse.NameOfRestartOutputFile=filename;
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;
%%

CtrlVar.Experiment=['I-',CtrlVar.Inverse.AdjointGradientPreMultiplier,'-',num2str(CtrlVar.TriNodes)];

end
