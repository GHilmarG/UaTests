

%% Test using a simple single notch geometry


warning('off','MATLAB:triangulation:PtsNotInTriWarnId')
warning('off','MATLAB:decomposition:SaveNotSupported')
warning('off','MATLAB:decomposition:genericError')
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:SaveNotSupported');




%%  Define geometry and key input variables needed to solve for uv
UserVar=[];
UserVar.Experiment="ice shelf constricted"; 
UserVar.Geometry="constricted";  UserVar.VideoFileName="constricted";
CtrlVar=Ua2D_DefaultParameters(); 

CtrlVar.Parallel.uvhAssembly.spmd.isOn=true ;        % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.uvAssembly.spmd.isOn=true;          % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.BuildWorkers=true;
CtrlVar.Parallel.isTest=false;                        % Runs both with and without parallel approach, and prints out some information on relative performance. 

CtrlVar.PhaseFieldFracture.Video=true;

RunInfo=UaRunInfo;
BCs=BoundaryConditions;

CtrlVar.uvDesiredWorkAndForceTolerances=[inf inf];
CtrlVar.uvDesiredWorkOrForceTolerances=[1e-15 1e-10];
CtrlVar.uvExitBackTrackingStepLength=1e-4;
CtrlVar.uvAcceptableWorkAndForceTolerances=[inf 1e-6];
CtrlVar.uvAcceptableWorkOrForceTolerances=[1 1e-8];
CtrlVar.PlotXYscale=1000;
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
% Note; When creating this mesh using Úa, only the following
% three lines are required in the Ua2D_InitialUserInput.m
CtrlVar.MeshSizeMax=1000e3;
CtrlVar.MeshSizeMin=1e3;
CtrlVar.MeshSize=5e3;
CtrlVar.TriNodes=3;
xmin=-100e3 ; xmax=100e3 ; ymin=-100e3 ; ymax=100e3;


lx=xmax-xmin;
ly=ymax-ymin;


MeshBoundaryCoordinates=[xmin ymin ; xmax ymin ; xmax ymax ;  (xmin+0.55*lx) ymax ; (xmin+0.55*lx) (ymax-0.25*ly) ; (xmin+0.45*lx) (ymax-0.25*ly) ;  (xmin+0.45*lx) ymax ;    xmin ymax];

CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
% Now generate mesh (When using Úa this is done internally, no such call
% then needed).


[UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA); drawnow


% Calculate initial phi for undamaged ice, and do some local mesh refinement around initial crack


F=DefineF(UserVar,CtrlVar,MUA) ;



CtrlVar.PhaseFieldFracture.Gc=1e5;  
CtrlVar.PhaseFieldFracture.l=10e3;
CtrlVar.PhaseFieldFracture.k=1e-3; % regularization parameter
CtrlVar.PhaseFieldFracture.UpdateRatio=0.5;
CtrlVar.PhaseFieldFracture.MaxMeshRefinements=5;   % max number of mesh refinements per phi solve where phi is not updated 
CtrlVar.PhaseFieldFracture.MaxUpdates=100;           % number of updates in phi and Psi
CtrlVar.PhaseFieldFracture.RiftsAre="-thin ice above inviscid water-"; 
F.Psi=zeros(MUA.Nnodes,1) ; 

F.phi=zeros(MUA.Nnodes,1) ;  % phi=0, undamaged,
                             % phi=1, fully damaged



[MUA,BCs,BCsphi,F]=PhaseFieldFractureSolver(UserVar,RunInfo,CtrlVar,MUA,F,BCs) ;





%% check if deactivating "fully" damaged elements gives about the same solution

% CompareDamageWithDeactivativation(UserVar,RunInfo,CtrlVar,MUA,BCs,F) ; 





%%