
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


CtrlVar.Experiment='FreeSlip';
CtrlVar.doplots=1; CtrlVar.doRemeshPlots=1;

xd=100e3; xu=-100e3 ; yl=10e3 ; yr=-10e3;
CtrlVar.MeshSize=25e3;


xmarginLeft=xu+CtrlVar.MeshSize:CtrlVar.MeshSize:xd-CtrlVar.MeshSize;
xmarginRight=fliplr(xmarginLeft);
Amp=10e3 ; lambda=200e3;

ymarginLeft=Amp*sin(2*pi*xmarginLeft/lambda)+yl;
ymarginRight=Amp*sin(2*pi*xmarginRight/lambda)+yr;

MeshBoundaryCoordinates=...
    [xu yr ; ...
    xu yl ; ...
    xmarginLeft(:) ymarginLeft(:) ; ...
    xd yl ; ...
    xd yr  ; ...
    xmarginRight(:), ymarginRight(:)];


CtrlVar.OnlyMeshDomainAndThenStop=0;
%% Types of runs

CtrlVar.time=0 ; 
CtrlVar.dt=0.1; 
CtrlVar.TotalNumberOfForwardRunSteps=1;

CtrlVar.FlowApproximation='SSTREAM' ;  % 'SSTREAM'|'SSHEET'|'Hybrid'
CtrlVar.ThicknessConstraints=0;

%% Solver
CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
CtrlVar.InfoLevelNonLinIt=1000;
CtrlVar.LineSeachAllowedToUseExtrapolation=1;

%% Restart
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;


%% Mesh generation and remeshing parameters

CtrlVar.TriNodes=6;
CtrlVar.MeshSizeMin=0.05*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.MaxNumberOfElements=5000;


%% plotting

CtrlVar.PlotLabels=1 ; CtrlVar.PlotMesh=0; CtrlVar.PlotBCs=1;
CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes



end
