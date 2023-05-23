load TestSaveJuvOpt

%%

[F,J,RunInfo]=JuvOpt(UserVar,RunInfo,CtrlVar,MUA,BCs,F) ;

[norm(F.ub) ,norm(F.vb)]