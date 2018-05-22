function FE2dTransientPlots(CtrlVar,DTxy,TRIxy,MeshBoundaryCoordinates,GF,dGFdt,coordinates,connectivity,...
        b,B,S,s,h,u,v,wSurf,dhdt,C,AGlen,m,n,xint,yint,wSurfInt,etaInt,exx,eyy,exy,e,time,...
        rho,rhow,a,as,ab)
    
    persistent vidObj Volume VolumeStart dV

    
    
    x=coordinates(:,1); y=coordinates(:,2);
        
    if ~isempty(strfind(CtrlVar.FE2dTransientPlotsInfostring,'First'))
        vidObj=VideoWriter('hPos.avi');
        open(vidObj)
    end
    
    figPosition=[150 50 800 600];
    
    
    figure(100) ; 
    set(gcf,'Position',figPosition)
    set(gca,'nextplot','replacechildren');
    
    subplot(2,1,1)
    
    trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,s,'EdgeColor','none') ;
    view(35,50); lightangle(-45,30) ; lighting phong ;
    xlabel('x (km)') ; ylabel('y (km)') ; zlabel('z (m)') ; title(sprintf('Surface at t=%5.1f yr',time))
    % colorbar ; caxis([0 10])%
    
    tt=axis  ; axis([tt(1) tt(2) tt(3) tt(4) 750 900])
    
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
    
    I=abs(x)<eps ; sx0=s(I) ; yx0=y(I) ; [yx0,I]=sort(yx0); yx0=yx0/CtrlVar.PlotXYscale; sx0=sx0(I);
    plot(yx0,sx0,'color','k','LineWidth',2) ; hold on

    
    Volume=sum(fIntElementwise(connectivity,coordinates,CtrlVar.nip,h,CtrlVar));
    if isempty(VolumeStart) ;  VolumeStart=Volume; end
    dV=Volume-VolumeStart;
    
    legend('x=0 km')
    %text(-90,900,sprintf('Constraints: %-i Volume: %-g (10^9 m)',CtrlVar.NumberOfActiveThicknessConstraints,Volume/1e9))
    text(-90,920,sprintf('Volume: %-g (10^9 m^3)',Volume/1e9))
    text(-90,900,sprintf('dV: %6.2f (m^3) ',dV))
    axis([min(x)/CtrlVar.PlotXYscale max(x)/CtrlVar.PlotXYscale 750 950 ])
    xlabel('(km)') ; ylabel('z (m)') ; % colorbar ; caxis([0 10])%
    title(sprintf('Surface profile'))
    
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);
    
    if ~isempty(strfind(CtrlVar.FE2dTransientPlotsInfostring,'Last'))
        fprintf(CtrlVar.fidlog,' Closing videoobject at t=%-g \n ',time);
        close(vidObj)
    end
    
    %tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)]);
end