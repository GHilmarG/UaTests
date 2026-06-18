
function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);




time=CtrlVar.time;


plots='-ubvb-e-save-';
plots='-udvd-ubvb-speed-';
%plots='-mesh-';

UserVar.CreateVideo=1;
TRI=[];
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);

if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if strcmp(CtrlVar.DefineOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7 ;
        mkdir('ResultsFiles') ;
    end

    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
        %FileName=['ResultsFiles/',sprintf('%07i',round(100*time)),'-TransPlots-',CtrlVar.Experiment]; good for transient runs

        FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.DefineOutputsCounter),'-TransPlots-',CtrlVar.Experiment];

        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','time','s','b','S','B','h','u','v','dhdt','dsdt','dbdt','C','AGlen','m','n','rho','rhow','as','ab','GF')

    end
end




% only do plots at end of run
%if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end



%% perturbations
cbar=UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="Upper Surface")  ;
CM=cmocean('balanced',25,'pivot',mean(F.s)) ; colormap(CM);
title(cbar,"(m)")

cbar=UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="Lower Surface")  ;
CM=cmocean('balanced',25,'pivot',mean(F.b)) ; colormap(CM);
title(cbar,"(m)")

FindOrCreateFigure("vel pert")
QuiverColorGHG(F.x,F.y,F.ub-mean(F.ub),F.vb,CtrlVar)  ;
title("Velocity pertubations (ub,vb)")
axis equal

if contains(plots,'-sbB-')
    FindOrCreateFigure("-sbB-")
    hold off
    if isempty(TRI) ;  TRI = delaunay(x,y); end
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,s,'EdgeColor','none') ; hold on
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
    trisurf(TRI,F.x/CtrlVar.PlotXYscale,F.y/CtrlVar.PlotXYscale,B,'EdgeColor','none') ;
    view(50,20); lightangle(-45,30) ; lighting phong ;
    xlabel('y') ; ylabel('x') ;
    colorbar ; title(colorbar,'(m)')
    hold on

    title(sprintf('sbB at t=%#5.1g ',time))
    axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale]); axis tight
    hold off
end


if contains(plots,'-ubvb-')

    figubvb=FindOrCreateFigure("-ubvb-") ; clf(figubvb)
    % plotting horizontal velocities
    UaPlots(CtrlVar,MUA,F,"-ubvb-",CreateNewFigure=false);

    title(sprintf('(ub,vb) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight

end


if contains(plots,'-udvd-')

    figudvd=FindOrCreateFigure("-udvd-") ; clf(figudvd)
    % plotting horizontal velocities
    UaPlots(CtrlVar,MUA,F,"-udvd-",CreateNewFigure=false);

    title(sprintf('(ud,vd) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight

end


if contains(plots,'-e-')
    % plotting effective strain rates

    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,u,v,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therfore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);

    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    title(sprintf('e t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')

end

if contains(plots,'-speed-')

    figspeed=FindOrCreateFigure("-speed-") ; clf(figspeed)
    % plotting horizontal velocities
    UaPlots(CtrlVar,MUA,F,"-speed-",CreateNewFigure=false,logColorbar=true);
    CM=cmocean('balanced',25,'pivot',mean(F.ub)) ; colormap(CM);
    xlabel('x (km)') ; ylabel('y (km)')
    axis equal tight

end


end
