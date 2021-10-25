
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

%load("ResultsFiles/0010000-Nodes1055-Ele1948-Tri3-kH1000-MismipPlus-FixedRate100-Keeper.mat")
load("ResultsFiles/0010000-Nodes1195-Ele2230-Tri3-kH1000-MismipPlus-FixedRate1000-.mat") ;
load("ResultsFiles/0010000-Nodes1423-Ele2678-Tri3-kH1000-MismipPlus-FixedRate1000-constant-muValue1-IniInf-PDist1.mat") ; 
load("ResultsFiles/0010000-Nodes1177-Ele2192-Tri3-kH1000-MismipPlus-FixedRate1000-ucl-muValue1-IniInf-PDist1-Keeper.mat ") ;

File(1)="ResultsFiles/0010000-Nodes1187-Ele2211-Tri3-kH1000-MismipPlus-FixedRate1000-ucl-muValue0k1-IniInf-PDist1.mat" ;
File(2)="ResultsFiles/0010000-Nodes1177-Ele2192-Tri3-kH1000-MismipPlus-FixedRate1000-ucl-muValue1-IniInf-PDist1-Keeper.mat " ;
File(3)="ResultsFiles/0010000-Nodes1174-Ele2184-Tri3-kH1000-MismipPlus-FixedRate1000-ucl-muValue10-IniInf-PDist1.mat" ; 
File(4)="ResultsFiles/0010000-Nodes1172-Ele2178-Tri3-kH1000-MismipPlus-FixedRate1000-ucl-muValue100-IniInf-PDist1.mat" ; 

File(5)="ResultsFiles/0010000-Nodes1293-Ele2418-Tri3-kH1000-MismipPlus-FixedRate1000-ucl-muValue0k001-IniInf-PDist1"; 
File(6)="ResultsFiles/0010000-Nodes1177-Ele2189-Tri3-kH1000-MismipPlus-FixedRate1000-ucl-muValue10000-IniInf-PDist1";
File(7)="ResultsFiles/0010000-Nodes1174-Ele2186-Tri3-kH1000-MismipPlus-FixedRate1000-ucl-muValue1000-IniInf-PDist1";



Sym=["ro","b+","c*","m^","k*","g*","r+"] ;


FindOrCreateFigure("compare")
for I=6:7
    load(File(I))
    hold on  ; plot(Ct,Cx/1000,Sym(I))
    I=~isnan(Ct); Ct=Ct(I) ; Cx=Cx(I) ;  n=numel(Ct)  ; A=[ones(n,1) Ct] ; sol=A\Cx ; fprintf(" rate %f m/yr \n",-sol(2)) ;
    c=1000 ;
    plot(Ct,(Cx(end)-(Ct-Ct(end))*c)/1000,'k')
end



