

%%


function [CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar)


% extracts from:
%
%   UserVar.RunType
%
% various model options and set CrtlVar fields accordingly
%



%% FT -> forward run

if contains(UserVar.RunType,"-FT-")
    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=1;
elseif contains(UserVar.RunType,"-IR-")
    CtrlVar.TimeDependentRun=0;
    CtrlVar.InverseRun=1;
end

%% from to : start and end times of run

pat="-from"+digitsPattern+"to";    TimeStart=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;
pat="to"+digitsPattern+"-";      TimeEnd=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;

CtrlVar.time=TimeStart ; CtrlVar.TotalTime=TimeEnd ;
pat="-"+digitsPattern+"km-";  MR=str2double(extract(extract(UserVar.RunType,pat),digitsPattern));

%% ??km : mesh resolution and input file with initial mesh

UserVar.MeshResolution=MR*1000;   % MESH RESOLUTION
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

pat="-ThickMin"+digitsPattern+"k"+digitsPattern+"-" ; TM=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ; CtrlVar.ThickMin=TM(1)+TM(2)/10 ;
CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin;


%% Inverse regularization parameters
CtrlVar.Inverse.Regularize.logC.ga=str2double(extractBetween(UserVar.RunType,"Ca","-"));
CtrlVar.Inverse.Regularize.logC.gs=str2double(extractBetween(UserVar.RunType,"Cs","-"));
CtrlVar.Inverse.Regularize.logAGlen.ga=str2double(extractBetween(UserVar.RunType,"Aa","-"));
CtrlVar.Inverse.Regularize.logAGlen.gs=str2double(extractBetween(UserVar.RunType,"As","-"));

%%
if contains(UserVar.RunType,"-ITS120-")
    UserVar.SurfaceVelocityInterpolant='../../../Interpolants/ITS-LIVE-ANT-G0120-0000-VelocityGriddedInterpolants-nStride2.mat';
    UserVar.VelDataSet="-ITS120-";
else
    UserVar.SurfaceVelocityInterpolant='../../../Interpolants/SurfVelMeasures990mInterpolants.mat';
    UserVar.VelDataSet="";
end

%%

if contains(UserVar.RunType,"-uvdhdt-")
    CtrlVar.Inverse.Measurements="-uv-dhdt-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
else
    CtrlVar.Inverse.Measurements="-uv-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
end


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

InvFile=replace(InvFile,".","k");

InvFile=replace(InvFile,"--","-");

UserVar.InverseRestartFile=UserVar.InverseRestartFileDirectory+"InverseRestartFile-"+InvFile;

UserVar.AFile="InvA-"+InvFile;
UserVar.CFile="InvC-"+InvFile;

UserVar.CFile=replace(UserVar.CFile,".mat","");
UserVar.AFile=replace(UserVar.AFile,".mat","");

UserVar.CFile=replace(UserVar.CFile,".","k");
UserVar.AFile=replace(UserVar.AFile,".","k");

UserVar.FAFile="FA-"+InvFile;
UserVar.FCFile="FC-"+InvFile;

UserVar.AFile=UserVar.InversionFileDirectory+UserVar.AFile;
UserVar.CFile=UserVar.InversionFileDirectory+UserVar.CFile;

UserVar.FAFile=UserVar.InversionFileDirectory+UserVar.FAFile;
UserVar.FCFile=UserVar.InversionFileDirectory+UserVar.FCFile;



end