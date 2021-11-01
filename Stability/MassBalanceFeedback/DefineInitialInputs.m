
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

xd=50e3; xu=-50e3; yl=50e3 ; yr=-50e3;

UserVar.ELA=3500;
UserVar.hStart=10;
UserVar.lambda=1e-1; 
UserVar.Geometry="-1dMountain-" ; "-plane-" ; 
UserVar.Experiment="MB"+UserVar.Geometry; 
UserVar.B0=4000;
UserVar.beta=atan(UserVar.B0/xd) ;

%%




CtrlVar.FlowApproximation='SSTREAM' ;  % any off ['SSTREAM'|'SSHEET'|'Hybrid']  
CtrlVar.Experiment=UserVar.Experiment ;
CtrlVar.Implicituvh=1; 
CtrlVar.ResetThicknessToMinThickness=0;CtrlVar.ThicknessConstraints=1; CtrlVar.ThicknessConstraintsItMax=1  ;
CtrlVar.TimeDependentRun=1 ;  % any of [0|1].  
CtrlVar.time=0 ; 
CtrlVar.dt=0.1; 
CtrlVar.TotalNumberOfForwardRunSteps=inf; 
CtrlVar.TotalTime=25 ; 
CtrlVar.AdaptiveTimeStepping=1 ;
CtrlVar.ATSdtMax=1;  
CtrlVar.ATSdtMin=0.01;  
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;

CtrlVar.theta=0.5;    


MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);

CtrlVar.TriNodes=3;   % [3,6,10]
CtrlVar.MeshSize=10e3;
CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;

%%
CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
CtrlVar.du=1e10;     % tolerance for change in (normalised) speed
CtrlVar.dh=1e10;     % tolerance for change in (normalised) thickness
CtrlVar.dl=100;   
%%


CtrlVar.doplots=1;
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
CtrlVar.UaOutputs='-saveAcc-';

%%
CtrlVar.MassBalanceGeometryFeedback=3; 


end
