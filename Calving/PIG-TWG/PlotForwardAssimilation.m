

%%




RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE1-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

RunString="ES10km-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

RunString="ES2.5km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE1-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

RunString="ES20km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

RunString="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0M-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0M-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 


RunString="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
RunString="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";

RunString="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";

CtrlVar=Ua2D_DefaultParameters();


UserVar.RunType=RunString ;

UserVar=FileDirectories(UserVar) ;
UserVar.GeometryInterpolant="create the name of inverse restart file from User.RunType";
UserVar.InverseRestartFile="create the name of inverse restart file from User.RunType";

UserVar.Assimilation.tStart=2015;       % typically RunStartYear = Assimilation.tStart
UserVar.Assimilation.tEnd=2020;

UserVar.RunStartYear=UserVar.Assimilation.tEnd ;          
UserVar.RunEndYear=2200;         


[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ;


SearchString=replaceBetween(UserVar.RunType,"-FR","-","*");
SearchString=replace(SearchString,"2.5","2k5");
SearchString=replace(SearchString,"ES","");  % for some reason the output files were named with ES missing

SearchString="00-FR*"+"-"+SearchString; 

% SearchString="*"+SearchString; 
% SearchString=replace(SearchString,"**","*") ;
ResultFiles=dir(UserVar.ResultsFileDirectory+"*"+SearchString+".mat"); 

if isempty(ResultFiles)

    fprintf("No output files found. \n ")
    return

end



xGL0=nan ; yGL0=nan  ;
hVector=nan(10,1000) ;
uVector=nan(10,1000);
vVector=nan(10,1000);
tVector=nan(10,1000) ;
TextVector=strings(10,1) ;
Location(1,:)=[-1585e3 -240e3 ]  ; TextVector(1)="PIG 20km upstream of GL" ;
Location(2,:)=[-1595e3 -271e3 ]  ; TextVector(2)="PIG about 20km downstream of GL" ;

nloc=size(Location,1) ;

Fh=[] ; Fu=[] ; Fv=[]; F=UaFields ; 

tMax=inf;
CreateReferenceFile=true; 
VideoDhDt=VideoWriter(UserVar.VideoFileDirectory+UserVar.RunType+"DhDt.avi"); open(VideoDhDt)
VideoDVel=VideoWriter(UserVar.VideoFileDirectory+UserVar.RunType+"VelocityChanges.avi"); open(VideoDVel)
VideoVel=VideoWriter(UserVar.VideoFileDirectory+UserVar.RunType+"Velocities.avi"); open(VideoVel)
Videoab=VideoWriter(UserVar.VideoFileDirectory+UserVar.RunType+"ab.avi"); open(Videoab)

for ifile=1:numel(ResultFiles)

    FhPrevious=Fh; timePrevious=F.time;
    FuPrevious=Fu;
    FvPrevious=Fv;

    fprintf("%s \n ",ResultFiles(ifile).name)
    load(ResultFiles(ifile).folder+"\"+ResultFiles(ifile).name,"CtrlVar","MUA","F")

    [Emin,Emax,Emean,Emedian]=PrintInfoAboutElementsSizes(CtrlVar,MUA,LengthMeasure="-side of a perfect square of equal area-",print=false);
    MeltParameterisation=extractBetween(UserVar.RunType,"Duvh-","-P");
    Fh=scatteredInterpolant(F.x,F.y,F.h)  ;
    Fu=scatteredInterpolant(F.x,F.y,F.ub)  ;
    Fv=scatteredInterpolant(F.x,F.y,F.vb)  ;

    


    for iloc=1:nloc
         % always estimate changes at the same (x,y) location 
        hVector(iloc,ifile)=Fh(Location(iloc,1),Location(iloc,2)); %
        uVector(iloc,ifile)=Fu(Location(iloc,1),Location(iloc,2));
        vVector(iloc,ifile)=Fv(Location(iloc,1),Location(iloc,2));
        tVector(iloc,ifile)=F.time ;

    end

    RunID=extractBefore(ResultFiles(ifile).name,"-Tri") ; 

    if ifile>1
        CtrlVar.QuiverSameVelocityScalingsAsBefore=false;
    end

    speed=sqrt(F.ub.*F.ub+F.vb.*F.vb);
    MaxSpeedPlot=ceil(max(speed/1000))*1000 ;
    CtrlVar.QuiverColorSpeedLimits=[0 MaxSpeedPlot] ;

    CtrlVar.VelPlotIntervalSpacing="log10" ; CtrlVar.QuiverColorPowRange=3;
    vFig = FindOrCreateFigure("velocity",[50 100  1200 1200]) ; clf(vFig)  ;
    vFig.Position=[50 100  1200 1200] ;
    speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
    mspeed=ceil(max(speed)/1000)*1000;
    mspeed=max(mspeed,6000);
    CtrlVar.QuiverColorSpeedLimits=[0 mspeed] ;

    [cbar,xGL,yGL,xCF,yCF,CtrlVar]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="velocity",CreateNewFigure=false) ;

    if ~isnan(xGL0)
        plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
    end
    Fig=gcf; Fig.Position=[50 100  1200 1200] ;
    FigTitle=sprintf("Velocity at t=%4.2f (yr)",F.time);
    Ti=title(FigTitle,Interpreter="latex");
    SuTi=subtitle(sprintf("Median element size %3.1f km. Melt: %s",Emedian/1000,MeltParameterisation),Interpreter="latex");
    Ti.Color="blue"; Ti.FontSize=14;
    SuTi.Color="blue"; SuTi.FontSize=12;
    frame=getframe(gcf) ;  writeVideo(VideoVel,frame);

    if CreateReferenceFile  % this is just to avoid the first output file containing velocities equal to zero

        if any(abs(F.ub)>0)

            CreateReferenceFile=false ;
            Fh0=Fh; Fu0=Fu ; Fv0=Fv;
            F0=F; % keep a copy of F from first solution
            MUA0=MUA;
            xGL0=xGL ; yGL0=yGL  ;
            RunIDCompare=RunID;


            UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="Inital Surface")
            hold on
            axis([-1722.86513409962         -1479.58176245211          -410.98275862069         -149.399310344828])
            plot(Location(:,1)/1000,Location(:,2)/1000,"or",MarkerFaceColor="r")

            PlotLatLonGrid();

        end

    else

        CtrlVar.QuiverSameVelocityScalingsAsBefore=false;



        % Map initial thickness and velocity fields on current mesh
        % map 0 onto the actual mesh. This is needed for plotting differences in  velocity and thickness fields
        ub0=Fu0(F.x,F.y);
        vb0=Fv0(F.x,F.y);
        h0=Fh0(F.x,F.y);


        % Map last velocity and thickness fields on current mesh.

        ubPrevious=FuPrevious(F.x,F.y);
        vbPrevious=FvPrevious(F.x,F.y);
        hPrevious=FhPrevious(F.x,F.y);


        dub=F.ub-ub0 ; dvb=F.vb-vb0 ;
    

        CtrlVar.QuiverColorSpeedLimits=[0 2000] ; CtrlVar.VelPlotIntervalSpacing="log10" ; CtrlVar.QuiverColorPowRange=3;
        FigTitle=sprintf("Velocity changes at %s compared to %s",RunID,RunIDCompare) ;
        dvFig=FindOrCreateFigure("VelChanges",[50 100  1200 1200]); clf(dvFig);
        dvFig.Position=[50 100  1200 1200] ;
        [cbar,xGL,yGL,xCF,yCF,CtrlVar]=UaPlots(CtrlVar,MUA,F,[dub dvb],FigureTitle="VelChanges",GetRidOfValuesDownStreamOfCalvingFronts=true,CreateNewFigure=false) ;
        Fig=gcf; Fig.Position=[50 100  1200 1200] ;
        hold on ;
        plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
        title(FigTitle)
        subtitle(sprintf("t=%3.1f",CtrlVar.time),interpreter="latex")
        frame=getframe(gcf) ;  writeVideo(VideoDVel,frame);

        dh0=F.h-h0 ;
        
        FigTitle=sprintf("thickness change at %s compared to  %s",RunID,RunIDCompare) ;
        dhFig=FindOrCreateFigure("thickness changes",[50 100  1200 1200]); clf(dhFig);
        dhFig.Position=[50 100  1200 1200] ;
        UaPlots(CtrlVar,MUA,F,dh0,FigureTitle="thickness changes",GetRidOfValuesDownStreamOfCalvingFronts=true,CreateNewFigure=false) ;
        hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
        clim([-100 100])
        title(FigTitle)
        subtitle(sprintf("t=%g",CtrlVar.time),interpreter="latex")

        dtPrevious=(F.time-timePrevious) ;
        if dtPrevious> eps

            dhdtPrevious=(F.h-hPrevious)./dtPrevious;


            fFig=FindOrCreateFigure("rate of thickness change",[50 100  1200 1200])  ; clf(fFig)  ;
            fFig.Position=[50 100  1200 1200] ;


            FigTitle=sprintf("Rate of thickness change from t=%4.2f to  t=%4.2f (yr)",timePrevious,F.time);

            [cbar,xGL,yGL]=UaPlots(CtrlVar,MUA,F,dhdtPrevious,GetRidOfValuesDownStreamOfCalvingFronts=true,CreateNewFigure=false) ;
            hold on ; plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,"k",LineWidth=1)
            hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
            clim([-10 2])
            Ti=title(FigTitle,Interpreter="latex");
            SuTi=subtitle(sprintf("Median element size %3.1f km. Melt: %s",Emedian/1000,MeltParameterisation),Interpreter="latex");
            Ti.Color="blue"; Ti.FontSize=16;
            SuTi.Color="blue"; SuTi.FontSize=14;
            
            title(cbar,["dh/dt","(m/yr)"],interpreter="latex")
            %subtitle(sprintf("t=%g",CtrlVar.time),interpreter="latex")
            %colormap(othercolor("Mtemperaturemap",1028))
            ModifyColormap();
            PlotLatLonGrid();

            frame=getframe(gcf) ;
            writeVideo(VideoDhDt,frame);

        end

        abFig=FindOrCreateFigure("ab",[50 100  1200 1200])  ; clf(abFig)  ;
        abFig.Position=[50 100  1200 1200] ;
        FigTitle=sprintf("Basal melt rate t=%4.2f (yr)",F.time);

        ab=-F.ab ; ab(ab<eps)=nan ; 
        [cbar,xGL,yGL]=UaPlots(CtrlVar,MUA,F,ab,GetRidOfValuesDownStreamOfCalvingFronts=true,CreateNewFigure=false) ;
        set(gca,'ColorScale','log')
        hold on ; plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,"k",LineWidth=1)
        hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
        
        % clim([-150 0]) ; ModifyColormap(GrayLevelRange=0.2);
        Ti=title(FigTitle,Interpreter="latex");
        SuTi=subtitle(sprintf("Median element size %3.1f km. Melt: %s",Emedian/1000,MeltParameterisation),Interpreter="latex");
        Ti.Color="blue"; Ti.FontSize=16;
        SuTi.Color="blue"; SuTi.FontSize=14;

        title(cbar,["$-a_b$","(m/yr)"],interpreter="latex")
        set(gca,'ColorScale','log') ; clim([0.1 150]) ; colormap(othercolor("Greys7",1028))
        PlotLatLonGrid();
        %subtitle(sprintf("t=%g",CtrlVar.time),interpreter="latex")
        
        % PlotLatLonGrid();
        % clim([-150 0]) ; ModifyColormap(GrayLevelRange=0.2);
        frame=getframe(gcf) ;
        writeVideo(Videoab,frame);

    end

    if F.time >= tMax
        break
    end

