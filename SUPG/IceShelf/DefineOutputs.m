function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


persistent TV iCounter

v2struct(F);
time=CtrlVar.time;


% plots='-ubvb-e-save-';
% plots='-sbB-udvd-ubvb-ub-ub(x)-';


if contains(CtrlVar.DefineOutputsInfostring,"Last call")

    FileName=UserVar.RunType+"-TV" ; 
    save(FileName,"CtrlVar","UserVar","F","TV","RunInfo") 

end

plots='-plot-';

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
if contains(plots,'-plot-')
    
    
    GLgeo=[]; xGL=[] ; yGL=[];
    
    FigName='DefineOutputs';
    fig=findobj(0,'name',FigName);
    if isempty(fig)
        fig=figure('name',FigName);
        fig.Position=[10,10,800,800] ;
    else
        fig=figure(fig);
        hold off
    end
    
    subplot(3,2,1)
    hold off
    PlotMeshScalarVariable(CtrlVar,MUA,h); title(sprintf('h at t=%g',time))
    
    
    subplot(3,2,2)
    hold off
%     speed=sqrt(F.ub.*F.ub+F.vb.*F.vb);
%     PlotMeshScalarVariable(CtrlVar,MUA,speed); title(sprintf('speed at t=%g',time))
%     caxis([min(speed) max(speed)])
%    
    N=1;
    QuiverColorGHG(x(1:N:end),y(1:N:end),F.ub(1:N:end),F.vb(1:N:end),CtrlVar);
    hold on ;
    PlotMuaBoundary(CtrlVar,MUA,'b') 
    title(sprintf('velocity at t=%g',time))
    
    subplot(3,2,3)
    hold off
    PlotMeshScalarVariable(CtrlVar,MUA,dhdt);   title(sprintf('dhdt at t=%g',time))
    
    subplot(3,2,4);
    hold off
    I=abs(MUA.coordinates(:,2))<5000;
    
    plot(F.x/1000,F.h,'o')
    xlabel('x (km)') ; ylabel('h (m)')
    title('Ice thickness profile ')
    
    subplot(3,2,5);
    hold off
    PlotBoundaryConditions(CtrlVar,MUA,BCs,'k');
    axis tight 
    
    subplot(3,2,6);
    hold off
    
    %[exx,eyy,exy,e]=CalcHorizontalNodalStrainRates(CtrlVar,MUA,F.ub,F.vb);
    % PlotMeshScalarVariable(CtrlVar,MUA,e);   title(sprintf('effective strain rates at t=%g',time))
    %Plot_sbB(CtrlVar,MUA,s,b,B);   title(sprintf('sbB at t=%g',time))

   
    IhAbove=F.h>500;
    IhBelow=F.h<500;
    
    xStepBelow=min(F.x(IhBelow));
    xStepAbove=max(F.x(IhAbove));


    hAbove=F.h ; 
    hAbove(~IhAbove)=0 ; 
    AreaAbove=sum(FEintegrate2D(CtrlVar,MUA,double(IhAbove))) ; 
    MeanThicknessAbove=sum(FEintegrate2D(CtrlVar,MUA,hAbove))./AreaAbove ; % this is a scalar
    MTA=hAbove ; MTA(IhAbove)=MeanThicknessAbove ;   % create a vector ahead of the absolute value 
    TVaboveNodal=abs(hAbove-MTA); 

    hBelow=F.h ; 
    hBelow(~IhBelow)=0 ; 
    AreaBelow=sum(FEintegrate2D(CtrlVar,MUA,double(IhBelow))) ; 
    MeanThicknessBelow=sum(FEintegrate2D(CtrlVar,MUA,hBelow))./AreaBelow ; % this is a scalar
    MTB=hBelow ; MTB(IhBelow)=MeanThicknessBelow ;   % create a vector ahead of the absolute value 
    TVbelowNodal=abs(hBelow-MTB); 


    TVabove=sum(FEintegrate2D(CtrlVar,MUA,TVaboveNodal))./AreaAbove ;
    TVbelow=sum(FEintegrate2D(CtrlVar,MUA,TVbelowNodal))./AreaBelow ;

    TVNodal=TVaboveNodal+TVbelowNodal ;


    [dhdxInt,dhdyInt,xint,yint]=calcFEderivativesMUA(F.h,MUA,CtrlVar) ;
    [dhdx,dhdy]=ProjectFintOntoNodes(MUA,dhdxInt,dhdyInt) ;
    ThicknessGradient=sqrt(dhdx.*dhdx+dhdy.*dhdy);
    TV2Nodal=abs(ThicknessGradient) ;  % is this needed..?!
    TV2=sum(FEintegrate2D(CtrlVar,MUA,TV2Nodal)) ;
    TV.Value(iCounter)=TVabove+TVbelow;
    TV.time(iCounter)=F.time;
    TV.Int(iCounter)=TV2 ;
    [hApprox,RMSerror]=ContructReferenceSolution(CtrlVar,UserVar,MUA,F);

    TV.RMS(iCounter)=RMSerror;


    FindOrCreateFigure("TVnodal") ;
    PlotMeshScalarVariable(CtrlVar,MUA,TVNodal);   title(sprintf('TV=%g above at t=%g',TV.Value(iCounter),TV.time(iCounter)))

    FindOrCreateFigure("RMSerror") ;
    UaPlots(CtrlVar,MUA,F,F.h-hApprox) ; title(sprintf('RMSerror=%g at t=%g',RMSerror,F.time));


    if isempty(iCounter)
        iCounter=1;
    else
        iCounter=iCounter+1;
    end

  

end
drawnow
  
TRI=[];
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);


if contains(plots,'-save-')
    
    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create
    
    if exist(fullfile(cd,'ResultsFiles'),'dir')~=7
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
        
        %
        % 
        %
        
        FileName=sprintf('%s/%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            'ResultsFiles',round(100*time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','time','s','b','S','B','h','ub','vb','C','dhdt','AGlen','m','n','rho','rhow','as','ab','GF')
        
    end
    
end

% only do plots at end of run
% if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end

if contains(plots,'-ub(x)-')
    figure
    plot(x/CtrlVar.PlotXYscale,ub)
    title(sprintf('u_b(x) at t=%-g ',CtrlVar.time)) ; xlabel('x') ; ylabel('u_b')
end



if contains(plots,'-sbB-')
    
    FigName='sbB';
    fig=findobj(0,'name',FigName);
    if isempty(fig)
        fig=figure('name',FigName);
        fig.Position=[10,10,500,500] ;
    else
        fig=figure(fig);
        hold off
    end

    if isempty(TRI) ;  TRI = delaunay(x,y); end
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,s,'EdgeColor','none') ; hold on
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,B,'EdgeColor','none') ;
    view(50,20); lightangle(-45,30) ; lighting phong ;
    xlabel('y') ; ylabel('x') ;
    colorbar ; title(colorbar,'(m)')
    hold on
    
    title(sprintf('sbB at t=%#5.1g ',CtrlVar.time))
    axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale]); axis tight
    hold off
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
    title(sprintf('(ub,vb) t=%-g ',CtrlVar.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
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
    title(sprintf('(ud,vd) t=%-g ',CtrlVar.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if contains(plots,'-e-')
    % plotting effectiv strain rates
    
    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,ub,vb,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therfore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    title(sprintf('e t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end

if contains(plots,'-ub-')
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,ub,CtrlVar)    ;
    title(sprintf('ub t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


end
