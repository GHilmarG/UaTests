


function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)



CtrlVar.hEq.Method="(h-hmeas) P (h-hmeas) / 2 + (h-hprior) Q (h-hprior) / 2 +  (K h - b) M (K h - b) / 2" ;


%% PIG upstream of grounding line
xByB=[ -1750 -250 ; -1400 -250 ; -1400 0 ; -1750 0 ];
MeshBoundaryCoordinates=1000*xByB;
CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;


CtrlVar.MeshSize=10000;


%%



%% Define parameters entering the precision matrices

CtrlVar.hEq.gha=0;
CtrlVar.hEq.ghs=1e2;
CtrlVar.hEq.gFa=0;


%%

% Using cross diffusion is very effective as "smoothing" the solution and results insensitive to the exact diffusion coefficient value

CtrlVar.SUPG.beta0=1;

CtrlVar.hEq.kIso=1e2;
CtrlVar.hEq.kAlong=1e4;
CtrlVar.hEq.kCross=1e4;




end


