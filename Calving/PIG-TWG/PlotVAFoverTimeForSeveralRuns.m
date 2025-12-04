

%%
%
% driver for ReadPlotSequenceOfResultsFiles2.m
%
% Creates a plot with three panels, showing surface elevation changes, Sea Level Rise, and a longitudinal profile of geometry
%
%
%
%%

%                       -side of a perfect square of equal area-
% 30km = 14km                        9.806 km
% 20km = 9.3km                       6.559 km
% 10km = 4.6km                       3.28  km
%  5km = 2.3km                       1.64  km
% 2.5km = 1.16km                     0.821 km


%poolobj=parpool("Processes") ;

OriginalDirectory=pwd;

RunType="Weertman-MRIM6HadGEM2-abMask0A-P-BCVel";
RunType="Weertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel";
RunType="Weertman-Duvh-MRZERO-P-BCVel";

TimeStep=5;

switch RunType

    case "Weertman-MRIM6HadGEM2-abMask0A-P-BCVel"

        RunString(1)="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2203
        RunString(2)="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2203
        RunString(3)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2203
        RunString(4)="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2203
        RunString(5)="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2203


    case "Weertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel"

        RunString(1)="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %
        RunString(2)="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %
        RunString(3)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %
        RunString(4)="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %
        RunString(5)="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %

    case "Weertman-Duvh-MRZERO-P-BCVel"


        RunString(1)="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-" ; % 2500
        RunString(2)="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"   ; % 2500#
        RunString(3)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"   ; % 2500
        RunString(4)="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"   ; % 2500
        RunString(5)="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"   ; % 2500

    otherwise

        error(" case not found")

end

LegendText=["0.82 km","2.3 km","4.6 km","6.6 km","9.8 km"];

for I=1:5
    UserVar.RunType=RunString(I) ;
    UserVar=FileDirectories(UserVar) ;
    cd(UserVar.ResultsFileDirectory)

    SearchString=replaceBetween(UserVar.RunType,"-FR","-","*");
    SearchString=replace(SearchString,"2.5","2k5");
    SearchString=replace(SearchString,"ES","");  % for some reason the output files were named with ES missing
    SearchString="-"+SearchString; % I need this to make a distinction between 5km and 2.5km
    SearchString=replace(SearchString,"--","-");

  
    TimeInterval=[0 inf] ;
    xyBoundary=nan;



    DataCollect{I}=ReadPlotSequenceOfResultFiles2(FileNameSubstring=SearchString,PlotTimestep=TimeStep,PlotType="-collect-",PlotTimeInterval=TimeInterval) ;
    cd(OriginalDirectory)

end


%%
FigSLR=FindOrCreateFigure("Sea Level Rise") ;




ColorVector=["b","r","g","c","m"] ;

Tile=tiledlayout(2,1); 

nexttile
for I=1:5


    SLRmm=-(DataCollect{I}.VAF-DataCollect{I}.VAF(1))/362.5e9 ;
    RateOfSeaLevelRise=SLRmm*0+nan ;
    RateOfSeaLevelRise(2:end-1)=(SLRmm(3:end)-SLRmm(1:end-2))./(DataCollect{I}.time(3:end)-DataCollect{I}.time(1:end-2));

    
    plot(DataCollect{I}.time,SLRmm/10,'-',LineWidth=2,Color=ColorVector(I));
    ylabel(" Sea Level Rise (cm)") ;

    hold on
    xlabel("time (yr)") ;

end
lg1=legend(LegendText,Location="northwest") ;
title(lg1,"Uniform mesh resolution:") ; 
nexttile
for I=1:5


    SLRmm=-(DataCollect{I}.VAF-DataCollect{I}.VAF(1))/362.5e9 ;
    RateOfSeaLevelRise=SLRmm*0+nan ;
    RateOfSeaLevelRise(2:end-1)=(SLRmm(3:end)-SLRmm(1:end-2))./(DataCollect{I}.time(3:end)-DataCollect{I}.time(1:end-2));

    plot(DataCollect{I}.time,RateOfSeaLevelRise,'-',LineWidth=2,Color=ColorVector(I));
    ylabel(" Rate of Sea Level Rise (mm/yr)") ;
    hold on
    xlabel("time (yr)") ;

end
lg2=legend(LegendText,Location="northwest"); 
title(lg2,"Uniform mesh resolution:") ; 
FigSLR.Position=[1400 430 1000 775];
Tile.Padding="compact";
Tile.TileSpacing="tight";
Tile.Title.String=RunType;  Tile.Title.Color="b" ; Tile.Title.FontWeight="bold"; Tile.Title.FontSize=16;
%%
%
% figure ; plot(DataCollect.time,DataCollect.GroundedArea/1e6,'-or');
% xlabel("time (yr)") ; ylabel(" Grounded area(km^2)")

%%

save(RunType+"VAF.mat","DataCollect")
%Tile.Title.String="";
exportgraphics(gcf,RunType+"VAF.pdf",ContentType="vector",BackgroundColor="none")
exportgraphics(gcf,RunType+"VAF.png")

%%