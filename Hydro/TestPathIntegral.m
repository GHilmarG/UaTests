

load("RestartWaterFilmThicknessEquationDriver932","UserVar","CtrlVar","MUA","F0","F1","k","hwMinVector");

%%


[~,xGL,yGL]=UaPlots(CtrlVar,MUA,F1,F1.hw,FigureTitle="hw",CreateNewFigure=true) ;
title(sprintf("$h_w$ time=%g",CtrlVar.time),Interpreter="latex")

% Phi1=F1.g.* ( (F1.rhow-F1.rho).*F1.B + F1.rho.*F1.s) ;
% phi1=Phi1+F1.g.*(F1.rhow-F1.rho).*F1.hw ;
% [dphi1dx,dphi1dy]=gradUa(CtrlVar,MUA,phi1) ;
% qwx1=-F1.hw.*k.*dphi1dx;  qwy1=-F1.hw.*k.*dphi1dy;  % Achtung, this implies a boundary condition, compare with the integration

Phi1=F1.g.* ( (F1.rhow-F1.rho).*F1.B + F1.rho.*F1.s) ;   % does not change, if s and b do not
Phi0=F0.g.* ( (F0.rhow-F0.rho).*F0.B + F0.rho.*F0.s) ;   % does not change, if s and b do not

[dPhidx,dPhidy]=gradUa(CtrlVar,MUA,Phi1) ; uw1=-k.*dPhidx;  vw1=-k.*dPhidy;
[dPhidx,dPhidy]=gradUa(CtrlVar,MUA,Phi0) ; uw0=-k.*dPhidx;  vw0=-k.*dPhidy;

[UserVar,qwx1,qwy1,qphix,qphiy,qPhix,qPhiy]=WaterFilmFlux(UserVar,CtrlVar,MUA,F0,F1,k,uw0,vw0,uw1,vw1) ; 

figqw=FindOrCreateFigure("(qwx,qwy)") ; clf(figqw) ;
QuiverColorGHG(F1.x,F1.y,qwx1,qwy1,CtrlVar) ;
hold on
plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
PlotMuaBoundary(CtrlVar,MUA) ;
title(sprintf("$\\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
hold off


Int=FEintegrate2D(CtrlVar,MUA,F1.aw) ;
QInt=sum(Int) ;


BoundaryNodes=MUA.Boundary.EdgeCornerNodes ;
BoundaryNodes=[BoundaryNodes;BoundaryNodes(1)] ;
BoundaryNodes=flipud(BoundaryNodes) ;

[Qn,Qt,qn,qt,Xc,Yc,normal]=PathIntegral(CtrlVar,F1.x(BoundaryNodes),F1.y(BoundaryNodes),qwx1(BoundaryNodes),qwy1(BoundaryNodes));

figNP=FindOrCreateFigure("Boundary fluxes") ; clf(figNP);
qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
[cbar,QuiverHandel,Par]=QuiverColorGHG(Xc,Yc,qnx,qny,CtrlVar) ;
hold on
plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
PlotMuaBoundary(CtrlVar,MUA) ;
title(sprintf("Qn=%g  \t QInt=%g \t time=%g",Qn,QInt,CtrlVar.time))
hold off

%%

figNP=FindOrCreateFigure("(uw,vw)") ; clf(figNP);
qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
[cbar,QuiverHandel,Par]=QuiverColorGHG(F1.x,F1.y,uw1,vw1,CtrlVar) ;
hold on
plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
PlotMuaBoundary(CtrlVar,MUA) ;
title(sprintf("$\\mathbf{v}_w$ time=%g",CtrlVar.time),Interpreter="latex")
hold off
%%
% circle integral

theta=linspace(0,1,200) ;


NR=10;
RVector=linspace(20e3,100e3,NR); 



QVector=nan(NR,1);


for I=1:numel(RVector)
    R=RVector(I); 

    Xc=R*cos(2*pi*theta);
    Yc=R*sin(2*pi*theta);
    figure(10)
    plot(Xc/1000,Yc/1000,'.');
    axis equal

    Fqwx=scatteredInterpolant(F1.x,F1.y,qwx1) ;  Fqwy=scatteredInterpolant(F1.x,F1.y,qwy1) ;
    [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,Xc,Yc,Fqwx,Fqwy);

    figNPc=FindOrCreateFigure("Boundary fluxes circle") ; clf(figNPc);
    qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
    PlotMuaMesh(CtrlVar,MUA)
    hold on
    [cbar,QuiverHandel,Par]=QuiverColorGHG(Xc,Yc,qnx,qny,CtrlVar) ;
    hold on
    plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
    plot(Xc/CtrlVar.PlotXYscale,Yc/CtrlVar.PlotXYscale,'k-')
    PlotMuaBoundary(CtrlVar,MUA) ;
    title(sprintf("R=%f \t Qn=%g  \t QInt=%g \t time=%g",R/1e3,Qn,QInt,CtrlVar.time))

    QVector(I)=Qn;  

    figQR=FindOrCreateFigure("Q(R)") ; clf(figQR);
    plot(RVector/1e3,QVector,"o-")
    yline(QInt,"--")

    hold off

end










%%