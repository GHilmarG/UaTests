


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
% SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile20km-PIG-TWG";
% SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile10km-PIG-TWG";
SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile5km-PIG-TWG";

SubString(1)="T-P-TWISC-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-PIG-TWG-MeshFile10km-PIG-TWG";
SubString(2)="T-P-TWIS-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-PIG-TWG-MeshFile10km-PIG-TWG";


SubString(1)="T-P-TWISC-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-PIG-TWG-MeshFile5km-PIG-TWG";
SubString(2)="T-P-TWIS-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-PIG-TWG-MeshFile5km-PIG-TWG";

SubString(1)="T-P-TWISC-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
SubString(2)="T-P-TWIS-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";

SubString(1)="T-P-TWISC-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
SubString(2)="T-P-TWIS-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";



Experiment="AC-lim" ;
Experiment= "ConvergenceStudy";

switch Experiment

    case "AC-lim"

        MS="5km"; LM=" 2.3km" ;
        MS="10km"; LM=" 4.6km" ;
        MS="20km"; LM=" 9.3km" ;
        MS="30km"; LM=" 14km" ;

        SubString(1)="T-P-TWIS-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile"+MS+"-PIG-TWG";
        %SubString(1)="T-P-TWIS-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile"+MS+"-PIG-TWG";

        SubString(2)="T-P-TWIS-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile"+MS+"-PIG-TWG";
        SubString(3)="T-P-TWISC0-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC0-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile"+MS+"-PIG-TWG";
        IRange=1:3;

        LegendEntry=[...
            "TWIS"+LM,"TWIS AClim"+LM, "TWISC AClim"+LM
            ];

    case "ConvergenceStudy"


        SubString(1)="T-P-TWIS-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile30km-PIG-TWG";
        SubString(2)="T-P-TWIS-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile20km-PIG-TWG";
        SubString(3)="T-P-TWIS-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(4)="T-P-TWIS-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";


        LegendEntry=[...
            "14km","9.3km","4.6km","2.3km",...
            ];

        IRange=1:4;

    case "10km"
        % 10km
        SubString(1)="T-P-TWIS-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(2)="T-P-TWISC-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(3)="T-P-TWISC2-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC2-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(4)="T-P-TWISC5-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC5-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(5)="T-P-TWISC10-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC10-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";


        LegendEntry=[...
            "4.6km: Thwaites ice shelf","4.6km: Thwaites ice shelf removed","4.6km: Thwaites ice shelf removed 2km downstream","4.6km: Thwaites ice shelf removed 5km downstream","4.6km: Thwaites ice shelf removed 10km downstream",...
            ];



    case "5km"

        % 5 km
        SubString(6)="T-P-TWIS-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
        SubString(7)="T-P-TWISC-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
        SubString(8)="T-P-TWISC2-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC2-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
        SubString(9)="T-P-TWISC5-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC5-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
        SubString(10)="T-P-TWISC10-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC10-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";



        LegendEntry=[...
            "2.3km: Thwaites ice shelf","2.3km: Thwaites ice shelf removed","2.3km: Thwaites ice shelf removed 2km downstream","2.3km: Thwaites ice shelf removed 5km downstream","2.3km: Thwaites ice shelf removed 10km downstream",...
            ];

        IRange=6:10;

end

% 30km = 14km
% 20km = 9.3km
% 10km = 4.6km
%  5km = 2.3km

CreateVideo=false;
CalcVAF=true;
ComparisionPlots=false;
Step=5;


if CreateVideo

    for I=IRange


        %ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-h-") ;
        ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-B-") ;
    end
end

col=["k","r","g","m","y","k","c","g","m","y"]  ;

lw=[1 1 1 1 1 2 2 2 2 2 ];
M=["+","o","*","^","s","<"];
DataCollect=cell(10) ;


