function UserVar=UaOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

v2struct(F);
time=CtrlVar.time; 


persistent Fig_sbB


plots='-ubvb-e-save-';
plots='-udvd-ud(x)-sbB(x)-';
plots='-sbB(x)-';
plots='-mesh-sbB-udvd-';
plots='-h-ubvb-sbB-';
%plots='-sbB-';
%plots='-save-';


TRI=[]; x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);

if ~isempty(strfind(plots,'-save-'))

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if exist('ResultsFiles','dir')~=7 ;
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.UaOutputsInfostring,'Last call')==0
        
        FileName=['ResultsFiles/',sprintf('%07i',round(100*time)),'-',CtrlVar.Experiment]; % good for transient runs
        
        %FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.UaOutputsCounter),'-TransPlots-',CtrlVar.Experiment];
        
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','time','s','b','ub','vb','ud','vd','dhdt')
        
    end
    return
end

if ~isempty(strfind(plots,'-mesh-'))
    figure(100) ;  PlotFEmesh(MUA.coordinates,MUA.connectivity,CtrlVar);
    title(sprintf('mesh at t=%-g ',time)) ; xlabel('x') ; ylabel('y')
    
end

if ~isempty(strfind(plots,'-h-'))
    %%
    figh=figure(1000);
    hold off
    PlotMeshScalarVariable(CtrlVar,MUA,h);
    figh.Position=[1000 200 900 900];
    
    title(sprintf('h at t=%-g ',time)) ; xlabel('x') ; ylabel('y')
end

if ~isempty(strfind(plots,'-ub(x)-'))
    figure
    plot(x/CtrlVar.PlotXYscale,ub)
    title(sprintf('u_b(x) at t=%-g ',time)) ; xlabel('x') ; ylabel('u_b')
end

if ~isempty(strfind(plots,'-sbSB(x)-'))
    figure
    
    plot(x/CtrlVar.PlotXYscale,S,'k--') ; hold on
    plot(x/CtrlVar.PlotXYscale,B,'k') ; 
    plot(x/CtrlVar.PlotXYscale,b,'b') ; 
    plot(x/CtrlVar.PlotXYscale,s,'b') ;
    
    title(sprintf('sbSB(x) at t=%-g ',time)) ; xlabel('x') ; ylabel('z')
end

if ~isempty(strfind(plots,'-sbB(x)-'))
    
    [~,I]=sort(x);
    
    if isempty(Fig_sbB) ; Fig_sbB= figure; else Fig_sbB=figure(Fig_sbB) ; end
    hold off
    plot(x(I)/CtrlVar.PlotXYscale,B(I),'k') ; hold on
    plot(x(I)/CtrlVar.PlotXYscale,b(I),'b') ; 
    plot(x(I)/CtrlVar.PlotXYscale,s(I),'b') ;
    
    title(sprintf('sbB(x) at t=%-g ',time)) ; xlabel('x') ; ylabel('z')
end

if ~isempty(strfind(plots,'-sbB-'))
    %%
    figure
    
    if ~exist('DT','var') ; DT=[] ; end
    if ~exist('TRI','var') ; TRI=[] ; end
    if ~exist('LightHandle','var') ; LightHandle=[] ; end
    AspectRatio=0.1; ViewAndLight=[];
    hold off
    [TRI,DT,LightHandle]=Plot_sbB(CtrlVar,MUA,s,b,B,TRI,DT,AspectRatio,ViewAndLight,LightHandle);
    
    title(sprintf('sbB at t=%f ',time))
    axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale]); axis tight
    hold off
    
    
end


if ~isempty(strfind(plots,'-B-'))
    %%
    figure(6)
    hold off
    if isempty(TRI) ;  TRI = delaunay(x,y); end
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,B,'EdgeColor','none') ;
    view(120,40); lightangle(-45,30) ; lighting phong ;
    xlabel('x') ; ylabel('y') ;
    colorbar ; title(colorbar,'(m)')
    hold on
    
    title(sprintf('B at t=%#5.1g ',time))
    axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale]); axis tight
    hold off
    
    
end


if ~isempty(strfind(plots,'-udvd-'))
    % plotting horizontal velocities
    figudvd=figure(2000); 
    hold off
    N=1;
    speed=sqrt(ud.*ud+vd.*vd);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; 
    CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    CtrlVar.RelativeVelArrowSize=1;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ud(1:N:end),vd(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ud,vd) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    figudvd.Position=[10 100 900 800];
    
end


if ~isempty(strfind(plots,'-ubvb-'))
    % plotting horizontal velocities
    figubvb=figure(2010); 
    hold off
    N=1;
    speed=sqrt(ub.*ub+vb.*vb);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; 
    CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    CtrlVar.RelativeVelArrowSize=1;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ub(1:N:end),vb(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g ',time)) ; xlabel('(km)') ; ylabel('(km)')
    figubvb.Position=[10 100 900 800];
    
end



if ~isempty(strfind(plots,'-e-'))
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

if ~isempty(strfind(plots,'-ub-'))
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,ub,CtrlVar)    ;
    title(sprintf('ub t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


end
