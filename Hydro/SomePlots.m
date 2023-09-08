
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

figqwP=FindOrCreateFigure("(qwx,qwy)") ; clf(figqwP) ;
CtrlVar.VelColorBarTitle="($\mathrm{km^2 \, yr^{-1}}$)" ;

qwx=qw1x ; qwy=qw1y ; 
qwx(~F1.GF.NodesUpstreamOfGroundingLines)=0;
qwy(~F1.GF.NodesUpstreamOfGroundingLines)=0;

QuiverColorGHG(F1.x,F1.y,qwx/1e6,qwy/1e6,CtrlVar) ;
hold on
plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
PlotMuaBoundary(CtrlVar,MUA) ;
if ~isempty(FluxGate)
    plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,Color="k",LineWidth=2) ;
end
xlabel("$x\,(\mathrm{km})$",interpreter="latex")
ylabel("$y\,(\mathrm{km})$",interpreter="latex")

title(sprintf("$\\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
hold off

%%

ax = gca;  exportgraphics(ax,'HydroSyntheticPeaksFluxExample.pdf')

ax = gca;  exportgraphics(ax,'HydroSyntheticPotentialVelocitiesExample.pdf')

ax = gca;  exportgraphics(ax,'HydroSyntheticGeometryExample.pdf')

%%
xlabel("$x\,(\mathrm{km})$",interpreter="latex")
ylabel("$y\,(\mathrm{km})$",interpreter="latex")

zlabel("$z\,(\mathrm{m})$",interpreter="latex")
zlim([-2000 1600])
title("")


%%


x=x1int(:);

qy=qy1int(:);

N=10; 
x=x(1:N:end);
y=y(1:N:end);
qx=qx(1:N:end);
qy=qy(1:N:end) ; 

figure(100)
cbar=QuiverColorGHG(x,y,qx,qy,CtrlVar) ;

CtrlVar.RelativeVelArrowSize=10;
F1.x=x; F1.y=y ; F1.ub=qx ; F1.vb=qy ;
UaPlots(CtrlVar,MUA,F1,"-uv-");


%%


  Box=[-1500 -1200 -500 -200]*1000;

figqw=FindOrCreateFigure("(qwx,qwy)") ; clf(figqw) ;
CtrlVar.VelColorBarTitle="($\mathrm{km^2 \, yr^{-1}}$)" ;


cbar=QuiverColorGHG(xint,yint,qwxint/1e6,qwyint/1e6,CtrlVar) ;
hold on
plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
PlotMuaBoundary(CtrlVar,MUA) ;


plot([Box(1) Box(2)  Box(2) Box(1) Box(1)]/CtrlVar.PlotXYscale,[Box(3) Box(3) Box(4) Box(4) Box(3)]/CtrlVar.PlotXYscale,'k')


% if ~isempty(FluxGate)
%    plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,Color="k",LineWidth=2) ;
% end

xlabel("$x\,(\mathrm{km})$",interpreter="latex")
ylabel("$y\,(\mathrm{km})$",interpreter="latex")
title(sprintf("$\\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
hold off



%%








