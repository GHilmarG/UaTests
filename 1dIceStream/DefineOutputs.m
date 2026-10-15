





function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s") 
CM=cmocean('ice',25,'pivot',0) ; colormap(CM);

UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="uv")  


UaPlots(CtrlVar,MUA,F,"-speed-",FigureTitle="speed",logColorbar=true)  ;


cbar=UaPlots(CtrlVar,MUA,F,F.dhdt,FigureTitle="dh/dt",PlotUnderMesh=true)  ;
CM=cmocean('-balanced',25,'pivot',0) ; colormap(CM);
title("$\dot{h}$",Interpreter="latex")
title(cbar,"(m/yr)")

end