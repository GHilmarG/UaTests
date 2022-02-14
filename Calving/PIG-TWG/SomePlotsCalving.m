


CurDir=pwd ;


if ~contains(CurDir,"ResultsFiles")
    [~,hostname]=system('hostname') ;
    if contains(hostname,"DESKTOP-G5TCRTD")
        UserVar.ResultsFileDirectory="F:\Runs\Calving\PIG-TWG\ResultsFiles\";
    elseif contains(hostname,"DESKTOP-BU2IHIR")
        UserVar.ResultsFileDirectory="D:\Runs\Calving\PIG-TWG\ResultsFiles\";
    else
        error("case not implemented")
    end
    cd(UserVar.ResultsFileDirectory)
end

% "0001530-Nodes5190-Ele10116-Tri3-kH1000-ucl-muValue1-Ini1-PDist1-CliffHeight-Crawford-GL0-cExtrapolation0-PIG-MeshFile10km"


% ReadPlotSequenceOfResultFiles("FileNameSubstring","cExtrapolation0-PIG-MeshFile10km","PlotTimestep",0.1)
% ReadPlotSequenceOfResultFiles("FileNameSubstring","cExtrapolation0-PIG-MeshFile5km","PlotTimestep",0.1)
% ReadPlotSequenceOfResultFiles("FileNameSubstring","cExtrapolation0-PIG-MeshFile2k5km","PlotTimestep",0.1)

%ReadPlotSequenceOfResultFiles("FileNameSubstring","-PTS-FPtol100-FPIt100-cExtrapolation0-PIG-MeshFile2k5km","PlotTimestep",0.1)
% ReadPlotSequenceOfResultFiles("FileNameSubstring","-PTS-FPtol100-FPIt100-cExtrapolation0-PIG-MeshFile1k25km","PlotTimestep",0.1)
% ReadPlotSequenceOfResultFiles("FileNameSubstring","-PTS-FPtol100-FPIt100-cExtrapolation0-PIG-MeshFile5km","PlotTimestep",0.1)
% ReadPlotSequenceOfResultFiles("FileNameSubstring","-muValue1000-Ini1-PDist1-CliffHeight-Crawford-GL0-PTS-FPtol100-FPIt100-cExtrapolation0-PIG-MeshFile10km","PlotTimestep",0.1)



% ReadPlotSequenceOfResultFiles("FileNameSubstring","ScalesWithNormalVelocity1-BedMachineCalvingFronts-PTS-FPtol100-FPIt100-cExtrapolation0-cDist10000-cOutMax5000-cOutMin1000-cMax5000-PIG-TWG-MeshFile30km-PIG-TWG","PlotTimestep",0.1)


SubString="Tri3-kH1000-Forward-Transient-ucl-muValue1-Ini1-PDist1-CliffHeight-Crawford-GL0-PTS-FPtol100-FPIt100-cExtrapolation0-cDist10000-cOutMax5000-cOutMin1000-cMax5000-PIG-MeshFile5km";
SubString="Tri3-kH1000-Forward-Transient-ucl-muValue1-IniInf-PDist1-ScalesWithNormalVelocity1-BedMachineCalvingFronts-PTS-FPtol100-FPIt100-cExtrapolation0-cDist10000-cOutMax5000-cOutMin1000-cMax5000-PIG-TWG-MeshFile30km-PIG-TWG";

SubString="muValue1-IniInf-PDist1-ScalesWithNormalVelocity+1k2-BedMachineCalvingFronts-PTS-FPtol100-FPIt100-cExtrapolation0-cDist10000-cOutMax5000-cOutMin1000-cMax5000-PIG-TWG-MeshFile30km-PIG-TWG";

SubString="T-C-I-ucl-mu1-IniInf-PDist1-NV-1-BMCF-PIG-TWG-MeshFile30km-PIG-TWG";
SubString="T-C-I-P-DTW-u-cl-mu0k1-Ini-geo-Inf-Strip1-SW=100km-NV-1k5-BMCF-int-PIG-TWG-MeshFile30km-PIG-TWG";

SubString="T-C-I-u-cl-mu0k1-Ini-geo-Inf-Strip1-SW=100km-AD=1-NV-1k5-BMCF-int-PIG-TWG-MeshFile10km-PIG-TWG";
%SubString="T-C-I-u-cl-mu0k1-Ini-geo-Inf-Strip1-SW=100km-AD=1-NV-1k5-BMCF-int-PIG-TWG-MeshFile20km-PIG-TWG";


SubString="T-C-I-u-cl-mu0k1-Ini-geo-Inf-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile30km-PIG-TWG";
SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-Inf-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile30km-PIG-TWG";

SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile30km-PIG-TWG";

SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile20km-PIG-TWG";
%SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile10km-PIG-TWG";
SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile5km-PIG-TWG";

%  1.5 experiments

fEx="1.1";
fEx="RR"; 
switch fEx

    case "1.5"

        SubString(1)="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile30km-PIG-TWG";
        SubString(2)="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile20km-PIG-TWG";
        SubString(3)="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(4)="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile5km-PIG-TWG";

        IRange=4;
    case "1.1"
        % 1.1 experiments

        SubString(1)="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k1-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile30km-PIG-TWG";
        SubString(2)="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k1-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile20km-PIG-TWG";
        SubString(3)="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k1-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(4)="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k1-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
        IRange=3;


    case "RR"

        SubString(1)="T-C-RR-BMCF-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-RR-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile30km-PIG-TWG";
        SubString(2)="T-C-RR-BMCF-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-RR-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile20km-PIG-TWG";
        SubString(3)="T-C-RR-BMCF-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-RR-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        IRange=1:3;
end


CreateVideo=true;  TimeStep=0.25;
CalcVAF=false;

if CreateVideo

    for I=IRange
        ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),PlotTimestep=TimeStep,PlotType="-ubvb-B-") ;
    end

end

col=["r","b","g","m"] ;
DataCollect=cell(2) ; 


if CalcVAF

    fig=FindOrCreateFigure("VAF"); clf(fig);

    for I=IRange

        DataCollect{I}=ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),PlotType="-collect-",PlotTimestep=TimeStep) ;

    end

    for I=IRange

        if I==IRange(1)
            VAF0=DataCollect{I}.VAF(1);  % The ref value
        else
            hold on
        end


        yyaxis left
        plot(DataCollect{I}.time, (DataCollect{I}.VAF-VAF0)/1e9,'-o',color=col(I));
        tt=ylim;
        ylabel(" VAF (km^3)")
        yyaxis right
        AreaOfTheOcean=3.625e14; % units m^2.
        ylim(tt*1000*1e9/3.62e14) ;
        ylabel(" Equvivalent global sea level change (mm)")

        xlabel("time (yr)") ;

        %FindOrCreateFigure("Grounded area");
        %plot(DataCollect.time,DataCollect.GroundedArea/1e6,'-or');
        %xlabel("time (yr)") ; ylabel(" Grounded area(km^2)")

    end



    %legend("30km","20km","10km","5km") ;   title("VC=1.1")
    legend("30km","20km","10km") ;   title("Retreat rate = 1k/yr if v > 1km/yr")

    % f=gcf; exportgraphics(f,'VAF-VC1k1.pdf')

end

cd(CurDir)