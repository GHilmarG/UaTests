
%%


Experiment="As";

switch Experiment

    case "As"

        FileNames(1)="InverseRestartFile-Weertman-Ca1-Cs1000-Aa1+As1-20km" ;
        FileNames(2)="InverseRestartFile-Weertman-Ca1-Cs1000-Aa1+As10-20km" ;
        FileNames(3)="InverseRestartFile-Weertman-Ca1-Cs1000-Aa1+As100-20km" ;
        FileNames(4)="InverseRestartFile-Weertman-Ca1-Cs1000-Aa1+As1000-20km" ;
        FileNames(5)="InverseRestartFile-Weertman-Ca1-Cs1000-Aa1+As10000-20km" ;
        FileNames(6)="InverseRestartFile-Weertman-Ca1-Cs1000-Aa1+As100000-20km" ;
        FileNames(7)="InverseRestartFile-Weertman-Ca1-Cs1000-Aa1+As1000000-20km" ;
        FileNames(8)="InverseRestartFile-Weertman-Ca1-Cs1000-Aa1+As10000000-20km" ;
        FileNames(9)="InverseRestartFile-Weertman-Ca1-Cs1000-Aa1+As100000000-20km" ;

        iRange=1:9;


    case "Cs"



    otherwise

        error("case not found")

end



for i=iRange

    load(FileNames(i))


    UserVar=UserVarInRestartFile ; CtrlVar=CtrlVarInRestartFile; CtrlVar.Inverse.CalcGradI=false ;

    J(i)=RunInfo.Inverse.J(end);
    R(i)=Regularisation(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ;
    I(i)=Misfit(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ;

    fprintf(" J \t\t\t R \t\t\t I \t\t\t R+I \t\t\t (R+I-J)/J \n %f %f  %f    %f         %f \n",J(i),R(i),I(i),R(i)+I(i),(R(i)+I(i)-J(i))/J(i))

    Ca(i)=CtrlVar.Inverse.Regularize.logC.ga;
    Cs(i)=CtrlVar.Inverse.Regularize.logC.gs;

    Aa(i)=CtrlVar.Inverse.Regularize.logAGlen.ga;
    As(i)=CtrlVar.Inverse.Regularize.logAGlen.gs;


    CtrlVar.Inverse.Regularize.logC.ga=0;
    CtrlVar.Inverse.Regularize.logC.gs=0;

    CtrlVar.Inverse.Regularize.logAGlen.ga=0;
    CtrlVar.Inverse.Regularize.logAGlen.gs=0;


    CtrlVar.Inverse.Regularize.logAGlen.gs=1;
    RCs(i)=Regularisation(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ;

end


% PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);

%%
fig=FindOrCreateFigure("LCurve Analysis") ;clf(fig) ; loglog(I,RCs,'o-r') ;
xlabel("I")
ylabel("R")

% J must be equal to R+I if all is as is should be
