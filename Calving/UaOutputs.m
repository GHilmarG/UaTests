
function UserVar=UaOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)



v2struct(F);
time=CtrlVar.time;

plots='-plot-flowline-mapplane-';
plots='-plot-mapplane-flowline-';
plots='-plot-mapplane-save-speedcalving-';
plots='-plot-flowline-save-';

if ~contains(RunInfo.Message,"-RunStepLoop-")
    return
end

if contains(plots,'-save-')
    
    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create
    OutputsDirectory="Results" ; 
    
%     if exist(fullfile(cd,UserVar.Outputsdirectory),'dir')~=7
%         mkdir(OutputsDirectory) ;
%     end
    
    if strcmp(CtrlVar.UaOutputsInfostring,'Last call')==0
        
        %
        %
        %
        
        FileName=sprintf('%s/%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            OutputsDirectory,round(100*time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','F','BCs')
        
    end
    
end

if contains(plots,'-plot-')
    
    figsWidth=1000 ; figHeights=300;
    GLgeo=[]; xGL=[] ; yGL=[];
    %%
    if contains(plots,'-mapplane-')
        
        FigureName='map plane view'; Position=[50 50 figsWidth 3*figHeights];
        fig100=FindOrCreateFigure(FigureName,Position) ;
        clf(fig100) 
        
        
        subplot(4,1,1)
        hold off
        PlotMeshScalarVariable(CtrlVar,MUA,F.h); title(sprintf('h at t=%g',time))
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        %Plot_sbB(CtrlVar,MUA,s,b,B) ; title(sprintf('time=%g',time))
        
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ; 
        
        subplot(4,1,2)
        hold off
        QuiverColorGHG(MUA.coordinates(:,1),MUA.coordinates(:,2),ub,vb,CtrlVar);
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        hold off
        
        subplot(4,1,3)
        hold off
        if CtrlVar.LevelSetMethod
            PlotMeshScalarVariable(CtrlVar,MUA,F.c);   title(sprintf('Calving Rate Field at t=%g',time))
        else
            PlotMeshScalarVariable(CtrlVar,MUA,dhdt);   title(sprintf('dh/dt at t=%g',time))
        end
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        
        subplot(4,1,4)
        hold off
        
        if CtrlVar.LevelSetMethod
            PlotMeshScalarVariable(CtrlVar,MUA,F.LSF);   title(sprintf('Level Set Field at t=%g',time))
            ModifyColormap ; 
        else
            PlotMeshScalarVariable(CtrlVar,MUA,F.ab);   title(sprintf('ab at t=%g',time))
        end
        hold on
        
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        colormap(othercolor('BuOr_12',2048)); ModifyColormap();
        hold off
        
    end
    
    
    if contains(plots,'-Speed-')
        
        FindOrCreateFigure("Speed") ;
        speed=sqrt(F.ub.*F.ub+F.vb*F.vb) ;
        PlotMeshScalarVariable(CtrlVar,MUA,speed);   title(sprintf('speed at t=%g',time))
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        colormap(othercolor('BuOr_12',2048)); ModifyColormap();
        hold off
        
    end
    
    
    if contains(plots,'-speedcalving-')
        
        if isempty(F.c)
            F.c=0;
        end
        
        FindOrCreateFigure("Speed-Calving") ;
        speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
        PlotMeshScalarVariable(CtrlVar,MUA,speed-F.c);
        title(sprintf('speed-calving rate at t=%g',time))
        hold on
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'b');
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'r') ;
        colormap(othercolor('Blues6',2048)); % ModifyColormap();
        hold off
        
        
    end
    
    
    if contains(plots,'-flowline-')
        %%

        if exist('CtrlVarInRestartFile','var') && ~exist('CtrlVar','var')
            CtrlVar=CtrlVarInRestartFile; 
        end

        yProfile=0e3 ;
        if contains(UserVar.RunType,"-1dAnalyticalIceShelf-")
            ugl=300; hgl=1000; xgl=0;
            [s,b,u,x]=AnalyticalOneDimentionalIceShelf(CtrlVar,MUA,F,hgl,ugl,xgl);
            yProfile=0 ;
        end
        
        FigureName='flowline';
        FindOrCreateFigure(FigureName) ;
        
     
        
    
            

        % point selection
        Iy=abs(MUA.coordinates(:,2)-yProfile)< 1000 ;
        
        xProfile=MUA.coordinates(Iy,1) ;  
        [xProfile,Ix]=sort(xProfile) ; 
    
        sProfile=F.s(Iy);
        bProfile=F.b(Iy);
        BProfile=F.B(Iy);
        uProfile=F.ub(Iy) ; 
        if ~isempty(F.c)
            cProfile=F.c(Iy);
            cProfile=cProfile(Ix);
        end
        if ~isempty(F.LSF)
            LSFProfile=F.LSF(Iy);
            LSFProfile=LSFProfile(Is);
        end
        GFProfile=F.GF.node(Iy);
        
        
        
        uProfile=uProfile(Ix) ;
        sProfile=sProfile(Ix); 
        bProfile=bProfile(Ix); 
        BProfile=BProfile(Ix); 
       
       % 
       % GFProfile=GFProfile(I); 
%  Interpolation        
%         Fb=scatteredInterpolant(x,y,F.b);
%         Fs=Fb ; Fs.Values=F.s;
%         xProfile=min(x):1000:max(x);
%         yCentre=yProfile+xProfile*0;
%         sProfile=Fs(xProfile,yCentre);
%         bProfile=Fb(xProfile,yCentre);
%         BProfile=MismBed(xProfile,yCentre);
        
        yyaxis left
        plot(xProfile/1000,sProfile,'b-o')
        hold on
        plot(xProfile/1000,bProfile,'g-o')
        
        plot(x/1000,s,'b-','LineWidth',2)
        plot(x/1000,b,'g-','LineWidth',2)
        % plot(xProfile/1000,BProfile,'k-o')
        ylabel('$z$ (m)','interpreter','latex')
        yyaxis right
        
      %  plot(xProfile/1000,LSFProfile>0,'r-+')
      %  plot(xProfile/1000,GFProfile,'g-o')
        plot(xProfile/1000,uProfile,'r-o')
        hold on
        plot(x/1000,u,'r-','LineWidth',2)
        ylabel('$u$ (m/a)','interpreter','latex')
        
        title(sprintf('Profile along the medial line at t=%g',CtrlVar.time))
        xlabel('$x$ (km)','interpreter','latex') ; 
        legend('$s$ numerical','$b$ numerical','$s$ analytical ','$b$ analytical','$u$ numerical','$u$ analytical','interpreter','latex')
        hold off
        
        
    end
    
    if contains(plots,'-mesh-')
        
        fig300=figure(300);
        fig300.Position=[1200 700 figsWidth figHeights];
        PlotMuaMesh(CtrlVar,MUA)
        hold on
        
        [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r','LineWidth',2);
        title(sprintf('t=%g',time))
        hold off
    end
    
    drawnow
    %%
end

end

