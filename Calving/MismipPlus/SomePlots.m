
%%
load 0025000-Nodes652-Ele1158-Tri3-kH1000-MismipPlus-FixedRate100-Keeper.mat


FindOrCreateFigure("CalvingFrontMovement")

plot(Ct,Cx/1000,'ob')
ylabel("Calving Front Position (km)",Interpreter="latex")
xlabel("time (yr)",Interpreter="latex")

I=~isnan(Ct); Ct=Ct(I) ; Cx=Cx(I) ;  n=numel(Ct)  ; A=[ones(n,1) Ct] ; sol=A\Cx ; 
title(sprintf("C=100 and rate=%f",-sol(2)))

load("ResultsFiles/0010000-Nodes652-Ele1158-Tri3-kH1000-MismipPlus-FixedRate100-.mat")

hold on  ; plot(Ct,Cx/1000,'*r')


load("ResultsFiles/0010000-Nodes652-Ele1158-Tri3-kH1000-MismipPlus-IceThickness1-.mat")  % this was a run with c=h
hold on  ; plot(Ct,Cx/1000,'+g')
I=~isnan(Ct); Ct=Ct(I) ; Cx=Cx(I) ;  n=numel(Ct)  ; A=[ones(n,1) Ct] ; sol=A\Cx ; fprintf(" rate %f m/yr \n",-sol(2)) ; 

load("ResultsFiles/0010000-Nodes652-Ele1158-Tri3-kH1000-MismipPlus-IceThickness10-.mat")
hold on  ; plot(Ct,Cx/1000,'^m')
I=~isnan(Ct); Ct=Ct(I) ; Cx=Cx(I) ;  n=numel(Ct)  ; A=[ones(n,1) Ct] ; sol=A\Cx ; fprintf(" rate %f m/yr \n",-sol(2)) ; 

%%
figure
%load("ResultsFiles/0010000-Nodes1055-Ele1948-Tri3-kH1000-MismipPlus-FixedRate100-Keeper.mat")
load("ResultsFiles/0010000-Nodes1195-Ele2230-Tri3-kH1000-MismipPlus-FixedRate1000-.mat") ;
load("ResultsFiles/0010000-Nodes1423-Ele2678-Tri3-kH1000-MismipPlus-FixedRate1000-constant-muValue1-IniInf-PDist1.mat") ; 
load("ResultsFiles/0010000-Nodes1177-Ele2192-Tri3-kH1000-MismipPlus-FixedRate1000-ucl-muValue1-IniInf-PDist1-Keeper.mat ") ;
hold on  ; plot(Ct,Cx/1000,'^m')
I=~isnan(Ct); Ct=Ct(I) ; Cx=Cx(I) ;  n=numel(Ct)  ; A=[ones(n,1) Ct] ; sol=A\Cx ; fprintf(" rate %f m/yr \n",-sol(2)) ; 
c=1000 ;
plot(Ct,(Cx(end)-(Ct-Ct(end))*c)/1000,'k')

