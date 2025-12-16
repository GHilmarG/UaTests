
%%
%
% driver for ReadPlotSequenceOfResultsFiles2.m
%
% Creates a plot with three panels, showing:
%
%   Surface Elevation Changes,
%   Sea Level Rise and rate of sea level rise
%   A longitudinal profile of geometry
%
%
%
%%
OriginalDirectory=pwd;

UserVar=FileDirectories(UserVar) ;
DFD=UserVar.ResultsFileDirectory;


UserVar.RunString(1)="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
UserVar.RunString(2)="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
UserVar.RunString(3)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
UserVar.RunString(4)="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
UserVar.RunString(5)="ES2k5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500

n= numel(UserVar.RunString); 

DataCollect=cell(n,1);

for iRunString=1:n

    SearchString=replaceBetween(UserVar.RunString(iRunString),"-FR","-","*");
    SearchString=replace(SearchString,"2.5","2k5");
    SearchString=replace(SearchString,"ES","");  % for some reason the output files were named with ES missing
    SearchString="-"+SearchString; % I need this to make a distinction between 5km and 2.5km
    SearchString=replace(SearchString,"--","-");

    TimeStep=10;
    TimeInterval=[0 inf] ;

    CtrlVar.Parallel.uvAssembly.spmd.isOn=false ;
    CtrlVar.Parallel.uvhAssembly.spmd.isOn=false ;

    load("ase_basin_masks.mat","x_crosson_dotson","y_crosson_dotson","x_thwaites","y_thwaites","x_pig","y_pig") ;
    xyBoundary=[x_thwaites(:) y_thwaites(:)] ;
    PlotTypeString="-collect-";
    Square=nan;

    DataCollect{iRunString}=ReadPlotSequenceOfResultFiles2(FileNameSubstring=SearchString,...
        DataFileDirectory=DFD,...
        PlotTimestep=TimeStep,...
        PlotType=PlotTypeString,...
        VAFBoundary=xyBoundary,...
        PlotPolygon=Square,...
        PlotTimeInterval=TimeInterval) ;

    cd(OriginalDirectory)
    fprintf("==============\n")
end

%%

% 30km = 14km                        9.806 km
% 20km = 9.3km                       6.559 km
% 10km = 4.6km                       3.28  km
%  5km = 2.3km                       1.64  km
% 2.5km = 1.16km                     0.821 km

%%

figSLR=FindOrCreateFigure("VAF") ;  clf(figSLR) ; hold off

AreaOfOcean=3.625e14 ;

for iRunString=1:n

    SLC=-1000*(DataCollect{iRunString}.VAF-DataCollect{iRunString}.VAF(1))/AreaOfOcean;  % units mm

    UserVar.RunString(iRunString)=replace(UserVar.RunString(iRunString),"2k5","2.5")
    MS=str2double(extractBetween(UserVar.RunString(iRunString),"ES","km-"));
    MS=MS/3.049 ;
    DN=sprintf("Mesh size %2.1f km",MS) ;
    plot(DataCollect{iRunString}.time,SLC,"o-",DisplayName=DN) ;
    hold on
end

ylabel("Sea level rise (mm)")
xlabel("year")
legend(Location="best")
title("Sea level contribution for Thwaites catchment")
%%