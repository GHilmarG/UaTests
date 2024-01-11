

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%% Select the type of run by uncommenting one of the following options:
%
%
% close all ; job=batch("Ua;","Pool",1) ;
%


%   -SM-    Apparantly no longer used...                   
%   -MR4-   Basal melt rate parameterisation #4
%
%




if isempty(UserVar) || ~isfield(UserVar,'RunType')


    % UserVar.RunType='Forward-Diagnostic' ;

    UserVar.RunType='-FT-I-' ;  % 'Forward-Transient-Initialisation' ;
    UserVar.RunType='-FT-C-I-' ;  % 'Forward-Transient-Calving-Initialisation' ;
    UserVar.RunType="-FT-C-MR4-SM-" ;  % 'Forward-Transient-Calving with surface mass balance based on rachmo
   
    UserVar.RunType="-FT-C-RR-BMCF-MR4-SM-" ;  % 'Forward-Transient , Retreat-Rate prescribed , Initial calving fronts are Bedmachine grounding lines , ocean melt param #4
    UserVar.RunType="-FT-C-AC-BMGL-MR4-SM-" ;  % 'Forward-Transient , Anna Crawford

 
    UserVar.RunType="-FT-P-TWISC0-MR4-SM-10km" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 0km away
    % the "-P-" stands for prescribed calving fronts
    UserVar.RunType="-FT-P-TWIS-MR4-SM-10km" ;         % not calved off

    UserVar.RunType="-FT-P-TWIS-MR4-SM-10km-Alim-" ;   % not calved off
    UserVar.RunType="-FT-P-TWISC0-MR4-SM-10km-Alim" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 0km away

    UserVar.RunType="-FT-P-TWIS-MR4-SM-5km-Alim-" ;   % not calved off
    UserVar.RunType="-FT-P-TWISC0-MR4-SM-5km-Alim" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 0km away


    UserVar.RunType="-GenerateMesh-20km-AM-P-BMGL-";
    
    % UserVar.RunType='GenerateMesh' ;
    % UserVar.RunType='Inverse-MatOpt';



end


if UserVar.RunType=="TestOne"

    load("DefineInitialInputsTestOne.mat","UserVar","CtrlVar")
    MeshBoundaryCoordinates=CtrlVar.MeshBoundaryCoordinates;
    return

end



FileNameFormat="new" ; 

%% UserVar

UserVar.Region="PIG-TWG" ; "PIG" ; % "PIG-TWG" ;

if isempty(UserVar) || ~isfield(UserVar,'MeshResolution')

    pat="-"+digitsPattern+"km";
    MR=str2double(extract(extract(UserVar.RunType,pat),digitsPattern));

    if ~isempty(MR)
        UserVar.MeshResolution=MR*1000;   % MESH RESOLUTION
    else
        UserVar.MeshResolution=5e3;   % MESH RESOLUTION
    end
end


% 30km = 14km
% 20km = 9.3km
% 10km = 4.6km
%  5km = 2.3km
% 2.5km = 1.16km


if contains(UserVar.RunType,"-TWISC")
    % UserVar.CalvingFront0=extract(UserVar.RunType,"-TWISC"+digitsPattern+"-");
    UserVar.CalvingFront0=extract(UserVar.RunType,"-TWISC"+alphanumericsPattern+"-");
elseif contains(UserVar.RunType,"-PIGC")
     UserVar.CalvingFront0=extract(UserVar.RunType,"-PIGC"+alphanumericsPattern+"-");
elseif contains(UserVar.RunType,"-BMGL-")
    UserVar.CalvingFront0="-BMGL-";
elseif contains(UserVar.RunType,"-c0isGL0-")
    UserVar.CalvingFront0="-c0isGL0-";
else
    UserVar.CalvingFront0="-BMCF-"; "-BedMachineCalvingFronts-"  ;  % "-GL0-" ; % "-BedMachineCalvingFronts-"  ;
end

CtrlVar.CalvingLaw.Evaluation="-int-"  ; % nodal or integration-point evaluation  ["-int-","-node-"]
UserVar.DefineOutputs="-ubvb-LSF-h-dhdt-speed-save-AC-";


CtrlVar.LimitRangeInUpdateFtimeDerivatives=true ;

