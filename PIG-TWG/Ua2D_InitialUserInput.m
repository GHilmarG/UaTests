function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


if isempty(UserVar)
    gs=1 ;   % do 1, 10 , 100, 1000 , 10e3 ; 100e3 ; 1e6  ; 10e6
    ga=1;
elseif isnumeric(UserVar)
    fprintf(' On input UserVar=%f \n',UserVar)
    gs=UserVar ; 
    ga=1;
end

clearvars UserVar

CtrlVar.kH=100;
CtrlVar.NLtol=1e-20;

UserVar.RunType="Inversion";
%UserVar.RunType='TestingMeshOptions';
UserVar.InterpolantsDirectory="../Interpolants/PIG-TWG";


CtrlVar.Experiment=UserVar.RunType;

if contains(UserVar.RunType,"Inversion")

        UserVar.RunType=UserVar.RunType+CtrlVar.Inverse.Measurements;
        CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
        CtrlVar.InverseRun=1;
        CtrlVar.Restart=0;
        CtrlVar.ReadInitialMesh=1;
        CtrlVar.AdaptMesh=0;
        UserVar.Slipperiness.ReadFromFile=0;  
        UserVar.AGlen.ReadFromFile=0;
        
elseif contains(UserVar.RunType,"TestingMeshOptions")
    
        
        CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
        CtrlVar.InverseRun=0;
        CtrlVar.Restart=0;
        CtrlVar.ReadInitialMesh=0;
        CtrlVar.AdaptMesh=1;
        UserVar.Slipperiness.ReadFromFile=1;
        UserVar.AGlen.ReadFromFile=1;
else
    error('hm?')
end

CtrlVar.dt=0.01;
CtrlVar.time=0;
CtrlVar.ResetTimeStep=0; CtrlVar.TotalNumberOfForwardRunSteps=1; CtrlVar.TotalTime=10;
%

CtrlVar.TriNodes=3 ;
CtrlVar.ATStimeStepTarget=0.1; CtrlVar.ATSTargetIterations=4;

if CtrlVar.InverseRun
    CtrlVar.InfoLevelNonLinIt=0; CtrlVar.InfoLevel=0;
else
    CtrlVar.InfoLevelNonLinIt=1; CtrlVar.InfoLevel=1;
end


%%
CtrlVar.doplots=1;
CtrlVar.PlotOceanLakeNodes=0;
CtrlVar.PlotMesh=0;  CtrlVar.PlotBCs=1 ;
%% Meshing 

CtrlVar.GmshMeshingAlgorithm=8; 
CtrlVar.MeshSizeMax=20e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;
CtrlVar.MeshSizeFastFlow=CtrlVar.MeshSizeMax/5;
CtrlVar.MeshSizeIceShelves=CtrlVar.MeshSizeMax/10;
CtrlVar.MeshSizeBoundary=CtrlVar.MeshSize;

CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';   
%CtrlVar.MeshRefinementMethod='explicit:global';
CtrlVar.InfoLevelAdaptiveMeshing=3;                                            
CtrlVar.AdaptMeshInitial=1  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshInterval)~=0.
CtrlVar.AdaptMeshAndThenStop=1;    % if true, then mesh will be adapted but no further calculations performed
                                   % useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)
CtrlVar.AdaptMeshMaxIterations=10;
CtrlVar.SaveAdaptMeshFileName='MeshFileAdapt';    %  file name for saving adapt mesh. If left empty, no file is written
CtrlVar.AdaptMeshInterval=1 ; % remesh whenever mod(Itime,CtrlVar.AdaptMeshInterval)==0
CtrlVar.doAdaptMeshPlots=1; 


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
MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(CtrlVar);

CtrlVar.ReadInitialMeshFileName='PIG-TWG-Mesh.mat';
CtrlVar.SaveInitialMeshFileName='MeshFile.mat';

CtrlVar.OnlyMeshDomainAndThenStop=0; % if true then only meshing is done and no further calculations. Usefull for checking if mesh is reasonable
CtrlVar.MaxNumberOfElements=70e3;


%% plotting
CtrlVar.PlotXYscale=1000;






                                                        
%%  Bounds on C and AGlen
CtrlVar.AGlenmin=1e-10; CtrlVar.AGlenmax=1e-5;
CtrlVar.Cmin=1e-6;  CtrlVar.Cmax=1e20;        
CtrlVar.CisElementBased=0;   
CtrlVar.AGlenisElementBased=0;   
UserVar.Slipperiness.FileName='C-Estimate.mat';
UserVar.AGlen.FileName='AGlen-Estimate.mat';



