




%% Read in results of calculated velocities

load("InverseRestartFile-Weertman-Ca1-Cs100000-Aa1-As100000-5km-Alim-.mat","CtrlVarInRestartFile","MUA","F","Meas","InvFinalValues","UserVarInRestartFile") ;


UserVar=[]; 
CtrlVar=CtrlVarInRestartFile;
MUA=UpdateMUA(CtrlVar,MUA);


%%
FindOrCreateFigure("Modelled Velocitie");

QuiverColorGHG(F.x,F.y,F.ub,F.vb,CtrlVar) ;
hold on ; 
[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,F.GF);
[xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,"b") ;


%%



dsdt=F.x*0 ; dhdt=F.x*0; 

[ab,qx,qy,dqxdx,dqxdy,dqydx,dqydy]=CalcIceShelfMeltRates(CtrlVar,MUA,F.ub,F.vb,F.s,F.b,F.S,F.B,F.rho,F.rhow,dsdt,F.as,dhdt) ;

FindOrCreateFigure("Directly calculated basal melt rates") ;
[cbar,xGL,yGL,xCF,yCF]=UaPlots(CtrlVar,MUA,F,ab);

ds=3e3;  ID=FindAllNodesWithinGivenRangeFromGroundingLine(CtrlVar,MUA,xCF,yCF,ds) ; 
abNoCF=ab ; abNoCF(ID)=NaN;

FindOrCreateFigure("Directly calculated basal melt rates excluding calving fronts") ;
[cbar,xGL,yGL,xCF,yCF]=UaPlots(CtrlVar,MUA,F,abNoCF);

%%


ga=0; gs=1e7 ;  R= ga* MUA.M  + gs *(MUA.Dxx+MUA.Dyy);

P=MUA.M ;

tic ; abEst=(R+P)\ (P*ab); toc
abEst(ID)=nan;

FindOrCreateFigure(sprintf("Regularized basal melt rates ga=%i gs=%i",ga,gs)) ;
hold off
UaPlots(CtrlVar,MUA,F,abEst);

% axis([-1660 -1530 -360 -240])



%% inspect results

FindOrCreateFigure("ab scatter plots Whole Region")
I=F.GF.node<0.5 & F.b < -100; 
abEst(ID)=nan ; 
plot(abEst(I),F.b(I),'.k')
xlabel("ab est (m/yr)"); ylabel("ice shelf draft (m)")
hold on 

% FindOrCreateFigure("ab scatter plots PIG")

I=F.GF.node<0.5 ;
I=I & F.x>-1660e3 & F.x < -1540e3  & F.y > -360e3  & F.y<-240e3  & F.b  <-100 ;
abEst(ID)=nan ; 
plot(abEst(I),F.b(I),'.r')
xlabel("ab est (m/yr)"); ylabel("ice shelf draft (m)")
hold on 



% FindOrCreateFigure("ab scatter plots Thwaites")
I=F.GF.node<0.5 ;
I=I & F.x>-1620e3 & F.x < -1500e3  & F.y > -500e3  & F.y<-400e3  & F.b  <-100 ;
abEst(ID)=nan ; 
plot(abEst(I),F.b(I),'.b')


% FindOrCreateFigure("ab scatter plots Crosson and Dotson")
I=F.GF.node<0.5 ;
I=I & F.x>-1620e3 & F.x < -1400e3  & F.y > -700e3  & F.y<-500e3  & F.b  <-10 ;
abEst(ID)=nan ; 
plot(abEst(I),F.b(I),'.g')
xlabel("ab est (m/yr)"); ylabel("ice shelf draft (m)")


MRP="0";
abPar=DraftDependentMeltParameterisations(UserVar,CtrlVar,F,"0") ; 
hold on 
plot(abPar(I),F.b(I),'oc')

legend("all","PIG","Thwaites","D+C","MRP"+MRP)

%%


MPA="0" ; 
abPar=DraftDependentMeltParameterisations(UserVar,CtrlVar,F,MPA) ; 
abPar(F.GF.node>0.5)=0 ; 
FindOrCreateFigure("parameterized melt rate"+MPA)
UaPlots(CtrlVar,MUA,F,abPar)

%%


    
FindOrCreateFigure("ice shelf draft")
hold off
d=F.b;
d(F.GF.node>0.5)=nan ;
d(F.LSF<1)=nan ;
UaPlots(CtrlVar,MUA,F,d);


%%    
FindOrCreateFigure("ice shelf cavity thickness")
hold off
d=F.b-F.B ;
d(F.GF.node>0.5)=nan ;
d(F.LSF<1)=nan ;
UaPlots(CtrlVar,MUA,F,d);

%%
FindOrCreateFigure("basal gradient")
hold off
d=F.b-F.B ;
d(F.GF.node>0.5)=nan ; d(F.LSF<1)=nan ;
UaPlots(CtrlVar,MUA,F,d);


%%
[dbdxInt,dbdyInt,xint,yint]=calcFEderivativesMUA(F.b,MUA) ;
[dbdx,dbdy]=ProjectFintOntoNodes(MUA,dbdxInt,dbdyInt) ;
G=sqrt(dbdx.*dbdx+dbdy.*dbdy);

ga=0; gs=1e7 ;  R= ga* MUA.M  + gs *(MUA.Dxx+MUA.Dyy); P=MUA.M ;

tic ; Gradient=(R+P)\ (P*G); toc

Gradient(F.GF.node>0.5)=nan ; Gradient(F.LSF<1)=nan ;

FindOrCreateFigure("lower surface gradient")
UaPlots(CtrlVarInRestartFile,MUA,F,Gradient) ;
%% atempt a new parameterisation 










