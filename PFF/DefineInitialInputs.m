

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


iDriver=7 ;

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

    case 1

        UserVar.Experiment="single notch";
        UserVar.Geometry="square";  UserVar.VideoFileName="square";

        UserVar.Geometry="wide quadrilateral" ;  UserVar.VideoFileName="DriverOne-Wide";


    otherwise

        error("Case not found")

end
%%

CtrlVar.PhaseFieldFracture.Video=false;

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



