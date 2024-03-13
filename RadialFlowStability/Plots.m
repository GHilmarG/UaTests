

%%
%cd res
CtrlVar=Ua2D_DefaultParameters();
load("F37","F") ; 
load("MUA37","MUA") ;
CtrlVar.time=F.time;
UaPlots(CtrlVar,MUA,F,"-uv-")