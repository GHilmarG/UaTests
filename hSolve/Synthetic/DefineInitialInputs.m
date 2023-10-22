


function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)



CtrlVar.hEq.Method="(h-hmeas) P (h-hmeas) / 2 + (h-hprior) Q (h-hprior) / 2 +  (K h - b) M (K h - b) / 2" ;


%% MeshBoundary

MeshBoundaryCoordinates=[]; % I'm starting from a restart run here, so I don't need to define the mesh


%% Define parameters entering the precision matrices

CtrlVar.hEq.gha=0;
CtrlVar.hEq.ghs=0;
CtrlVar.hEq.gFa=1;


%%

% Using cross diffusion is very effective as "smoothing" the solution and results insensitive to the exact diffusion coefficient value

CtrlVar.SUPG.beta0=1;

CtrlVar.hEq.kIso=1e2;
CtrlVar.hEq.kAlong=1e4;
CtrlVar.hEq.kCross=1e4;




end