%% Set output files directory
[~,hostname]=system('hostname') ;
if contains(hostname,"DESKTOP-G5TCRTD")

    UserVar.ResultsFileDirectory="F:\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="F:\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="F:\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="F:\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="F:\Runs\Calving\PIG-TWG\RestartFiles";

elseif contains(hostname,"DESKTOP-BU2IHIR")   % home
    UserVar.ResultsFileDirectory="D:\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="D:\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="D:\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="D:\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="D:\Runs\Calving\PIG-TWG\RestartFiles";
else
    UserVar.ResultsFileDirectory=pwd+"\ResultsFiles\";
end


%%
% This run requires some additional input files. They are too big to be kept on Github so you
% will have to get those separately.
%
% You can get these files on OneDrive using the link:
%
%   https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg?e=yMZEOs
%
% Put the OneDrive folder `Interpolants' into you directory so that it can be reached as ../Interpolants with respect to you rundirectory.
%
%
%UserVar.GeometryInterpolant='../../Interpolants/Bedmap2GriddedInterpolantModifiedBathymetry.mat'; % this assumes you have downloaded the OneDrive folder `Interpolants'.
UserVar.GeometryInterpolant='../../../Interpolants/BedMachineGriddedInterpolants.mat';


if contains(UserVar.RunType,"-ITS120-")
    UserVar.SurfaceVelocityInterpolant='../../../Interpolants/ITS-LIVE-ANT-G0120-0000-VelocityGriddedInterpolants-nStride2.mat';
else
    UserVar.SurfaceVelocityInterpolant='../../../Interpolants/SurfVelMeasures990mInterpolants.mat';
end

UserVar.MeshBoundaryCoordinatesFile='../../../Interpolants/MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine';
load(UserVar.MeshBoundaryCoordinatesFile,"Boundary") ; UserVar.BedMachineBoundary=Boundary;
UserVar.DistanceBetweenPointsAlongBoundary=5e3 ;

UserVar.FasFile="Fas_SMB_RACMO2k3_1979_2011.mat" ; %  surface mass balance




%% uvh tau;
CtrlVar.uvh.SUPG.tau="taus" ; % default,  issues with uvh convergence in the beginning
% CtrlVar.uvh.SUPG.tau="tau1" ; % testing


%%


if UserVar.kH==""
    CtrlVar.kH=10;
else
    CtrlVar.kH=str2double(extract(UserVar.kH,digitsPattern));
end

CtrlVar.MeshSize=UserVar.MeshResolution ;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize ; 
%%  Level-set parameters


CtrlVar.LevelSetInitialisationInterval=100 ;


CtrlVar.DefineOutputsDt=1;
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-10;  % This is the constant a1, it has units 1/time.
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffCubic=0;

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

CtrlVar.LevelSetInitialisationMethod="-geo-" ;
CtrlVar.LevelSetReinitializePDist=true ;
CtrlVar.LevelSetFixPointSolverApproach="-PTS-" ;   % pseudo forward stepping
CtrlVar.LevelSetPseudoFixPointSolverTolerance=100;
CtrlVar.LevelSetPseudoFixPointSolverMaxIterations=100;
CtrlVar.DevelopmentVersion=false;
CtrlVar.LevelSetFABmu.Scale="-u-cl-" ; % "-constant-";
CtrlVar.LevelSetFABmu.Value=0.1;
CtrlVar.CalvingLaw.Evaluation="-int-";
CtrlVar.LevelSetMethodSolveOnAStrip=1; 

if contains(UserVar.RunType,"-SW")
    CtrlVar.LevelSetMethodStripWidth=str2double(extract(extract(UserVar.RunType,"-SW"+digitsPattern+"-"),digitsPattern));
    CtrlVar.LevelSetMethodStripWidth=CtrlVar.LevelSetMethodStripWidth*1000;
else
    CtrlVar.LevelSetMethodStripWidth=50e3;
end

if contains(UserVar.RunType,"-Duvh")   % 'Forward-Transient-Calving-Initialisation' ;
    CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=1 ;
else
    CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=0 ;
end

CtrlVar.TriNodes=3;

