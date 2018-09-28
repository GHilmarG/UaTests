
function [Experiment,CtrlVar,time,dt,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(CtrlVar)


    Experiment='TestTides'; CtrlVar.geo='dhdx'; % {'dsdx','dhdx'}
    CtrlVar.doplots=1;  CtrlVar.FE2dPlots=0; CtrlVar.doRemeshPlots=1;
    
	xd=30e3; xu=-100e3 ; yl=2.5e3 ; yr=-2.5e3;
    MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
    CtrlVar.Report_if_b_less_than_B=0; CtrlVar.kH=100;  
    %% Types of runs
    CtrlVar.doPrognostic=1 ;
    CtrlVar.doDiagnostic=0 ;
    CtrlVar.doInverseStep=0;
    time=0 ; dt=0.025/365.25; CtrlVar.TotalNumberOfForwardRunSteps=100;
    CtrlVar.UaOutputsDt=0.001; % model time interval between calling UaOutputs.m
    CtrlVar.AdaptiveTimeStepping=0 ;    % true if time step should potentially be modified   
    CtrlVar.ResetTime=0 ;                    % set to 1 to reset (model) time at start of restart run
    CtrlVar.RestartTime=NaN;                 % if ResetTime is true, then this is the model time at the start of the restart run
    CtrlVar.ResetTimeStep=1;                 % 1 if time step should be reset to dt given in the Ua2D_InitialUserInputFile
    CtrlVar.Restart=0;      
    CtrlVar.ReadInitialMesh=1;  CtrlVar.ReadInitialMeshFileName='InitialMesh.mat';   
    CtrlVar.DefineOceanSurfaceAtEachTimeStep=1; 
    CtrlVar.AdaptMesh=0; 
    CtrlVar.AdaptMeshAndThenStop=0;
    %% Solver
    CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
    CtrlVar.InfoLevelNonLinIt=1;
    CtrlVar.LineSeachAllowedToUseExtrapolation=1;
    
    %% Restart
    
    CtrlVar.WriteRestartFile=1;
    CtrlVar.NameOfRestartFiletoRead='IceStream-Restart.mat';
    CtrlVar.NameOfRestartFiletoWrite='IceStream-Restart.mat';
    
    
    
    %% Mesh generation and remeshing parameters
    
    CtrlVar.meshgeneration=1; CtrlVar.TriNodes=3 ; 
    CtrlVar.MeshSize=2.5e3;
    CtrlVar.MeshSizeMin=0.05*CtrlVar.MeshSize;
    CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
    CtrlVar.MaxNumberOfElements=10000;
    %% for adaptive meshing
    
    CtrlVar.AdaptMeshInterval=100;
    CtrlVar.AdaptMeshIterations=3;    % in the explicit adapt method set this to 1, for an implicit adaptation set larger than one 
    %%
  
      
    %CtrlVar.RefineCriteria='effective strain rates';
    %CtrlVar.RefineCriteria='thickness gradient';
    %CtrlVar.RefineCriteria={'flotation','thickness gradient'};
    %CtrlVar.RefineCriteria={'f factor'};
	CtrlVar.RefineCriteria={'flotation'};
    CtrlVar.RefineDiracDeltaWidth=100;  % for `flotation' and 'f factor' the zone withing this distance from floation is refined
    % CtrlVar.RefineCriteria='gradient of effective strain rates';
    
    
    
    %% plotting
    CtrlVar.doTransientPlots=1; CtrlVar.PlotGLmask=0;  CtrlVar.PlotStrains=0;
    CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=0;
    CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes    
   
    
    
end
