load TestSaveCalculateReactions

CtrlVar.MUA.DecomposeMassMatrix=true ;
MUA=UpdateMUA(CtrlVar,MUA) ; 

tic
Reactions=CalculateReactions(CtrlVar,MUA,BCs,l);
toc