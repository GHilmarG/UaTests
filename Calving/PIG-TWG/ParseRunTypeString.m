
%%


function [CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar)

%%
%
% extracts from:
%
%   UserVar.RunType
% 
% 
%
% various model options and set CrtlVar fields accordingly
%
%
%
%
% Files with A and C nodal values obtained from inversion start with InvA and InvC followed by the CtrlVar.Experiment, but with "-FT-" or "-IR-" deleted
%
% Files with A and C interpolants start with FA and FC followed by the CtrlVar.Experiment, but with "-FT-" or "-IR-" deleted.
% These may have to be created/copied from previous runs ahead of first inversion.
%
% Geometry interpolants are either based on bedmachine or a previous run based on the value of "-fromT1toT2-". If T1=0 then
% bedmachine, otherwise the interpolants are created from previous run results at t=T1;
%
%
%
% For example when starting the initial forward run with:
%
%   UserVar.RunType="-FT-from0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-SMB_RACHMO2k3_2km-" ;
%
% then
% 
%   UserVar.GeometryInterpolant="BedMachineGriddedInterpolants.mat";
%   UserVar.FAFile="FA-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-SMB_RACHMO2k3_2km-"
%   UserVar.SurfaceVelocityInterpolant="ITS-LIVE-ANT-G0120-0000-VelocityGriddedInterpolants-nStride2.mat";
%
% The UserVar.FAfile would be a result from a prevous inversion using ITS120 velocities, and Bedmachine2 bed geometry
%
% If, for example, the run is to continue from year 1 to year 2, using velocities and geometry from year 1 of a previous run, and 
%
%   UserVar.RunType="-FT-from0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-Geo_0000100_Vel_0000100-"
%
% then
%
%   UserVar.GeometryInterpolant=       "Fsb_0000100-FT-from0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-SMB_RACHMO2k3_2km-" ;
%   UserVar.SurfaceVelocityInterpolant= "Fuv_0000100-FT-from0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-SMB_RACHMO2k3_2km-" ;
%   UserVar.FAFile=                      "FA_0000100-IR-from0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-SMB_RACHMO2k3_2km-" ;
%   UserVar.FCFile=                      "FC_0000100-IR-from0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-SMB_RACHMO2k3_2km-" ;


%%
%
% rename --no-act --verbose InverseRestartFile IR InverseR*.mat
% rename --no-act --verbose R-Weertman R-SlidWeertman *.mat
%
%%

if nargin==0
    CtrlVar=Ua2D_DefaultParameters(); 
    UserVar=FileDirectories();   
    UserVar.RunType="-FT-from0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-" ;
    UserVar.RunType="-FT-from0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-sbB0000100-uv0000100-";

    % inverse run using ITS120 velocities and Bedmachine2 geometry
    UserVar.RunType="-IR-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-" ;
    
    % inverse run using ITS120 velocities and geometry based on this forward run at time t=1 year
    UserVar.RunType="-IR-from0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";

    % forward run, continuing from t=1 using inversion products FA and FC from  
     UserVar.RunType="-FT-from1to2-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-IR0to1-";


end

%% FT -> forward run

if contains(UserVar.RunType,"FT-")
    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=1;
elseif contains(UserVar.RunType,"IR-")
    CtrlVar.TimeDependentRun=0;
    CtrlVar.InverseRun=1;
end

%% from to : start and end times of run

pat="-from"+digitsPattern+"to";    TimeStart=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;
pat="to"+digitsPattern+"-";      TimeEnd=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;

CtrlVar.time=TimeStart ; CtrlVar.TotalTime=TimeEnd ;
pat="-"+digitsPattern+"km-";   MR=str2double(extract(extract(UserVar.RunType,pat),digitsPattern));

%% ??km : mesh resolution and input file with initial mesh
UserVar.MeshResolution=1000*str2double(extractBetween(UserVar.RunType,"-ES","km-")); 

UserVar.RunType=replace(UserVar.RunType,"-ES","-") ;
CtrlVar.MeshSize=UserVar.MeshResolution ;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize ;

%% Tri? : Element type

pat="-Tri"+digitsPattern+"-";    CtrlVar.TriNodes=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;

