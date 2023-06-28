


%%
% Klear ; load("../../GaussPeak/TestSaveBacktrack.mat","CtrlVar","UserVar","RunInfo","MUA","F","l","Kuv","L","cuv","dl","dub","dvb","frhs","grhs","fext0")

%% uv test

load TestSaveBack.mat

func=@(gamma,Du,Dv,Dl) CalcCostFunctionNR(UserVar,RunInfo,CtrlVar,MUA,gamma,F,fext0,L,l,cuv,Du,Dv,Dl) ;

dh=[];  dJdh=[] ;

dJdu=frhs(1:MUA.Nnodes);
dJdv=frhs(MUA.Nnodes+1:2*MUA.Nnodes);
dJdl=grhs ;
Normalisation=fext0'*fext0+1000*eps;
CtrlVar.InfoLevelBackTrack=1000;  CtrlVar.InfoLevelNonLinIt=10 ;


[gamma,r,du,dv,dh,dl,BackTrackInfo,rForce,rWork,D2] = rLineminUa(CtrlVar,UserVar,func,r0,r1,Kuv,L,dub,dvb,dh,dl,dJdu,dJdv,dJdh,dJdl,Normalisation,MUA.M) ;

%%
Klear
warning('off','MATLAB:decomposition:SaveNotSupported')
warning('off','MATLAB:decomposition:genericError')
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:SaveNotSupported');


%  uvh


load TestSaveBack_uvhInt.mat



dJdu=frhs(1:MUA.Nnodes);
dJdv=frhs(MUA.Nnodes+1:2*MUA.Nnodes);
dJdh=frhs(2*MUA.Nnodes+1:3*MUA.Nnodes);
dJdl=grhs ;

Normalisation=Fext0'*Fext0+1000*eps;

func=@(gamma,Du,Dv,Dh,Dl) CalcCostFunctionNRuvh(UserVar,RunInfo,CtrlVar,MUA,F1,F0,Du,Dv,Dh,Dl,L,luvh,cuvh,gamma,Fext0) ;


r0=func(0,dub,dvb,dh,dl) ;
r1=func(1,dub,dvb,dh,dl) ;

 CtrlVar.InfoLevelBackTrack=1000;  CtrlVar.InfoLevelNonLinIt=10 ;
[gamma,r,du,dv,dh,dl,BackTrackInfo,rForce,rWork,D2] = rLineminUaTest(CtrlVar,UserVar,func,r0,r1,K,L,dub,dvb,dh,dl,dJdu,dJdv,dJdh,dJdl,Normalisation,MUA.M) ;




 