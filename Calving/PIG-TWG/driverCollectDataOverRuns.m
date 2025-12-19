
%%
%
% driver for ReadPlotSequenceOfResultsFiles2.m
%
%
%%
OriginalDirectory=pwd;
UserVar=[];
UserVar=FileDirectories(UserVar) ;
DFD=UserVar.ResultsFileDirectory;
% 
% 
% UserVar.RunString(1)="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
% UserVar.RunString(2)="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
% UserVar.RunString(3)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
% UserVar.RunString(4)="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
% UserVar.RunString(5)="ES2k5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500


% UserVar.RunString(1)="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500
% UserVar.RunString(1)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500

UserVar.RunString(1)="ES2k5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2500

n= numel(UserVar.RunString); 

DataCollect=cell(n,1);

CathmentArea="Thwaites";
%CathmentArea="PIG";

PlotTypeString="-collect-";
TimeStep=1;

for iRunString=1:n

    SearchString=replaceBetween(UserVar.RunString(iRunString),"-FR","-","*");
    SearchString=replace(SearchString,"2.5","2k5");
    SearchString=replace(SearchString,"ES","");  % for some reason the output files were named with ES missing
    SearchString="-"+SearchString; % I need this to make a distinction between 5km and 2.5km
    SearchString=replace(SearchString,"--","-");

    
    TimeInterval=[0 inf] ;

    CtrlVar.Parallel.uvAssembly.spmd.isOn=false ;
    CtrlVar.Parallel.uvhAssembly.spmd.isOn=false ;

    load("ase_basin_masks.mat","x_crosson_dotson","y_crosson_dotson","x_thwaites","y_thwaites","x_pig","y_pig") ;

    switch CathmentArea
        case "Thwaites"
            xyBoundary=[x_thwaites(:) y_thwaites(:)] ;
        case "PIG"
            xyBoundary=[x_pig(:) y_pig(:)] ;
        otherwise
            error("case not found")
    end

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

    UserVar.RunString(iRunString)=replace(UserVar.RunString(iRunString),"2k5","2.5");
    MS=str2double(extractBetween(UserVar.RunString(iRunString),"ES","km-"));
    MS=MS/3.049 ;
    DN=sprintf("Mesh size %2.1f km",MS) ;
    plot(DataCollect{iRunString}.time,SLC,"o-",DisplayName=DN) ;
    hold on
end

ylabel("Sea level rise (mm)")
xlabel("year")
legend(Location="best")
title("Sea level contribution for "+CathmentArea+" catchment")

savefig(figSLR,"SeaLevelRise_2k5km_"+CathmentArea)

%% Table

TableSLR=[]; 
for iRunString=1:n

    time=DataCollect{iRunString}.time ;
    VAF=DataCollect{iRunString}.VAF ;
    IceVolume=DataCollect{iRunString}.IceVolume;
    GroundedArea=DataCollect{iRunString}.GroundedArea;


    I=~isnan(time);
    time=time(I);
    VAF=VAF(I);
    IceVolume=IceVolume(I);
    GroundedArea=GroundedArea(I);
    SLC=SLC(I);
    UserVar.RunString(iRunString)=replace(UserVar.RunString(iRunString),"2k5","2.5");
    MS=str2double(extractBetween(UserVar.RunString(iRunString),"ES","km-"));
    MS=MS/3.049 ;

     nDataPoints=length(time);

    Experiment=strings(nDataPoints,1)+CathmentArea;
    MeshSize=zeros(nDataPoints,1)+MS;

    T=table(Experiment,MeshSize,time,SLC,VAF,IceVolume,GroundedArea);
    TableSLR=[TableSLR;T] ; 
end

save(CathmentArea+"Table_2k5km_.mat","TableSLR")

%% netcdf


%% Table


for iRunString=1:n

    time=DataCollect{iRunString}.time ;
    VAF=DataCollect{iRunString}.VAF ;
    IceVolume=DataCollect{iRunString}.IceVolume;
    GroundedArea=DataCollect{iRunString}.GroundedArea;


    I=~isnan(time);

    time_thw=time(I);
    vaf_thw=VAF(I);
    icevolume_thw=IceVolume(I);
    groundedarea_thw=GroundedArea(I);
    SLC=SLC(I);
    UserVar.RunString(iRunString)=replace(UserVar.RunString(iRunString),"2k5","2.5");
    MS=str2double(extractBetween(UserVar.RunString(iRunString),"ES","km-"));
    MS=MS/3.049 ;

    nDataPoints=length(time);

    MeshSize=zeros(nDataPoints,1)+MS;


    % SLC/VAF for TG
    % outname='Scalars_TG_UNN_Ua_1ka_CF2010.nc';
    outname=CathmentArea+"_UNN_Ua_Hilmar_"+"MeshSize"+num2str(MS)+"km.nc";
    ncid=netcdf.create(outname,'NC_SHARE');

    dim=netcdf.defDim(ncid,'coordinates',length(time_thw));

    varid=netcdf.getConstant('GLOBAL');
    netcdf.putAtt(ncid,varid,'Conventions','CF-1.7');
    netcdf.putAtt(ncid,varid,'info','Model Ua, Geography and Environmental Sciences, Northumbria University, Newcastle Upon Tyne, UK');
    netcdf.putAtt(ncid,varid,'Contact','hilmar.gudmundsson@northumbria.ac.uk');

    tid=netcdf.defVar(ncid,'time','float',dim);
    netcdf.putAtt(ncid,tid,'units','a');
    netcdf.putAtt(ncid,tid,'standard_name','time');

    vafid=netcdf.defVar(ncid,'vaf','float',dim);
    netcdf.putAtt(ncid,vafid,'standard_name','ice volume above flotation');
    netcdf.putAtt(ncid,vafid,'units','m^3');

    ivid=netcdf.defVar(ncid,'iv','float',dim);
    netcdf.putAtt(ncid,ivid,'standard_name','ice volume in total');
    netcdf.putAtt(ncid,ivid,'units','m^3');

    gafid=netcdf.defVar(ncid,'ga','float',dim);
    netcdf.putAtt(ncid,gafid,'standard_name','grounded area with ice');
    netcdf.putAtt(ncid,gafid,'units','m^2');

    netcdf.endDef(ncid);
    netcdf.putVar(ncid,tid,time_thw);
    netcdf.putVar(ncid,vafid,vaf_thw);
    netcdf.putVar(ncid,ivid,icevolume_thw);
    netcdf.putVar(ncid,gafid,groundedarea_thw);

    netcdf.close(ncid);



end

%%