end

close(VideoDhDt)
close(VideoDVel)
close(VideoVel)
close(Videoab)

%%

for iloc=1:nloc

    fhv=FindOrCreateFigure("h and v versus t "+TextVector(iloc)) ; clf(fhv) ;
    hold off
    yyaxis left
    plot(tVector(iloc,:),hVector(iloc,:)-hVector(iloc,1),"ob-")
    ylabel("$\Delta h (m)$",Interpreter="latex")
    hold on

    yyaxis right
    plot(tVector(iloc,:),uVector(iloc,:),"+r-")
    plot(tVector(iloc,:),vVector(iloc,:),"*r-")
    legend("$\Delta h$","$u$","$v$",interpreter="latex")
    ylabel("$(u,v) (m)$",Interpreter="latex")
    title(TextVector(iloc))
    xlabel("time (yr)",Interpreter="latex")

end
%%

UaPlots(CtrlVar,MUA,F,F.ab,FigureTitle=" ab ")
hold on ; plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,"k",LineWidth=1)
hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
%colormap(othercolor("Mtemperaturemap",1028)) ;
ModifyColormap();

UaPlots(CtrlVar,MUA,F,F.as,FigureTitle=" as ") ; title(" as " ) ; clim([0 2])


%% Comparing dh/dt with measurements