if contains(UserVar.RunType,'-uv-h')
    CtrlVar.Implicituvh=0;           % 0: prognostic run is semi-implicit (implicit with respect to h only)
    CtrlVar.etaZero=100 ;
    CtrlVar.LevelSetMethodStripWidth=20000;
    CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=1;                    %
    CtrlVar.LevelSetMethodAutomaticallyDeactivateElementsRunStepInterval=20;    %
    CtrlVar.TriNodes=3;
    
end



if  contains(UserVar.GroupAssembly,"-uvhGroup-")
    CtrlVar.uvhGroupAssembly=true;
else
    CtrlVar.uvhGroupAssembly=false;
end

if  contains(UserVar.GroupAssembly,"-uvGroup-") || contains(UserVar.RunType,"-uvGroup-") 
    CtrlVar.uvGroupAssembly=true;
else
    CtrlVar.uvGroupAssembly=false;
end


CtrlVar.LevelSetInfoLevel=1 ;

pat="-TM"+digitsPattern+"-";
ThickMin=str2double(extract(extract(UserVar.RunType,pat),digitsPattern))/100;


if isempty(ThickMin)
    CtrlVar.ThickMin=1;
    CtrlVar.ThickMin=0.01;  % Default changed
else
    CtrlVar.ThickMin=ThickMin;
end
CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin;    % this is the hmin constant, i.e. the accepted min ice thickness

%%
CtrlVar.SaveInitialMeshFileName=[] ; % Do not create a new initial mesh file each time
%%
CtrlVar.SaveInitialMeshFileName='MeshFile';

UserVar.Sliding.V0=300; % Only used in the Joughin sliding law

if contains(UserVar.RunType,"Cornford")
    CtrlVar.SlidingLaw="Cornford" ;
elseif contains(UserVar.RunType,"Umbi")
    CtrlVar.SlidingLaw="Umbi" ;
elseif contains(UserVar.RunType,"Joughin")
    CtrlVar.SlidingLaw="Joughin" ;
else
    CtrlVar.SlidingLaw="Weertman" ;
end
% "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"


    


if ~isfile(UserVar.GeometryInterpolant) || ~isfile(UserVar.SurfaceVelocityInterpolant)

    fprintf('\n This run requires the additional input files: \n %s \n %s \n %s  \n \n',UserVar.GeometryInterpolant,UserVar.DensityInterpolant,UserVar.SurfaceVelocityInterpolant)
    fprintf('You can download these file from : https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwBF0SQnJdXtucDHKtPnv7G9Q?e=5aLX7T \n')
end

%% UserVar.RunType

if contains(UserVar.RunType,"Inverse")

    if contains(UserVar.RunType,"Inverse-UaOpt")
        % Testing
        CtrlVar.Inverse.MinimisationMethod='UaOptimization-Hessian'; % {'MatlabOptimization','UaOptimization'}
    end

    % CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased";     CtrlVar.Inverse.AdjointGradientPreMultiplier="I"; % {'I','M'}
    % CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased";     CtrlVar.Inverse.AdjointGradientPreMultiplier="M"; % {'I','M'}

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

    % AFile and CFile contains A/C interpolants, ie these are not the data output files for A and C
    if isempty(UserVar.AFile)
        UserVar.AFile="FA-"+InvFile;
    end
    if isempty(UserVar.CFile)
        UserVar.CFile="FC-"+InvFile;
    end




    UserVar.DefineOutputs="-"; %
    CtrlVar.InverseRun=1;

    CtrlVar.Restart=0;
    CtrlVar.Inverse.InfoLevel=1;
    CtrlVar.InfoLevelNonLinIt=0;  CtrlVar.InfoLevel=0;
   

    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;

    CtrlVar.ReadInitialMesh=1;
    CtrlVar.AdaptMesh=0;
   

    CtrlVar.Inverse.Iterations=2;

    CtrlVar.Inverse.InvertFor="-logA-logC-" ; % {'C','logC','AGlen','logAGlen'}
    CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
    CtrlVar.Inverse.DataMisfit.GradientCalculation="-adjoint-" ; % "-FixpointC-"; "adjoint";

    if contains(UserVar.RunType,"-uvdhdt-")
        CtrlVar.Inverse.Measurements="-uv-dhdt-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
    else
        CtrlVar.Inverse.Measurements="-uv-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
    end


    
    CtrlVar.NameOfFileForSavingSlipperinessEstimate= UserVar.InversionFileDirectory+"InvC-"+InvFile;
    CtrlVar.NameOfFileForSavingAGlenEstimate= UserVar.InversionFileDirectory+"InvA-"+InvFile;

    CtrlVar.Inverse.NameOfRestartOutputFile=UserVar.InverseRestartFileDirectory+"InverseRestartFile-"+InvFile;


    % [----------- Testing adjoint gradents
    CtrlVar.Inverse.TestAdjoint.isTrue=0; % If true then perform a brute force calculation
    % of the directional derivative of the objective function.
    CtrlVar.TestAdjointFiniteDifferenceType="central-second-order" ;
    CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=0.01 ;
    CtrlVar.Inverse.TestAdjoint.iRange=[100,121] ;  % range of nodes/elements over which brute force gradient is to be calculated.
    % if left empty, values are calulated for every node/element within the mesh.
    % If set to for example [1,10,45] values are calculated for these three
    % nodes/elements.
    % ----------------------- ]end, testing adjoint parameters.


