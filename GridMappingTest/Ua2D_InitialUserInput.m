
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)
    
  
    CtrlVar.Experiment='TestGaussPeak';
     %%
    
    CtrlVar.TimeDependentRun=1 ;
    CtrlVar.doInverseStep=0;
    CtrlVar.Restart=0;  
    

    
    CtrlVar.time=0 ; 
    CtrlVar.dt=1;
    CtrlVar.TotalNumberOfForwardRunSteps=5;
    
    CtrlVar.FlowApproximation='SSTREAM';   % 'hybrid'
    %CtrlVar.ALSpower=6;
    %%
    xd=300e3; xu=-300e3 ; yl=300e3 ; yr=-300e3;
    MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
    CtrlVar.OnlyMeshDomainAndThenStop=0;

    CtrlVar.TriNodes=6;   % [3,6,10]
    CtrlVar.MeshSize=25e3;
    CtrlVar.MeshSizeMin=0.0001*CtrlVar.MeshSize;
    CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
    
    
    CtrlVar.AdaptMesh=1;
    CtrlVar.AdaptMeshInitial=0  ;
    CtrlVar.AdaptMeshMaxIterations=2;
    CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=0;  
    CtrlVar.AdaptMeshAndThenStop=0;
    
    CtrlVar.MaxNumberOfElements=25000;
    
    
    CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;  CtrlVar.PlotLabels=0;
    
    CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';
    CtrlVar.MeshRefinementMethod='explicit:local:red-green';
    % CtrlVar.MeshRefinementMethod='global';

  
    
    %%
    CtrlVar.LineSeachAllowedToUseExtrapolation=1;
    
    %%
    CtrlVar.doplots=1;
    CtrlVar.doAdaptMeshPlots=0;
    CtrlVar.InfoLevelAdaptiveMeshing=1;
    
    CtrlVar.PlotNodes=1;       % If true then nodes are plotted when FE mesh is shown
    CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes
    CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=00;CtrlVar.PlotNodes=1;
    CtrlVar.InfoLevelNonLinIt=1;
    
end
