function F=DefineF(CtrlVar,MUA)


F=UaFields;
n=MUA.Nnodes;

h=300;
rho=920;
rhow=1030;

F.s=zeros(n,1);
F.b=zeros(n,1);
F.h=zeros(n,1)+h;
F.S=zeros(n,1);
F.B=zeros(n,1)-1e10;
F.ub=zeros(n,1);
F.vb=zeros(n,1);
F.rho=zeros(n,1)+rho;
F.rhow=rhow;
F.AGlen=zeros(n,1)+AGlenVersusTemp(-10) ;
F.C=zeros(n,1)+1 ;
F.g=9.81/1000;
F.alpha=0;

F.x=MUA.coordinates(:,1) ;
F.y=MUA.coordinates(:,2) ;


F.n=zeros(n,1)+3;
F.m=zeros(n,1)+3;


[F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow);

end