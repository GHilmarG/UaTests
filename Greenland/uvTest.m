
%%
load("uvTestSave.mat","UserVar","CtrlVar","RunInfo","MUA","BCs","F","l")


[UserVar,RunInfo,F,l,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l); 


%%

To=6; 
 [UserVar,MUA6,F6,BCs6]=ChangeOrderOfMUAandF(CtrlVar,UserVar,MUA,F,BCs,To);
 
l6=l; 
%%
l6=[];
CtrlVar.TriNodes=6;
MUA6=UpdateMUA(CtrlVar,MUA6);
[UserVar,RunInfo,F6,l6,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA6,BCs6,F6,l6); 

%%