



%%
load("PIG-TWG-Diagnostic2025Assembly.mat","CtrlVarInRestartFile","MUA","F")

F2025=F;

load("PIG-TWG-DiagnosticPre2025Assembly.mat","F")

F2024=F; 

du=F2025.ub-F2024.ub;
dv=F2025.vb-F2024.vb;

CtrlVar=CtrlVarInRestartFile;



UaPlots(CtrlVar,MUA,F2025,"-uv-",FigureTitle="2025")

CtrlVar.QuiverSameVelocityScalingsAsBefore=true;

UaPlots(CtrlVar,MUA,F2024,"-uv-",FigureTitle="2024")

CtrlVar.QuiverSameVelocityScalingsAsBefore=false;
UaPlots(CtrlVar,MUA,F2025,[du dv],FigureTitle="Difference")

%%

%%
