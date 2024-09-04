
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
% various model options and set CtrlVar fields accordingly
%
%
%
%
%%

%%
%
% rename --no-act --verbose InverseRestartFile IR InverseR*.mat
% rename --no-act --verbose R-Weertman R-SlidWeertman *.mat
%
%%

if nargin==0
    CtrlVar=Ua2D_DefaultParameters();
    UserVar=FileDirectories();

    % initial inverse run using ITS120 velocities and Bedmachine2 geometry.
    UserVar.RunType="-IR-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";

    % forward run from t=0 to t=1, using inversion products FA and FC from t=0, which implies using the initial inversion
    % UserVar.RunType="-FR0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";

    % inverse run using forward run results from t=1. This implies using the geometry from t=1 instead of Bedmachine2  geometry.
    UserVar.RunType="-IR1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";

    % forward restart run continuing from t=1 and using inversion products from t=1, ie "-IRt1-".
    % UserVar.RunType="-FR1to2-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";




end

%% FR -> forward run

if contains(UserVar.RunType,"-FR")
    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=1;
elseif contains(UserVar.RunType,"-IR")
    CtrlVar.TimeDependentRun=0;
    CtrlVar.InverseRun=1;
end

%%  ; % "-uvh-" , "-uv-h-" , "-uv-" , "-h-" ;

if contains(UserVar.RunType,"-uv-h-")
    CtrlVar.ForwardTimeIntegration="-uv-h-" ;
else
    CtrlVar.ForwardTimeIntegration="-uvh-" ;
end
%

%%

UserVar.VelDataSet=extractBetween(UserVar.RunType,"-Vel","-") ;

%% from to : start and end times of run



pat="R"+digitsPattern+"to";    from=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;
pat="to"+digitsPattern+"-";    to=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;

% In the initial inverse run I do not include the from and to times, so these will not be found, resulting in from=[] and
% to=[];

if isempty(from) ; from=nan ; end
if isempty(to) ; to=nan ; end

CtrlVar.time=from ; 
CtrlVar.TotalTime=to ; 

UserVar.from=from;
UserVar.to=to;

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

CtrlVar.kH=str2double(extractBetween(UserVar.RunType,"-kH","-"))/1000;

%% -P- / -C-  : Level set is prescribed as (P) opposed to evolved (C)

if contains(UserVar.RunType,"-CF0is")

    UserVar.CalvingFront0="-"+extractBetween(UserVar.RunType,"-CF0is","-")+"-";
else
    UserVar.CalvingFront0="-BMCF-"; % "-GL0-" ; % "-BedMachineCalvingFronts-"  ;

end

if contains(UserVar.RunType,"-P-")

    CtrlVar.LevelSetEvolution="-Prescribed-"   ; % "-prescribed-",
    CtrlVar.LevelSetMethod=1;


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

%% Mass balance, both upper and lower surface, ie including ocean-induced melt
%
% This is selected in DefineMassBalance, depending on
%


if  contains(UserVar.RunType,"-MRIM")


    if contains(UserVar.RunType,"CCSM4")
        UserVar.SMBfilename="ISMIP6_smb\CCSM4_";
        UserVar.TFfilename="ISMIP6_ocean\CCSM4_ocean_";
    elseif contains(UserVar.RunType,'CESM2')
        UserVar.SMBfilename="ISMIP6_smb\CESM2_ssp585_";
        UserVar.TFfilename="ISMIP6_ocean\CESM2-WACCM_SSP585_ocean_";
    elseif contains(UserVar.RunType,'HadGEM2')
        UserVar.SMBfilename="ISMIP6_smb\HadGEM2_rcp85_";
        UserVar.TFfilename="ISMIP6_ocean\HadGEM2_RCP85_ocean_";
    elseif contains(UserVar.RunType,'NorESM1')
        UserVar.SMBfilename="ISMIP6_smb\NorESM1_M_RCP26_repeat";
        UserVar.TFfilename="ISMIP6_ocean\NorESM1-M_RCP26_ocean_";
    elseif contains(UserVar.RunType,'UKESM1rep')
        UserVar.SMBfilename="ISMIP6_smb\UKESM1_ssp585_repeat_";
        UserVar.TFfilename="ISMIP6_ocean\UKESM1_ssp585_repeat_ocean_";
    elseif contains(UserVar.RunType,'UKESM1')
        UserVar.SMBfilename="ISMIP6_smb\UKESM1_ssp585_";
        UserVar.TFfilename="ISMIP6_ocean\UKESM1_ssp585_ocean_";
    end

    UserVar.SMBfilename=UserVar.ISMIP6Directory+UserVar.SMBfilename;
    UserVar.TFfilename=UserVar.ISMIP6Directory+UserVar.TFfilename;

