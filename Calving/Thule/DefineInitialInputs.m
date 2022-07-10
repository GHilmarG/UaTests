
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%%
%  ReadPlotSequenceOfResultFiles("FileNameSubstring","-ucl-muValue1-Ini100-PDist1-speed2-750000-cExtrapolation0-ThuleNS-","PlotTimestep",100)

%%


%% Select the type of run by uncommenting one of the following options:
%
%
% close all ; job=batch("Ua","Pool",1)
%


%% UserVar


 UserVar.RunType="-Thule-C-NV1.1-10km-" ;  %  % prescribed, to get steady state
 UserVar.RunType="-Thule-C-NV2.0-10km-" ;  %  % 


%UserVar.RunType="-Thule-P-SSmin-10km-" ;  NewFileNameFormat=1 ;  %  prescribed calving front, steady state grown from zero initial ice thickness  
%UserVar.RunType="-Thule-P-SSmax-10km-" ;  NewFileNameFormat=1 ;  %  prescribed calving front, steady state grown from zero initial ice thickness  

UserVar.RunType="-Thule-C-Tmax-C-NV2.0-10km-" ;  NewFileNameFormat=1 ;  %  prescribed calving front, steady state grown from zero initial ice thickness  
UserVar.RunType="-Thule-C-Tmin-C-NV2.0-10km-" ;  NewFileNameFormat=1 ;  %  prescribed calving front, steady state grown from zero initial ice thickness  

UserVar.RunType="-Thule-P-SSmin-10km-Cxy-" ;  NewFileNameFormat=1 ;  %  prescribed calving front, steady state grown from zero initial ice thickness  
UserVar.RunType="-Thule-P-SSmax-10km-Cxy-" ;  NewFileNameFormat=1 ;  %  prescribed calving front, steady state grown from zero initial ice thickness  

UserVar.RunType="-Thule-C-Tmin-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini10-10km-" ;  NewFileNameFormat=1 ;  %  prescribed calving front, steady state grown from zero initial ice thickness  
% copyfile Restart-Thule-P-SSmin-10km-.mat Restart-Thule-C-Tmin-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-10km-.mat

UserVar.Region="-Thule-" ;

if contains(UserVar.RunType,"-C-NV")
    UserVar.CalvingLaw.Type="-NV-"  ;  % "-ScalesWithNormalVelocity+1.0-"  ;
    UserVar.CalvingLaw.Factor=str2double(extract(extract(UserVar.RunType,"NV"+digitsPattern+"."+digitsPattern+"-"),digitsPattern+"."+digitsPattern));
    %UserVar.CalvingLaw.Factor=1.1;
    %UserVar.CalvingLaw.Factor=2.0;
elseif contains(UserVar.RunType,"-C-Fq")

  
    UserVar.CalvingLaw.Type="-Fqk-"  ;  
    UserVar.CalvingLaw.Fqk.q=str2double(extract(extract(UserVar.RunType,"-Fq"+digitsPattern+"Fk"),digitsPattern));
    UserVar.CalvingLaw.Fqk.k=str2double(extract(extract(UserVar.RunType,"Fk"+digitsPattern+"Fmin"),digitsPattern));
    UserVar.CalvingLaw.Fqk.Fmin=str2double(extract(extract(UserVar.RunType,"Fmin"+digitsPattern+"cmin"),digitsPattern));
    UserVar.CalvingLaw.Fqk.cmin=str2double(extract(extract(UserVar.RunType,"cmin"+digitsPattern+"Fmax"),digitsPattern));
    UserVar.CalvingLaw.Fqk.Fmax=str2double(extract(extract(UserVar.RunType,"Fmax"+digitsPattern+"cmax"),digitsPattern));
    UserVar.CalvingLaw.Fqk.cmax=str2double(extract(extract(UserVar.RunType,"cmax"+digitsPattern+"-"),digitsPattern));


else
    UserVar.CalvingLaw.Type=""  ;  % "-ScalesWithNormalVelocity+1.0-"  ;
    UserVar.CalvingLaw.Factor=0;
