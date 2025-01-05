%% Test using a simple two notch geometry


warning('off','MATLAB:triangulation:PtsNotInTriWarnId')
warning('off','MATLAB:decomposition:SaveNotSupported')
warning('off','MATLAB:decomposition:genericError')
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:SaveNotSupported');




%%  Define geometry and key input variables needed to solve for uv
UserVar=[];
UserVar.Experiment="ice shelf single notch"; 
CtrlVar=Ua2D_DefaultParameters(); 

CtrlVar.Parallel.uvhAssembly.spmd.isOn=true ;        % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.uvAssembly.spmd.isOn=true;          % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.BuildWorkers=true;
CtrlVar.Parallel.isTest=false;                        % Runs both with and without parallel approach, and prints out some information on relative performance. 

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
CtrlVar.MeshSize=5e3;  CtrlVar.MeshSize=1e3;  CtrlVar.MeshSize=0.5e3;
CtrlVar.MeshSizeMin=0.1e3 ; 
CtrlVar.TriNodes=3;


CtrlVar.PhaseFieldFracture.Video=true;


xmin=0e3 ; xmax=100e3 ; ymin=-100e3 ; ymax=100e3;

MeshBoundaryCoordinates=[xmin ymin ; xmax ymin ; xmax ymax ; xmin ymax];


MeshBoundaryCoordinates=[xmin (ymin+ymax)/2 ; xmax ymin ; xmax ymax ];

xl=50e3 ; xr=70e3 ; yd=-30e3 ; yu=30e3; 

MeshBoundaryCoordinates=[xmin (ymin+ymax)/2 ; xmax ymax ; xmax ymin ; xmin (ymin+ymax)/2  ; ...
                         xl 0 ; xl  yu ;  xr yu   ; xr yd ; xl yd ; ... 
                         xl 0 ; xl yd ;  xr yd  ; xr  yu ; xl yu  ; ...
                         xl 0 ];

                         

CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
% Now generate mesh (When using Úa this is done internally, no such call
% then needed).


[UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=true;
FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA); drawnow




% Calculate initial phi for undamaged ice, and do some local mesh refinement around initial crack


F=DefineF(UserVar,CtrlVar,MUA) ;


CtrlVar.PhaseFieldFracture.Gc=1e5;
% CtrlVar.PhaseFieldFracture.Gc=1e4;
CtrlVar.PhaseFieldFracture.l=5e3;
CtrlVar.PhaseFieldFracture.k=1e-15; % regularisation parameter
% CtrlVar.MeshSizeMin=CtrlVar.PhaseFieldFracture.l/4;

CtrlVar.PhaseFieldFracture.MaxMeshRefinements=5;   % max number of mesh refinements per phi solve where phi is not updated
CtrlVar.PhaseFieldFracture.MaxUpdates=15;           % number of updates in phi and Psi

F.Psi=zeros(MUA.Nnodes,1) ;

F.phi=zeros(MUA.Nnodes,1) ;  % phi=0, undamaged,
% phi=1, fully damaged

CtrlVar.BCs="-uv-" ;
BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs) ;
lm=UaLagrangeVariables ;

%%

Inod=F.x >= xl & F.x <= xr & F.y >= yd & F.y <= yu; 
%Inod=F.x > xl & F.x < xr & F.y > yd & F.y < yu; 
F.phi(Inod)=1; 

CompareDamageWithDeactivativation(UserVar,RunInfo,CtrlVar,MUA,BCs,F) ; 

                             
%%


[MUA,BCs,BCsphi,F]=PhaseFieldFractureSolver(UserVar,RunInfo,CtrlVar,MUA,F,BCs) ;




[PsiPlot,e,eInt]=StrainRateEnergy(CtrlVar,MUA,F,F.AGlen0) ; % just here for plotting purposes
PlotTitle="";
CtrlVar.PhaseFieldFracture.iphiUpdate=nan; 
PFFPlots(UserVar,CtrlVar,MUA,F,BCs,BCsphi,F.phi,F.Psi,e,PlotTitle) ;



%% check if deactivating "fully" damaged elements gives about the same solution

% CompareDamageWithDeactivativation(UserVar,RunInfo,CtrlVar,MUA,BCs,F) ; 
