
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


UserVar.VelDataSet=extractBetween(UserVar.RunType,"Vel","-") ;

%% from to : start and end times of run



pat="R"+digitsPattern+"to";    from=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;
pat="to"+digitsPattern+"-";    to=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;



if isempty(from)
    from=0;
end

if isempty(to)
    to=0;
end

CtrlVar.time=from ; CtrlVar.TotalTime=to ;
UserVar.from=from ; UserVar.to=to ;
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

CtrlVar.kH=str2double(extractBetween(UserVar.RunType,"-kH","-"))/1000;

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



%%

if contains(UserVar.RunType,"-uvdhdt-")
    CtrlVar.Inverse.Measurements="-uv-dhdt-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
else
    CtrlVar.Inverse.Measurements="-uv-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
end



   

if contains(UserVar.RunType,"-IR-") || contains(UserVar.RunType,"-FR0to")
    
    % old naming convection, fine for initial inverse run
    %  The new naming convention is simply to use the UserVar.RunType for the name of the inverse restart file


    InvFile=CtrlVar.SlidingLaw...
        +"-"+UserVar.VelDataSet ...
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
    InvFile=replace(InvFile,"Slid","");o


    UserVar.AFile="InvA"+InvFile;
    UserVar.CFile="InvC"+InvFile;
    UserVar.FAFile="FA"+InvFile;
    UserVar.FCFile="FC"+InvFile;

    InvFile="InverseRestartFile-"+InvFile;



else

    if CtrlVar.InverseRun && to > 0
        TS=num2str(to) ;
    elseif ~CtrlVar.InverseRun && from > 0
        TS=num2str(from) ;
    end
    
    InvFile=UserVar.RunType;
    InvFile=replace(InvFile,"IR","FR");
    InvFile="IR-at"+TS+"-"+InvFile; 
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

if CtrlVar.InverseRun && to > 0

     UserVar.GeometryInterpolant=UserVar.Interpolants+"FsbB-at"+UserVar.RunType ;

elseif ~CtrlVar.InverseRun && from > 0
  
    UserVar.GeometryInterpolant=UserVar.Interpolants+"FsbB-at"+num2str(from)+UserVar.RunType ;  % This should already exist, since I must have done a previous inverse run to get here.

else

    UserVar.GeometryInterpolant=UserVar.Interpolants+"BedMachineGriddedInterpolants";

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
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;


UserVar.GeometryInterpolant=replace( UserVar.GeometryInterpolant,"--","-") ;
UserVar.SurfaceVelocityInterpolant=replace( UserVar.SurfaceVelocityInterpolant,"--","-") ;
UserVar.InverseRestartFile=replace( UserVar.InverseRestartFile,"--","-") ;
UserVar.FAFile=replace(UserVar.FAFile,"--","-");
UserVar.FCFile=replace(UserVar.FCFile,"--","-");

if nargin==0
    
    fprintf(" UserVar.GeometryInterpolant:       \t %s \n ",UserVar.GeometryInterpolant)
    fprintf("UserVar.SurfaceVelocityInterpolant: \t %s \n ",UserVar.SurfaceVelocityInterpolant)
    fprintf("UserVar.InverseRestartFile:         \t %s \n ",UserVar.InverseRestartFile)
    fprintf("UserVar.FAFile:                     \t %s \n ",UserVar.FAFile)
    fprintf("UserVar.FCFile:                     \t %s \n ",UserVar.FCFile)
    fprintf("CtrlVar.NameOfRestartFiletoWrite:   \t %s \n \n \n",CtrlVar.NameOfRestartFiletoWrite)
    
    which(UserVar.GeometryInterpolant+".mat")
    isfile(UserVar.InverseRestartFile+".mat")
    isfile(UserVar.FAFile+".mat")
    isfile(UserVar.FCFile+".mat")

end

if ~nargout   % A trick to suppress any function output if no output requested. No need to suppress output using ;
    clearvars CtrlVar
end

% Now add ".mat" to filenames if it is not already a part of the name

[filepath,fname,fext]=fileparts(UserVar.GeometryInterpolant) ; if fext=="" ;  UserVar.GeometryInterpolant =UserVar.GeometryInterpolant+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.SurfaceVelocityInterpolant) ; if fext=="" ;  UserVar.SurfaceVelocityInterpolant =UserVar.SurfaceVelocityInterpolant+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.InverseRestartFile) ; if fext=="" ;  UserVar.InverseRestartFile =UserVar.InverseRestartFile+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.FAFile) ; if fext=="" ;  UserVar.FAFile =UserVar.FAFile+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.FCFile) ; if fext=="" ;  UserVar.FCFile =UserVar.FCFile+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.AFile) ; if fext=="" ;  UserVar.AFile =UserVar.AFile+".mat" ; end
[filepath,fname,fext]=fileparts(UserVar.CFile) ; if fext=="" ;  UserVar.CFile =UserVar.CFile+".mat" ; end
     
CtrlVar.Inverse.NameOfRestartInputFile=UserVar.InverseRestartFile; 


end