%% Inverse


CtrlVar.Inverse.Iterations=3;
CtrlVar.Inverse.Measurements="-uv-" ;  
CtrlVar.Inverse.InvertFor="-B-" ; % {'C','logC','AGlen','logAGlen'}


    
% Testing adjoint parameters, start:
CtrlVar.Inverse.TestAdjoint.isTrue=1; % If true then perform a brute force calculation
% of the directional derivative of the objective function.
CtrlVar.Inverse.TestAdjoint.FiniteDifferenceType='fourth-order' ;
CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=1e-5 ;

CtrlVar.Inverse.TestAdjoint.iRange=[2000:2220] ;  % range of nodes/elements over which brute force gradient is to be calculated.
%CtrlVar.Inverse.TestAdjoint.iRange=[2200:2220] ;  % range of nodes/elements over which brute force gradient is to be calculated.
CtrlVar.Inverse.TestAdjoint.iRange=[2200:2205] ;  % range of nodes/elements over which brute force gradient is to be calculated.
% if left empty, values are calculated for every node/element within the mesh.
% If set to for example [1,10,45] values are calculated for these three
% nodes/elements.
% end, testing adjoint parameters.


CtrlVar.Inverse.MinimisationMethod='MatlabOptimization';
%CtrlVar.Inverse.MinimisationMethod='UaOptimization';
CtrlVar.Inverse.GradientUpgradeMethod='ConjGrad' ; %{'SteepestDecent','ConjGrad'}


CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;

CtrlVar.Inverse.DataMisfit.GradientCalculation='Adjoint' ; % {'Adjoint','FixPointC'}
CtrlVar.Inverse.AdjointGradientPreMultiplier='I'; % {'I','M'}


% UaOptimization parameters, start :

CtrlVar.Inverse.InitialLineSearchStepSize=[];
CtrlVar.Inverse.MinimumAbsoluteLineSearchStepSize=1e-20; % minimum step size in backtracking
CtrlVar.Inverse.MinimumRelativelLineSearchStepSize=1e-5; % minimum fractional step size relative to initial step size
CtrlVar.Inverse.MaximumNumberOfLineSeachSteps=50;
% end, UaOptimization parameters

CtrlVar.Inverse.InfoLevel=1;  % Set to 1 to get some basic information, >=2 for additional info on backtrackgin,
                                 % >=100 for further info and plots



                                                    
UserVar.AddDataErrors=0;


CtrlVar.Inverse.Regularize.C.gs=1;
CtrlVar.Inverse.Regularize.C.ga=1;
CtrlVar.Inverse.Regularize.logC.ga=ga;
CtrlVar.Inverse.Regularize.logC.gs=gs ; % 1e6  works well with I

CtrlVar.Inverse.Regularize.AGlen.gs=1;
CtrlVar.Inverse.Regularize.AGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.ga=ga;
CtrlVar.Inverse.Regularize.logAGlen.gs=gs;

CtrlVar.Inverse.Regularize.AGlen.bs=0;
CtrlVar.Inverse.Regularize.AGlen.ba=0;


CtrlVar.Inverse.DataMisfit.HessianEstimate='0'; % {'0','I','MassMatrix'}

CtrlVar.Inverse.DataMisfit.Multiplier=1;
CtrlVar.Inverse.Regularize.Multiplier=1;

CtrlVar.Inverse.DataMisfit.FunctionEvaluation='integral';
CtrlVar.MUA.MassMatrix=1;
CtrlVar.MUA.StiffnessMatrix=1;

%%
CtrlVar.ThicknessConstraints=0;
CtrlVar.ResetThicknessToMinThickness=1;  % change this later on
CtrlVar.ThickMin=1;

%%
filename=sprintf('IR-%s-%s-Nod%i-%s-%s-Cga%i-Cgs%i-Aga%i-Ags%i-%i-%i-%s',...
    UserVar.RunType,...
    CtrlVar.Inverse.MinimisationMethod,...
    CtrlVar.TriNodes,...
    CtrlVar.Inverse.AdjointGradientPreMultiplier,...
    CtrlVar.Inverse.DataMisfit.GradientCalculation,...
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

end