end



R=750e3 ;
theta=linspace(0,2*pi,400);
Xc=R*cos(theta); Yc=R*sin(theta) ; Xc(end)=[] ; Yc(end)=[];
UserVar.CalvingFront0.Xc=Xc(:);
UserVar.CalvingFront0.Yc=Yc(:);


if contains(UserVar.RunType,"-10km-")
    UserVar.ElementSize=10e3; % Mesh size
else
    error("not done")
end

UserVar.DefineOutputs="-ubvb-LSF-h-sbB-s-B-dhdt-save-log10speed-";
UserVar.DefineOutputs="-ubvb-LSF-h-sbB-s-B-dhdt-log10speed-";


[~,hostname]=system('hostname') ;

if contains(hostname,"DESKTOP-G5TCRTD")

    UserVar.ResultsFileDirectory="F:\Runs\Calving\Thule\ResultsFiles\";
elseif contains(hostname,"DESKTOP-BU2IHIR")

    UserVar.ResultsFileDirectory="D:\Runs\Calving\Thule\ResultsFiles\";
elseif contains(hostname,"C17777347")

    UserVar.ResultsFileDirectory="D:\Runs\Calving\Thule\ResultsFiles\";

elseif contains(hostname,"DESKTOP-014ILS5")

    UserVar.ResultsFileDirectory=".\ResultsFiles\";

else

    error("PC platform not known")

end


% UserVar.DefineOutputs="-ubvb-h-sbB-s-B-dhdt-";
%%
% CtrlVar.FlowApproximation="uvhPrescribed" ;
CtrlVar.LevelSetMethod=1;

if contains(UserVar.RunType,"-P-")  || contains(UserVar.RunType,"-Inverse-")
    CtrlVar.LevelSetEvolution="-Prescribed-"   ; % "-prescribed-",
else
    CtrlVar.LevelSetEvolution="-By solving the level set equation-"   ; % "-prescribed-",
end


CtrlVar.LevelSetReinitializePDist=true ; CtrlVar.LevelSetInitialisationInterval=inf;
if contains(UserVar.RunType,"-Ini")
    IniInt=str2double(extract(extract(UserVar.RunType,"-Ini"+digitsPattern+"-"),digitsPattern));

    if ~isempty(IniInt)
        CtrlVar.LevelSetInitialisationInterval=IniInt;
    
    end
end


CtrlVar.DevelopmentVersion=true;

CtrlVar.LevelSetFABmu.Scale="-u-cl-" ; % "-constant-";
CtrlVar.LevelSetFABmu.Value=0.1;
CtrlVar.LevelSetInfoLevel=1 ;

CtrlVar.CalvingLaw.Evaluation="-int-";

CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=0;
CtrlVar.LevelSetMethodSolveOnAStrip=1;
CtrlVar.LevelSetMethodStripWidth=150e3;

CtrlVar.MeshAdapt.CFrange=[20e3 5e3 ; 10e3 2e3] ; % Tmhis refines the mesh around the calving front, but must set


% The melt is decribed as a= a_1 (h-hmin)
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-10;  % This is the constant a1, it has units 1/time.
% Default value is -1


% over the 'ice-free' areas.
% Default value is CtrlVar.ThickMin+1



%%

CtrlVar.SlidingLaw="Weertman" ; % "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"


CtrlVar.InverseRun=0;
CtrlVar.TimeDependentRun=1;

CtrlVar.InfoLevelNonLinIt=1;

CtrlVar.AdaptMesh=0;
CtrlVar.TotalNumberOfForwardRunSteps=inf; 
%CtrlVar.LevelSetMethod=0;





CtrlVar.dt=1e-3;   CtrlVar.DefineOutputsDt=1;  CtrlVar.ATSdtMin=1e-4  ; 
CtrlVar.TotalTime=1000;


CtrlVar.time=0;



% Element type
CtrlVar.TriNodes=3 ;


%%
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5;

