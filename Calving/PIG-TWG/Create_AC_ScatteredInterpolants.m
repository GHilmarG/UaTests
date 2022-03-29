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



load("InvA-Weertman-Ca1-Cs100000-Aa1-As100000-10km") ;
FA=scatteredInterpolant(xA,yA,AGlen);  
save("FA-Weertman-Ca1-Cs100000-Aa1-As100000-10km.mat") ;



load("InvC-Weertman-Ca1-Cs100000-Aa1-As100000-10km") ;
FC=scatteredInterpolant(xC,yC,C);  
save("FC-Weertman-Ca1-Cs100000-Aa1-As100000-10km.mat") ;

%%

Klear

load("InvA-Weertman-Ca1-Cs100000-Aa1-As100000-10km") ;
load("InvA-Weertman-Ca1-Cs1000-Aa1-As1000-10km") ;


FindOrCreateFigure("A") ;
PlotMeshScalarVariable(CtrlVarInRestartFile,MUA,log10(AGlen));
hold on ; PlotGroundingLines(CtrlVarInRestartFile,"Bedmachine",[],[],[],[],"r");
hold on ; PlotMuaBoundary(CtrlVarInRestartFile,MUA) ;
hold on ; PlotMuaBoundary(CtrlVarInRestartFile,MUA) ;


Box=[ -1616.3      -1491.8      -530.00      -395.07]*1000;
F.x=MUA.coordinates(:,1); F.y=MUA.coordinates(:,2); 

In=IsInBox(Box,F.x,F.y) ;
AminTWIS=AGlenVersusTemp(-20) ;
I= AGlen < AminTWIS & In ;
AGlen(I)=AminTWIS;

FindOrCreateFigure("A lim") ;
PlotMeshScalarVariable(CtrlVarInRestartFile,MUA,log10(AGlen));
hold on ; PlotGroundingLines(CtrlVarInRestartFile,"Bedmachine",[],[],[],[],"r");
hold on ; PlotMuaBoundary(CtrlVarInRestartFile,MUA) ;
hold on ; PlotMuaBoundary(CtrlVarInRestartFile,MUA) ;


