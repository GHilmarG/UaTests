function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

persistent iCount CxMin CxMax Ct

if isempty(iCount)
    iCount=1;
    CxMin=NaN(10000,1);
    CxMax=NaN(10000,1);
    Ct=NaN(10000,1) ; 
else 
    iCount=iCount+1 ; 
end

time=CtrlVar.time;

% plots='-plot-save-';

plots=UserVar.Plots ;


% Because calving rate is only calculated within the integration-point loop,
% it has never been evaluated over the nodes, so I simply make a call to the m-File
% for nodal values. This will only work if the calving law itself does not depend on the
% spatial gradients of the level set function.
F.c=DefineCalvingAtIntegrationPoints(UserVar,CtrlVar,nan,nan,F.ub,F.vb,F.h,F.s,F.S,F.x,F.y) ;


if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if CtrlVar.DefineOutputsInfostring == "First call" && ~isfolder(UserVar.ResultsFileDirectory)
        mkdir(UserVar.ResultsFileDirectory)
    end

    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0  % Only create file at regular intervals as determined by DT
                                                              % so don't create an addtional file at end of run

        if ~endsWith(UserVar.ResultsFileDirectory,"/")  % make sure that the name of the directory ends with an "/"
            UserVar.ResultsFileDirectory= UserVar.ResultsFileDirectory+"/";
        end
        
        FileName=sprintf('%s%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            UserVar.ResultsFileDirectory,...
            round(100*CtrlVar.time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        FileName=replace(FileName,"--","-");
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,"CtrlVar","MUA","F")


    end

if contains(plots,'-plot-')
    


    if UserVar.DoNotPlotVelocitiesDownstreamOfCalvingFronts
  
        F.ub(F.LSFMask.NodesOut)=nan;
        F.vb(F.LSFMask.NodesOut)=nan;
    end
    
    GLgeo=[]; xGL=[] ; yGL=[];
    %%
    fig100=FindOrCreateFigure("4Plots") ; 
    %fig100=figure(100) ;
    %fig100.Position=[50 50 figsWidth 3*figHeights];
    subplot(6,1,1)
    PlotMeshScalarVariable(CtrlVar,MUA,F.h); title(sprintf('h at t=%g (yr)',CtrlVar.time))
    hold on    
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL);
    hold on ; [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    axis tight
    hold off
    %Plot_sbB(CtrlVar,MUA,s,b,B) ; title(sprintf('time=%g',time))
    ttAxis=axis;

    if ~isempty(xc)
       %  Ind=abs(yc-40e3)<CtrlVar.MeshSize ;
        CxMin(iCount)=min(xc) ;
        CxMax(iCount)=max(xc) ;
        Ct(iCount)=F.time ;
    end

    subplot(6,1,2)
    
    QuiverColorGHG(MUA.coordinates(:,1),MUA.coordinates(:,2),F.ub,F.vb,CtrlVar);
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL);
    hold on ; [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    axis(ttAxis)
    hold off
    
    subplot(6,1,3)
    hold off
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.LSF/1000);   title(sprintf('LSF at t=%g (yr)',CtrlVar.time))
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL);
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    title(cbar,"(km)")
    axis tight
    hold off

    subplot(6,1,4)
    % Because calving rate is only calculated within the integration-point loop,
    % is has never been evaluated over the nodes, so I simply make a call to the m-File
    % for nodal values. This will only work if the calving law itself does not depend on the
    % spatial gradients of the level set function.
    % F.c=DefineCalvingAtIntegrationPoints(UserVar,CtrlVar,nan,nan,F.ub,F.vb,F.h,F.s,F.S,F.x,F.y) ;

    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.c);   title(sprintf('Calving rate c at t=%g  (yr)',CtrlVar.time))
    hold on
    title(cbar,"(m/yr)")
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL);
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    axis tight
    hold off
    
    subplot(6,1,5)
    CliffHeight=min((F.s-F.S),F.h) ; 
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,CliffHeight);   title(sprintf('Cliff height at t=%g  (yr)',CtrlVar.time))
    hold on
    title(cbar,"(m)")
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL);
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    axis tight
    hold off

    subplot(6,1,6)
    PlotMuaMesh(CtrlVar,MUA);
    title(sprintf('FE Mesh at t=%g  (yr)',CtrlVar.time))
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL);
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    axis tight
    hold off

    x=MUA.coordinates(:,1);
    y=MUA.coordinates(:,2);
    
    Fb=scatteredInterpolant(x,y,F.b);
    Fs=Fb ; Fs.Values=F.s;
    
    xProfile=min(x):1000:max(x);
    
    yCentre=40e3+xProfile*0;
    sProfile=Fs(xProfile,yCentre);
    bProfile=Fb(xProfile,yCentre);
    
    BProfile=MismBed(xProfile,yCentre);
    
    fig200=FindOrCreateFigure("flowline") ; 
    %fig200=figure(200);
    %fig200.Position=[1200 50 figsWidth 2*figHeights];
    
    plot(xProfile/1000,sProfile,'b')
    hold on
    plot(xProfile/1000,bProfile,'b')
    plot(xProfile/1000,BProfile,'k')
    title(sprintf('t=%g',time))
    hold off
    
    %fig200=FindOrCreateFigure("grounding line and mesh") ; 
    %fig300=figure(300);
    %fig300.Position=[1200 700 figsWidth figHeights];
    %PlotMuaMesh(CtrlVar,MUA);
    %hold on 
    
    %[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'r','LineWidth',2);
    %hold on ; [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    %title(sprintf('t=%g',time))
    %hold off
    
    FigC=FindOrCreateFigure("Calving front") ;
    plot(Ct,CxMin/1000,'ob')
    hold on 
    plot(Ct,CxMax/1000,'*r')
    ylabel("Calving Front Position (km)")
    xlabel("time (yr)")

    drawnow
    %%
end


end