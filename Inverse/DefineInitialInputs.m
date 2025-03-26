function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%
% Used primarily to test various inversion options.
%
% 2025, March: A, B, and C inversions all working, and test of adjoint gradients against brute-force difference approach
% showed an excellent agreement (including for B). But as before, the B inversion is not to designed to work across grounding lines. 
%

UserVar.Inverse.Syntdata.GeoPerturbation='Gauss';

if ~isfield(UserVar,'RunType')
    UserVar.RunType='IceStream+IceShelf';   %  either 'IceStream' or  'IceShelf'
    %UserVar.RunType='Channel';   %  either 'IceStream' or  'IceShelf'
    UserVar.RunType='IceStream';   UserVar.Inverse.Syntdata.GeoPerturbation='gauss';
    % UserVar.RunType='IceShelf';   %  either 'IceStream' or  'IceShelf'

    UserVar.Inverse.Syntdata.GeoPerturbation='valley';
    UserVar.RunType='valley';
    UserVar.vShift=1000 ; % UserVar.vShift=-4000 ; % This generates a synthetic valley shaped b geometry
    % For vShift=0 there is no grounding-line within the domain, but it is exactly
    % at the edge.
    % for vShift=-2000 , for example, the grounding line is within the domain

end


UserVar.uError=1;
UserVar.dhdtError=1;

UserVar.Inverse.SynthData.Pert="-C-B-" ; %  {"-B-","-C-","-A-"}
UserVar.Inverse.CreateSyntData=1;  % This field

%%

if UserVar.RunType=="IceStream"
    CtrlVar.alpha=0.01;
else
    CtrlVar.alpha=0.0 ;
end

%%
CtrlVar.doplots=1;
CtrlVar.Plot.Units.xDistance="(km)" ;
CtrlVar.Plot.Units.yDistance="(km)" ;
CtrlVar.Plot.Units.zDistance="(m)" ;

%%
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
CtrlVar.Inverse.Iterations=100;
CtrlVar.Inverse.InvertFor='-B-' ; % {'-C-','-logC-','-AGlen-','-logAGlen-'}
CtrlVar.Inverse.OnlyModifyBedUpstreamOfGL=false ;


CtrlVar.Inverse.DataMisfit.GradientCalculation='Adjoint' ; % {'Adjoint','FixPoint'


CtrlVar.Inverse.InfoLevel=1;  % Set to 1 to get some basic information,
% >=2 for additional info on backtracking,
% >=100 for further info and plots

if CtrlVar.InverseRun
    CtrlVar.InfoLevelNonLinIt=0; CtrlVar.InfoLevel=0;
else
    CtrlVar.InfoLevelNonLinIt=1; CtrlVar.InfoLevel=1;
end


CtrlVar.Inverse.InfoLevel=1;

%% Testing adjoint parameters
CtrlVar.Inverse.TestAdjoint.isTrue=true; % If true then perform a brute force calculation
CtrlVar.TestAdjointFiniteDifferenceType="central-second-order" ;
CtrlVar.TestAdjointFiniteDifferenceType="central-fourth-order" ;
CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=0.001 ;

% CtrlVar.Inverse.TestAdjoint.iRange=[220:250] ;  % range of parameters over which brute force gradient is to be calculated.
% if left empty, values are calculated for every node/element within the mesh.
% If set to for example [1,10,45]
% values are calculated for these
% parameters

%% 

UserVar.AddDataErrors=0;

CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;

CtrlVar.Inverse.Regularize.B.gs=1000;
CtrlVar.Inverse.Regularize.B.ga=0;

CtrlVar.Inverse.Regularize.C.gs=1;
CtrlVar.Inverse.Regularize.C.ga=1;

CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=10;
CtrlVar.Inverse.Regularize.AGlen.gs=1;
CtrlVar.Inverse.Regularize.AGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=10000 ;




CtrlVar.Inverse.DataMisfit.Multiplier=1;
CtrlVar.Inverse.Regularize.Multiplier=1;


%% Mesh generation and re-meshing parameters


CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (i.e the MUA variable) directly from a .mat file
% unless the adaptive meshing option is used, no further meshing is done.
CtrlVar.ReadInitialMeshFileName='AdaptMeshFile10k'; 
CtrlVar.SaveInitialMeshFileName='NewMeshFile.mat';



CtrlVar.MeshSize=10e3;
CtrlVar.MeshSize=50e3;
CtrlVar.MeshSize=25e3;
%CtrlVar.MeshSize=2.5e3;
CtrlVar.MeshSizeMin=0.1*CtrlVar.MeshSize;    % min element size
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;

% CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';
CtrlVar.AdaptMesh=0;
CtrlVar.SaveAdaptMeshFileName='AdaptMeshFile';



%% plotting
CtrlVar.PlotXYscale=1000;
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=0;


%%
filename=sprintf('IR-%s-Nod%i-%s-%s-%s',...
    UserVar.RunType,...
    CtrlVar.TriNodes,...
    CtrlVar.Inverse.AdjointGradientPreMultiplier,...
    CtrlVar.Inverse.DataMisfit.GradientCalculation,...
    CtrlVar.Inverse.InvertFor);

filename="IR-Test.mat" ;


filename=replace(filename,'.','k');
CtrlVar.Inverse.NameOfRestartOutputFile=filename;
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;
%%

CtrlVar.Experiment=join(['I-',CtrlVar.Inverse.AdjointGradientPreMultiplier,'-',num2str(CtrlVar.TriNodes)],'');

end