end


%%

if contains(UserVar.RunType,"-uvdhdt-")
    CtrlVar.Inverse.Measurements="-uv-dhdt-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
else
    CtrlVar.Inverse.Measurements="-uv-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
end




% This is here for the first inverse run, or the first transient run. The idea is to always use the same inverse file at the
% beginning. This inverse file is then updated at the end of the inverse run. This should ensure that I have a good initial A
% and C estimates at the beginning.  All later inversion files that are used during the transient relaxation phase, get names
% that are specific to that run and have geometries which are those of a previous transient run.
%

if contains(UserVar.RunType,"-IR-") ||  contains(UserVar.RunType,"-FR"+num2str(UserVar.Assimilation.tStart))

    % old naming convection, fine for initial inverse run
    %  The new naming convention is simply to use the UserVar.RunType for the name of the inverse restart file


    InvRestartFile=CtrlVar.SlidingLaw...
        +"-"+UserVar.VelDataSet ...
        +"-Ca"+num2str(CtrlVar.Inverse.Regularize.logC.ga)...
        +"-Cs"+num2str(CtrlVar.Inverse.Regularize.logC.gs)...
        +"-Aa"+num2str(CtrlVar.Inverse.Regularize.logAGlen.ga)...
        +"-As"+num2str(CtrlVar.Inverse.Regularize.logAGlen.gs)...
        +"-"+num2str(UserVar.MeshResolution/1000)+"km";

    if contains(UserVar.RunType,"-Alim-")
        InvRestartFile=InvRestartFile+"-Alim-";
    end

    if contains(UserVar.RunType,"-Clim-")
        InvRestartFile=InvRestartFile+"-Clim-";
    end

    if contains(UserVar.RunType,"-uvdhdt-")
        InvRestartFile=InvRestartFile+"-uvdhdt-";
    end

    if contains(UserVar.RunType,"-uvGroup-")
        InvRestartFile=InvRestartFile+"-uvGroup-";
    end

    if contains(UserVar.RunType,"-2024-")
        InvRestartFile=InvRestartFile+"-2024-";
    end

    InvRestartFile=replace(InvRestartFile,"Vel","");
    InvRestartFile=replace(InvRestartFile,"Slid","");


    UserVar.AFile="InvA-"+InvRestartFile;
    UserVar.CFile="InvC-"+InvRestartFile;
    UserVar.FAFile="FA-"+InvRestartFile;
    UserVar.FCFile="FC-"+InvRestartFile;

    InvRestartFile="InverseRestartFile-"+InvRestartFile;



