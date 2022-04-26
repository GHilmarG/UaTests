%%

% rename GL0-.mat GL0-10km-.mat *GL0-.mat

isVideo=true;
CurDir=pwd ;
cd ResultsFiles\


SubString(1)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-.mat";


SubString(1)="-MismipPlus-C-Fq1Fk3Fmin80cmin0Fmax100cmax300-Ini5-" ;

SubString(1)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-" ;

SubString(1)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-10km-";
SubString(2)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-5km-";
SubString(3)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-4km-";
SubString(4)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-3km-";
SubString(5)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-c0isGL0-2km-";




if isVideo

    
    I=5;  TimeStep=0.5;  % video

    ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),...
        PlotTimestep=TimeStep,...
        PlotTimeInterval=[0 100],...
        PlotType="-uv-lsf-c-f-mesh-") ;



else

    %% Data Collect

    col=["r","b","c","m","g"];
    DataCollect=cell(10);
    Irange=1:5 ;  TimeStep=1 ;  

    for I=Irange

        DataCollect{I}=ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),...
            PlotTimestep=TimeStep,...
            PlotTimeInterval=[0 100],...
            isCenterlineProfile=true,...
            PlotType="-collect-") ;

    end

    Figxc=FindOrCreateFigure("xc(t)") ; clf(Figxc);

    for I=Irange

        plot(DataCollect{I}.time,DataCollect{I}.xcMaxCenterLine/1000,'-o',Color=col(I))
        hold on
        plot(DataCollect{I}.time,DataCollect{I}.xcMinCenterLine/1000,'-+',Color=col(I))
    end

    xlabel("t (yr)",Interpreter="latex")
    ylabel("$x_c(t)$ along centerline (km)",Interpreter="latex")
    lgd=legend("10 km max","10km min","5 km max","5 km min","4 km max","4 km min","3 km max","3km min","2 km max","2km min",interpreter="latex") ; 
    lgd.NumColumns=3;

    Figxc=FindOrCreateFigure("Ice Volume") ; clf(Figxc);

    for I=Irange

        plot(DataCollect{I}.time,DataCollect{I}.IceVolume/1e9,'-o',Color=col(I))
        hold on
    end

    xlabel("t (yr)",Interpreter="latex")
    ylabel("Ice Volume ($\mathrm{km}^3$)",Interpreter="latex")


    legend("10 km","5 km","4 km","3 km","2 km",interpreter="latex")


end

cd(CurDir)