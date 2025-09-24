

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%% Testing against analytical transfer functions
%
%
% Here a flow down a uniformly inclined slab with some small perturbations in bedrock and slipperiness are compared against
% analytical solutions, valid provided the perturbations are small.
% 
% For simplicity here the perturbations are Gaussian perturbations, although the theory works for any small amplitude
% perturbations.
%
% The domain is periodic, and periodic boundary conditions are applied using nodal ties. 
%
%
%%

%% Some key model parameters are defined by this string: 

UserVar.Experiment="NumAna-Nod3-MS1k-dt2-DSx50k-DSy50k-alpha0.05-TI-uvh-IT-theta0.5-" ; 

% MS :  element size (km)
% dt :  dt,
% DSx : (half) domain size in x direction (km)
% DSy : (half) domain size in y direction (km)
%
% theta : theta=0   ->  forward Euler
%         theta=1   ->  backward Euler
%         theta=1/2 ->  Crank-Nicolson (the default Ua method)
%
%
%%

%%
%
% For theta=1/2 the solution is as far as I have tested, always stable.
% For theta=0, the solution is unstable for dt > 0.35 years, or there about
%
% The CDT number, u dt/dx, is about 0.8 years
%%




%% Slope of coordinate system 
CtrlVar.alpha=str2double(extractBetween(UserVar.Experiment,"-alpha","-")) ;   % slope of the coordinate system

%% Mesh
CtrlVar.Experiment=UserVar.Experiment;
CtrlVar.FlowApproximation="SSTREAM" ; 

%% Mesh

xd=str2double(extractBetween(UserVar.Experiment,"-DSx","k-"))*1000 ; xu=-xd ; 
yl=str2double(extractBetween(UserVar.Experiment,"-DSy","k-"))*1000 ; yr=-xd ; 


MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';  % these lines are added to the gmsh .geo input file each time such a file is created
CtrlVar.OnlyMeshDomainAndThenStop=0;

CtrlVar.TriNodes=str2double(extractBetween(UserVar.Experiment,"-Nod","-")) ; 
CtrlVar.MeshSize=str2double(extractBetween(UserVar.Experiment,"-MS","k-"))*1000 ; 


CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.GmshMeshingAlgorithm=8;

%% time stepping and run duration


CtrlVar.ForwardTimeIntegration=extractBetween(UserVar.Experiment,"-TI","IT-") ; 


CtrlVar.theta=str2double(extractBetween(UserVar.Experiment,"-theta","-")); 
CtrlVar.htheta=str2double(extractBetween(UserVar.Experiment,"-theta","-")); 

CtrlVar.TimeDependentRun=1;
CtrlVar.Restart=0;
CtrlVar.StartTime=0 ;
CtrlVar.EndTime=10 ;
CtrlVar.dt= str2double(extractBetween(UserVar.Experiment,"-dt","-")) ; 

CtrlVar.AdaptiveTimeStepping=0 ;
CtrlVar.TotalNumberOfForwardRunSteps=inf;

%%
CtrlVar.ThicknessConstraints=0;
%% Plots

CtrlVar.doplots=1;
CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;CtrlVar.PlotNodes=1;

CtrlVar.InfoLevelNonLinIt=1;

%% Automated mesh refinement
CtrlVar.AdaptMesh=0;  CtrlVar.InfoLevelAdaptiveMeshing=10;

CtrlVar.MeshGenerator='gmsh'; % mesh2d does not allow for periodic BCs 
CtrlVar.GmshMeshingAlgorithm=8;  % see gmsh manual

CtrlVar.AdaptMeshInitial=1  ;
CtrlVar.AdaptMeshMaxIterations=5;
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=0;
CtrlVar.AdaptMeshAndThenStop=0;

CtrlVar.MaxNumberOfElements=25000;

CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;  CtrlVar.PlotLabels=0;
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';


%% Perturbations

UserVar.h0=1000;
UserVar.ub0=1000; 
UserVar.m=3;
UserVar.rho0=900 ; 
UserVar.g=9.81/1000 ; 
taud=UserVar.rho0*UserVar.g*sin(CtrlVar.alpha)*UserVar.h0 ; 
UserVar.C0=UserVar.ub0/taud^(UserVar.m); 
UserVar.n=1 ; 
UserVar.AGlen=1e-4 ; 

UserVar.ampl_c=0.0;   UserVar.sigma_cx=(xd-xu)/20; UserVar.sigma_cy=Inf;              % fractional perturbation in basal slipperiness, C
UserVar.ampl_b=0.01;   UserVar.sigma_bx=(xd-xu)/20; UserVar.sigma_by=(xd-xu)/20;       % perturbation in bedrock, measured as fraction of unperturbed ice thickness) 
UserVar.ampl_rho=0.0; UserVar.sigma_rhox=(xd-xu)/10; UserVar.sigma_rhoy=(xd-xu)/10;   % perturbation in rho (comparison not fully implemented)


end
