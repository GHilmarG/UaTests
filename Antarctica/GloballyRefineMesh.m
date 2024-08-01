



%%

% load("AntarcticaMUAwith54kElements")
%load("AntarcticaMUAwith218kElements111kNodes","MUA")
load("AntarcticaMUAwith873kElements440kNodes.mat","MUA") ; 
%%

CtrlVar=Ua2D_DefaultParameters;

MUAold=MUA;

ElementsToBeCoarsened=false(MUAold.Nele,1);
ElementsToBeRefined=true(MUAold.Nele,1);

CtrlVar.MeshRefinementMethod='explicit:local:red-green' ;
CtrlVar.LocalAdaptMeshSmoothingIterations=0;   % Maximum number of smoothing iteration using the 'red-green' local mesh refinement option. 
                                                % Set to zero to disable mesh-smoothing after red-green refinement operation.
RunInfo=UaRunInfo; 
[MUAnew,RunInfo]=LocalMeshRefinement(CtrlVar,RunInfo,MUAold,ElementsToBeRefined,ElementsToBeCoarsened) ; 



FindOrCreateFigure("MUA original") ; PlotMuaMesh(CtrlVar,MUA); 

FindOrCreateFigure("MUAnew: Mesh refined local:red-green") ; PlotMuaMesh(CtrlVar,MUAnew); 


%%

MUA=MUAnew ; 
MUA.dM=[] ; % I can't save this anyhow

%save("AntarcticaMUAwith218kElements111kNodes","MUA")
% save("AntarcticaMUAwith873kElements440kNodes","MUA") ;
save("AntarcticaMUAwith3494kElements1754kNodes","MUA")

%%