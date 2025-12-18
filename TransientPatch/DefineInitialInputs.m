
function [UserVar,CtrlVar,time,dt,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(CtrlVar)


Experiment='Melting';
CtrlVar.Implicituvh=1;    
CtrlVar.TimeDependentRun=1 ; CtrlVar.AdaptiveTimeStepping=0 ; 
time=0 ; dt=0.01; CtrlVar.TotalNumberOfForwardRunSteps=100; CtrlVar.TotalTime=300 ;
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;

xd=10e3; xu=-10e3 ; yl=10e3 ; yr=-10e3;

CtrlVar.MeshSize=2.5e3;
CtrlVar.MeshSizeMin=0.1*CtrlVar.MeshSize;    % min element size
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;

CtrlVar.TriNodes=10;  
MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);

CtrlVar.PlotXYscale=1000;


CtrlVar.ThickMin=0;

CtrlVar.ThicknessConstraints=1;



end
