
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=Ua2D_InitialUserInput(UserVar,CtrlVar)
    
  
    CtrlVar.Experiment='TestGaussPeak';
     %%
    
    CtrlVar.TimeDependentRun=0 ;
    CtrlVar.doInverseStep=0;
    CtrlVar.Restart=0;  
    
    CtrlVar.InitialDiagnosticStep=1; CtrlVar.Implicituvh=1;
    
    CtrlVar.time=0 ; 
    CtrlVar.dt=1;
    CtrlVar.TotalNumberOfForwardRunSteps=1;
    
    CtrlVar.FlowApproximation='SSTREAM';   % 'hybrid'
    %CtrlVar.ALSpower=6;
    %%
    xd=300e3; xu=-300e3 ; yl=300e3 ; yr=-300e3;
    MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
    CtrlVar.MeshGenerator='gmsh'; % mesh2d does not allow for periodic BCs 
    CtrlVar.MeshGenerator='mesh2d'; % mesh2d does not allow for periodic BCs 
    CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';  % these lines are added to the gmsh .geo input file each time such a file is created
    CtrlVar.OnlyMeshDomainAndThenStop=0;
    CtrlVar.GmshMeshingAlgorithm=8;  % see gmsh manual
    CtrlVar.TriNodes=6;   % [3,6,10]
    CtrlVar.MeshSize=25e3;
    CtrlVar.MeshSizeMin=0.0001*CtrlVar.MeshSize;
    CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
    
    
    CtrlVar.AdaptMesh=1;
    CtrlVar.AdaptMeshInitial=1  ;
    CtrlVar.AdaptMeshMaxIterations=20;
    CtrlVar.AdaptMeshUntilChangeInNumberOfElementsLessThan=0;  
    CtrlVar.AdaptMeshAndThenStop=0;
    
    CtrlVar.MaxNumberOfElements=25000;
    
    
    CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;  CtrlVar.PlotLabels=0;
    
    CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection';
    %CtrlVar.MeshRefinementMethod='explicit:local:red-green';
    %CtrlVar.MeshRefinementMethod='global';
    %CtrlVar.LocalAdaptMeshSmoothingIterations=32; 
    %CtrlVar.GlobalAdaptMeshSmoothingIterations=0;
    
    I=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates gradient';
    CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=1e-8;
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Use=false;
    
    I=2;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Name='effective strain rates';
    CtrlVar.ExplicitMeshRefinementCriteria(I).Scale=5e-5;
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).p=[];
    CtrlVar.ExplicitMeshRefinementCriteria(I).InfoLevel=1;
    CtrlVar.ExplicitMeshRefinementCriteria(I).Use=true;
    
    %%
    CtrlVar.LineSeachAllowedToUseExtrapolation=1;
    
    %%
    CtrlVar.doplots=1;
    CtrlVar.doAdaptMeshPlots=1;
    CtrlVar.InfoLevelAdaptiveMeshing=10;
    
    CtrlVar.PlotNodes=1;       % If true then nodes are plotted when FE mesh is shown
    CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes
    CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=00;CtrlVar.PlotNodes=1;
    CtrlVar.InfoLevelNonLinIt=1;
    
end
