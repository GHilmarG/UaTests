
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

        % files=dir("InverseRestartFile-Weertman-Ca1-Cs1000-Aa1-As*-"+MR+".mat") ;
        files=dir("InverseRestartFile-Weertman-Ca1000-Cs1000-Aa1000-As*-"+MR+".mat") ;


    case "Cs"

        %files=dir("InverseRestartFile-Weertman-Ca1-Cs*-Aa1-As1000-"+MR+".mat") ;
        files=dir("InverseRestartFile-Weertman-Ca1000-Cs*-Aa1000-As1000-"+MR+".mat") ;

    otherwise

        error("case not found")

end

DataID=strings(numel(files),1) ;

%% So now we have all the restart files in the structure 'files'

% loop over inverse restart files and calculate I and R
for i=1:numel(files)

    fprintf("File: %s \n",files(i).name)
    load(files(i).name)


    UserVar=UserVarInRestartFile ; CtrlVar=CtrlVarInRestartFile; CtrlVar.Inverse.CalcGradI=false ;


    


    J(i)=RunInfo.Inverse.J(end);  % This infomation is in the RunInfo variable from the inverse run
    R(i)=Regularisation(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ; % but this is not
    I(i)=Misfit(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ;         % and this in not

    % R as calculated here includes the gamma (ie g), so this is not the R we want, we just calculate
    % this here to make sure everything is OK
    % J must be equal to R+I if all is as is should be.
    %  fprintf(" J \t\t\t R \t\t\t I \t\t\t R+I \t\t\t (R+I-J)/J \n %f %f  %f    %f         %f \n",J(i),R(i),I(i),R(i)+I(i),(R(i)+I(i)-J(i))/J(i))

    Ca(i)=CtrlVar.Inverse.Regularize.logC.ga;
    Cs(i)=CtrlVar.Inverse.Regularize.logC.gs;

    Aa(i)=CtrlVar.Inverse.Regularize.logAGlen.ga;
    As(i)=CtrlVar.Inverse.Regularize.logAGlen.gs;

    % all other regularisation parameters set to zero to exclude them being included in the sum
    CtrlVar.Inverse.Regularize.logC.ga=0;
    CtrlVar.Inverse.Regularize.logC.gs=0;

    CtrlVar.Inverse.Regularize.logAGlen.ga=0;
    CtrlVar.Inverse.Regularize.logAGlen.gs=0;


    switch Experiment

        case "As"
            CtrlVar.Inverse.Regularize.logAGlen.gs=1;  % this is the regularisation parameter we are interested in
            DataID(i)= sprintf("%g",CtrlVarInRestartFile.Inverse.Regularize.logAGlen.gs);
        case "Cs"
            CtrlVar.Inverse.Regularize.logC.gs=1; % this is the regularisation parameter we are interested in
            DataID(i)= sprintf("%g",CtrlVarInRestartFile.Inverse.Regularize.logC.gs);
        otherwise
            error("case not found")
    end


    % OK now we have set all the regularisation paramters to zero, except the one that we are 
    % plotting the L-curve for. So now when we calculate R, we get that single term
    RCs(i)=Regularisation(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ;
    % This could of course be done differently, for example by just fixing all the other gammas, but not
    % setting them to zero. That is possible a better approach when looking at the impact of more than
    % one regularisation parameter at the same time.


end


% PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);

%% And now plot the L curve (which may or may not actually look like an L)
figlog=FindOrCreateFigure("LCurve Analysis (log-log)"+Experiment) ;clf(figlog) ;

[~,isort]=sort(RCs) ; RCs=RCs(isort) ; I=I(isort); DataID=DataID(isort);

loglog(I,RCs,'o-r') ;
xlabel("I") ; ylabel("R")

text(I,RCs,DataID)
% J must be equal to R+I if all is as is should be

figlin=FindOrCreateFigure("LCurve Analysis (lin-lin)"+Experiment) ;clf(figlin) ;

[~,isort]=sort(RCs) ; RCs=RCs(isort) ; I=I(isort); DataID=DataID(isort);

plot(I,RCs,'o-r') ;
xlabel("I") ; ylabel("R")

text(I,RCs,DataID)




%%