fprintf('Loading interpolants for dhdt data based on Schroeder 2019 and Susheel.\n')
load("FdhdtMeasuredRatesOfElevationChanges2000to2018","Fdh2000to2018")

dhMeasured=Fdh2000to2018(F.x,F.y);

cbar=UaPlots(CtrlVar,MUA,F,dhMeasured,FigureTitle="dh/dt measured");
colormap(othercolor("Mtemperaturemap",1028))
title("Mean rate of thickness change between 2000 and 2010")
subtitle("based on Schroder 2019 and Susheel")
title(cbar,["dh/dt","(m/yr)"],interpreter="latex")
clim([-5 5])
PlotLatLonGrid() ;


%% Calculated dh/dt at end of run

fFig=FindOrCreateFigure("Final rate of thickness change",[50 100  1200 1200])  ; clf(fFig)  ;
fFig.Position=[50 100  1200 1200] ;

FigTitle=sprintf("Rate of thickness change from t=%4.2f to  t=%4.2f (yr)",timePrevious,F.time);



dhdtFinal=dhdtPrevious ;

dhdtFinal(MUA.Boundary.Nodes)=0; 
L=2e3 ; [UserVar,dhdtFinal]=HelmholtzEquation([],CtrlVar,MUA,1,L^2,dhdtFinal,0); 

[cbar,xGL,yGL]=UaPlots(CtrlVar,MUA,F,dhdtFinal,GetRidOfValuesDownStreamOfCalvingFronts=false,CreateNewFigure=false) ;
hold on ; plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,"k",LineWidth=1)
hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
clim([-5 5])
Ti=title(FigTitle,Interpreter="latex");
SuTi=subtitle(sprintf("Median element size %3.1f km. Melt: %s",Emedian/1000,MeltParameterisation),Interpreter="latex");
Ti.Color="blue"; Ti.FontSize=16;
SuTi.Color="blue"; SuTi.FontSize=14;

title(cbar,["dh/dt","(m/yr)"],interpreter="latex")
%subtitle(sprintf("t=%g",CtrlVar.time),interpreter="latex")
colormap(othercolor("Mtemperaturemap",1028))
PlotLatLonGrid();


%%