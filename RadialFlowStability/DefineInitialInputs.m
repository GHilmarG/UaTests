



function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)
%% This is the initial input file for my circular SSH tryout

%%UNITS here are taken as meters and seconds

%   MR : mesh resolution factor, the larger this is, the finer the mesh
%   AM : automated mesh adaptation
%   RG : inner radius
%   DE : Deactive elements (using DefineElementsToDeactivate)

UserVar.RunType="-MR150-AM0-RG0k015-"; 
UserVar.RunType="-MR500-AM0-RG0k015-"; 

UserVar.RunType="-MR250-AM0-RG0k015-n1-"; 
UserVar.RunType="-MR250-AM0-RG0k015-n6-"; 
UserVar.RunType="-MR250-AM0-RG0k015-TR6-n6-"; 
% UserVar.RunType="-MR250-AM0-RG0k015-TR6-n6-DE-"; 
UserVar.RunType="-MR250-AM0-RG0k015-TR3-n6-DE-h0Pert-"; 
UserVar.RunType="-MR250-AM0-RG0k015-TR3-n6-DE-QD25-h0Pert-"; 
UserVar.RunType="-MR250-AM0-RG0k015-TR3-n1-DE-QD25-"; 
UserVar.RunType="-MR250-AM0-RG0k015-TR3-n1-DE-QD25-h0Pert-"; 

UserVar.RunType="-MR500-AM0-RG0k015-TR3-n1-DE-QD25-h0Pert-"; 
UserVar.RunType="-MR500-AM0-RG0k015-TR3-n1-DE-QD25-"; 

UserVar.RunType="-MR500-AM0-RG0k015-TR3-n6-DE-QD25-"; 
UserVar.RunType="-MR500-AM0-RG0k015-TR3-n6-DE-QD25-h0Pert-"; 
% UserVar.RunType="-MR750-AM0-RG0k015-TR3-n6-DE-QD25-h0Pert-"; 
% UserVar.RunType="-MR750-AM0-RG0k015-TR3-n6-DE-QD25-"; 
% UserVar.RunType="-MR750-AM0-RG0k015-TR3-n1-DE-QD25-h0Pert-"; 

UserVar.Geometry='circular_shelf';

CtrlVar.SaveInitialMeshFileName="MeshFile-"+extractBetween(UserVar.RunType,"MR","-",Boundaries="inclusive")+extractBetween(UserVar.RunType,"RG","-",Boundaries="inclusive")+".mat";



%%

UserVar.n=double(str2double(extractBetween(UserVar.RunType,"-n","-"))); 

[UserVar.rg,UserVar.Domain_radius,UserVar.shelf_width,UserVar.h0,UserVar.Bedrock,UserVar.rho,UserVar.rhow,UserVar.g,UserVar.thinice,UserVar.ur,UserVar.n,UserVar.AGlen]=...
    DefineMyParameters(UserVar);

MeshResolutionFactor=str2double(extractBetween(UserVar.RunType,"-MR","-")) ;
AdaptMeshFlag=logical(str2double(extractBetween(UserVar.RunType,"-AM","-"))); 
rg=str2double(replace(extractBetween(UserVar.RunType,"-RG","-"),"k",".")) ;
CtrlVar.Experiment='CircularSSH';
UserVar.rg=rg;  % inner radius




g_tag=UserVar.g*(1-UserVar.rho/UserVar.rhow);
nu=1/(2*UserVar.AGlen*UserVar.rho);
Q0=UserVar.ur*UserVar.rg*UserVar.h0*2*pi;
L=sqrt(nu*Q0/(2*pi*g_tag*UserVar.h0*UserVar.h0)); %[m]
T=nu/(g_tag*UserVar.h0);
CtrlVar.doplots=1; CtrlVar.doRemeshPlots=1;

%%for the square domain only
Length=1 ; Width=1;
xu=-Length/2;
xd=Length/2;
yl=Width/2 ;
yr=-Width/2;

% IMPORTANT: this defines the space resolution. use Width/150 for adpative
% meshing, but at least 1500 for uniform.


resolution=Width/MeshResolutionFactor ;

cfr=(2*pi*rg)/resolution;
% cfr=100; %fix to match the high resolution around rg (Hilmar, why is this here?)
% cfr=5*cfr;
cfr2=(2*pi*UserVar.Domain_radius)/resolution;
x0=0; % centre coordinates
y0=0;

t=linspace(-pi,pi,ceil(cfr));          %this will keep a relatively uniform resolution about the inner radii and the outer one
t2=linspace(-pi,0.99*pi,ceil(cfr2));
t(end)=[];

xrg=x0+rg*cos(t);
yrg=y0+rg*sin(t);

xrn=x0+(UserVar.Domain_radius)*cos(t2);
yrn=y0+(UserVar.Domain_radius)*sin(t2);

switch UserVar.Geometry
    
    case 'square_domain'
         MeshBoundaryCoordinates=[xu yl ; % Outer boundary (clockwise orientation)
             xd yl ;
             xd yr ;
             xu yr ;                            
             NaN NaN ;
             xrg(:) yrg(:)];      % inner boundary 
        
    case 'circular_shelf'
         MeshBoundaryCoordinates=[xrn(:) yrn(:) ;                            
             NaN NaN ;
             xrg(:) yrg(:)];
end





%% New numerics to try (after new Beta version)
%CtrlVar.InfoLevel=10;
CtrlVar.MapOldToNew.method="scatteredInterpolant" ;
CtrlVar.MaxNumberOfElements=1000e3;           % max number of elements. If #elements larger then CtrlMeshSize/min/max are changed
CtrlVar.etaZero=1e-09; %not needed probably

