


%%




load("srDump.mat")
CtrlVar.InfoLevelNonLinIt=10;
CtrlVar.InfoLevelBackTrack=10000 ;

[UserVar,RunInfo,F,l,BCs,dt]=uvh2(UserVar,RunInfo,CtrlVar,MUA,F0,F,l,l,BCs);

%%