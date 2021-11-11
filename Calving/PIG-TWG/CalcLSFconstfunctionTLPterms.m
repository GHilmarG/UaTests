function CalcLSFconstfunctionTLPterms(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,l,LSF)






fprintf("\n LSF: fix point solver \n")

F1.LSF=LSF ; 

% P/L : 0.001697    9.9e6
% P/L : 0.013       1.8e8
% P/L : 0.015       1.1e9


% Testing residuals towards an automated criterion
gamma=0 ; CtrlVar.LevelSetTheta=1 ; L=[] ; Lrhs=[] ; dLSF=0 ; dl=0 ; 



CtrlVar.LSF.P=1 ; CtrlVar.LSF.T=0 ; CtrlVar.LSF.L=0 ; % Fixed point
[rP,UserVar,RunInfo,rForce,rWork,D2]=CalcCostFunctionLevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,gamma,F1,F0,L,Lrhs,l,dLSF,dl,BCs) ; 

CtrlVar.LSF.P=1 ; CtrlVar.LSF.T=1 ; CtrlVar.LSF.L=0 ; % Pseudo time stepping
[rPT,UserVar,RunInfo,rForce,rWork,D2]=CalcCostFunctionLevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,gamma,F1,F0,L,Lrhs,l,dLSF,dl,BCs) ; 

CtrlVar.LSF.P=1 ; CtrlVar.LSF.T=1 ; CtrlVar.LSF.L=1 ; % Pseudo time stepping
[rPTL,UserVar,RunInfo,rForce,rWork,D2]=CalcCostFunctionLevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,gamma,F1,F0,L,Lrhs,l,dLSF,dl,BCs) ;

CtrlVar.LSF.P=0 ; CtrlVar.LSF.T=0 ; CtrlVar.LSF.L=1 ; % advection term
[rL,UserVar,RunInfo,rForce,rWork,D2]=CalcCostFunctionLevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,gamma,F1,F0,L,Lrhs,l,dLSF,dl,BCs) ;

fprintf('                     P residual %g \n',rP)
fprintf('                     L residual %g \n',rL)
fprintf('  Pseudo-time stepping residual %g \n',rPT)
fprintf('                  Full residual %g \n',rPTL)
fprintf('                            P/L %g \n',rP/rL)




end
