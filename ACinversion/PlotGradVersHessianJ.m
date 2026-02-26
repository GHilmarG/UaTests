
%%

FileA="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS25km-Tri3-MatGrad-.mat";
FileB="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS25km-Tri3-UaHess-.mat";

FileA="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-MatGrad-.mat";
FileB="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaHess-.mat";

FileA="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-MatGrad-logA-logC-uv-.mat";
FileB="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logA-logC-uv-.mat";

load(FileA,"RunInfo")


fig=FindOrCreateFigure("Inverse Parameter Optimisation comparision"); clf(fig)

semilogy(RunInfo.Inverse.Iterations,RunInfo.Inverse.J,'-bo','LineWidth',2,DisplayName="lBFGS")



load(FileB,"RunInfo")

hold on
semilogy(RunInfo.Inverse.Iterations,RunInfo.Inverse.J,'-r*','LineWidth',2,DisplayName="Hessian")

ylabel("$J$",'interpreter','latex')
xlabel("Iteration")
lg=legend;


% MS=extractBetween(FileA,"-MS","-");
% exportgraphics(fig,"Hessian_lBFGS"+MS+".pdf")
% exportgraphics(fig,"Hessian_lBFGS"+MS+".png")


%%

FileA="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-MatGrad-logA-logC-uv-.mat";
FileB="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logA-logC-uv-.mat";
MS=extractBetween(FileA,"-MS","-");

load(FileA);
FigName="MatGrad";
CtrlVar=CtrlVarInRestartFile;  

FIG=PlotTrueAndEstimated(FigName,CtrlVar,MUA,F,Priors,InvFinalValues);

exportgraphics(FIG,"TrueAndEstimatedACHessian_lBFGS"+MS+".pdf")
exportgraphics(FIG,"TrueAndEstimatedACHessian_lBFGS"+MS+".png")

load(FileB);
FigName="UaHess";
CtrlVar=CtrlVarInRestartFile;  
FIG=PlotTrueAndEstimated(FigName,CtrlVar,MUA,F,Priors,InvFinalValues);

exportgraphics(FIG,"TrueAndEstimatedACUaAdjointHessian"+MS+".pdf")
exportgraphics(FIG,"TrueAndEstimatedACUaAdjointHessian"+MS+".png")





%%


function FIG=PlotTrueAndEstimated(FigName,CtrlVar,MUA,F,Priors,InvFinalValues)

FIG=FindOrCreateFigure(FigName); clf(FIG);

T=tiledlayout("flow");

nexttile
cbar=UaPlots(CtrlVar,MUA,F,Priors.TrueAGlen,CreateNewFigure=false) ;
title("True $A$",Interpreter="latex") ; set(gca,'ColorScale','log')

subtitle("")
title(cbar,"($\mathrm{yr}^{-1} \, \mathrm{kPa}^{-1}$)",interpreter="latex")  
xlabel("x (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex")
CL=clim;

nexttile
cbar=UaPlots(CtrlVar,MUA,F,InvFinalValues.AGlen,CreateNewFigure=false) ;
title("Retrieved $A$",Interpreter="latex") ; set(gca,'ColorScale','log')
subtitle("")
title(cbar,"($\mathrm{yr}^{-1} \, \mathrm{kPa}^{-1}$)",interpreter="latex")  
xlabel("x (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex")
clim(CL)

nexttile
cbar=UaPlots(CtrlVar,MUA,F,Priors.TrueC,CreateNewFigure=false) ;
title("True $C$",Interpreter="latex") ; set(gca,'ColorScale','log')
subtitle("")
title(cbar,"($\mathrm{m} \, \mathrm{yr}^{-1} \, \mathrm{kPa}^{-1}$)",interpreter="latex")  
xlabel("x (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex")
CL=clim;

nexttile
cbar=UaPlots(CtrlVar,MUA,F,InvFinalValues.C,CreateNewFigure=false) ;
title("Retrieved $C$",Interpreter="latex") ; set(gca,'ColorScale','log')
title(cbar,"($\mathrm{m} \, \mathrm{yr}^{-1} \, \mathrm{kPa}^{-1}$)",interpreter="latex")  
subtitle("")
xlabel("x (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex")
clim(CL)


T.Padding="tight";   T.TileSpacing="tight";

end

%%

