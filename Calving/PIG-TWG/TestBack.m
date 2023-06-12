load TestSaveBack.mat


%%
CtrlVar.InfoLevelBackTrack=1000;
CtrlVar.BacktrackingGammaMin=1e-11; 


Func=@(gamma) CalcCostFunctionNR(UserVar,RunInfo,CtrlVar,MUA,gamma,F,fext0,L,l,cuv,dub,dvb,dl) ;
gamma=0 ; [r0,UserVar,RunInfo,rForce0,rWork0,D20,frhs,grhs,Normalisation]=Func(gamma);
gamma=1 ; [r1,UserVar,RunInfo,rForce1,rWork1,D21]=Func(gamma);

slope0=-2*r0 ;
dxNewton=[dub ;dvb ;dl ] ;
gradJ=[frhs;grhs] ;

% J^2(x0+gamma dxNewton)   
% d(J^2)/dgamma = 2 J  gradJ  \cdot dxNewton
%               = 2 J  gradJ \cdot (H \ gradJ)
%  
% = 2 J 
slope0Test = -(gradJ'*dxNewton)/Normalisation ;

CtrlVar.uvMinimisationQuantity="Force Residuals" ;
[gamma,r,BackTrackInfo]=BackTracking(slope0,1,r0,r1,Func,CtrlVar);

%%
% Newton direction is [dub;dvb;dl]
% Steepest descent is [frhs; grhs]

dJdu=frhs(1:MUA.Nnodes);
dJdv=frhs(MUA.Nnodes+1:2*MUA.Nnodes);
dJdl=grhs ;


 

FuncDescent=@(gamma) CalcCostFunctionNR(UserVar,RunInfo,CtrlVar,MUA,gamma,F,fext0,L,l,cuv,dJdu,dJdv,dJdl) ;


gamma=0 ; [r0,UserVar,RunInfo,rForce0,rWork0,D20frhs,grhs]=FuncDescent(gamma);

slop0Descent=2

b = -0.0001 *r0/slope0 ;  % initial step size
gamma=b ; [rb,UserVar,RunInfo,rForce1,rWork1,D21]=FuncDescent(gamma);

CtrlVar.InfoLevelBackTrack=1000;
CtrlVar.BacktrackingGammaMin=1e-13; 
[gamma,r,BackTrackInfo]=BackTracking(slope0Descent,b,r0,rb,FuncDescent,CtrlVar);