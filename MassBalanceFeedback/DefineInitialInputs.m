
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%
%   Testing mass-balance feedback
%   Here the mass balance is a function of elevation/thickness with as=h and h(t0)=10 ; 
%    
%   The surface slope is zero and the thickness so small that there is effectivly no deformation.
%   Therefore dh/dt=a=h and the solution is h=h0 exp(t)
%   Integrating from t=0 to t=1 will give a final thickness of h=10 exp(1) = 27.3
%
% Plot results using:

%%

%%

CtrlVar.UaRunType="-uvh-" ; 


CtrlVar.FlowApproximation='SSTREAM' ;  % any off ['SSTREAM'|'SSHEET'|'Hybrid']  
CtrlVar.Experiment='MB';
CtrlVar.ForwardTimeIntegration="-uvh-" ;

CtrlVar.StartTime=0;
CtrlVar.EndTime=1;

CtrlVar.dt=0.1; 
CtrlVar.TotalNumberOfForwardRunSteps=10; 
CtrlVar.AdaptiveTimeStepping=0 ; CtrlVar.ATSdtMax=0.1;   % maximum time step allowed
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;



xd=50e3; xu=-50e3; yl=50e3 ; yr=-50e3;
MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);

CtrlVar.TriNodes=3;   % [3,6,10]
CtrlVar.MeshSize=10e3;
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;


%%


CtrlVar.doplots=1;
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
CtrlVar.UaOutputs='-saveAcc-';

%%
CtrlVar.MassBalanceGeometryFeedback=3; 


end
