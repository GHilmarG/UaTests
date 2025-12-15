function PFFdeltaPlots(UserVar,CtrlVar,MUA,F,PlotTitle,phi,phiLast) 


[xphi,yphi]=CalcMuaFieldsContourLine(CtrlVar,MUA,phi,0.9) ;


UaPlots(CtrlVar,MUA,F,phi,FigureTitle="phi")
hold on 
plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title(sprintf("$\\phi$  ")+PlotTitle,Interpreter="latex")


dphi=phi-phiLast;
cbar=UaPlots(CtrlVar,MUA,F,dphi,FigureTitle="dphi"); 
hold on 
plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title(sprintf("$\\Delta \\phi$  ")+PlotTitle,Interpreter="latex")
title(cbar,"$\Delta \phi$",Interpreter="latex")

end