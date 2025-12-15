
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%%
%  ReadPlotSequenceOfResultFiles("FileNameSubstring","-ucl-muValue1-Ini100-PDist1-speed2-750000-cExtrapolation0-ThuleNS-","PlotTimestep",100)

%%


%% Select the type of run by uncommenting one of the following options:
%
%
% close all ; job=batch("Ua","Pool",1)
%
if isempty(UserVar) || ~isfield(UserVar,'RunType')

    % UserVar.RunType='Forward-Diagnostic' ;
    UserVar.RunType='Forward-Transient' ;

end

%% UserVar

UserVar.CalvingFrontInit="Radius750000" ;
UserVar.CalvingFrontInit="wavy" ; 
UserVar.Region="-Thule-" ;
UserVar.Region="-ThuleNS-" ;
UserVar.Region="-IceShelf-" ;

UserVar.CalvingLaw.Scale="-NV-"  ; 
UserVar.CalvingLaw.Factor=2;  
CtrlVar.CalvingLaw.Evaluation="-int-";
UserVar.ElementSize=5e3; 
UserVar.DefineOutputs="-ubvb-LSF-h-sbB-s-B-dhdt-save-";


[~,hostname]=system('hostname') ;

if contains(hostname,"DESKTOP-G5TCRTD")

    UserVar.ResultsFileDirectory="F:\Runs\Calving\Circular\ResultsFiles\";
elseif contains(hostname,"DESKTOP-BU2IHIR")

    UserVar.ResultsFileDirectory="D:\Runs\Calving\Circular\ResultsFiles\";

else

    error("case not implemented")

end


% UserVar.DefineOutputs="-ubvb-h-sbB-s-B-dhdt-";
%%
CtrlVar.FlowApproximation="uvhPrescribed" ;
CtrlVar.LevelSetMethod=1;
CtrlVar.LevelSetEvolution="-By solving the level set equation-"   ; % "-prescribed-",
CtrlVar.LevelSetInitialisationInterval=inf ; CtrlVar.LevelSetReinitializePDist=true ;
CtrlVar.DevelopmentVersion=true;
CtrlVar.LevelSetFABmu.Scale="-ucl-" ; % "-constant-";
CtrlVar.LevelSetFABmu.Value=0.01;
CtrlVar.LevelSetInfoLevel=1 ;
CtrlVar.LevelSetFixPointSolverApproach="-PTS-" ;   % Initial-fix point then pseudo-forward stepping if required
CtrlVar.LevelSetMethodAutomaticallyDeactivateElements=0;
CtrlVar.LevelSetMethodSolveOnAStrip=1;
CtrlVar.LevelSetMethodStripWidth=150e3;

CtrlVar.MeshAdapt.CFrange=[20e3 5e3 ; 10e3 2e3] ; % This refines the mesh around the calving front, but must set


% The melt is decribed as a= a_1 (h-hmin)
CtrlVar.LevelSetMethodMassBalanceFeedbackCoeffLin=-10;  % This is the constant a1, it has units 1/time.
% Default value is -1

CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin+1;    % this is the hmin constant, i.e. the accepted min ice thickness
% over the 'ice-free' areas.
% Default value is CtrlVar.ThickMin+1

CtrlVar.LevelSetEvolution="-By solving the level set equation-"  ; % "-prescribed-",



%%

CtrlVar.SlidingLaw="Weertman" ; % "Umbi" ; % "Weertman" ; % "Tsai" ; % "Cornford" ;  "Umbi" ; "Cornford" ; % "Tsai" , "Budd"


CtrlVar.InverseRun=0;
CtrlVar.TimeDependentRun=1;
CtrlVar.Restart=0;
CtrlVar.InfoLevelNonLinIt=1;

CtrlVar.AdaptMesh=0;
CtrlVar.TotalNumberOfForwardRunSteps=inf;
%CtrlVar.LevelSetMethod=0;


CtrlVar.dt=1;   CtrlVar.DefineOutputsDt=10;
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

CtrlVar.ReadInitialMesh=0;  CtrlVar.OnlyMeshDomainAndThenStop=1;
CtrlVar.ReadInitialMesh=1;  CtrlVar.OnlyMeshDomainAndThenStop=0;
CtrlVar.SaveInitialMeshFileName="MeshFile"+num2str(UserVar.ElementSize/1000)+"km" ; 
CtrlVar.ReadInitialMeshFileName="MeshFile"+num2str(UserVar.ElementSize/1000)+"km" ; 
CtrlVar.MaxNumberOfElements=70e3;

CtrlVar.MeshGenerator='mesh2d' ; % 'mesh2d';




R=1000e3 ;
theta=linspace(0,2*pi,100);
x=R*cos(theta); y=R*sin(theta) ; x(end)=[] ; y(end )=[];
MeshBoundaryCoordinates=[x(:) y(:)];



%%
CtrlVar.ResetThicknessToMinThickness=1;  % change this later on
CtrlVar.ThickMin=1;

%%
if CtrlVar.LevelSetMethod
    CtrlVar.Experiment=CtrlVar.LevelSetFABmu.Scale+...
        "-mu"+num2str(CtrlVar.LevelSetFABmu.Value)...
        +"-Ini"+num2str(CtrlVar.LevelSetInitialisationInterval)...
        +"-PDist"+num2str(CtrlVar.LevelSetReinitializePDist)...
        +"-AD"+num2str(CtrlVar.LevelSetMethodAutomaticallyDeactivateElements)...
        +"Strip"+num2str(CtrlVar.LevelSetMethodSolveOnAStrip)...
        +"SW="+num2str(CtrlVar.LevelSetMethodStripWidth)...
        +"-"+UserVar.CalvingLaw.Scale...
        +"="+sprintf("%+2.1f",UserVar.CalvingLaw.Factor)...
        +"-"+UserVar.CalvingFrontInit...
        +"-"+CtrlVar.CalvingLaw.Evaluation...
        +"dt="+num2str(CtrlVar.dt)...
        +"Ele"+num2str(UserVar.ElementSize/1000)+"km"...
        +"T"+num2str(CtrlVar.TriNodes)...
        +"-"+UserVar.Region ;
else
    CtrlVar.Experiment="NoCalving"+UserVar.Region ;
end

CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
CtrlVar.Experiment=replace(CtrlVar.Experiment,"-+","+");
CtrlVar.Experiment=replace(CtrlVar.Experiment,".","k");
CtrlVar.Experiment=replace(CtrlVar.Experiment," ","");


end
