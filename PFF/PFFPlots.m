
function PFFPlots(UserVar,CtrlVar,MUA,F,BCs,BCsphi,phi,Psi,e,PlotTitle) 


persistent phiVideo MeshVideo

narginchk(10,10)


[xphi,yphi]=CalcMuaFieldsContourLine(CtrlVar,MUA,phi,0.9) ;


figBCs=FindOrCreateFigure("BCs") ; clf(figBCs) ;
PlotBoundaryConditions(CtrlVar,MUA,BCs);
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title(PlotTitle)

FindOrCreateFigure("BCs Phi") ; PlotBoundaryConditions(CtrlVar,MUA,BCsphi);
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)

UaPlots(CtrlVar,MUA,F,F.AGlen,FigureTitle="A Effective") ; set(gca,'ColorScale','log')
hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title(sprintf("$A$")+PlotTitle,Interpreter="latex")

fvel=FindOrCreateFigure("uv") ; clf(fvel)
QuiverColorGHG(F.x,F.y,F.ub,F.vb,CtrlVar) ;
hold on ; 
plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)


%% phi

phiVideoFile="phi-"+UserVar.Experiment+".avi";

if ~isfield(CtrlVar.PhaseFieldFracture,"Video")
    
end

if CtrlVar.PhaseFieldFracture.Video
    if CtrlVar.PhaseFieldFracture.iphiUpdate==1
        phiVideo=VideoWriter(phiVideoFile) ;
        phiVideo.FrameRate=1;
        open(phiVideo)
    end
end

figphi=FindOrCreateFigure("phi")  ; clf(figphi) ;
cbar=UaPlots(CtrlVar,MUA,F,phi) ;
title(cbar,"$\phi$",interpreter="latex")
CM=cmocean('balanced',25,'pivot',0.5) ; colormap(CM);
hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title(sprintf("$\\phi$  ")+PlotTitle,Interpreter="latex")
xlabel("$x$ (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex")

if CtrlVar.PhaseFieldFracture.Video

    if (CtrlVar.PhaseFieldFracture.iphiUpdate>=1) && (CtrlVar.PhaseFieldFracture.iphiUpdate <=CtrlVar.PhaseFieldFracture.MaxUpdates)
        frame=getframe(gcf);
        writeVideo(phiVideo,frame) ;
    end

    if CtrlVar.PhaseFieldFracture.iphiUpdate==CtrlVar.PhaseFieldFracture.MaxUpdates

        close(phiVideo)

    end
end
%% Mesh


MeshVideoFile="Mesh-"+UserVar.Experiment+".avi";

if CtrlVar.PhaseFieldFracture.Video
    if CtrlVar.PhaseFieldFracture.iphiUpdate==1
        MeshVideo=VideoWriter(MeshVideoFile) ;
        MeshVideo.FrameRate=1;
        open(MeshVideo)
    end
end


figMesh=FindOrCreateFigure("Mesh")  ; clf(figMesh) ;
PlotMuaMesh(CtrlVar,MUA) ;
axis tight
hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title(sprintf("Mesh ")+PlotTitle,Interpreter="latex")
xlabel("$x$ (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex")


if CtrlVar.PhaseFieldFracture.Video
    if (CtrlVar.PhaseFieldFracture.iphiUpdate>=1) && (CtrlVar.PhaseFieldFracture.iphiUpdate <=CtrlVar.PhaseFieldFracture.MaxUpdates)
        frame=getframe(gcf);
        writeVideo(MeshVideo,frame) ;
    end

    if CtrlVar.PhaseFieldFracture.iphiUpdate==CtrlVar.PhaseFieldFracture.MaxUpdates

        close(MeshVideo)

    end
end

%%



figphiy=FindOrCreateFigure("Phi(y)") ; clf(figphiy) ; 
Ind=F.x>50e3 & F.x <60e3 ;   
plot(F.y(Ind)/CtrlVar.PlotXYscale,phi(Ind),'.r') ;



cbar=UaPlots(CtrlVar,MUA,F,F.rho,FigureTitle="rho effective") ;
title("$\rho$ effective "+PlotTitle,interpreter="latex")
title(cbar,"$\rho$",interpreter="latex")
hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)





fige=FindOrCreateFigure("e") ;  clf(fige);
UaPlots(CtrlVar,MUA,F,e);
hold on ;
plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title(sprintf("$e$  ")+PlotTitle,Interpreter="latex")


cbar=UaPlots(CtrlVar,MUA,F,Psi,FigureTitle="Psi") ;  set(gca,'ColorScale','log')
title(cbar,"$\Psi$",interpreter="latex")
hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title(sprintf("$\\Psi$  ")+PlotTitle,Interpreter="latex")



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