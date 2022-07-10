function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


persistent cyMax cTime iCounter  xBMGL yBMGL


if isempty(cyMax)

    iCounter=0 ;
    cyMax=NaN(1000,1) ;
    cTime=NaN(1000,1) ;

end

if isempty(xBMGL)

    load("GroundingLineForAntarcticaBasedOnBedmachine.mat","xGL","yGL") ;
    % load("GroundingLineForAntarcticaBasedOnBedmachine","GroundingLines") ; xGL=GroundingLines(:,1) ;   yGL=GroundingLines(:,2) ;

    xBMGL=xGL ; yBMGL=yGL ;
    xGL=[] ; yGL=[] ; 
end


%%
if ~isfield(UserVar,'DefineOutputs')

    UserVar.DefineOutputs='-ubvb-LSF-h-save-';
    plots=UserVar.DefineOutputs  ;
    % plots='-ubvb-log10(BasalSpeed)-sbB-ab-log10(C)-log10(AGlen)-save-';
    % plots='-save-';
else
    plots=UserVar.DefineOutputs;
end



CtrlVar.QuiverColorPowRange=2;

%%
GLgeo=GLgeometry(MUA.connectivity,MUA.coordinates,GF,CtrlVar);
TRI=[]; DT=[]; xGL=[] ; yGL=[] ;
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);

%%
if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create
    if CtrlVar.DefineOutputsInfostring == "First call" && ~isfolder(UserVar.ResultsFileDirectory) %  exist(fullfile(cd,UserVar.ResultsFileDirectory),'dir')~=7
        mkdir(UserVar.ResultsFileDirectory)
    end

    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0

        if CtrlVar.ThickMin==1
            
            FileName=sprintf('%s%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
                UserVar.ResultsFileDirectory,...
                round(100*CtrlVar.time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        else

            FileName=sprintf('%s%07i-Nodes%i-Ele%i-Tri%i-kH%i-ThickMin%3.2f-%s.mat',...
                UserVar.ResultsFileDirectory,...
                round(100*CtrlVar.time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.ThickMin,CtrlVar.Experiment);

        end
        FileName=replace(FileName,"--","-");
        FileName=replace(FileName,".","k");
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,"CtrlVar","MUA","F")

    end
end

% only do plots at end of run
% if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end

switch UserVar.MeshResolution

 case 2500

     MRT="1.16 km";

    case 5000

        MRT="2.3 km";

    case 10000

        MRT="4.6 km";

    case 20000

        MRT="9.3 km";

    case 30000

        MRT="14 km";

    otherwise

        error("case not found")

end












if contains(plots,'-BCs-')
    %%
    FindOrCreateFigure("BCs");
    PlotBoundaryConditions(CtrlVar,MUA,BCs);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'r');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    %%
end


if contains(plots,'-LSF-')

    fig= FindOrCreateFigure("LSF") ; clf(fig) ;
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.LSF/1000);
    title(sprintf('LSF at t=%g (yr)',CtrlVar.time)) ;
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,"color","r");
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    title(cbar,"(km)")
    axis tight
    ModifyColormap(0,1028);
    hold off

end





