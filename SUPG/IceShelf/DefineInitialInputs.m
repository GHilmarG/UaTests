
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%%

clear DefineOutputs

UserVar.Geometry='square';
% UserVar.Geometry='island';

CtrlVar.uvh.SUPG.tauMultiplier=0.5 ; CtrlVar.uvh.SUPG.tau="taus"; 
CtrlVar.TriNodes=3 ;  % {3|6|10}  number of nodes per element
l=0.25e3 ;     % overall element size
UserVar.u0=10000; 
CtrlVar.TotalTime=1;          % maximum model time

UserVar.RunType="SUPG"+"-T"+num2str(CtrlVar.TriNodes)+"-l"+num2str(l)+"-"+num2str(UserVar.u0)+"-"+CtrlVar.uvh.SUPG.tau+"-m"+CtrlVar.uvh.SUPG.tauMultiplier ; 
UserVar.RunType=replace(UserVar.RunType,".","k") ; 
UserVar.RunType=replace(UserVar.RunType,"--","-") ; 
%%


CtrlVar.Experiment='TestSUPG-Iceshelf';


CtrlVar.doplots=1; CtrlVar.doRemeshPlots=1;

Length=200e3 ; Width=10e3;
xu=0 ;
xd=Length;
yl=Width/2 ;
yr=-Width/2;

switch UserVar.Geometry
    
    case 'square'
        MeshBoundaryCoordinates=[xu yl ; xd yl ; xd yr ; xu yr];
        
    case 'island'
        x0=50e3;
         MeshBoundaryCoordinates=[xu yl ; xd yl ; xd yr ; xu yr ; ...                           % Outer boundary (clockwise orientation)
             NaN NaN ; xu/10+x0 yr/10 ; xd/10+x0 yr/10 ; xd/10+x0 yl/10 ; xu/10+x0 yl/10];      % inner boundary (anticlockwise orientation)
         
%         MeshBoundaryCoordinates=[-1 -1 ; -1 0 ; 0 1 ; 1 0 ; 1 -1 ; 0 -1 ; ...      
%             NaN NaN ;  0.5 -0.5 ; 0.5 0 ; 0.1 0 ; 0.1 -0.5 ; ...         
%             NaN NaN ; -0.1 -0.5 ; -0.1 0 ; -0.8 0 ; -0.8 -0.5 ];         % another innner boundary (anticlockwise orientation
end

%% Types of runs
CtrlVar.TimeDependentRun=1 ;
CtrlVar.dt=0.01;
CtrlVar.TotalNumberOfForwardRunSteps=inf;

CtrlVar.time=0; 
CtrlVar.ATSdtMax=10.0;  % Timestep maximum is 10 years
CtrlVar.ATSdtMin=0.001;  % Timestep maximum is 10 years


%% Solver
CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
CtrlVar.InfoLevelNonLinIt=1;
CtrlVar.LineSeachAllowedToUseExtrapolation=1;

%% Restart
CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1;
CtrlVar.NameOfRestartFiletoRead="R-"+UserVar.RunType;
CtrlVar.NameOfRestartFiletoWrite=CtrlVar.NameOfRestartFiletoRead;



%% Mesh generation and remeshing parameters

CtrlVar.meshgeneration=1; 

CtrlVar.MeshSize=l;
CtrlVar.MeshSizeMin=l; 
CtrlVar.MeshSizeMax=l ; 
CtrlVar.MaxNumberOfElements=50000;
%% for adaptive meshing
CtrlVar.AdaptMesh=0;


CtrlVar.MeshGenerator='mesh2d';      % 'mesh2d' | 'gmsh' 




%%


%% plotting
CtrlVar.PlotXYscale=1000;
CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
CtrlVar.doplots=0;          % if true then plotting during runs by Ua are allowed, set to 0 to suppress all plots

CtrlVar.ThickMin=1; % minimum allowed thickness without (potentially) doing something about it
CtrlVar.ResetThicknessToMinThickness=0;  % if true, thickness values less than ThickMin will be set to ThickMin
CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
CtrlVar.ThicknessConstraintsItMax=10  ;

CtrlVar.DefineOutputsDt=0.01;


end
