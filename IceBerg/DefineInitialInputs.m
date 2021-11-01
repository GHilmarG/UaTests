
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%%


CtrlVar.Experiment='IceBerg';
CtrlVar.IncludeMelangeModelPhysics=1;

CtrlVar.doplots=1; CtrlVar.doRemeshPlots=1;

Length=10e3 ; Width=10e3;
xu=-Length/2 ;
xd=Length/2;
yl=Width/2 ;
yr=-Width/2;

MeshBoundaryCoordinates=[xu yl ; xd yl ; xd yr ; xu yr];


%% Types of runs
CtrlVar.TimeDependentRun=1 ;
CtrlVar.dt=0.1;
CtrlVar.TotalNumberOfForwardRunSteps=200;
CtrlVar.TotalTime=10;          % maximum model time
CtrlVar.time=0; 
CtrlVar.ATSdtMax=10.0;  % Timestep maximum is 10 years

CtrlVar.Restart=0; 


%% Mesh generation and remeshing parameters

CtrlVar.meshgeneration=1; 
CtrlVar.TriNodes=3 ;  % {3|6|10}  number of nodes per element
CtrlVar.MeshSize=Width/10;
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.MaxNumberOfElements=5000;



%%


%% plotting
CtrlVar.PlotXYscale=1000;
CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
CtrlVar.doplots=0;          % if true then plotting during runs by Ua are allowed, set to 0 to suppress all plots

CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.DefineOutputsDt=0.1;


end