else


    if UserVar.InverseRestartFile=="create the name of inverse restart file from User.RunType"
        InvRestartFile=UserVar.RunType;

        % I need to create the name of the inverse restart file for both inverse and forward run.
        %
        % In the case of a forward run this will be used to find the previously created inverse restart file from which to get the A
        % and the C interpolants, as well as the geometry interpolants

        % get rid of the "IR<from>to<to>" or the "FR<from>to<to>" and replace with "-at<to>?"
        if CtrlVar.InverseRun
            % InvFile=replace(InvFile,num2str(from)+"to",  "-at");
            InvRestartFile=replaceBetween(InvRestartFile,"IR","-","IR-at"+num2str(to)+"-",Boundaries="inclusive");
        else
            InvRestartFile=replaceBetween(InvRestartFile,"FR","-","IR-at"+num2str(from)+"-",Boundaries="inclusive");
        end

        InvRestartFile=replace(InvRestartFile,"--","-") ;
        InvRestartFile=replace(InvRestartFile,"--","-") ;


    else

        InvRestartFile=UserVar.InverseRestartFile;

    end

    UserVar.InverseRestartFile=UserVar.InverseRestartFileDirectory+InvRestartFile;

    ACFiles=replace(InvRestartFile,["-IR-","IR-"],"-");
    ACFiles=replace(ACFiles,["-FR-","-FR-"],"-");



    ACFiles=strip(ACFiles,"left","-");
    ACFiles=replace(ACFiles,".","k");
    UserVar.AFile="InvA-"+ACFiles;
    UserVar.CFile="InvC-"+ACFiles;
    UserVar.FAFile="FA-"+ACFiles;
    UserVar.FCFile="FC-"+ACFiles;

end

InvRestartFile=replace(InvRestartFile,".","k");
InvRestartFile=replace(InvRestartFile,"--","-");
InvRestartFile=strip(InvRestartFile,"left","-");



UserVar.InverseRestartFile=UserVar.InverseRestartFileDirectory+InvRestartFile;


UserVar.AFile=UserVar.InversionFileDirectory+UserVar.AFile;
UserVar.CFile=UserVar.InversionFileDirectory+UserVar.CFile;

UserVar.FAFile=UserVar.InversionFileDirectory+UserVar.FAFile;
UserVar.FCFile=UserVar.InversionFileDirectory+UserVar.FCFile;



UserVar.CFile=replace(UserVar.CFile,".mat","");
UserVar.AFile=replace(UserVar.AFile,".mat","");

UserVar.CFile=replace(UserVar.CFile,".","k");
UserVar.AFile=replace(UserVar.AFile,".","k");

UserVar.CFile=replace(UserVar.CFile,"--","-");
UserVar.AFile=replace(UserVar.AFile,"--","-");


SMB=extractBetween(UserVar.RunType,"-SMB_","-");
if SMB=="RACHMO2k3_2km"

    UserVar.FasFile=UserVar.Interpolants+"Fas_smb_rec.1979-2021.RACMO2.3p2_ANT27_ERA5-3h.AIS.2km.YY-GriddedInterpolant.mat";
else
    UserVar.FasFile=UserVar.Interpolants+"Fas_SMB_RACMO2k3_1979_2011.mat" ; %  surface mass balance

end