%% Slid : Sliding law
CtrlVar.SlidingLaw=extractBetween(UserVar.RunType,"Slid","-");


%% -Duvh-  : Automated deactivation of elements downstream of calving front
if contains(UserVar.RunType,"-Duvh")   % 'Forward-Transient-Calving-Initialisation' ;
    CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=1 ;
else
    CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=0 ;
end

%%
if contains(UserVar.RunType,"-SW")

    CtrlVar.LevelSetMethodStripWidth=1000*str2double(extractBetween(UserVar.RunType,"-SW","-"));

else
    CtrlVar.LevelSetMethodStripWidth=50e3;
end

%% kH  : kH value

CtrlVar.kH=str2double(extractBetween(UserVar.RunType,"-kH","-"));

%% -P- / -C-  : Level set is prescribed as (P) opposed to evolved (C)

if contains(UserVar.RunType,"-P-")

    CtrlVar.LevelSetEvolution="-Prescribed-"   ; % "-prescribed-",
    CtrlVar.LevelSetMethod=1;
    UserVar.CalvingFront0="-BMCF-"; "-BedMachineCalvingFronts-"  ;  % "-GL0-" ; % "-BedMachineCalvingFronts-"  ;

elseif contains(UserVar.RunType,"-C-")

    CtrlVar.LevelSetEvolution="-By solving the level set equation-"   ; % "-prescribed-",
    CtrlVar.LevelSetMethod=1;

    % specify calving law
    if contains(UserVar.RunType,"-Fq")

        UserVar.CalvingLaw.Type="-Fqk-"  ;
        UserVar.CalvingLaw.Fqk.q=str2double(extract(extract(UserVar.RunType,"-Fq"+digitsPattern+"Fk"),digitsPattern));
        UserVar.CalvingLaw.Fqk.k=str2double(extract(extract(UserVar.RunType,"Fk"+digitsPattern+"Fmin"),digitsPattern));
        UserVar.CalvingLaw.Fqk.Fmin=str2double(extract(extract(UserVar.RunType,"Fmin"+digitsPattern+"cmin"),digitsPattern));
        UserVar.CalvingLaw.Fqk.cmin=str2double(extract(extract(UserVar.RunType,"cmin"+digitsPattern+"Fmax"),digitsPattern));
        UserVar.CalvingLaw.Fqk.Fmax=str2double(extract(extract(UserVar.RunType,"Fmax"+digitsPattern+"cmax"),digitsPattern));
        UserVar.CalvingLaw.Fqk.cmax=str2double(extract(extract(UserVar.RunType,"cmax"+digitsPattern+"-"),digitsPattern));

    elseif contains(UserVar.RunType,"-AC")  % Anna Crawford

        if contains(UserVar.RunType,"-ACRR-")

            UserVar.CalvingLaw.Type="-ACRR-"  ; % Anna Crawford as retreat rate (?!)
        else
            UserVar.CalvingLaw.Type="-AC-"  ;
        end
        CtrlVar.LevelSetInitialisationInterval=1 ;
        CtrlVar.DefineOutputsDt=0.01;
        CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-1000;  % This is the constant a1, it has units 1/time.
        CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffCubic=-1;

    elseif contains(UserVar.RunType,"-NV-")

        UserVar.CalvingLaw.Type="-NV-"  ;  % "-ScalesWithNormalVelocity+1.0-"  ;
        UserVar.CalvingLaw.Factor=1.1;

    elseif contains(UserVar.RunType,"-RR-")

        UserVar.CalvingLaw.Type="-RR-"  ;  %  prescribed retreat rate
        UserVar.CalvingLaw.Factor="";

    elseif contains(UserVar.RunType,"-DP")

        if contains(UserVar.RunType,"-DPRR-")
            UserVar.CalvingLaw.Type="-DPRR-"  ;  % Robert DeConto and David Pollard as retreat rate (?!)
        else
            UserVar.CalvingLaw.Type="-DP-"  ;  % Robert DeConto and David Pollard
        end

    else
        error("what calving law?")
    end

else

    CtrlVar.LevelSetMethod=0;

end

