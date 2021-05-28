
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

  
    CtrlVar.Experiment='UIP';
    CtrlVar.FlowApproximation="SSHEET" ; % "SSTREAM" ; % 'Hybrid' ;  % 'SSTREAM'|'SSHEET'|'Hybrid'
    CtrlVar.TimeDependentRun=0;
    xd=100e3; xu=0 ; yl=20e3 ; yr=-20e3;
    MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
    CtrlVar.GmshGeoFileAdditionalInputLines{1}='Periodic Line {1,2} = {3,4};';  % these lines are added to the gmsh .geo input file each time such a file is created
    CtrlVar.OnlyMeshDomainAndThenStop=0;
    
    CtrlVar.TriNodes=6;   % [3,6,10]
    CtrlVar.MeshSize=5e3;
    CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
    CtrlVar.MeshSizeMax=CtrlVar.MeshSize;
    CtrlVar.GmshMeshingAlgorithm=8;  
        
    %%
    CtrlVar.Restart=0;  
    CtrlVar.time=0 ; 
    CtrlVar.dt=1; 
    CtrlVar.TotalNumberOfForwardRunSteps=1;
    
    CtrlVar.ThicknessConstraints=0;
    %%
        
    CtrlVar.doplots=1;
    CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes
    CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;CtrlVar.PlotNodes=1;
    
    CtrlVar.InfoLevelNonLinIt=1;

end
