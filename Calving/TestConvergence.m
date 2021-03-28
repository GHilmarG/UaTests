%%
Klear ; load Dump_uvh


CtrlVar.InfoLevelNonLinIt=1000; CtrlVar.doplots=1 ; 

% BCs1.hPosNode=[] ; BCs1.hPosValue=[] ;
%F0.h(BCs1.hPosNode)=BCs1.hPosValue ; 
%F1.h(BCs1.hPosNode)=BCs1.hPosValue ; 

%CtrlVar.uvhMinimisationQuantity="Work Residuals" ;

CtrlVar.LevelSetMethodAutomaticallyApplyMassBalanceFeedback=1 ; 
[UserVar,RunInfo,F1,l1,BCs1]=uvh2D(UserVar,RunInfo,CtrlVar,MUA,F0,F1,l1,BCs1);