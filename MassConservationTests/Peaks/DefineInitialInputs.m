function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%%
%
% Testing mass conservation.
%
% sGaussPeak and sDeltaPeak are for flat bed and perturbations in surface (s). Here, excellent conservation of mass is
% observed.
%
%
% BDeltaPeak creates as delta bedrock (B) perturbation resulting in a nunatak. Here min thickness needs to be enforced, and
% this does understandably results in slight violation of mass conservation .
%
%%

if isempty(UserVar) || ~isfield(UserVar,"TestCase")
    UserVar.TestCase="sGaussPeak";
    UserVar.TestCase="sDeltaPeak";
    % UserVar.TestCase="BDeltaPeak";  % This e
end

CtrlVar.Experiment=UserVar.TestCase;


CtrlVar.TimeDependentRun=1 ;  % either [0|1].  
CtrlVar.time=0 ; 
CtrlVar.dt=0.1; 
CtrlVar.TotalTime=1;
CtrlVar.TotalNumberOfForwardRunSteps=inf; 
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1; CtrlVar.WriteRestartFileInterval=10;

xd=100e3; xu=-100e3 ; yl=100e3 ; yr=-100e3;
MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];

CtrlVar.ThickMin=0.001;                   % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method



CtrlVar.TriNodes=3;
CtrlVar.MeshSize=xd/20; 
%CtrlVar.MeshSize=2*xd/3; 

CtrlVar.MeshSizeMin=0.001*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;



CtrlVar.AdaptiveTimeStepping=0;


%%

CtrlVar.CompareWithAnalyticalSolutions=0;
CtrlVar.CompareResultsWithPreviouslyObtainedResults=0;


CtrlVar.PlotXYscale=1000;


%%

CtrlVar.Parallel.uvhAssembly.spmd.isOn=true ;        % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.uvAssembly.spmd.isOn=true;          % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.isTest=false;                        % Runs both with and without parallel approach, and prints out some information on relative performance. 
% CtrlVar.TriNodes=10;  CtrlVar.MeshSize=xd/50; 


end
