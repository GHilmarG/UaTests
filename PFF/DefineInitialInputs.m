

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%% UserVar

% Driver 7:
UserVar.Experiment="ice shelf constricted"; 
UserVar.Geometry="constricted";  UserVar.VideoFileName="constricted";


CtrlVar.PhaseFieldFracture.Video=false;

%% Run type
CtrlVar.ForwardTimeIntegration="-phi-" ; 


%% Parallel options
CtrlVar.Parallel.uvhAssembly.spmd.isOn=false;
CtrlVar.Parallel.uvAssembly.spmd.isOn=false;
CtrlVar.Parallel.Distribute=false;
CtrlVar.Parallel.isTest=false;

%% Mesh
CtrlVar.MeshSizeMax=1000e3;
CtrlVar.MeshSizeMin=1e3;
CtrlVar.MeshSize=5e3;
CtrlVar.TriNodes=3;
xmin=-100e3 ; xmax=100e3 ; ymin=-100e3 ; ymax=100e3;
lx=xmax-xmin;
ly=ymax-ymin;
MeshBoundaryCoordinates=[xmin ymin ; xmax ymin ; xmax ymax ;  (xmin+0.55*lx) ymax ; (xmin+0.55*lx) (ymax-0.25*ly) ; (xmin+0.45*lx) (ymax-0.25*ly) ;  (xmin+0.45*lx) ymax ;    xmin ymax];
CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;


%% Plots
CtrlVar.PlotXYscale=1000;

%%  Phase field fracture
CtrlVar.PhaseFieldFracture.Gc=1e5;  
CtrlVar.PhaseFieldFracture.l=10e3;
CtrlVar.PhaseFieldFracture.k=1e-3; % regularization parameter
CtrlVar.PhaseFieldFracture.UpdateRatio=0.5;
CtrlVar.PhaseFieldFracture.MaxMeshRefinements=5;   % max number of mesh refinements per phi solve where phi is not updated 
CtrlVar.PhaseFieldFracture.MaxUpdates=100;           % number of updates in phi and Psi
CtrlVar.PhaseFieldFracture.RiftsAre="-thin ice above inviscid water-"; 
CtrlVar.PhaseFieldFracture.isDefineF=false;



