
function [UserVar,CtrlVar,time,dt,MeshBoundaryCoordinates]=SSS2dInitialUserInput(CtrlVar)
    
    CtrlVar.StandartOutToLogfile=false ;
    Experiment='TestGaussPeak';
    time=0 ; dt=0.1; CtrlVar.TotalNumberOfForwardRunSteps=2000; CtrlVar.TotalTime=100 ;
    CtrlVar.Restart=0;  CtrlVar.WriteRestartFile=1; CtrlVar.WriteRestartFileInterval=10;

    xd=100e3; xu=-100e3 ; yl=100e3 ; yr=-100e3;
    MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];
    
    CtrlVar.ThickMin=0;                      % minimum allowed thickness without (potentially) doing something about it
    CtrlVar.ResetThicknessToMinThickness=0;  % if true, thicknes values less than ThickMin will be set to ThickMin
    CtrlVar.ThicknessConstraints=1  ;        % if true, min thickness is enforced using active set method
    CtrlVar.ThicknessBarrier=1;              % 
    CtrlVar.ThicknessBarrierThicknessScale=1;       
    CtrlVar.ThicknessBarrierMinThickMultiplier=1; 
    CtrlVar.ThicknessBarrierAccumulation=0.01;
    
    CtrlVar.TriNodes=10;
    CtrlVar.MeshSize=5e3;
    CtrlVar.MeshSizeMin=0.001*CtrlVar.MeshSize;
    CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
    
    
    CtrlVar.AdaptMesh=0;
    CtrlVar.AdaptMeshInitial=1  ; 
    CtrlVar.AdaptMeshIterations=5;
    CtrlVar.MeshRefinementMethod='implicit'; CtrlVar.RefineCriteria='effective strain rates';
    CtrlVar.MeshRefinement=1;
    CtrlVar.MaxNumberOfElements=25000;
    
    %%
    CtrlVar.doPrognostic=1 ;
    CtrlVar.doDiagnostic=0  ;
    CtrlVar.doInverseStep=0;
    CtrlVar.InitialDiagnosticStep=1; CtrlVar.Implicituvh=1;
    CtrlVar.TG3=0 ; CtrlVar.Gamma=1; CtrlVar.theta=0.5;
    
    CtrlVar.AdaptiveTimeStepping=0;
    
    CtrlVar.AsymmSolver='AugmentedLagrangian';
    %%

    CtrlVar.CompareWithAnalyticalSolutions=0;
    CtrlVar.CompareResultsWithPreviouslyObtainedResults=0;

    CtrlVar.doplots=1;  
    CtrlVar.doTransientPlots=1; 
    CtrlVar.TransientPlotDt=dt;
    CtrlVar.FE2dPlots=0;
    CtrlVar.PlotXYscale=1000; 
    CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;
    
    CtrlVar.NLtol=1e-15; % this is the square of the error, i.e. not root-mean-square error
    CtrlVar.InfoLevelNonLinIt=2;
    
    CtrlVar.WriteDumpFile=0;
    CtrlVar.WriteDumpFileStepInterval=1000;       % number of time steps between writing a dump file
    CtrlVar.WriteDumpFileTimeInterval=1.1;      % time interval between writing a dump file (0 implies infinite interval)
    
end
