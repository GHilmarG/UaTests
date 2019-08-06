
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)



%
%  Was testing how to generate mesh independent reactions.  I'm doing this in
%  UaOutputs by using using the mass matrix 
%
%  Creating mesh-independent reactinos works fine, and now need to think about
%  how to change the implementation of the active thickenss constraints to
%  reflect this.  (August 2016)
%



UserVar=[];
CtrlVar.Experiment='GaussMelting';
%Experiment='UniformMelting';
CtrlVar.ResetTimeStep=1;                 % 1 if time step should be reset to dt given in the Ua2D_InitialUserInputFile

CtrlVar.FlowApproximation='SSTREAM' ;  % 'SSTREAM'|'SSHEET'|'Hybrid'

CtrlVar.time= 0 ; CtrlVar.dt=1;
CtrlVar.TimeDependentRun=1 ; CtrlVar.AdaptiveTimeStepping=0 ; 
CtrlVar.TotalNumberOfForwardRunSteps=1000; CtrlVar.TotalTime=1000 ;

CtrlVar.Restart=0;  
CtrlVar.WriteRestartFile=1;
CtrlVar.TriNodes=10 ; CtrlVar.RedefineReactions=1; 
xd=100e3; xu=-100e3 ; yl=100e3 ; yr=-100e3;
MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);

CtrlVar.InfoLevelLinSolve=1;
CtrlVar.PlotXYscale=1000;

CtrlVar.ThickMin=0;

CtrlVar.ThicknessConstraintsInfoLevel=100 ;
CtrlVar.ThicknessConstraintsItMax=10  ;     % maximum number of active-set iterations.

CtrlVar.MUA.MassMatrix=true;
CtrlVar.ThicknessConstraints=1;

CtrlVar.ReadInitialMesh=1;    % if true then read FE mesh (coordinates, connectivity) directly from a .mat file 
                              % unless the adaptive meshing option is used, no further meshing is done.
CtrlVar.ReadInitialMeshFileName='MeshFile.mat'; CtrlVar.SaveInitialMeshFileName='MeshFile.mat';
CtrlVar.ReadInitialMeshFileName='LocallyRefinedMesh.mat'; CtrlVar.SaveInitialMeshFileName='LocallyRefinedMesh.mat';

end
