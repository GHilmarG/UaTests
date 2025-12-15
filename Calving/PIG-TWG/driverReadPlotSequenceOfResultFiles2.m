

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


NewRuns=true ;
UseDefineRunString=true;  % use DefineRunString.m to define the UserVar.RunString

TimeStep=1;
TimeInterval=[0 inf] ;
xyBoundary=nan;


if NewRuns

    OriginalDirectory=pwd;

    if UseDefineRunString

        UserVar.RunString=DefineRunString();

    else

        % RunType="Weertman-MRIM6HadGEM2-abMask0A-P-BCVel";
        RunType="Weertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel";
        iRunType=2;
        % RunType="Weertman-Duvh-MRZERO-P-BCVel";

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

        UserVar.RunString=RunString(iRunType) ;

    end

    UserVar=FileDirectories(UserVar) ;
    %cd(UserVar.ResultsFileDirectory)
    DFD=UserVar.ResultsFileDirectory;

    SearchString=replaceBetween(UserVar.RunString,"-FR","-","*");
    SearchString=replace(SearchString,"2.5","2k5");
    SearchString=replace(SearchString,"ES","");  % for some reason the output files were named with ES missing
    SearchString="-"+SearchString; % I need this to make a distinction between 5km and 2.5km
    SearchString=replace(SearchString,"--","-");

else

    % Older run files

    SubString(9)="-FT-P-Duvh-TWIS-MR4-SM-TM001-5km-Alim-Clim-Ca1-Cs100000-Aa1-As100000-InvMR5.mat"            ; % no files
    SubString(10)="-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-5km-Alim-Clim-Ca1-Cs100000-Aa1-As100000-.mat"        ; % 500 years with collapse, about 45 cm, and 3.5 mm/yr
    SubString(11)="-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Clim-Ca1-Cs100000-Aa1-As100000-.mat"       ; % 500 years with collapse, about 60 cm rise over 500 years, up to 2.5mm/yr
    SubString(12)="-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Clim-Ca1-Cs100000-Aa1-As100000-.mat"       ; % 500 years with collapse, about 13 cm rise over 500 years
    SubString(13)="-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-30km-Alim-Clim-Ca1-Cs100000-Aa1-As100000-.mat"       ; % not available

    SearchString=SubString(13) ;

    DFD="D:\Runs\Calving\PIG-TWG\ResultsFiles\" ;

end


CtrlVar.Parallel.uvAssembly.spmd.isOn=false ;
CtrlVar.Parallel.uvhAssembly.spmd.isOn=false ;

MeltSquareString=extractBetween(UserVar.RunString,"-MS","-",Boundaries="inclusive");

UserVar.MeltSquareWidth=str2double(extractBetween(MeltSquareString,"W","L",Boundaries="exclusive"));
UserVar.MeltSquareLength=str2double(extractBetween(MeltSquareString,"L","a",Boundaries="exclusive"));
UserVar.MeltSquareMelt=str2double(extractBetween(MeltSquareString,"a","-",Boundaries="exclusive"));

Origin=nan;
Direction=nan;
Width=UserVar.MeltSquareWidth*1000;
Length=UserVar.MeltSquareLength*1000;
Square=CreateSquare(Origin,Direction,Width,Length) ;



ReadPlotSequenceOfResultFiles2(FileNameSubstring=SearchString,...
    DataFileDirectory=DFD,...
    PlotTimestep=TimeStep,...
    PlotType="-s-VAF-dSLRdt-",...
    VAFBoundary=xyBoundary,...
    PlotPolygon=Square,...
    PlotTimeInterval=TimeInterval) ;

cd(OriginalDirectory)
%%