elseif contains(UserVar.RunType,"-FT-")

    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=1;
    CtrlVar.Restart=0;
    CtrlVar.InfoLevelNonLinIt=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
  
    CtrlVar.AdaptMesh=0;
    CtrlVar.TotalNumberOfForwardRunSteps=inf;
    %CtrlVar.LevelSetMethod=0;

elseif contains(UserVar.RunType,"Forward-Diagnostic")

    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=0;
    CtrlVar.Restart=0;
    CtrlVar.InfoLevelNonLinIt=1;
    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    CtrlVar.ReadInitialMesh=1;
    CtrlVar.AdaptMesh=0;

elseif contains(UserVar.RunType,"GenerateMesh")

    CtrlVar.TimeDependentRun=0;  % {0|1} if true (i.e. set to 1) then the run is a forward transient one, if not
    CtrlVar.InverseRun=0;
    CtrlVar.Restart=0;
    CtrlVar.ReadInitialMesh=0;
    CtrlVar.MeshGenerator="mesh2d" ; % "mesh2d" ; % 'mesh2d';

    CtrlVar.OnlyMeshDomainAndThenStop=0;
    CtrlVar.AdaptMeshAndThenStop=1; 

    UserVar.Slipperiness.ReadFromFile=1;
    UserVar.AGlen.ReadFromFile=1;
    CtrlVar.TotalNumberOfForwardRunSteps=1;

    if contains(UserVar.RunType,"-AM-")
        CtrlVar.AdaptMesh=1;
        CtrlVar.AdaptMeshMaxIterations=5;
        CtrlVar.MeshRefinementMethod='explicit:global'; 
    else
        CtrlVar.AdaptMesh=0;
    end




%     CtrlVar.MeshAdapt.GLrange=[2*CtrlVar.MeshSize   CtrlVar.MeshSize/2 ; ...
%                                  CtrlVar.MeshSize   CtrlVar.MeshSize/5 ; ...
%                                  CtrlVar.MeshSize/2   CtrlVar.MeshSize/10 ];
%   
     CtrlVar.MeshAdapt.CFrange=[5*CtrlVar.MeshSize   CtrlVar.MeshSize/2 ; ...
                                2*CtrlVar.MeshSize   CtrlVar.MeshSize/5 ; ...
                                 CtrlVar.MeshSize   CtrlVar.MeshSize/10 ];
  
    

    CtrlVar.AdaptMeshInitial=1  ;       % remesh in first iteration (Itime=1)  even if mod(Itime,CtrlVar.AdaptMeshRunStepInterval)~=0.
    
    
    CtrlVar.InfoLevelAdaptiveMeshing=1;

   UserVar.AFile="FA-Weertman-PIG-TWG-20km";
   UserVar.CFile="FC-Weertman-PIG-TWG-20km";


    CtrlVar.SaveInitialMeshFileName=...
        "NewMeshFile"...
        +num2str(CtrlVar.MeshSizeMax/1000) ...
        +"km-"...  ; %%            +CtrlVar.MeshGenerator ...
        +UserVar.Region ;

else

    error("case not found")


end



%% Time step, total run time, run steps



