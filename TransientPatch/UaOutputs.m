function  UaOutputs(CtrlVar,MUA,time,s,b,S,B,h,ub,vb,ud,vd,dhdt,dsdt,dbdt,C,AGlen,m,n,rho,rhow,as,ab,GF)


plots='-ubvb-e-save-';
plots='-sbB-speed-ubvb-';
plots='-sbB-';

[TotalIceVolume,ElementIceVolume]=CalcIceVolume(CtrlVar,MUA,h);

TRI=[];
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);

if ~isempty(strfind(plots,'-save-'))

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if strcmp(CtrlVar.UaOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7 ;
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.UaOutputsInfostring,'Last call')==0
        %FileName=['ResultsFiles/',sprintf('%07i',round(100*time)),'-TransPlots-',CtrlVar.Experiment]; good for transient runs
        
        FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.UaOutputsCounter),'-TransPlots-',CtrlVar.Experiment];
        
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','time','s','b','S','B','h','u','v','dhdt','dsdt','dbdt','C','AGlen','m','n','rho','rhow','as','ab','GF')
        
    end
end

% only do plots at end of run

if strcmp(CtrlVar.UaOutputsInfostring,'Last call')
    figure
    CtrlVar.PlotNodes=1;
    PlotFEmesh(MUA.coordinates,MUA.connectivity,CtrlVar)
end

if ~isempty(strfind(plots,'-sbB-'))
    figure(7)
    hold off
    if isempty(TRI) ;  TRI = delaunay(x,y); end
    
    %trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,B,50,'EdgeColor','none') ; hold on
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,s,s+10,'EdgeColor','k') ; hold on
    view(45,15); lightangle(-45,30) ; lighting phong ;
    xlabel('y (km)') ; ylabel('x (km)') ; zlabel('z (m)') ;
    %colorbar ; title(colorbar,'(m)')
    hold on
    
    
    title(sprintf('t=%#-10.3g. (a) Volume=%#-12.7g (m^3) ',time,TotalIceVolume))
    axis equal ; 
    tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale/10]); axis tight
    hold off
end


if ~isempty(strfind(plots,'-ubvb-'))
    % plotting horizontal velocities
    figure
    PlotFEmesh(MUA.coordinates,MUA.connectivity,CtrlVar)
    hold on 
    N=1;
    speed=sqrt(ub.*ub+vb.*vb);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    %CtrlVar.RelativeVelArrowSize=10;
    QuiverColorGHG(x(1:N:end),y(1:N:end),ub(1:N:end),vb(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal 
    
end

if ~isempty(strfind(plots,'-udvd-'))
    % plotting horizontal velocities
    figure
    N=1;
    speed=sqrt(ud.*ud+vd.*vd);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ud(1:N:end),vd(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ud,vd) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

%%
if ~isempty(strfind(plots,'-speed-'))
   %%
    figure
    speed=sqrt(ub.*ub+vb.*vb);
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,speed,CtrlVar)    ;
    title(sprintf('speed t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    %%
    
end
%%


if ~isempty(strfind(plots,'-e-'))
    % plotting effectiv strain rates
    
    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,u,v,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therfore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);
    
    figure
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)   ;

    title(sprintf('e t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end

if ~isempty(strfind(plots,'-flux gradients-'))
    % plotting effectiv strain rates
    
    qx=rho.*h.*ub;
    qy=rho.*h.*vb;
    
    [dqxdx,dqxdy,xint,yint]=calcFEderivativesMUA(qx,MUA,CtrlVar);
    [dqydx,dqydy,xint,yint]=calcFEderivativesMUA(qy,MUA,CtrlVar);
    [dqxdx,dqydy]=ProjectFintOntoNodes(MUA,dqxdx,dqydy);
 
    dhdtEst=a-dqxdx-dqydy;
    
    figure
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)   ;

    title(sprintf('e t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end



if ~isempty(strfind(plots,'-ub-'))
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,ub,CtrlVar)    ;
    title(sprintf('ub t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


end
