
%%
load TestSaveScatteredInterpolantError.mat


Finterpolant.ExtrapolationMethod='nearest'  ;
Finterpolant.Method='nearest';
Finterpolant.Method='linear';
Finterpolant.Method='natural';


Test=Finterpolant(xNew,yNew); 
FindOrCreateFigure("MUAnew Test") ; 
UaPlots(CtrlVar,MUAnew,[],Test) ; hold on ;  
PlotMuaMesh(CtrlVar,MUAnew) ; clim([-10 100]) ; 
axis([-1640 -1580 -720 -680]) ; plot(xNew(7334)/1000,yNew(7334)/1000,"*r") ; title("t="+num2str(CtrlVar.time))



FindOrCreateFigure("MUAold values") ; 
UaPlots(CtrlVar,MUAold,[],Finterpolant.Values) ; hold on ;  
PlotMuaMesh(CtrlVar,MUAold) ; clim([-10 100]) ; 
axis([-1640 -1580 -720 -670]) ; title("t="+num2str(CtrlVar.time))



%% Use shape function interpolation

xNew=MUAnew.coordinates(:,1);
yNew=MUAnew.coordinates(:,2);

values=Finterpolant.Values;
tic
sShapeFunctions=MapNodalVariablesFromMesh1ToMesh2UsingFEShapeFunctions(CtrlVar,MUAold,xNew,yNew,values);
toc



Test=Finterpolant(xNew,yNew); 
FindOrCreateFigure("MUAnew Test with Shape functions") ; 
UaPlots(CtrlVar,MUAnew,[],sShapeFunctions) ; hold on ;  
PlotMuaMesh(CtrlVar,MUAnew) ; clim([-10 100]) ; 
axis([-1640 -1580 -720 -680]) ; plot(xNew(7334)/1000,yNew(7334)/1000,"*r") ; title("t="+num2str(CtrlVar.time))



%% Use scattered interpolant everywhere



xNew=MUAnew.coordinates(:,1);
yNew=MUAnew.coordinates(:,2);

tic
sScatteredInt=Finterpolant(xNew,yNew);
toc


FindOrCreateFigure("MUAnew Test with scattered interpolant only") ; 
UaPlots(CtrlVar,MUAnew,[],sScatteredInt) ; hold on ;  
PlotMuaMesh(CtrlVar,MUAnew) ; clim([-10 100]) ; 
axis([-1640 -1580 -720 -680]) ; plot(xNew(7334)/1000,yNew(7334)/1000,"*r") ; title("t="+num2str(CtrlVar.time))


%%

OutsideValues=[] ; sOld=Finterpolant.Values; 
[RunInfo,sNew]=MapNodalVariablesFromMesh1ToMesh2UsingScatteredInterpolant(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,sOld);


FindOrCreateFigure("sNew from sOld using current approach") ; 
UaPlots(CtrlVar,MUAnew,[],sNew) ; hold on ;  
PlotMuaMesh(CtrlVar,MUAnew) ; clim([-10 100]) ; 
axis([-1640 -1580 -720 -680]) ; plot(xNew(7334)/1000,yNew(7334)/1000,"*r") ; title("t="+num2str(CtrlVar.time))