if contains(UserVar.RunType,"-C-")



    % Plot cliff height and calving rate
    
    CliffHeight=min((F.s-F.S),F.h).*F.rho./1000;
    CliffHeight(~F.LSFMask.NodesOn)=NaN ;


    FigCR=FindOrCreateFigure("Calving rate");
    PlotMuaMesh(CtrlVar,MUA); hold on
    cbar=UaPlots(CtrlVar,MUA,F,F.c/1000);
    T=sprintf("Calving rate at t=%g for mesh resolution %s",CtrlVar.time,MRT);
    title(T,Interpreter="latex")
    title(cbar,("(km/yr)"))
    FigCR.Children(1).Label.String="Calving Rate";
    xlabel("xps (km)",Interpreter="latex"); ylabel("yps (km)",Interpreter="latex");
    axis tight
    FigCR.Position=[1000 490 900 820] ; 

    % exportgraphics(FigCR,"CalvingRate.PDF")
    % exportgraphics(FigCH,"CliffHeight.PDF")


    FigCH=FindOrCreateFigure("Cliff height");
    PlotMuaMesh(CtrlVar,MUA); hold on
    cbar=UaPlots(CtrlVar,MUA,F,CliffHeight);
    
    T=sprintf("Cliff Height at t=%g and for mesh resolution %s",CtrlVar.time,MRT);
    title(T)
    title(cbar,("(m)"))
    FigCH.Children(1).Label.String="Cliff Height";
    xlabel("xps (km)",Interpreter="latex"); ylabel("yps (km)",Interpreter="latex");
    axis tight
    FigCH.Position=[15,490 900 820];

    FigCRvCH=FindOrCreateFigure("Calving versus Cliff Height") ;
    clf(FigCRvCH)
    plot(CliffHeight,F.c/1000,'.r')
    xlabel("Cliff Height (m)",Interpreter="latex") ;
    ylabel("Calving Rate (km/yr)",Interpreter="latex") ;
   % title("Anna Crawford et al, 2021, T=-20 C $\alpha$=7.2",Interpreter="latex")
    text(30,14,"Mesh Resolution"+MRT,Interpreter="latex")

    % save("CliffCalving"+MRT+".mat","CliffHeight","c")

    if ~isempty(F.ub)

        FigSpeed=FindOrCreateFigure("Speed along calving front") ;
        clf(FigSpeed)
        speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
        speed(~F.LSFMask.NodesOn)=NaN ;
        PlotMuaMesh(CtrlVar,MUA); hold on
        cbar=UaPlots(CtrlVar,MUA,F,speed/1000);
        xlabel("xps (km)",Interpreter="latex"); ylabel("yps (km)",Interpreter="latex");
        axis tight
        T=sprintf("Speed along calving front, time=%g, Mesh=%s",CtrlVar.time,MRT);
        title(T,Interpreter="latex")

        title(cbar,"(km/yr)")


        FigSpeedvCH=FindOrCreateFigure("Speed and Cliff Height") ;
        clf(FigSpeedvCH)
        plot(CliffHeight,F.c/1000,'or')
        hold on
        plot(CliffHeight,speed/1000,'.k')
        xlabel("Cliff Height (m)",Interpreter="latex") ;
        ylabel("Speed and Calving Rate (km/yr)",Interpreter="latex") ;
  %      T=sprintf("Anna Crawford et al, 2021, T=-20 C $\\alpha$=7.2 at t=%g (yr), Mesh=%s",CtrlVar.time,MRT) ;
  %      title(T,Interpreter="latex") ;
        
        text(0.1,0.9,"Mesh Resolution "+MRT,Interpreter="latex",Units="normalized")
        legend("Calving rate","Ice speed")




    end






 %    exportgraphics(FigCR,"CalvingRate.PDF")
 %    exportgraphics(FigCH,"CliffHeight.PDF")
 %    exportgraphics(FigCRvCH,"AnnaCrawfordCalvingLaw2k3km.jpg")

end

