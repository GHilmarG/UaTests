
%%


Experiment="As";
Experiment="Cs";
MR="10km";


switch Experiment

    case "As"

        files=dir("InverseRestartFile-Weertman-Ca1-Cs1000-Aa1-As*-"+MR+".mat") ;


    case "Cs"

        files=dir("InverseRestartFile-Weertman-Ca1-Cs*-Aa1-As1000-"+MR+".mat") ;

    otherwise

        error("case not found")

end

DataID=strings(numel(files),1) ;


for i=1:numel(files)

    load(files(i).name)


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


    switch Experiment

        case "As"
            CtrlVar.Inverse.Regularize.logAGlen.gs=1;
            DataID(i)= sprintf("%g",CtrlVarInRestartFile.Inverse.Regularize.logAGlen.gs);
        case "Cs"
            CtrlVar.Inverse.Regularize.logC.gs=1;
            DataID(i)= sprintf("%g",CtrlVarInRestartFile.Inverse.Regularize.logC.gs);
        otherwise
            error("case not found")
    end



    RCs(i)=Regularisation(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ;

end


% PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);

%%
fig=FindOrCreateFigure("LCurve Analysis") ;clf(fig) ;

[~,isort]=sort(RCs) ; RCs=RCs(isort) ; I=I(isort); DataID=DataID(isort);

loglog(RCs,I,'o-r') ;
xlabel("R") ; ylabel("I")

text(RCs,I,DataID)
% J must be equal to R+I if all is as is should be


%%



