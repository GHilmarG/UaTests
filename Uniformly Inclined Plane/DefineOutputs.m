function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);

v2struct(F);

time=CtrlVar.time; 

         

plots='-ubvb-e-save-';
plots='-sbB-udvd-ubvb-ub-';
plots='-udvd-stresses-';


x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);
GLgeo=[];
xGL=[];
yGL=[];

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
if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end


if contains(plots,'-sbB-')
    figure(5)
    hold off
    if isempty(TRI) ;  TRI = delaunay(x,y); end
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,s,'EdgeColor','none') ; hold on
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,B,'EdgeColor','none') ;
    view(50,20); lightangle(-45,30) ; lighting phong ;
    xlabel('y') ; ylabel('x') ;
    colorbar ; title(colorbar,'(m)')
    hold on
    
    title(sprintf('sbB at t=%#5.1g ',time))
    axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale]); axis tight
    hold off
end

if contains(plots,'-stresses-')
    %%
    [tbx,tby,tb,beta2] = CalcBasalTraction(CtrlVar,MUA,F.ub,F.vb,F.C,F.m,GF) ;
    
    [txzb,tyzb]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,F.AGlen,F.n,F.C,F.m,GF,F.s,F.b,F.ub,F.vb);
    figure
    PlotMeshScalarVariable(CtrlVar,MUA,tb) ;
    title(' tb ') ; cbar=colorbar; title(cbar, '(kPa)');
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    
    
    figure
    PlotMeshScalarVariable(CtrlVar,MUA,txzb) ;
    title(' txzb ') ; cbar=colorbar; title(cbar, '(kPa)');
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    
end



if contains(plots,'-ubvb-')
    % plotting horizontal velocities
    figure
    N=1;
    speed=sqrt(ub.*ub+vb.*vb);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    CtrlVar.RelativeVelArrowSize=10;
    QuiverColorGHG(x(1:N:end),y(1:N:end),ub(1:N:end),vb(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if contains(plots,'-udvd-')
    % plotting horizontal velocities
    figure
    N=1;
    speed=sqrt(ud.*ud+vd.*vd);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ud(1:N:end),vd(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ud,vd) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
    dsdx=tan(0.1);
    hmean=mean(s-b);
    taud=mean(rho*g*dsdx*hmean);
    udAnalytical=2*mean(AGlen)*taud.^mean(n)*hmean./mean(n+1)
    
end

if contains(plots,'-e-')
    % plotting effectiv strain rates
    
    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,u,v,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therfore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    title(sprintf('e t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end

if contains(plots,'-ub-')
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,ub,CtrlVar)    ;
    title(sprintf('ub t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


end
