function UserVar=UaOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


%save TestSaveUaOutputs


switch lower(CtrlVar.FlowApproximation)
    case 'sstream'
        plots='-sbB-ubvb-BCs-R-as-V(t)-h-';
    case'ssheet'
        plots='-sbB-udvd-BCs-R-as-';
end

TRI=[];
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);
I=F.h<=CtrlVar.ThickMin;

if contains(plots,'-h-')
    
    figh=FindOrCreateFigure('h') ; % ,Position); 
    clf(figh)
    PlotMeshScalarVariable(CtrlVar,MUA,F.h)
    hold on 
    plot(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,'ro');
    plot(x(BCs.hPosNode)/CtrlVar.PlotXYscale,y(BCs.hPosNode)/CtrlVar.PlotXYscale,'*w');
    hold on ; PlotMuaMesh(CtrlVar,MUA)
    
end

if contains(plots,'-R-')
    
    MLC=BCs2MLC(MUA,BCs) ;
    Reactions=CalculateReactions(MLC,l);
    figReactions=FindOrCreateFigure('Reactions') ; % ,Position); 
    clf(figReactions)
    figReactions=PlotReactions2(CtrlVar,MUA,Reactions,figReactions);
    
    
    if ~isempty(Reactions.h)
        %M=MassMatrix2D1dof(MUA);
        MeshIndependentReactions=MUA.M\Reactions.h;
        figReactions2=FindOrCreateFigure('Reactions2') ;%  ,Position); 
        PlotMeshScalarVariable(CtrlVar,MUA,MeshIndependentReactions./F.rho);
        title(sprintf("%s","M\\Reactions.h/rho")) ; xlabel('x (km)') ; ylabel('y (km)') 
    end
end


[TotalIceVolume,ElementIceVolume]=CalcIceVolume(CtrlVar,MUA,F.h);



if contains(plots,'-mesh-')
    
    
    figMesh=FindOrCreateFigure('Mesh') ; % 

    CtrlVar.PlotNodes=1; CtrlVar.PlotLabels=0;
    PlotFEmesh(MUA.coordinates,MUA.connectivity,CtrlVar)
    hold on
    plot(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,'ro');
end

if contains(plots,'-BCs-')
    figBCs=FindOrCreateFigure('BCs') ; 
    hold off ;  PlotBoundaryConditions(CtrlVar,MUA,BCs);
end

% save data in files with running names
% check if folder 'ResultsFiles' exists, if not create

if strcmp(CtrlVar.UaOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7 ;
    mkdir('ResultsFiles') ;
end

if strcmp(CtrlVar.UaOutputsInfostring,'Last call')==0
    if contains(plots,'-save-')
        %FileName=['ResultsFiles/',sprintf('%07i',round(100*time)),'-TransPlots-',CtrlVar.Experiment]; good for transient runs
        
        FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.UaOutputsCounter),'-TransPlots-',CtrlVar.Experiment];
        
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','time','s','b','S','B','h','u','v','dhdt','dsdt','dbdt','C','AGlen','m','n','rho','rhow','as','ab','GF')
        
    end
end

% only do plots at end of run
%if ~strcmp(CtrlVar.UaOutputsInfostring,'Last call') ; return ; end


if contains(plots,'-sbB-')
    figsbB=FindOrCreateFigure('sbB') ; 
    clf(figsbB)
    if isempty(TRI) ;  TRI = delaunay(x,y); end
    
    %trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,F.B,500,'EdgeColor','none') ; hold on
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,F.s,F.s+100,'EdgeColor','none') ; hold on
    
    
    plot3(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,F.s(I),'ro');
    
    view(45,5); lightangle(-45,10) ; lighting phong ;
    xlabel('y (km)') ; ylabel('x (km)') ; zlabel('z (m)') ;
    %colorbar ; title(colorbar,'(m)')
    hold on
    
    nThickConstraints=numel(find(I));
    title(sprintf('t=%5.1f (a) | Volume=%#-12.7g (m^3) | #%i',CtrlVar.time,TotalIceVolume,nThickConstraints))
    axis normal
    %axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale/80]); axis tight
    hold off
end

if contains(plots,'-V(t)-')
    figV=FindOrCreateFigure('V(t)') ;
    hold on
    plot(CtrlVar.time,TotalIceVolume,'or') ;
    xlabel('time (yr)') ; ylabel('Ice Volume (m^3)') 
end


if contains(plots,'-ubvb-')
    
    figubvb=FindOrCreateFigure('ubvb') ; 
    
    
    PlotFEmesh(MUA.coordinates,MUA.connectivity,CtrlVar)
    hold on
    N=1;
    speed=sqrt(F.ub.*F.ub+F.vb.*F.vb);
    CtrlVar.MinSpeedWhenPlottingVelArrows=max(speed); 
    CtrlVar.VelPlotIntervalSpacing='log10';
    [cbar,uvPlotScale,QuiverHandel]=QuiverColorGHG(x(1:N:end),y(1:N:end),F.ub(1:N:end),F.vb(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g  - circles where F.h<=CtrlVar.ThickMin=%f',CtrlVar.time,CtrlVar.ThickMin )) ; xlabel('x (km)') ; ylabel('y (km)')
    axis equal
    
    hold on
    plot(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,'ro');
    
    %uvPlotScale
    
end

if contains(plots,'-udvd-')
    % plotting horizontal velocities
    if isempty(Figudvd)
        Figudvd=figure; hold off
    else
        try
            Figudvd=figure(Figudvd) ; hold off
        catch
            Figudvd=figure; hold off
        end
    end
    N=1;
    speed=sqrt(ud.*ud+vd.*vd);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; 
    %CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ud(1:N:end),vd(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ud,vd) t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    axis equal tight
    
end

%%
if contains(plots,'-speed-')
    %%
    figure
    speed=sqrt(ub.*ub+vb.*vb);
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,speed,CtrlVar)    ;
    title(sprintf('speed t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    axis equal tight
    %%
    
end
%%

if contains(plots,'-as-')
    %%
    figas=FindOrCreateFigure('as') ; 
    clf(figas)
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.as);
    
    title(sprintf('as t=%-g ',CtrlVar.time)) ; 
    title('Surface mass balance, a_s (m/yr)')
    xlabel('x (km)') ; ylabel('y (km)')
    axis equal tight
    title(cbar,'(m/yr)')  
    %%
    
end

%%

if contains(plots,'-e-')
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

if contains(plots,'-flux gradients-')
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



if contains(plots,'-ub-')
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,ub,CtrlVar)    ;
    title(sprintf('ub t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


end
