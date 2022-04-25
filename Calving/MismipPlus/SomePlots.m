%%

% rename GL0-.mat GL0-10km-.mat *GL0-.mat

isVideo=false;
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

TimeStep=0.5;

if isVideo

    
    I=1;

    ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),...
        PlotTimestep=TimeStep,...
        PlotTimeInterval=[0 100],...
        PlotType="-uv-lsf-c-f-mesh-") ;



else

    %% Data Collect

    col=["r","b","c","m","g"];
    DataCollect=cell(10);
    Irange=1:5 ;

    for I=Irange

        DataCollect{I}=ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),...
            PlotTimestep=TimeStep,...
            PlotTimeInterval=[0 50],...
            PlotType="-collect-") ;

    end

    Figxc=FindOrCreateFigure("xc(t)") ; clf(Figxc);

    for I=Irange

        plot(DataCollect{I}.time,DataCollect{I}.xcMaxCenterLine/1000,'-o',Color=col(I))
        hold on
        plot(DataCollect{I}.time,DataCollect{I}.xcMinCenterLine/1000,'-+',Color=col(I))
    end

    xlabel("t (yr)",Interpreter="latex")
    ylabel("$x_c(t)$ (km)",Interpreter="latex")


    Figxc=FindOrCreateFigure("Ice Volume") ; clf(Figxc);

    for I=Irange

        plot(DataCollect{I}.time,DataCollect{I}.IceVolume/1e9,'-o',Color=col(I))
        hold on
        plot(DataCollect{I}.time,DataCollect{I}.IceVolume/1e9,'-+',Color=col(I))
    end

    xlabel("t (yr)",Interpreter="latex")
    ylabel("Ice Volume ($\mathrm{km}^3$)",Interpreter="latex")





end

cd(CurDir)