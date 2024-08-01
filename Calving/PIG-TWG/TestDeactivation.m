

%%
load TestSave



isIceNode = Fnew.LSF > 0 ;

isIceElement=AllElementsContainingGivenNodes(MUAnew.connectivity,isIceNode) ;

isIceNodeOfIceElement= MUAnew.connectivity(isIceElement,:) ;
isIceElement2=AllElementsContainingGivenNodes(MUAnew.connectivity,isIceNodeOfIceElement) ;

ElementsToBeDeactivated=~isIceElement2 ; 


%%
FigureName="Elements to be deactivated (red)";

fig=FindOrCreateFigure("D");  clf(fig) ;

PlotMuaMesh(CtrlVar,MUA,ElementsToBeDeactivated,'r');
hold on
PlotMuaMesh(CtrlVar,MUA,~ElementsToBeDeactivated,'k');
title('Elements to be deactivated in red')

%%
