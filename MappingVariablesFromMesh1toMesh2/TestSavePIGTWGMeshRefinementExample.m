



%%
load("TestSavePIGTWGMeshRefinementExample","CtrlVar","RunInfo","MUAold","MUAnew","OutsideValues","sOld");
CtrlVar.InfoLevelAdaptiveMeshing=1;

%% Plot region of interest for the old mesh



FindOrCreateFigure("MUAold values") ; 
UaPlots(CtrlVar,MUAold,[],sOld) ; hold on ;  
PlotMuaMesh(CtrlVar,MUAold) ; clim([-10 100]) ; 
axis([-1640 -1580 -720 -670]) ; title("t="+num2str(CtrlVar.time))



%% Use MATLAB scattered interpolant everywhere
% This examples shows a very strange behaviour at node 7334....!


Finterpolant=scatteredInterpolant(MUAold.coordinates(:,1),MUAold.coordinates(:,2),sOld);


xNew=MUAnew.coordinates(:,1);
yNew=MUAnew.coordinates(:,2);

tic
sScatteredInt=Finterpolant(xNew,yNew);
toc


FindOrCreateFigure("MUAnew Test with scattered interpolant only") ; 
UaPlots(CtrlVar,MUAnew,[],sScatteredInt) ; hold on ;  
PlotMuaMesh(CtrlVar,MUAnew) ; clim([-10 100]) ; 
axis([-1640 -1580 -720 -680]) ; plot(xNew(7334)/1000,yNew(7334)/1000,"*r") ; title("t="+num2str(CtrlVar.time))


%% Now use shape function interpolation as originally written by Sebastian Rosier
% This does NOT show this odd behavriour, and everything seems reasonable

xNew=MUAnew.coordinates(:,1);
yNew=MUAnew.coordinates(:,2);

values=Finterpolant.Values;
tic
sShapeFunctions=MapNodalVariablesFromMesh1ToMesh2UsingFEShapeFunctions(CtrlVar,MUAold,xNew,yNew,sOld);
toc


Test=Finterpolant(xNew,yNew); 
FindOrCreateFigure("MUAnew Test with Shape functions") ; 
UaPlots(CtrlVar,MUAnew,[],sShapeFunctions) ; hold on ;  
PlotMuaMesh(CtrlVar,MUAnew) ; clim([-10 100]) ; 
axis([-1640 -1580 -720 -680]) ; plot(xNew(7334)/1000,yNew(7334)/1000,"*r") ; title("t="+num2str(CtrlVar.time))



%% Use the standard pre-April 2024 Ua approach based on scattered interpolant where nodes are not identical
% This shows this odd behaviour!
OutsideValues=[] ; sOld=Finterpolant.Values; 
tic
[RunInfo,sNew]=MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,sOld);
toc

FindOrCreateFigure("sNew from sOld using current approach") ; 
UaPlots(CtrlVar,MUAnew,[],sNew) ; hold on ;  
PlotMuaMesh(CtrlVar,MUAnew) ; clim([-10 100]) ; 
axis([-1640 -1580 -720 -680]) ; plot(xNew(7334)/1000,yNew(7334)/1000,"*r") ; title("t="+num2str(CtrlVar.time))







%% Use the new 1st April 2023 approach where form-function interpolation is used for new inside nodes
% This does not show the odd behaviour


OutsideValues=[] ; sOld=Finterpolant.Values; 
tic
[RunInfo,sNew]=MapNodalVariablesFromMesh1ToMesh2UsingShapeAndScattered(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,sOld);
toc

FindOrCreateFigure("sNew from sOld using mixed approach") ; 
UaPlots(CtrlVar,MUAnew,[],sNew) ; hold on ;  
PlotMuaMesh(CtrlVar,MUAnew) ; clim([-10 100]) ; 
axis([-1640 -1580 -720 -680]) ; plot(xNew(7334)/1000,yNew(7334)/1000,"*r") ; title("t="+num2str(CtrlVar.time))




