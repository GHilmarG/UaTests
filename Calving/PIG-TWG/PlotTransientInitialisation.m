

%%



UserVar.RunType="-IR-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";

UserVar.RunType="-FR0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
UserVar.RunType="-FR0to1-ES30km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
UserVar.RunType="-FR0to1-ES10km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";


CtrlVar=Ua2D_DefaultParameters();


UserVar=FileDirectories(UserVar) ;

[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ;


SearchString=replaceBetween(UserVar.RunType,"-FR","-","*");
ResultFiles=dir(UserVar.ResultsFileDirectory+"*"+SearchString+".mat"); 


hVector=nan(10,100) ;
uVector=nan(10,100);
vVector=nan(10,100);
tVector=nan(10,100) ;
TextVector=strings(10,1) ;
Location(1,:)=[-1585e3 -240e3 ]  ; TextVector(1)="PIG 20km upstream of GL" ;
Location(2,:)=[-1590e3 -270e3 ]  ; TextVector(2)="PIG 20km downstream of GL" ;

nloc=size(Location,1) ;


for ifile=1:numel(ResultFiles)



    fprintf("%s \n ",ResultFiles(ifile).name)
    load(ResultFiles(ifile).folder+"\"+ResultFiles(ifile).name,"CtrlVar","MUA","F")

    Fh=scatteredInterpolant(F.x,F.y,F.h)  ;
    Fu=scatteredInterpolant(F.x,F.y,F.ub)  ;
    Fv=scatteredInterpolant(F.x,F.y,F.vb)  ;



    for iloc=1:nloc

        hVector(iloc,ifile)=Fh(Location(iloc,1),Location(iloc,2)); %
        uVector(iloc,ifile)=Fu(Location(iloc,1),Location(iloc,2));
        vVector(iloc,ifile)=Fv(Location(iloc,1),Location(iloc,2));
        tVector(iloc,ifile)=F.time ;

    end

    RunID=extractBefore(ResultFiles(ifile).name,"-Tri") ; 

    if ifile>1
        CtrlVar.QuiverSameVelocityScalingsAsBefore=true;
    end

    [cbar,xGL,yGL,xCF,yCF,CtrlVar]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle=RunID) ;

    if ifile==1
        F0=F; % keep a copy of F from first solution
        xGL0=xGL ; yGL0=yGL  ;
        RunIDCompare=RunID; 

        UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="Inital Surface")
        hold on 
        axis([-1722.86513409962         -1479.58176245211          -410.98275862069         -149.399310344828])
        plot(Location(:,1)/1000,Location(:,2)/1000,"or",MarkerFaceColor="r")
      
        PlotLatLonGrid();
    else

        CtrlVar.QuiverSameVelocityScalingsAsBefore=false;
        F.ub=F.ub-F0.ub ; F.vb=F.vb-F0.vb ;
        FigTitle=sprintf("Velocity changes at %s compared to %s",RunID,RunIDCompare) ;
        [cbar,xGL,yGL,xCF,yCF,CtrlVar]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle=FigTitle) ;
        hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
        title(FigTitle)
        subtitle(sprintf("t=%g",CtrlVar.time),interpreter="latex")

        F.h=F.h-F0.h ;
        FigTitle=sprintf("thickness change at %s compared to  %s",RunID,RunIDCompare) ;
        UaPlots(CtrlVar,MUA,F,F.h,FigureTitle=FigTitle) ;
        hold on ; plot(xGL0/CtrlVar.PlotXYscale,yGL0/CtrlVar.PlotXYscale,"k",LineWidth=1.5)
        clim([-100 100])
        title(FigTitle)
        subtitle(sprintf("t=%g",CtrlVar.time),interpreter="latex")

    end



end


%%

for iloc=1:nloc

    FindOrCreateFigure("30 km h and v versus t "+TextVector(iloc))
    hold off
    yyaxis left
    plot(tVector(iloc,:),hVector(iloc,:)-hVector(iloc,1),"ob-")
    ylabel("$\Delta h (m)$",Interpreter="latex")
    hold on

    yyaxis right
    plot(tVector(iloc,:),uVector(iloc,:),"+r-")
    plot(tVector(iloc,:),vVector(iloc,:),"*r-")
    legend("$\Delta h$","$u$","$v$",interpreter="latex")
    ylabel("$(y,v) (m)$",Interpreter="latex")
    title(TextVector(iloc))
    xlabel("time (yr)",Interpreter="latex")

end
%%