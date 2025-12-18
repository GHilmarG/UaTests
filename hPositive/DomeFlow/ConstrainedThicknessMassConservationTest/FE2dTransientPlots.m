    function  FE2dTransientPlots(CtrlVar,DTxy,TRIxy,MeshBoundaryCoordinates,GF,dGFdt,coordinates,connectivity,...
        b,B,S,s,h,u,v,wSurf,dhdt,C,AGlen,m,n,xint,yint,wSurfInt,etaInt,exx,eyy,exy,e,time,...
        rho,rhow,a,as,ab)
    
    persistent vidObj Volume VolumeStart VolumeLast dV dVdt velscale

    
    
    x=coordinates(:,1); y=coordinates(:,2);
        
    if ~isempty(strfind(CtrlVar.FE2dTransientPlotsInfostring,'First'))
        vidObj=VideoWriter('hPos.avi');
        open(vidObj)
    end

      
    if ~isempty(strfind(CtrlVar.FE2dTransientPlotsInfostring,'Last'))
        fprintf(CtrlVar.fidlog,' Closing videoobject at t=%-g \n ',time);
        close(vidObj)
        return
    end
    
    figPosition=[150 50 800 600];
    
    
    figure(100) ; 
    set(gcf,'Position',figPosition)
    set(gca,'nextplot','replacechildren');
    
    subplot(2,1,1)
    
    trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,s,'EdgeColor','none') ;
    view(35,50); lightangle(-45,30) ; lighting phong ;
    xlabel('x (km)') ; ylabel('y (km)') ; zlabel('z (m)') ; title(sprintf('Surface at t=%6.2f yr',time))
    % colorbar ; caxis([0 10])%
    
    tt=axis  ; axis([tt(1) tt(2) tt(3) tt(4) 0 600])
    
    subplot(2,1,2)
    JJ=0; col{1}='r' ; col{2}='b' ; col{3}='g';
%     for J=0:2
%         JJ=JJ+1;
%         I=abs(y+J*50e3)<eps ; 
%         sy0=s(I) ; xy0=x(I) ; [xy0,I]=sort(xy0); xy0=xy0/CtrlVar.PlotXYscale; sy0=sy0(I);
%         xl=min(xy0); xr=max(xy0);
%         
%         plot(xy0,sy0,'color',col{JJ},'LineWidth',2) ; hold on
%         %fill([xr xl  xy0' xr],[0 0 sy0'  0],'b')
%     end
    
    I=abs(x)<1 ; sx0=s(I) ; yx0=y(I) ;  vx0=v(I) ; wx0=wSurf(I);
    
    [yx0,I]=sort(yx0); yx0=yx0/CtrlVar.PlotXYscale; sx0=sx0(I); 
    
    %vx0=vx0*0+1;   wx0=vx0*0+1;  
    
    vx0=vx0(I); wx0=wx0(I);
    
    
    plot(yx0,sx0,'color','k','LineWidth',2) ; hold on
    axis([min(x)/CtrlVar.PlotXYscale max(x)/CtrlVar.PlotXYscale 0 600 ])
    aspect=[100 1000 1];  daspect(aspect)   ; daspect(daspect)
    
    %scale=0;
    %velscale=1;
    %quiver(yx0,sx0,velscale*vx0*aspect(1),velscale*wx0*aspect(2),scale)
    
    % x,y,vx,vy,velscale,headscale,sharp,head,col,lw,io,xyratio)
    t=daspect;
    
    velscale=0.2 ; 
    
    headscale=0.3; sharp=0.3; head=1; col='k'; lw=1 ;io=1; xyratio=t(2)/t(1);
    ghg_arrow(yx0,sx0,vx0,wx0,velscale,headscale,sharp,head,'r',lw,io,xyratio)
    
    VolumeLast=Volume;
    Volume=sum(fIntElementwise(connectivity,coordinates,CtrlVar.nip,h,CtrlVar));
    if isempty(VolumeStart) ;  VolumeStart=Volume; VolumeLast=Volume ; end
    dV=Volume-VolumeStart; dVdt=(Volume-VolumeLast)/CtrlVar.dt;
    
    legend('x=0 km')
    
    text(-90,550,sprintf('Volume: %-g (Gm^3)',Volume/1e9))
    text(-90,500,sprintf('dV: %7.3f (Gm^3) ',dV/1e9))
    text(-90,450,sprintf('dV/dt: %7.3f (Gm^3/a) ',dVdt/1e9))
    text(-90,400,sprintf('Constraints: %-i',CtrlVar.NumberOfActiveThicknessConstraints))
    

    xlabel('(km)') ; ylabel('z (m)') ; % colorbar ; caxis([0 10])%
    title(sprintf('Surface profile'))
    
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);
    %error('afds')
    %tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)]);
end