if contains(plots,'-CR-')  % calving rate

    

    fig= FindOrCreateFigure("Calving Rate")  ;  clf(fig) ;
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.c/1000);  % km/yr
    title(sprintf('Calving Rate at t=%g (yr)',CtrlVar.time)) ;
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,"color","r");
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    title(cbar,"(km/yr)")
    axis tight
    hold off


    if ~isempty(yc)
        iCounter=iCounter+1;
        cyMax(iCounter)=max(yc) ;
        cTime(iCounter)=F.time ;


        FindOrCreateFigure(" yc(t)")
        hold off
        plot(cTime,cyMax/1000,'or')
        xlabel("t (yr)")
        ylabel(" y-calving front (km) ")

    end

    if ~isempty(yc)
        CtrlVar.PlotGLs=0;
        [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
        CtrlVar.PlotGLs=1;

        CliffHeight=min((F.s-F.S),F.h).*F.rho./1000;
        FCliffHeight=scatteredInterpolant(F.x,F.y,CliffHeight);
        fcf=FCliffHeight(xc,yc);  % freeboard at calving front
        if ~isempty(F.c)
            FCalvingRate=scatteredInterpolant(F.x,F.y,F.c);
            ccf=FCalvingRate(xc,yc);  % calving rate at calving from
        else
            ccf=xc+NaN;
        end

        speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
        Fspeed=scatteredInterpolant(F.x,F.y,speed);
        ucf=Fspeed(xc,yc) ;

        if  ~isempty(F.c) && numel(xc)==numel(fcf)   && numel(xc)==numel(ccf)  && numel(xc)==numel(yc)

            fig=FindOrCreateFigure("Cliff height along calving fronts") ; clf(fig) ;
            plot3([xc xc]'/1000,[yc yc]'/1000,[fcf*0 fcf]','or-') ; axis equal  ; title("cliff heigh (m)")

            fig=FindOrCreateFigure("Calving rate along calving fronts") ; clf(fig) ;
            plot3([xc xc]'/1000,[yc yc]'/1000,[ccf*0 ccf]','or-') ; daspect([1 1 200]) ; title("calving rate (m/yr)")

            fig=FindOrCreateFigure("ice speed along calving fronts") ; clf(fig) ;
            plot3([xc xc]'/1000,[yc yc]'/1000,[ucf*0 ucf]','or-') ; daspect([1 1 200]) ; title("ice speed (m/yr)")


        else
            fprintf("not the same number of elements in xc and cr or ch \n")

        end
    end

end

if contains(plots,'-PIGprofile-')

    [xp,yp,d]=CreatePIGprofile(2);

    Fs=scatteredInterpolant() ;
    Fs.Points=[F.x(:) ,F.y(:)];
    Fb=Fs;
    FB=Fs;
    Fs.Values=F.s;
    Fb.Values=F.b;
    FB.Values=F.B;
    sp=Fs(xp,yp) ;
    bp=Fb(xp,yp) ;
    Bp=FB(xp,yp) ;

    FindOrCreateFigure("profile")
    plot(d/1000,sp,'-b')
    hold on
    plot(d/1000,bp,'-b')
    plot(d/1000,Bp,'-k')


    if ~isempty(F.LSF)
        FLSF=Fs;
        FLSF.Values=F.LSF;
        LSFp=FLSF(xp,yp) ;
        plot(d/1000,LSFp/1000,'r')
    end


    title(sprintf('PIG profile at t=%g (yr)',CtrlVar.time),Interpreter="latex") ;
    xlabel(" distance (km) ",Interpreter="latex")
    ylabel("$s$, $b$ and $B$ (m) ",Interpreter="latex")
end


if contains(plots,'-sbB-')
    %%
    FindOrCreateFigure("sbB");
    hold off
    AspectRatio=3;
    ViewAndLight(1)=-40 ;  ViewAndLight(2)=20 ;
    ViewAndLight(3)=30 ;  ViewAndLight(4)=50;
    [TRI,DT]=Plot_sbB(CtrlVar,MUA,F.s,F.b,F.B,TRI,DT,AspectRatio,ViewAndLight);
    %%
end

if contains(plots,'-B-')
    FindOrCreateFigure("B");
    PlotMeshScalarVariable(CtrlVar,MUA,F.B);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'g');
    PlotMuaBoundary(CtrlVar,MUA,'b')
end


if contains(plots,'-ubvb-')
    % plotting horizontal velocities
    %%
    figubvb=FindOrCreateFigure("(ub,vb)") ; clf(figubvb)
    N=1;
    %speed=sqrt(ub.*ub+vb.*vb);
    %CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %
    CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    %CtrlVar.RelativeVelArrowSize=10;

    QuiverColorGHG(F.x(1:N:end),F.y(1:N:end),F.ub(1:N:end),F.vb(1:N:end),CtrlVar);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=1);
    
    plot(xBMGL/CtrlVar.PlotXYscale,yBMGL/CtrlVar.PlotXYscale,'r');
    PlotMuaBoundary(CtrlVar,MUA,'k')
    axis([min(MUA.Boundary.x) max(MUA.Boundary.x)    min(MUA.Boundary.y) max(MUA.Boundary.y)]/CtrlVar.PlotXYscale)
    title(sprintf('(ub,vb) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    %%

end

if contains(plots,'-udvd-')
    % plotting horizontal velocities
    figure
    N=1;
    %speed=sqrt(ud.*ud+vd.*vd);
    %CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed);
    CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ud(1:N:end),vd(1:N:end),CtrlVar);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('(ud,vd) t=%-g ',CtrlVar.time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight

end

if contains(plots,'-e-')
    % plotting effectiv strain rates

    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,u,v,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therfore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);

    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('e t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')

end


if contains(plots,'-log10(AGlen)-')
    %%
    figure
    PlotMeshScalarVariable(CtrlVar,MUA,log10(AGlen));
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('log_{10}(AGlen) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    title(colorbar,'log_{10}(yr^{-1} kPa^{-3})')
    %%
end


if contains(plots,'-log10(C)-')
    %%
    figure
    PlotMeshScalarVariable(CtrlVar,MUA,log10(C));
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    PlotMuaBoundary(CtrlVar,MUA,'b')
    title(sprintf('log_{10}(C) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    title(colorbar,'log_{10}(m yr^{-1} kPa^{-3})')
    %%
end


if contains(plots,'-C-')

    figure
    PlotElementBasedQuantities(MUA.connectivity,MUA.coordinates,C,CtrlVar);
    title(sprintf('C t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')

end


if contains(plots,'-log10(SurfSpeed)-')

    us=ub+ud;  vs=vb+vd;
    SurfSpeed=sqrt(us.*us+vs.*vs);

    FindOrCreateFigure("SurfSpeed") ;
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,log10(SurfSpeed),CtrlVar);
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,'k');
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);
    PlotMuaBoundary(CtrlVar,MUA,'b')

    title(sprintf('log_{10}(Surface speed) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)')
    title(colorbar,'log_{10}(m/yr)')
end



if contains(plots,'-log10(BasalSpeed)-')
    BasalSpeed=sqrt(ub.*ub+vb.*vb);
    FindOrCreateFigure("Basal Speed")  ;
    PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,log10(BasalSpeed),CtrlVar);
    hold on
    plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    title(sprintf('log_{10}(Basal speed) t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'log_{10}(m/yr)')
end




if contains(plots,'-ab-')
    %%
    figure

    PlotMeshScalarVariable(CtrlVar,MUA,ab)
    hold on
    plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    title(sprintf('ab t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'(m/yr)')
    axis equal
    %%
end


if contains(plots,'-as-')
    %%
    figure
    PlotMeshScalarVariable(CtrlVar,MUA,as)
    hold on
    plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    title(sprintf('as t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'(m/yr)')
    axis equal
    %%
end

if contains(plots,'-h-')
    %%
    fig=FindOrCreateFigure("Ice thickness");  clf(fig) ;

    PlotMeshScalarVariable(CtrlVar,MUA,F.h);
    hold on

    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,"color","r");
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,color="w",LineWidth=2);
    [xp,yp,d]=CreatePIGprofile(2);
    plot(xp/CtrlVar.PlotXYscale,yp/CtrlVar.PlotXYscale,'r') ;

    I=F.h<=CtrlVar.ThickMin;
    plot(MUA.coordinates(I,1)/CtrlVar.PlotXYscale,MUA.coordinates(I,2)/CtrlVar.PlotXYscale,'.r')
    title(sprintf('h t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'(m/yr)')
    axis equal
    %%
end
%%


if contains(plots,'-dhdt-')
    %%
    fig=FindOrCreateFigure("-dh/dt-"); clf(fig) ;
    PlotMeshScalarVariable(CtrlVar,MUA,F.dhdt);
    hold on
    ModifyColormap(0,1028);
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,"color","r");
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,color="w",LineWidth=2);
    I=F.h<=CtrlVar.ThickMin;
    plot(MUA.coordinates(I,1)/CtrlVar.PlotXYscale,MUA.coordinates(I,2)/CtrlVar.PlotXYscale,'.r')
    title(sprintf('dh/dt t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'(m/yr)')
    axis equal
    %%
end
%%


if contains(plots,'-speed-')
    %%
    speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ; 
    fig=FindOrCreateFigure("-speed-"); clf(fig) ;
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,speed);
    hold on

    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF,GLgeo,xGL,yGL,"color","r");
    [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,color="w",LineWidth=2);
    %caxis([0 3000]);
    ModifyColormap(0,1028);
    title(cbar,"(m/yr)");
    title(sprintf('speed t=%-g ',CtrlVar.time)) ; xlabel('x (km)') ; ylabel('y (km)') ; title(colorbar,'(m/yr)')
    axis equal
    %%
end



if contains(plots,'-stresses-')

    figure

    [txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,F.GF,s,b,ub,vb,ud,vd);
    N=10;

    %xmin=-750e3 ; xmax=-620e3 ; ymin=1340e3 ; ymax = 1460e3 ;
    %I=find(x>xmin & x< xmax & y>ymin & y< ymax) ;
    %I=I(1:N:end);
    I=1:N:MUA.Nnodes;

    scale=1e-2;
    PlotTensor(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
    hold on
    plot(x(MUA.Boundary.Edges)/CtrlVar.PlotXYscale, y(MUA.Boundary.Edges)/CtrlVar.PlotXYscale, 'k', 'LineWidth',2) ;
    hold on ; plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    axis equal
    axis([xmin xmax ymin ymax]/CtrlVar.PlotXYscale)
    xlabel(CtrlVar.PlotsXaxisLabel) ;
    ylabel(CtrlVar.PlotsYaxisLabel) ;

end

drawnow limitrate


end
