

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%%
%
%   
%
% You will need to make sure that UaSource is in the MATLAB path.
%
% You can set the path by starting the 'pathtool' from the command line.
%
% 
% Alternatively, you can do this programmatically, for example:
%
%   addpath(genpath("../UaSource"))   [ret]
%
% You can check if Ua is on the path by seeing if MATLAB finds the command
% Ua. Use, for example:
%
%   which Ua  [ret]
%
%
%%

CtrlVar.TimeDependentRun=1; 
CtrlVar.Experiment='MyFlowLineMountainExperiment';
CtrlVar.FlowApproximation="SSHEET" ; % CtrlVar.NLtol=1e-15 ; 
%CtrlVar.uvh.SUPG.tau="tau2" ; % {'tau1','tau2','taus','taut'}  
%CtrlVar.SUPG.beta0=1; 

CtrlVar.Restart=0;   
CtrlVar.WriteRestartFile=0;

CtrlVar.time=0 ; 
CtrlVar.dt=1; 
CtrlVar.TotalNumberOfForwardRunSteps=Inf;  
CtrlVar.TotalTime=500;

% automated time stepping
CtrlVar.AdaptiveTimeStepping=1 ; CtrlVar.ATSdtMax=10; 
CtrlVar.DefineOutputsDt=5; 

% Flow approximation.
% SSHEET is what in the litterature is often referred to as SIA
% CtrlVar.FlowApproximation='SSHEET';  CtrlVar.NLtol=1e-15 ; % 

% set mininum allowed ice thickness
CtrlVar.ThickMin=1;                
CtrlVar.ResetThicknessToMinThickness=0;  
CtrlVar.ThicknessConstraints=1;  
%% Mesh domain and resolution 
xd=70e3; xu=-70e3 ; yl=1e3 ; yr=-1e3;
MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];
CtrlVar.MeshSize=1000;

%%
CtrlVar.NameOfRestartFiletoRead='Ua2D_Restartfile.mat';
CtrlVar.NameOfRestartFiletoWrite='Ua2D_Restartfile.mat';

end
