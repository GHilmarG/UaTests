function [UserVar,uo,vo,Co,mo,ua,va,Ca,ma]=DefineSeaIceParameters(UserVar,CtrlVar,MUA,BCs,GF,ub,vb,ud,vd,uo,vo,ua,va,s,b,h,S,B,rho,rhow,AGlen,n,C,m)

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

Co=1;
mo=1;

uo=x*0+1000 ;  %abs(x-mean(x))/1e5  ;
vo=y*0;

Ca=1e10;
ma=1;
ua=zeros(MUA.Nnodes,1) ;
va=zeros(MUA.Nnodes,1) ;




end