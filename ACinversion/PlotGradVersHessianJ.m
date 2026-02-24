
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


MS=extractBetween(FileA,"-MS","-");

exportgraphics(fig,"Hessian_lBFGS"+MS+".pdf")
exportgraphics(fig,"Hessian_lBFGS"+MS+".png")


%%