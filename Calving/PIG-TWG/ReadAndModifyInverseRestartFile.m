%%

load  InverseRestartFile-Cornford-Ca1-Cs100000-Aa1-As100000-5km-Alim-Clim-uvGroup-.mat

%%

CtrlVar=CtrlVarInRestartFile;
UserVar=UserVarInRestartFile ;


%%



UaPlots(CtrlVar,MUA,F,log10(F.C),GetRidOfValuesDownStreamOfCalvingFronts=false,FigureTitle="C") ;


UaPlots(CtrlVar,MUA,F,log10(F.AGlen),GetRidOfValuesDownStreamOfCalvingFronts=false,FigureTitle="A") ;

% Smooth A and C fields to get a new smoother iterate


  
L=10e3 ; [UserVar,CSmoothed]=HelmholtzEquation([],CtrlVar,MUA,1,L^2,F.C,0); minC=min(F.C) ; CSmoothed(CSmoothed<minC)=minC ;

L=1e3 ; [UserVar,ASmoothed]=HelmholtzEquation([],CtrlVar,MUA,1,L^2,F.AGlen,0); minA=min(F.AGlen) ; ASmoothed(ASmoothed<minA)=minA ;


UaPlots(CtrlVar,MUA,F,log10(CSmoothed),GetRidOfValuesDownStreamOfCalvingFronts=false,FigureTitle="C smoothed") ;
UaPlots(CtrlVar,MUA,F,log10(ASmoothed),GetRidOfValuesDownStreamOfCalvingFronts=false,FigureTitle="A smoothed") ;

%% Copy values across and save, 


F.AGlen=ASmoothed;
F.C=CSmoothed;
InvFinalValues.C=CSmoothed;
InvFinalValues.AGlen=ASmoothed; 


% Note that this will ovewrite the original file!
WriteAdjointRestartFile(UserVar,CtrlVar,MUA,BCs,F,F.GF,l,RunInfo,InvStartValues,Priors,Meas,BCsAdjoint,InvFinalValues);