%%
CtrlVar.dt=1e-5;   
CtrlVar.ATSdtMax=0.1;
CtrlVar.ATSdtMin=1e-5;  
CtrlVar.ATSTargetIterations=6;
CtrlVar.ThicknessConstraintsItMax=0  ; % only update active-set, then move to next time step

CtrlVar.NRitmax=50;       % maximum number of NR iteration




if contains(UserVar.RunType,"-I-")
    CtrlVar.time=-0.1;  % If I'm using a mass-balance initialisation set start time to a slighly neg value
    % In DefineMassBaloance, the initialisation is done for negative times.
else
    CtrlVar.time=0;
end

CtrlVar.TotalTime=400;




%%
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5;
CtrlVar.PlotsXaxisLabel="xps (km)";
CtrlVar.PlotsYaxisLabel="yps (km)";
%% Meshing

if contains(UserVar.RunType,"-AM-")

    CtrlVar.ReadInitialMeshFileName="MeshFileAdapt20km36kEle";

else

    CtrlVar.ReadInitialMeshFileName=...
        UserVar.MeshFileDirectory...
        +"MeshFile"...
        +num2str(UserVar.MeshResolution/1000) ...
        +"km-"...  ; %%            +CtrlVar.MeshGenerator ...
        +UserVar.Region ;
end

CtrlVar.ReadInitialMeshFileName=replace(CtrlVar.ReadInitialMeshFileName,".","k");
MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar);

%% Adapting mesh

% useful, for example, when trying out different remeshing options (then use CtrlVar.doAdaptMeshPlots=1 to get plots)

CtrlVar.SaveAdaptMeshFileName="";    %  file name for saving adapt mesh. If left empty, no file is written
CtrlVar.AdaptMeshRunStepInterval=100 ; % remesh whenever mod(Itime,CtrlVar.AdaptMeshRunStepInterval)==0


if contains(UserVar.RunType,"-GLrange-")

    % testing if this speeds things up
   
    CtrlVar.inUpdateFtimeDerivatives.SetTimeDerivativesAtMinIceThickToZero=true;
    CtrlVar.inUpdateFtimeDerivatives.SetTimeDerivativesDowstreamOfCalvingFrontsToZero=true;
    CtrlVar.InfoLevelAdaptiveMeshing=1;

    CtrlVar.AdaptMesh=1;
    CtrlVar.MeshRefinementMethod="explicit:local:newest vertex bisection" ;
    CtrlVar.AdaptMeshRunStepInterval=10 ;


    CtrlVar.doplots=true; CtrlVar.doAdaptMeshPlots=true; CtrlVar.InfoLevelAdaptiveMeshing=1;

    CtrlVar.MeshAdapt.GLrange=...
        [2*CtrlVar.MeshSize   CtrlVar.MeshSize/2 ; ...
        CtrlVar.MeshSize   CtrlVar.MeshSize/5 ; ...
        CtrlVar.MeshSize/2   CtrlVar.MeshSize/10 ];
        
end


%%
CtrlVar.ThicknessConstraints=1;
CtrlVar.ResetThicknessToMinThickness=0;

%% A C constraints
if contains(UserVar.RunType,"-Alim-")
    CtrlVar.AGlenmin=AGlenVersusTemp(-20) ;
end
CtrlVar.Cmin=1e-8; % This is based on having done some inversions for C for m=3 where no such contraint was used
                   % and finding that only inverted values where
                   % velocity data was available, where higher than this.
               
     
%%
if batchStartupOptionUsed
    CtrlVar.doplots=0;   % disable plotting if running as batch
    fprintf("disabling plotting as this is a batch job\n")
    if contains(UserVar.DefineOutputs,"save")
        UserVar.DefineOutputs="-save-";  % disable plotting in DefineOutputs as well
    end
end

%%


if FileNameFormat=="new"
    CtrlVar.Experiment=UserVar.RunType ;
