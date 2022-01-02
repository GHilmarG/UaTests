%% Create scattered A and C interpolants


load('C-EstimateWeertman.mat');
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman.mat','FC')

load('AGlen-Estimate.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman.mat','FA')

%%

load('C-Estimate.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Umbi.mat','FC')

load('AGlen-Estimate.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Umbi.mat','FA')

%%
clearvars


load('InvEstimate-CWeertman-PIG-TWG10km.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman-PIG-TWG-10km.mat','FC')

load('InvEstimate-AWeertman-PIG-TWG10km.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman-PIG-TWG-10km.mat','FA')


load('InvEstimate-CWeertman-PIG-TWG20km.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman-PIG-TWG-20km.mat','FC')

load('InvEstimate-AWeertman-PIG-TWG20km.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman-PIG-TWG-20km.mat','FA')


load('InvEstimate-CWeertman-PIG-TWG30km.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman-PIG-TWG-30km.mat','FC')

load('InvEstimate-AWeertman-PIG-TWG30km.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman-PIG-TWG-30km.mat','FA')

load('InvEstimate-CWeertman-PIG-TWG5km.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman-PIG-TWG-5km.mat','FC')

load('InvEstimate-AWeertman-PIG-TWG5km.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman-PIG-TWG-5km.mat','FA')


%%
figure ; PlotMeshScalarVariable(CtrlVarInRestartFile,MUA,log10(AGlen));
hold on ; PlotGroundingLines(CtrlVarInRestartFile,"Bedmachine",[],[],[],[],"r");
hold on ; PlotMuaBoundary(CtrlVarInRestartFile,MUA) ;
hold on ; PlotMuaBoundary(CtrlVarInRestartFile,MUA) ;
