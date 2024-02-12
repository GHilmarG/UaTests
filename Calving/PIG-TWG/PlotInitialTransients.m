



%%

UserVar.RunType="-FT-from0to1-ES5km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-ThickMin0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-SMB_RACHMO2k3_2km-" ;
UserVar.RunType="-FT-from0to1-ES2.5km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-ThickMin0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-SMB_RACHMO2k3_2km-" ;

CtrlVar=Ua2D_DefaultParameters();


UserVar=FileDirectories(UserVar) ;

[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ;

%%



for itime=0:1


    FileName=sprintf('%s%07i-%s.mat',...
        UserVar.ResultsFileDirectory,...
        round(100*itime),CtrlVar.Experiment);
    FileName=replace(FileName,".mat","");
    FileName=replace(FileName,"--","-");
    FileName=replace(FileName,".","k");


    load(FileName,"CtrlVar","MUA","F")

    FigTitle=sprintf("t=%g",itime) ;

    if itime>0
        CtrlVar.QuiverSameVelocityScalingsAsBefore=true;
    end

    [cbar,xGL,yGL,xCF,yCF,CtrlVar]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle=FigTitle) ;

    if itime==0
        F0=F; % keep a copy of F from first solution
        xGL0=xGL ; yGL0=yGL  ;
    else

        CtrlVar.QuiverSameVelocityScalingsAsBefore=false;
        F.ub=F.ub-F0.ub ; F.vb=F.vb-F0.vb ;
        FigTitle=sprintf("Velocites at t=%g compared to t=0",itime) ;
        [cbar,xGL,yGL,xCF,yCF,CtrlVar]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle=FigTitle) ;
        hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
        title(FigTitle)

        F.h=F.h-F0.h ;
        FigTitle=sprintf("thickness change from t=0 to  t=%g",itime) ;
        UaPlots(CtrlVar,MUA,F,F.h,FigureTitle=FigTitle) ;
        hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
        clim([-100 100])
        title(FigTitle)

    end



end

%%