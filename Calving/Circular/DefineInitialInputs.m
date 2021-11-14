
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%% Select the type of run by uncommenting one of the following options:
%
%
% close all ; job=batch("Ua","Pool",1)
%
if isempty(UserVar) || ~isfield(UserVar,'RunType')

    UserVar.RunType='Inverse-MatOpt';
    % UserVar.RunType='Forward-Diagnostic' ;
    UserVar.RunType='Forward-Transient' ;
    % UserVar.RunType='Inverse-UaOpt';meshb    % UserVar.RunType='Forward-Transient';
    % UserVar.RunType='TestingMeshOptions';
end

%% UserVar

UserVar.CalvingFrontInitRadius="750000" ;
UserVar.Region="-circular-" ;
UserVar.CalvingLaw="-speed1-";
UserVar.CalvingRateExtrapolated=0;
UserVar.DefineOutputs="-ubvb-LSF-h-sbB-s-B-dhdt-save-";
% UserVar.DefineOutputs="-ubvb-h-sbB-s-B-dhdt-";
%%

CtrlVar.LevelSetMethod=1;
CtrlVar.LevelSetEvolution="-By solving the level set equation-"   ; % "-prescribed-",
CtrlVar.LevelSetInitialisationInterval=100 ; CtrlVar.LevelSetReinitializePDist=true ;
CtrlVar.DevelopmentVersion=true;
CtrlVar.LevelSetFABmu.Scale="-ucl-" ; % "-constant-";
CtrlVar.LevelSetFABmu.Value=1;
CtrlVar.LevelSetInfoLevel=1 ;
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
CtrlVar.ReadInitialMesh=0;
CtrlVar.AdaptMesh=0;
CtrlVar.TotalNumberOfForwardRunSteps=inf;
%CtrlVar.LevelSetMethod=0;


CtrlVar.dt=0.01;   CtrlVar.DefineOutputsDt=1;
CtrlVar.time=0;

CtrlVar.TotalTime=1000;

% Element type
CtrlVar.TriNodes=3 ;


%%
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;
CtrlVar.PlotBCs=1 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5;

%% Meshing


CtrlVar.ReadInitialMesh=1;
CtrlVar.SaveInitialMeshFileName='MeshFile';
CtrlVar.ReadInitialMeshFileName="MeshFileCircular50km.mat";
CtrlVar.MaxNumberOfElements=70e3;

CtrlVar.MeshGenerator='mesh2d' ; % 'mesh2d';


CtrlVar.MeshSizeMax=50e3;
CtrlVar.MeshSize=CtrlVar.MeshSizeMax/2;
CtrlVar.MeshSizeMin=CtrlVar.MeshSizeMax/20;

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
        "-muValue"+num2str(CtrlVar.LevelSetFABmu.Value)...
        +"-Ini"+num2str(CtrlVar.LevelSetInitialisationInterval)...
        +"-PDist"+num2str(CtrlVar.LevelSetReinitializePDist)...
        +UserVar.CalvingLaw...
        +UserVar.CalvingFrontInitRadius...
        +"-cExtrapolation"+num2str(UserVar.CalvingRateExtrapolated)...
        +"-"+UserVar.Region ;
else
    CtrlVar.Experiment="NoCalving" ;
end
CtrlVar.Experiment=replace(CtrlVar.Experiment,"--","-");
CtrlVar.Experiment=replace(CtrlVar.Experiment,".","k");


end