CtrlVar.ExplicitEstimationMethod="-no extrapolation-"; % "-Adams-Bashforth-";
CtrlVar.ATSTargetIterations=6; 
CtrlVar.ATSdtMax=0.5; % when ADT is increased, do not exceed 3sec

%CtrlVar.InfoLevelNonLinIt=5; 

%%
CtrlVar.Parallel.uvhAssembly.spmd.isOn=true; % spmd results in considerable speedup, ranging from 6 to 20 times depending on size and memory
CtrlVar.Parallel.uvAssembly.spmd.isOn=true; 
CtrlVar.Distribute=false ;                    % only speeds things up somewhat if matrix large, for 262485 x 262485  speedup=1.7, 341265 x 341265 speedup=2.18
CtrlVar.Parallel.isTest=false;  
%% Types of runs
CtrlVar.TimeDependentRun=1 ;
CtrlVar.dt=0.0001;
CtrlVar.TotalNumberOfForwardRunSteps=40000; 
CtrlVar.TotalTime=140;          % maximum model time
CtrlVar.time=0; 
%% Positive Thickness constraints - HILMAR: SHOULD NOT AFFECT. TRY H00==ThickMin
CtrlVar.ThickMin=1e-06; % minimum allowed thickness 
CtrlVar.ResetThicknessToMinThickness=1;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=0  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=10  ;

%%LS Mass balance geometry feedback 
CtrlVar.MassBalanceGeometryFeedback=0; %Hilmar: Keep this OFF==0 

%%LS Update BC (Default is 0) HILMAR: this should NOT affect, check BC
CtrlVar.UpdateBoundaryConditionsAtEachTimeStep=0;  % if true, `DefineBoundaryConditions.m' is called at the beginning of each time step to update the boundary conditions.
                                                   % otherwise boundary conditions are only updated at the beginning of the run (also at the beginning or a restart run).
                                                   % Note that whenever the finite-element mesh is modified (for example during mesh refinement),
                                                   % the boundary conditions are updated through a call to DefineBoundaryConditions.m
%%LS Grounded/floating HILMAR: DOES NOT MATTER
CtrlVar.kH=100; %% implies a grounding line "width" of 1/kH [m] up and down from floating condition
%% Mesh generation and remeshing parameters

CtrlVar.meshgeneration=1; 



TriNodes=str2double(extractBetween(UserVar.RunType,"-TR","-")) ;
if isempty(TriNodes)
    CtrlVar.TriNodes=3 ;  % {3|6|10}  number of nodes per element
else
    CtrlVar.TriNodes=TriNodes;
end

CtrlVar.MeshSize=resolution; %over-all desired element size
CtrlVar.MeshSizeMin=0.0001*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
CtrlVar.MaxNumberOfElements=500000;
CtrlVar.Mesh2d.opts.kind = 'DELFRONT'  ; %  {'DELFRONT','DELAUNAY'} LS default is DELFRONT. but I find deluny more stable near BC

if contains(UserVar.RunType,"-DE-")
    CtrlVar.ManuallyDeactivateElements=true;
else
    CtrlVar.ManuallyDeactivateElements=false;
end

%% Adaptive meshing

CtrlVar.AdaptMesh=AdaptMeshFlag;


CtrlVar.MeshGenerator='mesh2d';      % 'mesh2d' | 'gmsh' 

CtrlVar.AdaptMeshInitial=0  ; % remesh in first run-step irrespecitivy of the value of AdaptMeshInterval
CtrlVar.AdaptMeshRunStepInterval=0; % Number of run-steps between mesh adaptation 
CtrlVar.AdaptMeshTimeInterval=1;
CtrlVar.AdaptMeshMaxIterations=30;  % Number of adapt mesh iterations within each run-step.
CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=0;  
CtrlVar.AdaptMeshAndThenStop=0; 
CtrlVar.InfoLevelAdaptiveMeshing=1;  
CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';                       % 'explicit:global';'explicit:local:newest vertex bisection';

CtrlVar.CurrentRunStepNumber=1 ;  % This is a counter that is increased by one at each run step.

%% Restart

CtrlVar.WriteRestartFile=1;
CtrlVar.NameOfRestartFiletoRead="Restartfile"+UserVar.RunType ;
CtrlVar.NameOfRestartFiletoWrite=CtrlVar.NameOfRestartFiletoRead ; 

% OK, this is potentialy a bit dangerous, but if a restart file is found, defined this as a restart run
if isfile(CtrlVar.NameOfRestartFiletoRead+".mat")
    CtrlVar.Restart=1;  
else
    CtrlVar.Restart=0;  
end

%% Meshfiles



CtrlVar.ReadInitialMeshFileName=CtrlVar.SaveInitialMeshFileName;


if isfile(CtrlVar.ReadInitialMeshFileName)
    CtrlVar.ReadInitialMesh=1;
else
    CtrlVar.ReadInitialMesh=0;
end

%% plotting
CtrlVar.PlotXYscale=1;
CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
CtrlVar.doplots=0;          % if true then plotting during runs by Ua are allowed, set to 0 to suppress all plots



%% Outputs
CtrlVar.DefineOutputsDt=1.0; %model time interval between calling DefineOutputs.m


%%



if contains(UserVar.RunType,"-QD")
    CtrlVar.QuadratureRuleDegree=str2double(extractBetween(UserVar.RunType,"-QD","-"));
else
    CtrlVar.QuadratureRuleDegree=[];  % use default
end




%%

% CtrlVar.doplots=1; 
% CtrlVar.doAdaptMeshPlots=1; 
% CtrlVar.InfoLevelAdaptiveMeshing=100; 
% 
%%


end