
%%
%
% Initialize solving the suitable norm of the eikonal equation with BCs
% 
% Evolve with FAB without Dirichlet BCs
%
%

clearvars
load LSFtest

CtrlVar.LevelSetInfoLevel=1; 
xc=200e3;  % this is the initial calving front
BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs);

% Testing
F0.LSF=0*(xc-MUA.coordinates(:,1)) ;
F1.LSF=0*(xc-MUA.coordinates(:,1)) ;

F1.ub=F1.ub*0+0  ;   F0.ub=F0.ub*0+0 ;  F1.vb=F1.ub*0  ;   F0.vb=F0.ub*0 ; 
F1.c=F1.c*0 ;
F0.c=F0.c*0 ; 
 % F0.LSF(BCs.LSFFixedNode)=BCs.LSFFixedValue;
 % F1.LSF(BCs.LSFFixedNode)=BCs.LSFFixedValue;

CtrlVar.LevelSetPhase="Initialisation" ; 
CtrlVar.LevelSetSolutionMethod="Newton Raphson";
CtrlVar.LevelSetFABCostFunction="p2q2"; 
CtrlVar.LevelSetTheta=0.5; 
[UserVar,RunInfo,LSF,Mask,lambda]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);

F1.LSF = LSF ;
TestLevelSetPlots(CtrlVar,UserVar,MUA,F1);

fprintf('\n \n ')
CtrlVar.LevelSetPhase="Propagation" ; 
% CtrlVar.LevelSetPhase="Propagation and FAB" ; 

F0.LSF = F1.LSF ; 
F1.ub=F1.ub*0+1000  ;   F0.ub=F0.ub*0+1000 ;  F1.vb=F1.ub*0  ;   F0.vb=F0.ub*0 ; 
F1.c=-11*F1.ub ; F0.c=-11*F0.ub ; 
BCs.LSFFixedNode=[];
BCs.LSFFixedValue=[]; 
N=100; CtrlVar.dt=0.1;  
for iRunStep=1:N
    
    [UserVar,RunInfo,F1.LSF,Mask,lambda]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);
    
    
    TestLevelSetPlots(CtrlVar,UserVar,MUA,F1);
    
    CtrlVar.time=CtrlVar.time+CtrlVar.dt ;
    F0=F1 ;
    
end