%% Minimum ice thickness, also used for level set min ice thickness downstream of calving fronts




pat="-TM"+digitsPattern+"k"+digitsPattern+"-" ; TM=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ; CtrlVar.ThickMin=TM(1)+TM(2)/10 ;
CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin;


%% Inverse regularization parameters
CtrlVar.Inverse.Regularize.logC.ga=str2double(extractBetween(UserVar.RunType,"Ca","-"));
CtrlVar.Inverse.Regularize.logC.gs=str2double(extractBetween(UserVar.RunType,"Cs","-"));
CtrlVar.Inverse.Regularize.logAGlen.ga=str2double(extractBetween(UserVar.RunType,"Aa","-"));
CtrlVar.Inverse.Regularize.logAGlen.gs=str2double(extractBetween(UserVar.RunType,"As","-"));
%%

CtrlVar.Experiment=UserVar.RunType ;

CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
CtrlVar.Experiment=replace(CtrlVar.Experiment,".","k");
CtrlVar.Experiment=replace(CtrlVar.Experiment,"+","p");

%%

VelocityDataSet=extractBetween(UserVar.RunType,"-Vel","-") ; 


if VelocityDataSet=="ITS120"
    UserVar.SurfaceVelocityInterpolant='ITS-LIVE-ANT-G0120-0000-VelocityGriddedInterpolants-nStride2.mat';
    UserVar.VelDataSet="-ITS120-";
elseif VelocityDataSet=="yr1"
     UserVar.VelDataSet="-yr1-";
else
    UserVar.SurfaceVelocityInterpolant='Interpolants/SurfVelMeasures990mInterpolants.mat';
    UserVar.VelDataSet="";
end

%%

if contains(UserVar.RunType,"-uvdhdt-")
    CtrlVar.Inverse.Measurements="-uv-dhdt-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
else
    CtrlVar.Inverse.Measurements="-uv-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
end



   

if contains(UserVar.RunType,"-from0") || ~contains(UserVar.RunType,"-from")
    
    % old naming convection, fine for initial inverse run
    %  The new naming convention is simply to use the UserVar.RunType for the name of the inverse restart file


    InvFile=CtrlVar.SlidingLaw...
        +UserVar.VelDataSet ...
        +"-Ca"+num2str(CtrlVar.Inverse.Regularize.logC.ga)...
        +"-Cs"+num2str(CtrlVar.Inverse.Regularize.logC.gs)...
        +"-Aa"+num2str(CtrlVar.Inverse.Regularize.logAGlen.ga)...
        +"-As"+num2str(CtrlVar.Inverse.Regularize.logAGlen.gs)...
        +"-"+num2str(UserVar.MeshResolution/1000)+"km";

    if contains(UserVar.RunType,"-Alim-")
        InvFile=InvFile+"-Alim-";
    end

    if contains(UserVar.RunType,"-Clim-")
        InvFile=InvFile+"-Clim-";
    end

    if contains(UserVar.RunType,"-uvdhdt-")
        InvFile=InvFile+"-uvdhdt-";
    end

    if contains(UserVar.RunType,"-uvGroup-")
        InvFile=InvFile+"-uvGroup-";
    end

    if contains(UserVar.RunType,"-2024-")
        InvFile=InvFile+"-2024-";
    end

    InvFile=replace(InvFile,"Vel","");
    InvFile=replace(InvFile,"Slid","");

    UserVar.AFile="InvA-"+InvFile;
    UserVar.CFile="InvC-"+InvFile;
    UserVar.FAFile="FA-"+InvFile;
    UserVar.FCFile="FC-"+InvFile;

    InvFile="InverseRestartFile-"+InvFile;



else

    InvFile=UserVar.RunType;
    InvFile=replace(InvFile,"FT-","IR-") ;
    InvFile=replace(InvFile,"--","-") ;
    InvFile=replace(InvFile,"--","-") ;
    UserVar.InverseRestartFile=UserVar.InverseRestartFileDirectory+InvFile;

    UserVar.AFile="InvA-"+InvFile;
    UserVar.CFile="InvC-"+InvFile;
    UserVar.FAFile="FA-"+InvFile;
    UserVar.FCFile="FC-"+InvFile;

