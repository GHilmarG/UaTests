
%%


figFGtlog=FindOrCreateFigure("Flux Gate(t) log") ; clf(figFGtlog);
semilogy(tVector,qwVector/1e9,"ob")
title(sprintf("$Q_n$=%g $(\\mathrm{km}^3/\\mathrm{yr})$ $Q_{\\mathrm{int}}$=%g $(\\mathrm{km}^3/\\mathrm{yr})$ $t$=%g $(\\mathrm{yr})$",Qn/1e9,QnTheoretical/1e9,CtrlVar.time),Interpreter="latex")
yline(QnTheoretical/1e9,"--")
xlabel("time, $t$ $(\mathrm{yr})$",Interpreter="latex")
ylabel("Water flux, $Q$ $(\mathrm{km}^3/\mathrm{yr})$",Interpreter="latex")


%%


[~,xGL,yGL]=UaPlots(CtrlVar,MUA,F1,F1.hw,FigureTitle="hw",CreateNewFigure=true,GetRidOfValuesDownStreamOfGroundingLines=true) ;
% IhwNeg=F1.hw<0 ; hold on ; plot(F1.x(IhwNeg)/CtrlVar.PlotXYscale,F1.y(IhwNeg)/CtrlVar.PlotXYscale,'or')
title(sprintf("$h_w$ time=%g",CtrlVar.time),Interpreter="latex")

%%