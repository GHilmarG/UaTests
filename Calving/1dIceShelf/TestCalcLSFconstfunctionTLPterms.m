%%
load TestSave2

CtrlVar.LevelSetPhase="Propagation and FAB" ;
CtrlVar.LevelSetTheta=0.5 ; 
[UserVar,RunInfo,F1.LSF,Mask,l,LSFqx,LSFqy]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,l);

CalcLSFconstfunctionTLPterms(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,l,F1.LSF);


%%
CtrlVar.LevelSetFixPointSolverApproach="-PTS-FFP-";
CtrlVar.LevelSetReinitializePDist=1;
CtrlVar.LevelSetPseudoFixPointSolverMaxIterations=10;
CtrlVar.LevelSetTheta=1;
[UserVar,RunInfo,LSFini,Mask,l,~,~,BCsLevel]=LevelSetEquationInitialisation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,l);
F0.LSF=LSFini;
F1.LSF=LSFini;


CalcLSFconstfunctionTLPterms(UserVar,RunInfo,CtrlVar,MUA,BCsLevel,F0,F1,l,LSFini);

% and then recalculate as it would be done
CtrlVar.LevelSetTheta=0.5 ; 
CalcLSFconstfunctionTLPterms(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,l,F1.LSF);
%%