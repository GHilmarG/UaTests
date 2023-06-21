


%%
% Klear ; load("../../GaussPeak/TestSaveBacktrack.mat","CtrlVar","UserVar","RunInfo","MUA","F","l","Kuv","L","cuv","dl","dub","dvb","frhs","grhs","fext0")



load TestSaveBack.mat

func=@(gamma,Du,Dv,Dl) CalcCostFunctionNR(UserVar,RunInfo,CtrlVar,MUA,gamma,F,fext0,L,l,cuv,Du,Dv,Dl) ;

dh=[];  dJdh=[] ;

dJdu=frhs(1:MUA.Nnodes);
dJdv=frhs(MUA.Nnodes+1:2*MUA.Nnodes);
dJdl=grhs ;
Normalisation=fext0'*fext0+1000*eps;
CtrlVar.InfoLevelBackTrack=1000;  CtrlVar.InfoLevelNonLinIt=10 ;


[gamma,r,du,dv,dh,dl,BackTrackInfo,rForce,rWork,D2] = rLineminUa(CtrlVar,UserVar,func,r0,r1,Kuv,L,dub,dvb,dh,dl,dJdu,dJdv,dJdh,dJdl,Normalisation,MUA.M) ;

  

