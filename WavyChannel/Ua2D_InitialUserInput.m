
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)


UserVar.L=20e3 ; 
UserVar.lambda=20e3 ; 
UserVar.h=1000 ; 
UserVar.ab=0 ; 
UserVar.as=10 ; 
UserVar.alpha=0.01 ; 

CtrlVar.Experiment='sin(x)';
CtrlVar.time=0;
CtrlVar.dt=1;
CtrlVar.FlowApproximation='Hybrid' ;  % 'SSTREAM'|'SSHEET'|'Hybrid'
CtrlVar.TimeDependentRun=0;

xd=UserVar.L; xu=0 ; yl=1e3 ; yr=-1e3;
MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';  % these lines are added to the gmsh .geo input file each time such a file is created
CtrlVar.OnlyMeshDomainAndThenStop=0;
%CtrlVar.GmshMeshingAlgorithm=8;  % see gmsh manual
CtrlVar.TriNodes=3;   % [3,6,10]
CtrlVar.MeshSize=0.25e3;
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;

CtrlVar.Restart=0;

%%

CtrlVar.doplots=0;
CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;CtrlVar.PlotNodes=1;
CtrlVar.TransientPlotDt=NaN;   % model time interval between calls to `FE2dTransientPlots.m'

end
