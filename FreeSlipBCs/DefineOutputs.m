function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);
v2struct(F);

time=CtrlVar.time; 

plots='-ubvb-e-save-';
plots='-ubvb-sbB-';

TRI=[];
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);

if ~isempty(strfind(plots,'-R-'))
    MLC=BCs2MLC(MUA,BCs) ;
    Reactions=CalculateReactions(MLC,l);
    PlotReactions(CtrlVar,MUA,Reactions);
end



if ~isempty(strfind(plots,'-save-'))

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

if ~isempty(strfind(plots,'-txzb(x)-'))
    
    [txzb,tyzb]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,GF,s,b,ub,vb);
    
    figure ;  plot(x/CtrlVar.PlotXYscale,txzb) ; title('txzb(x)')
    
end


if ~isempty(strfind(plots,'-ub(x)-'))
    figure
   plot(x/CtrlVar.PlotXYscale,ub) ;
    title(sprintf('u_b(x) at t=%-g ',time)) ; xlabel('x') ; ylabel('u_b')
end

if ~isempty(strfind(plots,'-ud(x)-'))
    figure
   plot(x/CtrlVar.PlotXYscale,ud) ;
    title(sprintf('u_d(x) at t=%-g ',time)) ; xlabel('x') ; ylabel('u_d')
end


if ~isempty(strfind(plots,'-sbSB(x)-'))
    figure
    
    plot(x/CtrlVar.PlotXYscale,S,'k--') ; hold on
    plot(x/CtrlVar.PlotXYscale,B,'k') ; 
    plot(x/CtrlVar.PlotXYscale,b,'b') ; 
    plot(x/CtrlVar.PlotXYscale,s,'b') ;
    
    title(sprintf('sbSB(x) at t=%-g ',time)) ; xlabel('x') ; ylabel('z')
end


if ~isempty(strfind(plots,'-sbB-'))
    figure(5)
    hold off
    Plot_sbB(CtrlVar,MUA,s,b,B);
    xlabel('y') ; ylabel('x') ;
    colorbar ; title(colorbar,'(m)')
    hold on
    
    title(sprintf('sbB at t=%#5.1g ',time))
    axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale]); axis tight
    hold off
end


if ~isempty(strfind(plots,'-ubvb-'))
    % plotting horizontal velocities
    figure
    N=1;
    %speed=sqrt(ub.*ub+vb.*vb);
    %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    %CtrlVar.RelativeVelArrowSize=10;
    QuiverColorGHG(x(1:N:end),y(1:N:end),ub(1:N:end),vb(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if ~isempty(strfind(plots,'-udvd-'))
    % plotting horizontal velocities
    figure
    N=1;
    %speed=sqrt(ud.*ud+vd.*vd);
    %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ud(1:N:end),vd(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ud,vd) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
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
