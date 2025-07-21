

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%%  Phase field fracture parameters (defaults, might be overwritten below)
CtrlVar.PhaseFieldFracture.Formulation="-elastic-";

if CtrlVar.PhaseFieldFracture.Formulation=="-elastic-"
    CtrlVar.PhaseFieldFracture.Gc=1e15;
    CtrlVar.PhaseFieldFracture.l=5e3;
else
    CtrlVar.PhaseFieldFracture.Gc=1e5;
    CtrlVar.PhaseFieldFracture.l=10e3;
end

CtrlVar.PhaseFieldFracture.k=1e-3; % regularization parameter
CtrlVar.PhaseFieldFracture.UpdateRatio=0.5;
CtrlVar.PhaseFieldFracture.MaxMeshRefinements=5;   % max number of mesh refinements per phi solve where phi is not updated
CtrlVar.PhaseFieldFracture.MaxUpdates=100;           % number of updates in phi and Psi
CtrlVar.PhaseFieldFracture.RiftsAre="-thin ice above inviscid water-";
CtrlVar.PhaseFieldFracture.isDefineF=false;

%%
iDriver=2 ;

switch iDriver


    case 7

        UserVar.Experiment="ice shelf constricted";
        UserVar.Geometry="constricted";  UserVar.VideoFileName="constricted";

    case 6

        UserVar.Experiment="ice shelf stream flow";
        CtrlVar.BCs="-uv-" ;

    case 5

        DriverFivePFF(); 

        return
        %% driver 5
        %
        % This is an interesting case regarding the comparison between density,
        % and/or thickness reductions, and element deactivation. This dose not use
        % the phase field solver, just the normal uv diagnostic solver. Run this
        % example directly as "DriverFive"

    case 4

        DriverFourPFF();
        return
        %
        % also a uv experiment, run directly
       
    case 3

        UserVar.Experiment="ice shelf single notch";
        UserVar.TestCase="PFF";
        CtrlVar.BCs="-uv-" ;
       
    case 2

        UserVar.Experiment="double notch";

        % good:
        CtrlVar.PhaseFieldFracture.Gc=1e15;
        CtrlVar.PhaseFieldFracture.l=1e3;
        
        CtrlVar.PhaseFieldFracture.MaxMeshRefinements=25; 

    case 1

        UserVar.Experiment="single notch";
        UserVar.Geometry="square";  UserVar.VideoFileName="square";

        UserVar.Geometry="wide quadrilateral" ;  
        UserVar.VideoFileName="DriverOne-Wide";


    otherwise

        error("Case not found")

end
%%



%% Run type
CtrlVar.ForwardTimeIntegration="-phi-" ;


%% Parallel options
CtrlVar.Parallel.uvhAssembly.spmd.isOn=false;
CtrlVar.Parallel.uvAssembly.spmd.isOn=false;
CtrlVar.Parallel.Distribute=false;
CtrlVar.Parallel.isTest=false;

%% Mesh

[CtrlVar,MeshBoundaryCoordinates]=CreateMeshBoundaryCoordinates(UserVar,CtrlVar);

CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;

CtrlVar.MeshSize= 2*CtrlVar.PhaseFieldFracture.l ;                       % over-all desired element size (however if gmsh is used without adaptive meshing
                                             % only CtrlVar.MeshSizeMin and CtrlVar.MeshSizeMax are used)
                                             % 
CtrlVar.MeshSizeMin=0.1*CtrlVar.MeshSize;    % min element size
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;        % max element size

%% Plots
CtrlVar.PlotXYscale=1000;


%% Video

 CtrlVar.PhaseFieldFracture.Video=false; 