if UserVar.GeometryInterpolant=="create the name of inverse restart file from User.RunType"

    % Note: Here I'm only defining the name the file with the GeometryInterpolant, the file is then found or created in
    % 'FindAndCreateInterpolants.m'

    if isnan(UserVar.from) || (contains(UserVar.RunType,"-FR") && UserVar.from == UserVar.Assimilation.tStart)

        fprintf("Parsing: This is either the very first inversion, which does not contain the from variable in the RunType, or this is the first forward run during the assimilation phase\n")

        % 
        % 
        %
        % Here the interpolants are based on data, ie Bedmachine, and those are located in a separate folder.
        UserVar.GeometryInterpolant=UserVar.Interpolants+"BedMachineGriddedInterpolants";
        UserVar.MeshBoundaryCoordinatesFile="../../../Interpolants/MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine";

        if contains(UserVar.RunType,"-BM3-")

            UserVar.GeometryInterpolant=UserVar.Interpolants+"BedMachineAntarctica-v3-GriddedInterpolants";
            UserVar.MeshBoundaryCoordinatesFile=UserVar.Interpolants+"BedMachineAntarctica-v3-MeshBoundaryCoordinates";

        end

         fprintf("The file for the geometry interpolant is %s \n",UserVar.GeometryInterpolant)

    elseif to <= UserVar.Assimilation.tEnd  % within assimilation period

        if CtrlVar.InverseRun

            fprintf("Inverse run within the assimilation period. \n")
            % This is an inverse run that uses the final geometry from a previous transient run
            % Apart from the first inversion, those later inversions are always done after a forward run from t=from to t=to.
            % and the RunType string has the same values for the 'from' and 'to' variables, and only an "IR" instead of a "FR"
            %
            % Thus, the geometry that should be used for this inverse run is based on the "to" time of that previous forward run.
            UserVar.GeometryInterpolant=UserVar.InversionFileDirectory+"FsbB-at"+num2str(to)+UserVar.RunType ;
            UserVar.GeometryInterpolant=replaceBetween(UserVar.GeometryInterpolant,"IR","-","-",Boundaries="inclusive") ;
            fprintf("The file for the geometry interpolant is %s \n",UserVar.GeometryInterpolant)

        else

            fprintf("Forward run within the assimilation period. \n")
            % This is a forward run within the assimilation/relaxation period.
            UserVar.GeometryInterpolant=UserVar.InversionFileDirectory+"FsbB-at"+num2str(from)+UserVar.RunType ;  % This should already exist, since I must have done a previous inverse run to get here.
            UserVar.GeometryInterpolant=replaceBetween(UserVar.GeometryInterpolant,"FR","-","-",Boundaries="inclusive") ;
            fprintf("The file for the geometry interpolant is %s \n",UserVar.GeometryInterpolant)

        end

    elseif from >= UserVar.Assimilation.tEnd  % after assimilation period

        fprintf("After the assimilation period. \n")
        UserVar.GeometryInterpolant=UserVar.InversionFileDirectory+"FsbB-at"+num2str(UserVar.Assimilation.tEnd)+UserVar.RunType ;  % This should already exist, since I must have done a previous inverse run to get here.
        UserVar.GeometryInterpolant=replaceBetween(UserVar.GeometryInterpolant,"FR","-","-",Boundaries="inclusive") ;
        fprintf("The file for the geometry interpolant is %s \n",UserVar.GeometryInterpolant)

    end
else
    UserVar.GeometryInterpolant=UserVar.InversionFileDirectory+UserVar.GeometryInterpolant;
end


if contains(UserVar.RunType,"ITS120")
    UserVar.SurfaceVelocityInterpolant=UserVar.Interpolants+"ITS-LIVE-ANT-G0120-0000-VelocityGriddedInterpolants-nStride2";
else
    UserVar.SurfaceVelocityInterpolant=UserVar.Interpolants+"Measures990mInterpolants";

end




