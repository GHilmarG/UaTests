
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)



%
%  Was testing how to generate mesh independent reactions.  I'm doing this in
%  UaOutputs by using using the mass matrix 
%

CtrlVar.ThicknessConstraintsLambdaPosThreshold=0;

%% testing restart
CtrlVar.ResetTimeStep=0; CtrlVar.dt=1e-3;
CtrlVar.InfoLevelNonLinIt=1 ; CtrlVar.doplots=1;
%%

% CtrlVar.uvhCostFunction="Work Residuals" ; % ["Work Residuals","Force Residuals"] 

UserVar.RunType="GaussMelting";
UserVar.RunType="ThicknessConstrained";
UserVar.Plots="-R-"; % calculate and plot reactions


CtrlVar.time=0 ; 
CtrlVar.TimeDependentRun=1 ; CtrlVar.AdaptiveTimeStepping=1 ; 
CtrlVar.TotalNumberOfForwardRunSteps=10000; CtrlVar.TotalTime=500;

CtrlVar.DefineOutputsDt=0;
CtrlVar.Restart=0;  
CtrlVar.WriteRestartFile=1;
CtrlVar.TriNodes=3; 
CtrlVar.MeshSize=2e3 ; % 5e3 ; 



xd=100e3; xu=-100e3 ; yl=100e3 ; yr=-100e3;
MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);


CtrlVar.PlotXYscale=1000;

CtrlVar.ThickMin=0.0;


CtrlVar.ThicknessConstraintsInfoLevel=1 ;
CtrlVar.ThicknessConstraintsItMax=10  ;     % maximum number of active-set iterations.


CtrlVar.ThicknessConstraints=1;

CtrlVar.ReadInitialMesh=0;    % if true then read FE mesh (coordinates, connectivity) directly from a .mat file 
                              % unless the adaptive meshing option is used, no further meshing is done.
CtrlVar.ReadInitialMeshFileName='MeshFile.mat'; CtrlVar.SaveInitialMeshFileName='MeshFile.mat';
CtrlVar.ReadInitialMeshFileName='LocallyRefinedMesh.mat'; CtrlVar.SaveInitialMeshFileName='LocallyRefinedMesh.mat';



CtrlVar.Experiment=sprintf("%s-Nod%i-MeshSize%i-lambdak%i",UserVar.RunType,CtrlVar.TriNodes,...
    CtrlVar.MeshSize,...
    100*CtrlVar.ThicknessConstraintsLambdaPosThreshold); 


CtrlVar.Experiment=replace(CtrlVar.Experiment," ","");

CtrlVar.NameOfRestartFiletoWrite="Restart-"+CtrlVar.Experiment+".mat" ; 
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite;

%%

CtrlVar.Parallel.uvhAssembly.spmd.isOn=true;    % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.uvAssembly.spmd.isOn=true;     % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Distribute=false;                       % linear system is solved using distributed arrays. 

CtrlVar.Parallel.isTest=false;                  % Runs both with and without parallel approach, and prints out some information on relative performance. 
                                                % Good for testing if switching on the parallel options speeds things up, and by how much.

end
