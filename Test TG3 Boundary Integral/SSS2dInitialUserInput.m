
function [UserVar,CtrlVar,time,dt,MeshBoundaryCoordinates]=SSS2dInitialUserInput(CtrlVar)

Experiment='Test1dIceStream';
CtrlVar.CompareWithAnalyticalSolutions=1;

xd=1800e3; xu=0e3 ; yl=100e3 ; yr=-100e3;
MeshBoundaryCoordinates=[xu yr ; xd yr ; xd yl ; xu yl];

CtrlVar.doPrognostic=1 ; CtrlVar.doDiagnostic=0  ;CtrlVar.doInverseStep=0;
CtrlVar.InitialDiagnosticStep=0; CtrlVar.Implicituvh=1;  

dt=1e-3; time=0; CtrlVar.TotalNumberOfForwardRunSteps=1; 
CtrlVar.doplots=1;  CtrlVar.doTransientPlots=0; CtrlVar.PlotBackgroundImage=0;


CtrlVar.Restart=0;  



CtrlVar.TG3=1 ; 
CtrlVar.theta=0.5;


CtrlVar.CalvingFrontFullyFloating=0; CtrlVar.NameOfRestartFiletoWrite='Ex1aFullyFloating.mat';  
%CtrlVar.CalvingFrontFullyFloating=1; CtrlVar.NameOfRestartFiletoWrite='Ex1aGeneral.mat';  


CtrlVar.WriteRestartFile=1;


CtrlVar.NameOfRestartFiletoRead='Ex1a.mat';


CtrlVar.WriteDumpFileInterval=1000;
CtrlVar.WriteRestartFileInterval=1000;

CtrlVar.WriteRestartFileInterval=1000;

% remesh variables
CtrlVar.nDiagnosticRemeshSteps=0;  % remeshing done as a part of diagnostic calculation
CtrlVar.nInitialRemeshSteps=0;     % remeshing before any calculation of vel is done
CtrlVar.AdaptMeshInitial=0 ;       %

CtrlVar.AdaptMesh=0; 
%CtrlVar.MeshRefinementMethod='implicit'; CtrlVar.RefineCriteria='effective strain rates';
CtrlVar.MeshRefinementMethod='explicit'; CtrlVar.RefineCriteria='flotation';

CtrlVar.AdaptMeshInitial=0  ; 
CtrlVar.AdaptMeshInterval=1;
CtrlVar.AdaptMeshIterations=3;

CtrlVar.MeshSize=5e3;
CtrlVar.TriNodes=6;
CtrlVar.MeshSizeMin=1e3;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;

CtrlVar.MaxNumberOfElements=30000;
CtrlVar.hpower=1;
CtrlVar.RefineDiracDeltaInvWidth=1000;



%CtrlVar.RefineCriteria='thickness gradient';
%CtrlVar.RefineCriteria='flotation';
% CtrlVar.RefineCriteria='gradient of effective strain rates';

CtrlVar.iJob=11;
CtrlVar.kH=1e4/CtrlVar.MeshSize;

CtrlVar.NLtol=1e-10; % this is the square of the error, i.e. not root-mean-square error
CtrlVar.InfoLevelNonLinIt=10;
CtrlVar.NRitmax=100;
    
CtrlVar.ThickMin=0.01; % minimum allowed thickness without doing something about it

CtrlVar.CalvingFrontFullyFloating=0;
end
