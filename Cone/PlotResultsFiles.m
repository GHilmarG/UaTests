CurDir=pwd;



F{1}='Cones'; D{1}='ResultsFiles'; 

plots='';  % defaults to B
plots='-sbB-';
       
%% get bed and plot
load BackgroundMeshFile
[~,~,~,Background]=DefineGeometry(' ',coordinates,[],'B');
xBackground=coordinates(:,1); yBackground=coordinates(:,2);  
triBackground=TriFE(connectivity);

%% 
 load('MyBlueWhiteColormap','BlueWhiteColormap')
 colormap(BlueWhiteColormap)
    


for J=1:1


    FileName=F{J};
    
    close all
    vidObj = VideoWriter([F{J},plots,'.avi']); 
    vidObj.FrameRate=5;
    
    open(vidObj);
    cd(D{J})
    list=dir(['*',F{J},'*.mat']);
    nFiles=length(list);
    
    
    
    
    %FigHandleh=figure('Position',[100 50 1100 800],'units','pixel') ;
    FigHandleh=figure('Position',[100 50 1000 600],'units','pixel') ;
    
   
    for I=1:nFiles
    % for I=1:10
        
        %load(list(I,:))
        try
            load(list(I).name)
            fprintf(' %s \n ',list(I).name)
        catch
            fprintf('could not load %s \n ',list(I).name)
        end
        %[Boundary.Nodes,Boundary.EdgeCornerNodes]=FindBoundaryNodes(connectivity,coordinates);
        
        x=coordinates(:,1); y=coordinates(:,2);
        
        ELA=2900;
        
        
        if time>=500 && time < 1000
            ELA=4200;
        elseif time>=1500 && time < 2000
            ELA=2200;
        elseif time>=3000 && time < 3500
            ELA=4400;
        end
        
        % Ice thickness
        
        figure(FigHandleh)
        %set(0,'CurrentFigure',FigHandleh)
        
        %trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,h-hinitial,'EdgeColor','none') ;
        %title(sprintf('Thickness change at t=%#5.1f (year)',time))
        %set(gcf,'Colormap',mycmap)
        
        switch plots
            case ''
                trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,B,'EdgeColor','none') ;
                view(0,90); lightangle(-45,30) ; lighting phong ;
                title(sprintf('Grounding line at t=%#5.1f (year). ',time))
                hold on
                axis equal tight
                axis([635 652 135 160])
                
                xlabel('xps (km)') ;  ylabel('yps (km)') ;
                colorbar ; title(colorbar,'Bedrock')  ;
                ylabel(colorbar,' (m a.s.l.)')  ; %caxis([-2200 100])
            case '-sbB-'
                
               
                
                col=h;
                ind=b>ELA; col(ind)=max(h);
                ph=trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,s,col,'EdgeColor','none') ;
                colorbar ; 
                %title(colorbar,'Ice thickness below ELA (m)')  ; 
                ylabel(colorbar,'Ice thickness below ELA (m)')  ; 
                caxis([0 max(h)])
                %set(ph,'facecolor',[255/255 245/255 238/255],'edgecolor','none');
                hold on
                
                pBackground=trisurf(triBackground,xBackground/1000,yBackground/1000,Background,'EdgeColor','none') ;
                %set(pBackground,'facecolor',[139/255 69/255 19/255],'edgecolor','none');
                set(pBackground,'facecolor',[0/255 250/255 150/255],'edgecolor','none');
                % trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
                 
                %colormap('jet')
               % trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,B,'EdgeColor','none') ;
                view(30,20); 
                xp=1000*cos(2*pi*time/100); yp=1000*sin(2*pi*time/100);
                campos([xp yp 40000])
                camtarget([0 0 3000])
                camva(10)
                lightangle(-25,30) ; lighting phong ;
                axis([-100 100 -100 100 1000 5000])
                tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) 5*tt(3)]);
                title(sprintf('t=%#5.1f (year). ELA=%-g ',time,ELA))
                grid off
                xlabel('(km)') ; ylabel('km') ; zlabel('(m a.s.l.)')
                colormap(BlueWhiteColormap)
                %patch([-100 100 100 -100],[-100 -100 100 100],[2000 2000 2000 2000],[1 1 1 1])
                %alpha(.5)
                %ylabel(colorbar,'(m a.s.l.)')  
            otherwise
                error(' case not found \n')
        end
        
        
        
        %colorbar ; %caxis([-1200 100])
        %axis([-1700 -1460 -370 -130])
        hold off
        
        currFrame = getframe(gcf);
        writeVideo(vidObj,currFrame);
        
        
        
    end
    
    close(vidObj);
    fprintf('\n video file closed \n')
    cd(CurDir)
end

cd(CurDir)