%% Meshing

CtrlVar.MeshSizeMax=NaN;
CtrlVar.MeshSize=UserVar.ElementSize; 
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;


CtrlVar.SaveInitialMeshFileName="MeshFile"+num2str(UserVar.ElementSize/1000)+"km.mat"; 
CtrlVar.ReadInitialMeshFileName="MeshFile"+num2str(UserVar.ElementSize/1000)+"km.mat" ; 
CtrlVar.MaxNumberOfElements=70e3;

if isfile(CtrlVar.ReadInitialMeshFileName)
    CtrlVar.ReadInitialMesh=1;  
    CtrlVar.OnlyMeshDomainAndThenStop=0;
else
    CtrlVar.ReadInitialMesh=0;  
    CtrlVar.OnlyMeshDomainAndThenStop=1;
end


CtrlVar.MeshGenerator='mesh2d' ; % 'mesh2d';




R=1000e3 ;
theta=linspace(0,2*pi,100);
x=R*cos(theta); y=R*sin(theta) ; x(end)=[] ; y(end )=[];
MeshBoundaryCoordinates=[x(:) y(:)];



%%
CtrlVar.ResetThicknessToMinThickness=1;  % change this later on
CtrlVar.ThicknessConstraints=0; 
CtrlVar.ThickMin=0.1;
CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin+0.1;   
CtrlVar.LevelSetDownstreamAGlen=AGlenVersusTemp(-20) ; 
%%
if CtrlVar.LevelSetMethod
    if NewFileNameFormat
        CtrlVar.Experiment=UserVar.RunType;
    else
        CtrlVar.Experiment=CtrlVar.LevelSetFABmu.Scale+...
            "-mu"+num2str(CtrlVar.LevelSetFABmu.Value)...
            +"-Ini"+num2str(CtrlVar.LevelSetInitialisationInterval)...
            +"-PDist"+num2str(CtrlVar.LevelSetReinitializePDist)...
            +"-AD"+num2str(CtrlVar.LevelSetMethodAutomaticallyDeactivateElements)...
            +"Strip"+num2str(CtrlVar.LevelSetMethodSolveOnAStrip)...
            +"SW="+num2str(CtrlVar.LevelSetMethodStripWidth)...
            +"-"+UserVar.CalvingLaw.Type...
            +"="+sprintf("%+2.1f",UserVar.CalvingLaw.Factor)...
            +"-"+UserVar.Region ;
    end
else
    CtrlVar.Experiment=UserVar.RunType;
end

CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
CtrlVar.Experiment=replace(CtrlVar.Experiment,"-+","+");
CtrlVar.Experiment=replace(CtrlVar.Experiment,".","k");
CtrlVar.Experiment=replace(CtrlVar.Experiment," ","");

CtrlVar.NameOfRestartFiletoRead="Restart"+UserVar.RunType; 
CtrlVar.NameOfRestartFiletoRead=replace(CtrlVar.NameOfRestartFiletoRead,".","k")+".mat";
CtrlVar.NameOfRestartFiletoWrite=CtrlVar.NameOfRestartFiletoRead;


%% Testing

CtrlVar.UseMexFiles=true ;  % CtrlVar.Restart=1;  CtrlVar.WriteRestartFile=0;

if isfile(CtrlVar.NameOfRestartFiletoRead)
    CtrlVar.Restart=1;

    CtrlVar.ResetTime=true ;                    % set to 1 to reset (model) time at start of restart run
     CtrlVar.RestartTime=0;                 % if ResetTime is true, then this is the model time at the start of the restart run
     CtrlVar.ResetTimeStep=1;                 % true if time step should be reset to dt given in the DefineInitialUserInputFile
     CtrlVar.ResetRunStepNumber=true;            % if true, RunStepNumber is set to zero at the beginning of a restart run.
     CtrlVar.InitialDiagnosticStep=1; % Start a transient run with an initial diagnostic step, even if the step is a restart step.
    
else
    CtrlVar.Restart=0;
end


end
