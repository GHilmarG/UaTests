


function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)



CtrlVar.hEq.Method="(h-hmeas) P (h-hmeas) / 2 + (h-hprior) Q (h-hprior) / 2 +  (K h - b) M (K h - b) / 2" ;


%% MeshBoundary

MeshBoundaryCoordinates=[]; % I'm starting from a restart run here, so I don't need to define the mesh


%% Define parameters entering the precision matrices

CtrlVar.hEq.gha=0;   % Amplitude regularisation for ice thickness, h
CtrlVar.hEq.ghs=0;   % Slope regularisation for ice thickness, h
CtrlVar.hEq.gFa=1;   % Weighting for forward model. 0 implies forward model is not used


%%

% Using cross diffusion is very effective as "smoothing" the solution and results insensitive to the exact diffusion coefficient value

CtrlVar.SUPG.beta0=1;

CtrlVar.hEq.kIso=0*1e2;
CtrlVar.hEq.kAlong=0*1e4;
CtrlVar.hEq.kCross=0*1e4;

%% Add Data Errors?

UserVar.SurfaceMassBalanceErrorAmplitude=0 ; 
UserVar.VelocityErrorAmplitude=1 ; 

UserVar.VelocitySmoothingScale=1000;


end