if CalcVAF



    for I=IRange
        fprintf("\n Reading %s \n",SubString(I))
        DataCollect{I}=ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),PlotType="-collect-",PlotTimestep=Step) ;
        fprintf("done. \n \n")
    end

    fig=FindOrCreateFigure("VAF"); clf(fig);

    for I=IRange

        if I==1
            VAF0=DataCollect{I}.VAF(1);  % The ref value, but this could be re-defined for each run in princple
        else
            hold on
        end


        yyaxis left
        plot(DataCollect{I}.time, (DataCollect{I}.VAF-VAF0)/1e9,'-o',color=col(I),DisplayName=LegendEntry(I),LineWidth=lw(I),Marker=M(I));
        tt=ylim;
        ylabel(" VAF (km^3)")
        yyaxis right


        % ax=gca(); linkprop([ax.YAxis(1) ax.YAxis(2)],'limits') ;

        ylabel(" Equvivalent global sea level change (mm)")

        xlabel("time (yr)") ;

        %FindOrCreateFigure("Grounded area");
        %plot(DataCollect.time,DataCollect.GroundedArea/1e6,'-or');
        %xlabel("time (yr)") ; ylabel(" Grounded area(km^2)")

    end
    AreaOfTheOcean=3.625e14; % units m^2.
    ax=gca();  ax.YAxis(2).Limits=ax.YAxis(1).Limits*1000*1e9/AreaOfTheOcean;
    % linkprop([ax.YAxis(1) ax.YAxis(2)],'limits') ;
    legend
    yyaxis left
    fig.YAxis(1).Exponent=0 ; 
end


%% Comparision plots


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


if ComparisionPlots

    Files(1)="0000000-Nodes83632-Ele166223-Tri3-kH1000-T-P-TWIS-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
    Files(2)="0007000-Nodes83632-Ele166223-Tri3-kH1000-T-P-TWIS-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";


    Files(3)="0000000-Nodes83632-Ele166223-Tri3-kH1000-T-P-TWISC-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
    Files(4)="0007000-Nodes83632-Ele166223-Tri3-kH1000-T-P-TWISC-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";


    %Files(1)="0000000-Nodes21094-Ele41666-Tri3-kH1000-T-P-TWIS-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-PIG-TWG-MeshFile10km-PIG-TWG";
    %Files(2)="0007000-Nodes21094-Ele41666-Tri3-kH1000-T-P-TWIS-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-PIG-TWG-MeshFile10km-PIG-TWG";

    %Files(3)="0000000-Nodes21094-Ele41666-Tri3-kH1000-T-P-TWISC-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-PIG-TWG-MeshFile10km-PIG-TWG";
    %Files(4)="0007000-Nodes21094-Ele41666-Tri3-kH1000-T-P-TWISC-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-PIG-TWG-MeshFile10km-PIG-TWG";





    LS={"Bedrock","Grounding line t=0 yr","Grounding line t=70 yr","Perturbation: Grounding line t=70 yr","Calving front","Pertubation: Calving front"} ;



    for I=1:4
        load(Files(I),"MUA","CtrlVar","F") ; FF(I)= F ;
    end

    fig=FindOrCreateFigure("Comparison") ; clf(fig)

    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,FF(1).B) ;
    hold on

    for I=[1 3 4]
        ls=["-","-","-","--"];
        PlotGroundingLines(CtrlVar,MUA,FF(I).GF,[],[],[],LineWidth=1,LineStyle=ls(I)) ;
    end

    for I=[1 3]
        ls=["-","-","--","--"];
        PlotCalvingFronts(CtrlVar,MUA,FF(I),LineWidth=2,LineStyle=ls(I),color="k") ;
    end

    leg=legend(Interpreter="latex") ;

    leg.String=LS;




    title(cbar,"(m a.s.l.)")
    ModifyColormap
    xlabel("xps (km)")
    xlabel("yps (km)")
    axis tight
end
%%

% f=gcf; exportgraphics(f,'ThwaitesIceShelf.pdf')


cd(CurDir)