
%%
% 
%  rename  Aa+As Aa1-As InverseRestartFile-Weertman-Ca1-Cs*.mat

%
%
%
%
%
% Ca1-Cs500000000-Aa1As1000 : singular issues
% Ca1-Cs500000000-Aa1As1000 : singular issues 
% Ca1-Cs50000000-Aa1-As1000 : singular
% Ca1-Cs500000000-Aa1-As1000 : singular
% Ca1-Cs1000000000-Aa1-As1000 : singular
% Ca1-Cs5000000000-Aa1-As1000 : singular
% Ca1-Cs10000000000-Aa1-As1000 : singular
% Ca1-Cs50000000000-Aa1-As1000 : singular
% Ca1-Cs50000000-Aa1-As1000 : singular
% Ca1-Cs500000000-Aa1-As1000 : singular
% Ca1-Cs50000000-Aa1-As1000 : singular 
% So for Cs> 5e7 all are singular



Experiment="As";
Experiment="Cs";
MR="10km";


%% First read in all the restart files, just make sure that this finds all of them
%  This may need to be modifed.
switch Experiment

    case "As"

        files=dir("InverseRestartFile-Weertman-Ca1-Cs1000-Aa1-As*-"+MR+".mat") ;
        % files=dir("InverseRestartFile-Weertman-Ca1000-Cs1000-Aa1000-As*-"+MR+".mat") ;
        % files=dir("InverseRestartFile-Weertman-Ca10-Cs1000-Aa10-As*-"+MR+".mat") ;


    case "Cs"

        files=dir("InverseRestartFile-Weertman-Ca1-Cs*-Aa1-As1000-"+MR+".mat") ;
        % files=dir("InverseRestartFile-Weertman-Ca1000-Cs*-Aa1000-As1000-"+MR+".mat") ;
        % files=dir("InverseRestartFile-Weertman-Ca10-Cs*-Aa10-As1000-"+MR+".mat") ;

    otherwise

        error("case not found")

end

NF=numel(files);
DataID=strings(NF,1) ;

%% So now we have all the restart files in the structure 'files'

J=nan(NF,1);
R=nan(NF,1);
I=nan(NF,1);
RCa=nan(NF,1);
RCs=nan(NF,1);
RAa=nan(NF,1);
RAs=nan(NF,1);

% loop over inverse restart files and calculate I and R
for i=1:numel(files)

    fprintf("File: %s \n",files(i).name)
    load(files(i).name)

    load(files(i).name,'CtrlVarInRestartFile','UserVarInRestartFile','RunInfo','InvFinalValues');
    % WriteAdjointRestartFile(UserVar,CtrlVar,MUA,BCs,F,F.GF,l,RunInfo,InvStartValues,Priors,Meas,BCsAdjoint,InvFinalValues);

    UserVar=UserVarInRestartFile ; CtrlVar=CtrlVarInRestartFile; CtrlVar.Inverse.CalcGradI=false ;


    J(i)=RunInfo.Inverse.J(end);  % This infomation is in the RunInfo variable from the inverse run
    R(i)=Regularisation(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ;
    I(i)=Misfit(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ;        

    J(i)=InvFinalValues.J;
    I(i)=InvFinalValues.I;
    R(i)=InvFinalValues.R;    % this is the total value of the regularisation term, including the multiplication by the regularisation parameters. 
    RCa(i)=InvFinalValues.RCa;
    RCs(i)=InvFinalValues.RCs;
    RAa(i)=InvFinalValues.RAa;
    RAs(i)=InvFinalValues.RAs;

    % Rtest should be equal to R(i), just to check
    Rtest=...
        CtrlVar.Inverse.Regularize.logAGlen.ga^2*InvFinalValues.RAa...
        +CtrlVar.Inverse.Regularize.logAGlen.gs^2*InvFinalValues.RAs...
        +CtrlVar.Inverse.Regularize.logC.ga^2*InvFinalValues.RCa...
        +CtrlVar.Inverse.Regularize.logC.gs^2*InvFinalValues.RCs;

    dR=norm(Rtest-R(i));

    if dR>1000*eps
        fprintf("check: R(i)=%g and Rtest(i)=%g \n",R(i),Rtest)
    end




    switch Experiment

        case "As"
            
            DataID(i)= sprintf("%g",CtrlVarInRestartFile.Inverse.Regularize.logAGlen.gs);
        case "Cs"
            
            DataID(i)= sprintf("%g",CtrlVarInRestartFile.Inverse.Regularize.logC.gs);
        otherwise
            error("case not found")
    end


  


end



% PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);

%% And now plot the L curve (which may or may not actually look like an L)
figlog=FindOrCreateFigure("LCurve Analysis (log-log)"+Experiment) ;clf(figlog) ;


switch Experiment

    case "As"

        RTerm=RAs;

    case "Cs"

        RTerm=RCs;

    otherwise

        error("case not found")

end


% RTerm(isnan(RTerm))=[];

[~,isort]=sort(RTerm) ; 
RTerm=RTerm(isort) ; 
I=I(isort); 
DataID=DataID(isort);

loglog(I,RTerm,'o-r') ;
xlabel("I") ; ylabel("R")

text(I,RTerm,DataID)
% J must be equal to R+I if all is as is should be

figlin=FindOrCreateFigure("LCurve Analysis (lin-lin)"+Experiment) ;clf(figlin) ;

plot(I,RTerm,'o-r') ;
xlabel("I") ; ylabel("R")

text(I,RTerm,DataID)




%%



