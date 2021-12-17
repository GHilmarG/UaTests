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
load('InvEstimateFA-Weertman-PIG-TWG20km.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman-PIG-TWG-20km.mat','FC')

clearvars
load('AGlen-Estimate.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman-PIG-TWG-20km.mat','FA')