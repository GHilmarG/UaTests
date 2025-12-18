%%


load("Nod6TestSave.mat","UserVar","RunInfo","CtrlVar","MUA","BCs","F","l");


CtrlVar.NRitmax=150;   
CtrlVar.NRitmin=1;  
[UserVar,RunInfo,F,l,Kuv,Ruv,Lubvb]=SSTREAM2dNR2(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l);


%%