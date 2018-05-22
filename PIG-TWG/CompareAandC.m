%%
             
Res{1}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs1k000000-Aga1k000000-Ags1k000000-0-0-logAGlenlogC.mat');
Res{10}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs10k000000-Aga1k000000-Ags10k000000-0-0-logAGlenlogC.mat');
Res{100}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs100k000000-Aga1k000000-Ags100k000000-0-0-logAGlenlogC.mat');
Res{1000}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs1000k000000-Aga1k000000-Ags1000k000000-0-0-logAGlenlogC.mat');
Res{10000}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs10000k000000-Aga1k000000-Ags10000k000000-0-0-logAGlenlogC.mat');
Res{25000}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs25000k000000-Aga1k000000-Ags25000k000000-0-0-logAGlenlogC.mat');
Res{100000}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs100000k000000-Aga1k000000-Ags100000k000000-0-0-logAGlenlogC.mat');
Res{250000}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs250000k000000-Aga1k000000-Ags250000k000000-0-0-logAGlenlogC.mat');
Res{500000}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs500000k000000-Aga1k000000-Ags500000k000000-0-0-logAGlenlogC.mat');
Res{750000}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs750000k000000-Aga1k000000-Ags750000k000000-0-0-logAGlenlogC.mat');
Res{1000000}=load('IR-UaOpt-ConjGrad-UaOptimization-Nod3-I-Adjoint-Cga1k000000-Cgs1000000k000000-Aga1k000000-Ags1000000k000000-0-0-logAGlenlogC.mat');

%%

for K=[1 10 100 1000 10000 25000 100000 250000 500000 750000  1000000]
    figure(K)   ; PlotMeshScalarVariable(Res{K}.CtrlVarInRestartFile,Res{K}.MUA,log10(Res{K}.InvFinalValues.C)); title(sprintf('C (%i)',K));
    figure(K+1) ; PlotMeshScalarVariable(Res{K}.CtrlVarInRestartFile,Res{K}.MUA,log10(Res{K}.InvFinalValues.AGlen)); title(sprintf('A (%i)',K));
end




%%

%%


J=0;

for K=[1 10 100 1000 10000 25000 100000 250000 500000 750000 1000000]
    
    Res{K}.CtrlVarInRestartFile.Inverse.Regularize.logC.gs=1;
    Res{K}.CtrlVarInRestartFile.Inverse.Regularize.logC.ga=1;
    Res{K}.CtrlVarInRestartFile.Inverse.Regularize.logAGlen.gs=1;
    Res{K}.CtrlVarInRestartFile.Inverse.Regularize.logAGlen.ga=1;
    
    
    [Rtemp,Temp2,Temp3,RegOuts]=Regularisation(Res{K}.UserVarInRestartFile,Res{K}.CtrlVarInRestartFile,Res{K}.MUA,Res{K}.BCs,Res{K}.F,Res{K}.l,Res{K}.GF,Res{K}.Priors,Res{K}.Meas,Res{K}.BCsAdjoint,Res{K}.RunInfo) ;
        
    J=J+1;
    I(J)=Res{K}.InvFinalValues.I;
    R(J)=RegOuts.R;
    Label{J}=num2str(K);
    
end


%%

figure ; plot(R(:),I(:),'o-') ; 
text(R,I,Label)

xlabel('Regularisation') ;  ylabel('Model misfit') ; 
