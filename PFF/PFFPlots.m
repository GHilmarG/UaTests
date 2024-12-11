
function PFFPlots(UserVar,CtrlVar,MUA,F,BCs,BCsphi,phi,Psi,e) 


narginchk(9,9)


[xphi,yphi]=CalcMuaFieldsContourLine(CtrlVar,MUA,phi,0.95) ;


figBCs=FindOrCreateFigure("BCs") ; clf(figBCs) ;
PlotBoundaryConditions(CtrlVar,MUA,BCs);
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)

FindOrCreateFigure("BCs Phi") ; PlotBoundaryConditions(CtrlVar,MUA,BCsphi);
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)

UaPlots(CtrlVar,MUA,F,F.AGlen,FigureTitle="A Effective") ; set(gca,'ColorScale','log')
hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)

fvel=FindOrCreateFigure("uv") ; clf(fvel)
QuiverColorGHG(F.x,F.y,F.ub,F.vb,CtrlVar) ;
hold on ; 
plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)


figphi=FindOrCreateFigure("phi")  ; clf(figphi) ;
cbar=UaPlots(CtrlVar,MUA,F,phi) ;
title(cbar,"$\phi$",interpreter="latex")
CM=cmocean('balanced',25,'pivot',0.5) ; colormap(CM);
hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)


figphiy=FindOrCreateFigure("Phi(y)") ; clf(figphiy) ; 
Ind=F.x>50e3 & F.x <60e3 ;   
plot(F.y(Ind)/CtrlVar.PlotXYscale,phi(Ind),'.r') ;



cbar=UaPlots(CtrlVar,MUA,F,F.rho,FigureTitle="rho effective") ;
title("$\rho$ effective",interpreter="latex")
title(cbar,"$\rho$",interpreter="latex")
hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)





fige=FindOrCreateFigure("e") ;  clf(fige);
UaPlots(CtrlVar,MUA,F,e);
hold on ;
plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)



cbar=UaPlots(CtrlVar,MUA,F,Psi,FigureTitle="Psi") ;  set(gca,'ColorScale','log')
title(cbar,"$\Psi$",interpreter="latex")
hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title(sprintf("$\\Psi$"),Interpreter="latex")



return

% deviatoric stresses : This takes some time
[X,Y]=ndgrid(linspace(min(F.x),max(F.x),80),linspace(min(F.y),max(F.y),80));
I=nearestNeighbor(MUA.TR,[X(:) Y(:)]);  % find nodes within computational grid closest to the regularly scape X and Y grid points.
fstress=FindOrCreateFigure("dev stresses") ; clf(fstress)
scale=5e-3;

iphi=phi>0.5 ;
txx(iphi)=nan;
txy(iphi)=nan;
tyy(iphi)=nan;

PlotTensor(F.x(I)/CtrlVar.PlotXYscale,F.y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
hold on ; 
plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
PlotMuaBoundary(CtrlVar,MUA,'k') ; axis equal





end