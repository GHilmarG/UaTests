
load TestSaveRestart

%%
figure ; UaPlots(CtrlVar,MUA,F,log10(F.C));
figure ; UaPlots(CtrlVar,MUA,F,log10(F.AGlen));
figure ; UaPlots(CtrlVar,MUA,F,"speed");

%%

[UserVar,RunInfo,Ftest,l,BCs,dt]=uvh(UserVar,RunInfo,CtrlVar,MUA,F0,F,l,l,BCs);


%%

F=F0; [UserVar,RunInfo,Ftest,l,BCs,dt]=uvh(UserVar,RunInfo,CtrlVar,MUA,F0,F,l,l,BCs);


%%

CtrlVar.uvh.SUPG.tau="taus" ; % default,  issues with uvh convergence in the beginning
CtrlVar.uvh.SUPG.tau="tau1" ; % testing
CtrlVar.SUPG.beta0=1 ; CtrlVar.SUPG.beta1=0 ;
CtrlVar.dt=0.1;
F=F0; [UserVar,RunInfo,Ftest,l,BCs,dt]=uvh(UserVar,RunInfo,CtrlVar,MUA,F0,F,l,l,BCs);