




function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)




if    CtrlVar.DefineOutputsInfostring == "End of Inverse Run"

    %%

    ProfilePlots(UserVar,CtrlVar,RunInfo,MUA,BCs,F,l,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint) ;

end

%%