CtrlVar.NameOfRestartFiletoWrite=UserVar.ForwardRestartFileDirectory+UserVar.RunType ;
CtrlVar.NameOfRestartFiletoWrite=replace(CtrlVar.NameOfRestartFiletoWrite,"--","-");
CtrlVar.NameOfRestartFiletoWrite=replace(CtrlVar.NameOfRestartFiletoWrite,".","k");
CtrlVar.NameOfRestartFiletoWrite=replace(CtrlVar.NameOfRestartFiletoWrite,"\-","\");




if ~isfield(UserVar,"NameOfRestartFiletoRead")
    CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;
else
    CtrlVar.NameOfRestartFiletoRead=UserVar.NameOfRestartFiletoRead;
end



UserVar.GeometryInterpolant=RemoveSomeUnwantedCharactersFromString(UserVar.GeometryInterpolant);
UserVar.SurfaceVelocityInterpolant=RemoveSomeUnwantedCharactersFromString(UserVar.SurfaceVelocityInterpolant);
UserVar.InverseRestartFile=RemoveSomeUnwantedCharactersFromString(UserVar.InverseRestartFile);
CtrlVar.NameOfRestartFiletoRead=RemoveSomeUnwantedCharactersFromString(CtrlVar.NameOfRestartFiletoRead);
UserVar.FAFile=RemoveSomeUnwantedCharactersFromString(UserVar.FAFile);
UserVar.FCFile=RemoveSomeUnwantedCharactersFromString(UserVar.FCFile);
UserVar.AFile=RemoveSomeUnwantedCharactersFromString(UserVar.AFile);
UserVar.CFile=RemoveSomeUnwantedCharactersFromString(UserVar.CFile);


fprintf(" UserVar.GeometryInterpolant:       \t %s \n ",UserVar.GeometryInterpolant)
fprintf("UserVar.SurfaceVelocityInterpolant: \t %s \n ",UserVar.SurfaceVelocityInterpolant)
fprintf("UserVar.InverseRestartFile:         \t %s \n ",UserVar.InverseRestartFile)
fprintf("UserVar.FAFile:                     \t %s \n ",UserVar.FAFile)
fprintf("UserVar.FCFile:                     \t %s \n ",UserVar.FCFile)
fprintf("CtrlVar.NameOfRestartFiletoWrite:   \t %s \n \n \n",CtrlVar.NameOfRestartFiletoWrite)
[ isfile(UserVar.GeometryInterpolant+".mat") , isfile(UserVar.InverseRestartFile+".mat") , isfile(UserVar.FAFile+".mat") , isfile(UserVar.FCFile+".mat")]



if ~nargout   % A trick to suppress any function output if no output requested. No need to suppress output using ;
    clearvars CtrlVar
end

% Now add ".mat" to filenames if it is not already a part of the name

[filepath,fname,fext]=fileparts(UserVar.GeometryInterpolant) ; if fext=="" ;  UserVar.GeometryInterpolant = UserVar.GeometryInterpolant+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.SurfaceVelocityInterpolant) ; if fext=="" ;  UserVar.SurfaceVelocityInterpolant = UserVar.SurfaceVelocityInterpolant+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.InverseRestartFile) ; if fext=="" ;  UserVar.InverseRestartFile = UserVar.InverseRestartFile+".mat" ; end
[filepath,fname,fext]=fileparts(CtrlVar.NameOfRestartFiletoRead) ; if fext=="" ;  CtrlVar.NameOfRestartFiletoRead = CtrlVar.NameOfRestartFiletoRead+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.FAFile) ; if fext=="" ;  UserVar.FAFile =UserVar.FAFile+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.FCFile) ; if fext=="" ;  UserVar.FCFile =UserVar.FCFile+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.AFile) ; if fext=="" ;  UserVar.AFile =UserVar.AFile+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.CFile) ; if fext=="" ;  UserVar.CFile =UserVar.CFile+".mat" ; end

UserVar.GeometryInterpolant=RemoveSomeUnwantedCharactersFromString(UserVar.GeometryInterpolant);
UserVar.SurfaceVelocityInterpolant=RemoveSomeUnwantedCharactersFromString(UserVar.SurfaceVelocityInterpolant);
UserVar.InverseRestartFile=RemoveSomeUnwantedCharactersFromString(UserVar.InverseRestartFile);
CtrlVar.NameOfRestartFiletoRead=RemoveSomeUnwantedCharactersFromString(CtrlVar.NameOfRestartFiletoRead);
UserVar.FAFile=RemoveSomeUnwantedCharactersFromString(UserVar.FAFile);
UserVar.FCFile=RemoveSomeUnwantedCharactersFromString(UserVar.FCFile);
UserVar.AFile=RemoveSomeUnwantedCharactersFromString(UserVar.AFile);
UserVar.CFile=RemoveSomeUnwantedCharactersFromString(UserVar.CFile);



CtrlVar.Inverse.NameOfRestartInputFile=UserVar.InverseRestartFile;


end