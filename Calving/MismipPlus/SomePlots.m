%%

% rename GL0-.mat GL0-10km-.mat *GL0-.mat

isVideo=false;
CurDir=pwd ;
cd ResultsFiles\


RunType(1)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-.mat";


RunType(1)="-MismipPlus-C-Fq1Fk3Fmin80cmin0Fmax100cmax300-Ini5-" ;

RunType(1)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-" ;

RunType(1)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-10km-";
RunType(2)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-5km-";
RunType(3)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-4km-";
RunType(4)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-3km-";
RunType(5)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-2km-";


RunType(1)="-MismipPlus-C-DP-Ini5-c0isGL0-10km-" ;
RunType(2)="-MismipPlus-C-DP-Ini5-c0isGL0-5km-" ;
RunType(3)="-MismipPlus-C-DP-Ini5-c0isGL0-4km-" ;
RunType(4)="-MismipPlus-C-DP-Ini5-c0isGL0-3km-" ;
RunType(5)="-MismipPlus-C-DP-Ini5-c0isGL0-2km-" ;
RunType(6)="-MismipPlus-C-DP-Ini5-c0isGL0-1km-" ;


if isVideo

    
    I=1;  TimeStep=10;  % video

    ReadPlotSequenceOfResultFiles(FileNameSubstring=RunType(I),...
        PlotTimestep=TimeStep,...
        PlotTimeInterval=[0 100],...
        PlotType="-uv-lsf-c-f-mesh-") ;



else

    %% Data Collect

    col=["r","b","c","m","g","k"];
    DataCollect=cell(10);
    Irange=1:6 ;  TimeStep=5 ;  

    for I=Irange

        DataCollect{I}=ReadPlotSequenceOfResultFiles(FileNameSubstring=RunType(I),...
            PlotTimestep=TimeStep,...
            isCenterlineProfile=true,...
            PlotType="-collect-",...
            PlotTimeInterval=[0 200]);

    end

    Figxc=FindOrCreateFigure("xc(t)") ; clf(Figxc);

    for I=Irange

        plot(DataCollect{I}.time,DataCollect{I}.xcMaxCenterLine/1000,'-o',Color=col(I))
        hold on
        plot(DataCollect{I}.time,DataCollect{I}.xcMinCenterLine/1000,'-+',Color=col(I))
    end

    xlabel("t (yr)",Interpreter="latex")
    ylabel("$x_c(t)$ along centerline (km)",Interpreter="latex")
    lgd=legend("10 km max","10km min","5 km max","5 km min","4 km max","4 km min","3 km max","3km min","2 km max","2km min","1km min","1km max",interpreter="latex") ; 
    lgd.NumColumns=3;

    Figxc=FindOrCreateFigure("Ice Volume") ; clf(Figxc);

    for I=Irange
        iTime=find(abs(DataCollect{I}.time-5)<0.01) ;  % use time=5 as the reference
        dVolume=DataCollect{I}.IceVolume-DataCollect{I}.IceVolume(iTime);
        plot(DataCollect{I}.time,dVolume/1e9,'-o',Color=col(I))

        hold on
    end

    xlabel("t (yr)",Interpreter="latex")
    ylabel("Ice Volume ($\mathrm{km}^3$)",Interpreter="latex")


    legend("10 km","5 km","4 km","3 km","2 km","1 km",interpreter="latex")

    %%
    FigV=FindOrCreateFigure("Convergence") ; clf(FigV);
    
    for I=Irange

        iTime5=find(abs(DataCollect{I}.time-5)<0.01) ;  % use time=5 as the reference
        iTime50=find(abs(DataCollect{I}.time-50)<0.01) ;  % use time=5 as the reference
        iTime50=iTime50(1); 
        V(I)=DataCollect{I}.IceVolume(iTime50)-DataCollect{I}.IceVolume(iTime5); 
    end

    plot([10 5 4 3 2 1],V/1e9,"-o")
    xlabel("Element Size (km)",Interpreter="latex")
    ylabel("Ice Volume Change ($\mathrm{km}^3$)",Interpreter="latex")
    %%

end







end

cd(CurDir)