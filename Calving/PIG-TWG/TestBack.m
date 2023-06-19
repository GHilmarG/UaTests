load TestSaveBack.mat


%%
Klear
load("../../GaussPeak/TestSaveBacktrack.mat","CtrlVar","UserVar","RunInfo","MUA","F","l","Kuv","L","cuv","dl","dub","dvb","frhs","grhs","fext0")


CtrlVar.BacktrackingGammaMin=1e-11; CtrlVar.InfoLevelBackTrack=1000;


func=@(gamma,Du,Dv,Dl) CalcCostFunctionNR(UserVar,RunInfo,CtrlVar,MUA,gamma,F,fext0,L,l,cuv,Du,Dv,Dl) ;

dh=[] ; dJdh=[] ; 

dJdu=frhs(1:MUA.Nnodes);
dJdv=frhs(MUA.Nnodes+1:2*MUA.Nnodes);
dJdl=grhs ;

Normalisation=fext0'*fext0+1000*eps;
[gammamin,rmin,BackTrackInfo] = rLineminUa(CtrlVar,UserVar,func,Kuv,L,dub,dvb,dh,dl,dJdu,dJdv,dJdh,dJdl,Normalisation) ; 




%%
CtrlVar.InfoLevelBackTrack=1000;
CtrlVar.BacktrackingGammaMin=1e-11; 



Func=@(gamma) CalcCostFunctionNR(UserVar,RunInfo,CtrlVar,MUA,gamma,F,fext0,L,l,cuv,dub,dvb,dl) ;
gamma=0 ; [r0,UserVar,RunInfo,rForce0,rWork0,D20,frhs,grhs,Normalisation]=Func(gamma);
gamma=1 ; [r1,UserVar,RunInfo,rForce1,rWork1,D21]=Func(gamma);

slope0=-2*r0 ;
dxNewton=[dub ;dvb ;dl ] ;
gradJ=[frhs;grhs] ;



CtrlVar.uvMinimisationQuantity="Force Residuals" ;
[gamma,r,BackTrackInfo]=BackTracking(slope0,1,r0,r1,Func,CtrlVar);

%%  Direct descent direction with backtracking
% Newton direction is [dub;dvb;dl]
% Steepest descent is [frhs; grhs]



dJdu=frhs(1:MUA.Nnodes);
dJdv=frhs(MUA.Nnodes+1:2*MUA.Nnodes);
dJdl=grhs ;

R=[dJdu;dJdv;dJdl]; 
[nL,mL]=size(L);
C=sparse(nL,nL);
H=[Kuv L' ;L C] ;


slope0Descent=-2*R'*H*R/Normalisation ;

FuncDescent=@(gamma) CalcCostFunctionNR(UserVar,RunInfo,CtrlVar,MUA,gamma,F,fext0,L,l,cuv,dJdu,dJdv,dJdl) ;


gamma=0 ; [r0,UserVar,RunInfo,rForce0,rWork0,D20,frhs,grhs]=FuncDescent(gamma);



b = -0.1 *r0/slope0Descent ;  % initial step size
gamma=b ; [rb,UserVar,RunInfo,rForce1,rWork1,D21]=FuncDescent(gamma);

CtrlVar.InfoLevelBackTrack=1000;
CtrlVar.BacktrackingGammaMin=1e-13; CtrlVar.LineSearchAllowedToUseExtrapolation=true;
[gamma,r,BackTrackInfo]=BackTracking(slope0Descent,b,r0,rb,FuncDescent,CtrlVar);



%% Cauchy


 gammaCauchy = (R' * H * R) / (R' *H'* H * R ) ;

  [rCauchy]=FuncDescent(gammaCauchy);