end

InvFile=replace(InvFile,".","k");
InvFile=replace(InvFile,"--","-");
InvFile=strip(InvFile,"left","-");



UserVar.InverseRestartFile=UserVar.InverseRestartFileDirectory+InvFile;






UserVar.AFile=UserVar.InversionFileDirectory+UserVar.AFile;
UserVar.CFile=UserVar.InversionFileDirectory+UserVar.CFile;

UserVar.FAFile=UserVar.InversionFileDirectory+UserVar.FAFile;
UserVar.FCFile=UserVar.InversionFileDirectory+UserVar.FCFile;


if contains(UserVar.RunType,"Velyr")  % this implies that the velocity "dataset" is from a previous run


    time=str2double(extractBetween(UserVar.RunType,"-Velyr","-"));
    VelocityDataFile=sprintf('%07i-%s.mat',round(100*time),CtrlVar.Experiment);
    VelocityDataFile=replace(VelocityDataFile,"--","-");

    if contains(UserVar.RunType,"from0")  % if the velocity "data" file is based on the first transient run, then "-vel?-" will not be a part of the file name
        % so must get rid of that

        Vstring=extractBetween(UserVar.RunType,"-Velyr","-",Boundaries="inclusive");
        VelocityDataFile=replace(VelocityDataFile,Vstring,"-"); 

    end

    UserVar.AFile=VelocityDataFile;
    UserVar.CFile=VelocityDataFile;
    UserVar.FAFile="FA-"+VelocityDataFile;
    UserVar.FCFile="FC-"+VelocityDataFile;

    UserVar.AFile=UserVar.ResultsFileDirectory+UserVar.AFile;
    UserVar.CFile=UserVar.ResultsFileDirectory+UserVar.CFile;

    UserVar.FAFile=UserVar.ResultsFileDirectory+UserVar.FAFile;
    UserVar.FCFile=UserVar.ResultsFileDirectory+UserVar.FCFile;

end

% 0000100-FT-from0to1-20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-SMB_RACHMO2k3_2km-
% 0000100-FT-from0to1-20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-Velyr1-GeoBed2-SMB_RACHMO2k3_2km-


UserVar.CFile=replace(UserVar.CFile,".mat","");
UserVar.AFile=replace(UserVar.AFile,".mat","");

UserVar.CFile=replace(UserVar.CFile,".","k");
UserVar.AFile=replace(UserVar.AFile,".","k");


SMB=extractBetween(UserVar.RunType,"-SMB_","-");
if SMB=="RACHMO2k3_2km"

    UserVar.FasFile="Fas_smb_rec.1979-2021.RACMO2.3p2_ANT27_ERA5-3h.AIS.2km.YY-GriddedInterpolant.mat";
else
    UserVar.FasFile="Fas_SMB_RACMO2k3_1979_2011.mat" ; %  surface mass balance

end


if contains(UserVar.RunType,"-sb")

    sbTime=extractBetween(UserVar.RunType,"-sbB","-") ;
    UserVar.GeometryInterpolant="FsbB"+sbTime+UserVar.RunType ;



else
    UserVar.GeometryInterpolant='BedMachineGriddedInterpolants.mat';

end

UserVar.GeometryInterpolant=replace( UserVar.GeometryInterpolant,"--","-") ;
UserVar.SurfaceVelocityInterpolant=replace( UserVar.SurfaceVelocityInterpolant,"--","-") ;
UserVar.InverseRestartFile=replace( UserVar.InverseRestartFile,"--","-") ;
UserVar.FAFile=replace(UserVar.FAFile,"--","-");
UserVar.FCFile=replace(UserVar.FCFile,"--","-");

UserVar.GeometryInterpolant
UserVar.SurfaceVelocityInterpolant
UserVar.InverseRestartFile
UserVar.FAFile
UserVar.FCFile

if ~nargout   % A trick to suppress any function output if no output requested. No need to suppress output using ;
    clearvars CtrlVar
end


UserVar.InverseRestartFile
isfile(UserVar.InverseRestartFile+".mat")
isfile(UserVar.FAFile+".mat")
isfile(UserVar.FCFile+".mat")

end