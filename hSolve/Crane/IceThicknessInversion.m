


CtrlVar=Ua2D_DefaultParameters(); 

[UserVar,CtrlVar,MUA,F,BCs,Priors,Meas,kIso,kAlong,kCross,Method]=DefineDataForThicknessInversion(CtrlVar) ; 




[UserVar,hest,lambda]=hEquation(UserVar,CtrlVar,MUA,F,BCs,kIso,kAlong,kCross,Method,Priors,Meas); 




PlotResultsFromThicknessInversion(CtrlVar,MUA,F,BCs,Priors,Meas,Method,hest,kIso,kAlong,kCross);






