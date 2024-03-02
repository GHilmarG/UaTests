function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


UserVar.TestCase="sGaussPeak";
UserVar.TestCase="sDeltaPeak";
UserVar.TestCase="BDeltaPeak";

CtrlVar.Experiment=UserVar.TestCase;


CtrlVar.TimeDependentRun=1 ;  % either [0|1].  
CtrlVar.time=0 ; 
CtrlVar.dt=0.1; 
CtrlVar.TotalTime=1;
CtrlVar.TotalNumberOfForwardRunSteps=inf; 
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1; CtrlVar.WriteRestartFileInterval=10;

xd=100e3; xu=-100e3 ; yl=100e3 ; yr=-100e3;
MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];

CtrlVar.ThickMin=0;                      % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thicknes values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method


CtrlVar.TriNodes=3;
CtrlVar.MeshSize=5e3;
CtrlVar.MeshSizeMin=0.001*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;



CtrlVar.AdaptiveTimeStepping=0;


%%

CtrlVar.CompareWithAnalyticalSolutions=0;
CtrlVar.CompareResultsWithPreviouslyObtainedResults=0;


CtrlVar.PlotXYscale=1000;






end
