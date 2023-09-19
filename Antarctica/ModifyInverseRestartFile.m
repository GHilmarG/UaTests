

%%  Modifying the data erros


load("Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile.mat")

CtrlVar=CtrlVarInRestartFile;





FindOrCreateFigure("Old u errors")
sqrt(full(diag(Meas.usCov))) ; 
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,log10(sqrt(full(diag(Meas.usCov))))) ;  title("old log10(u) errors") ; 

f=0.1 ; 
speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ; 
Error=f*speed ; 
Error=max(Error(:),f*10) ; 
Meas.usCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,Error.^2,MUA.Nnodes,MUA.Nnodes);
Meas.vsCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,Error.^2,MUA.Nnodes,MUA.Nnodes);

FindOrCreateFigure("New u errors")
sqrt(full(diag(Meas.usCov))) ; 
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,log10(sqrt(full(diag(Meas.usCov))))) ;  title("new log10(u) errors") ; 
%%  settign uv erros constant accross the domain


load("Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile.mat")
CtrlVar=CtrlVarInRestartFile;


UaPlots(CtrlVarInRestartFile,MUA,F,full(diag(Meas.usCov)),FigureTitle="original uv data errors" );

Error=1; 
Meas.usCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,Error.^2,MUA.Nnodes,MUA.Nnodes);
Meas.vsCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,Error.^2,MUA.Nnodes,MUA.Nnodes);

UaPlots(CtrlVarInRestartFile,MUA,F,full(diag(Meas.usCov)),FigureTitle="new uv data errors" );

save("Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile.mat")

%% Set erros at the boundary nodes to a high value

load("Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile.mat")
CtrlVar=CtrlVarInRestartFile;
UserVar=UserVarInRestartFile;
% PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);



Nodes=MUA.Boundary.Nodes;

for k=1:numel(Nodes)
    ii=Nodes(k);
    Meas.usCov(ii,ii)=1e+5;
    Meas.vsCov(ii,ii)=1e+5;
end


% PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);
save("Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile.mat")

%%