else
    CtrlVar.Experiment= ...
        UserVar.RunType...
        +CtrlVar.LevelSetFABmu.Scale....
        +"-mu"+num2str(CtrlVar.LevelSetFABmu.Value)...
        +"-Ini"+CtrlVar.LevelSetInitialisationMethod+num2str(CtrlVar.LevelSetInitialisationInterval)...
        +"-Strip"+num2str(CtrlVar.LevelSetMethodSolveOnAStrip)...
        +"-SW="+num2str(CtrlVar.LevelSetMethodStripWidth/1000)+"km"...
        +"-AD="+num2str(CtrlVar.LevelSetMethodAutomaticallyDeactivateElements)...
        +UserVar.CalvingLaw.String...
        +"-kH="+num2str(CtrlVar.kH)...
        +"-asRacmo"...
        +"-dhdtLim"+num2str(CtrlVar.LimitRangeInUpdateFtimeDerivatives)...
        +"-"+UserVar.Region...
        +"-"+CtrlVar.ReadInitialMeshFileName;

end
CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
CtrlVar.Experiment=replace(CtrlVar.Experiment,".","k");
CtrlVar.Experiment=replace(CtrlVar.Experiment,"+","p");

if startsWith(CtrlVar.Experiment,"-")
    CtrlVar.Experiment=replaceBetween(CtrlVar.Experiment,1,1,"");
end





CtrlVar.Inverse.NameOfRestartOutputFile=replace(CtrlVar.Inverse.NameOfRestartOutputFile,"--","-");
CtrlVar.Inverse.NameOfRestartOutputFile=replace(CtrlVar.Inverse.NameOfRestartOutputFile,".","k");
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile;



CtrlVar.ReadInitialMeshFileName=replace(CtrlVar.ReadInitialMeshFileName,".","k");
CtrlVar.SaveInitialMeshFileName=replace(CtrlVar.SaveInitialMeshFileName,".","k");


UserVar.CFile=replace(UserVar.CFile,".mat","");
UserVar.AFile=replace(UserVar.AFile,".mat","");

UserVar.CFile=replace(UserVar.CFile,".","k");
UserVar.AFile=replace(UserVar.AFile,".","k");


UserVar.AFile=UserVar.InversionFileDirectory+UserVar.AFile;
UserVar.CFile=UserVar.InversionFileDirectory+UserVar.CFile;



CtrlVar.NameOfRestartFiletoWrite=UserVar.ForwardRestartFileDirectory+"Restart-"+UserVar.RunType+".mat";
CtrlVar.NameOfRestartFiletoWrite=replace(CtrlVar.NameOfRestartFiletoWrite,"--","-");
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;


if CtrlVar.InverseRun
    fprintf(" Inverse restart file: %s \n",CtrlVar.Inverse.NameOfRestartOutputFile)
end

if CtrlVar.InverseRun
    if isfile(CtrlVar.Inverse.NameOfRestartInputFile+".mat")
        CtrlVar.Restart=1;
    else
        CtrlVar.Restart=0;
        fprintf("No restart file found. Starting a new run. \n")
    end
else
    if isfile(CtrlVar.NameOfRestartFiletoRead)
        CtrlVar.Restart=1;
    else
        CtrlVar.Restart=0;
    end
end

if ~CtrlVar.InverseRun
    if contains(UserVar.LevelSetDownstreamRheology,"-LSDRlin-")

        CtrlVar.LevelSetDownstream_nGlen=1;
        eta= 1e12  / (1000*365.25*24*60*60);
        CtrlVar.LevelSetDownstreamAGlen=1/(2*eta);

    end
end

if contains(UserVar.RunType,"GenerateMesh")
    CtrlVar.Restart=0;
    CtrlVar.ReadInitialMesh=0;
elseif CtrlVar.Restart
    CtrlVar.ReadInitialMesh=0;
else
    CtrlVar.ReadInitialMesh=1;
end


CtrlVar.WriteRestartFileInterval=20;






%% Testing
% CtrlVar.DefineOutputsDt=10 ; CtrlVar.ATSdtMax=20; CtrlVar.ATSTargetIterations=10 ; CtrlVar.dt=0.001;   CtrlVar.ATSdtMin=0.001;  CtrlVar.NRitmax=50;   CtrlVar.TotalTime=1000;    % maximum number of NR iteration
% CtrlVar.ExplicitEstimationMethod="-no extrapolation-" ;

% CtrlVar.InfoLevelBackTrack=1000;  CtrlVar.InfoLevelNonLinIt=1000; 

%%

% if CtrlVar.InverseRun && CtrlVar.Restart
% 
%     [UserVar]=DefineModificationsToInverseRestartRunData(UserVar,CtrlVar) ;
% 
% end

% ModifyInverseRestartFile




