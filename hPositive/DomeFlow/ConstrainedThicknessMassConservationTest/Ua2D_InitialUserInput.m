
function [UserVar,CtrlVar,time,dt,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(CtrlVar)

%%
%
% The idea here is to define a Gaussian shaped ice dome on a flat plane and
% allow the ice to flow outwards and see if mass is conserved. Surface mass
% balance is zero.  (August 2016).
%
%

UserVar=[];

CtrlVar.doPrognostic=1 ;
CtrlVar.doDiagnostic=0  ;
CtrlVar.doInverseStep=0;

CtrlVar.AdaptiveTimeStepping=1;
CtrlVar.TotalNumberOfForwardRunSteps=100;            % maximum number of time steps
CtrlVar.TotalTime=1e10;          % maximum model time
time=0 ; 
dt=0.1; 

CtrlVar.Experiment='CTMCT';

CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1; 

xd=100e3; xu=-100e3 ; yl=100e3 ; yr=-100e3;
MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);

CtrlVar.ThickMin=0;                      % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thicknes values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method

CtrlVar.ThicknessBarrier=0;              %
CtrlVar.ThicknessBarrierThicknessScale=1;
CtrlVar.ThicknessBarrierMinThickMultiplier=1;
CtrlVar.ThicknessBarrierAccumulation=0.01;
CtrlVar.ThicknessConstraintsInfoLevel=10 ;

CtrlVar.TriNodes=3;
CtrlVar.MeshSize=5e3;
CtrlVar.MeshSizeMin=0.001*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;


%%

CtrlVar.PlotXYscale=1000; CtrlVar.doPlots=0;
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=0; CtrlVar.PlotBCs=1; CtrlVar.PlotNodes=1;

end
