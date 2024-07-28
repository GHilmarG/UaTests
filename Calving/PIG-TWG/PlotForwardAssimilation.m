

%%



UserVar.RunType="-IR-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
UserVar.RunType="-FR0to1-ES10km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
UserVar.RunType="-FR0to1-ES30km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
UserVar.RunType="-FR0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";

UserVar.RunType="-FR0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";


UserVar.RunType="-FR4to5-30km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
UserVar.RunType="-FR4to5-10km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
UserVar.RunType="-FR4to5-5km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";


UserVar.RunType="ES5km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
UserVar.RunType="ES5km-Tri3-SlidWeertman-Duvh-MRlASE2-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";

UserVar.RunType="ES5km-Tri3-SlidWeertman-Duvh-MRlASE1-abMask0-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
UserVar.RunType="ES5km-Tri3-SlidWeertman-Duvh-MRlASE2-abMask0-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";



CtrlVar=Ua2D_DefaultParameters();


UserVar=FileDirectories(UserVar) ;
UserVar.GeometryInterpolant="create the name of inverse restart file from User.RunType";
UserVar.InverseRestartFile="create the name of inverse restart file from User.RunType";

[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ;


SearchString=replaceBetween(UserVar.RunType,"-FR","-","*");
SearchString=replace(SearchString,"ES","");  % for some reason the output files were named with ES missing
% SearchString="*"+SearchString; 
% SearchString=replace(SearchString,"**","*") ;
ResultFiles=dir(UserVar.ResultsFileDirectory+"*"+SearchString+".mat"); 


hVector=nan(10,100) ;
uVector=nan(10,100);
vVector=nan(10,100);
tVector=nan(10,100) ;
TextVector=strings(10,1) ;
Location(1,:)=[-1585e3 -240e3 ]  ; TextVector(1)="PIG 20km upstream of GL" ;
Location(2,:)=[-1595e3 -271e3 ]  ; TextVector(2)="PIG about 20km downstream of GL" ;

nloc=size(Location,1) ;

Fh=[] ; Fu=[] ; Fv=[]; F=UaFields ; 

tMax=inf;

VideoDhDt=VideoWriter(UserVar.RunType+".avi");
open(VideoDhDt)

for ifile=1:numel(ResultFiles)

    FhPrevious=Fh; timePrevious=F.time;
    FuPrevious=Fu;
    FvPrevious=Fv;

    fprintf("%s \n ",ResultFiles(ifile).name)
    load(ResultFiles(ifile).folder+"\"+ResultFiles(ifile).name,"CtrlVar","MUA","F")



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

    CtrlVar.QuiverColorSpeedLimits=[0 5000] ; CtrlVar.VelPlotIntervalSpacing="log10" ; CtrlVar.QuiverColorPowRange=3;
    [cbar,xGL,yGL,xCF,yCF,CtrlVar]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="velocity") ;

    if ifile==1

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


        F.ub=F.ub-ub0 ; F.vb=F.vb-vb0 ;
    
        CtrlVar.QuiverColorSpeedLimits=[0 2000] ; CtrlVar.VelPlotIntervalSpacing="log10" ; CtrlVar.QuiverColorPowRange=3;
        FigTitle=sprintf("Velocity changes at %s compared to %s",RunID,RunIDCompare) ;
        [cbar,xGL,yGL,xCF,yCF,CtrlVar]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="VelChanges",GetRidOfValuesDownStreamOfCalvingFronts=true) ;
        hold on ; 
        plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
        title(FigTitle)
        subtitle(sprintf("t=%3.1f",CtrlVar.time),interpreter="latex")

        dh0=F.h-h0 ;
        
        FigTitle=sprintf("thickness change at %s compared to  %s",RunID,RunIDCompare) ;
        UaPlots(CtrlVar,MUA,F,dh0,FigureTitle="thickness changes",GetRidOfValuesDownStreamOfCalvingFronts=true) ;
        hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
        clim([-100 100])
        title(FigTitle)
        subtitle(sprintf("t=%g",CtrlVar.time),interpreter="latex")

        dtPrevious=(F.time-timePrevious) ;
        if dtPrevious> eps

            dhdtPrevious=(F.h-hPrevious)./dtPrevious;


            fFig=FindOrCreateFigure("rate of thickness change",[50 100  1200 1200])  ; clf(fFig)  ;
            fFig.Position=[50 100  1200 1200] ;


            FigTitle=sprintf("Rate of thickness change from %4.2f to  %4.2f (yr)",timePrevious,F.time);
            [cbar,xGL,yGL]=UaPlots(CtrlVar,MUA,F,dhdtPrevious,GetRidOfValuesDownStreamOfCalvingFronts=true,CreateNewFigure=false) ;
            hold on ; plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,"k",LineWidth=1)
            hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
            clim([-30 30])
            title(FigTitle,Interpreter="latex")
            title(cbar,["dh/dt","(m/yr)"],interpreter="latex")
            %subtitle(sprintf("t=%g",CtrlVar.time),interpreter="latex")
            colormap(othercolor("Mtemperaturemap",1028))
            PlotLatLonGrid();

            frame=getframe(gcf) ;
            writeVideo(VideoDhDt,frame);

        end


    end

    if F.time >= tMax
        break
    end

end

close(VideoDhDt)

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

%%