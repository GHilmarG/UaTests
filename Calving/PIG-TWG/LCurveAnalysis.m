
%%
%
% Example of how to do L-curve analysis.
%
% This just illustraites how this can be done in general.
%
% Here this is done by reading restart files

Experiment="As";   % Plot L-cure as funcion of \gamma_s for A
Experiment="Cs";   % Plot L-cure as funcion of \gamma_s for C
Experiment="AsCs"; % Plot two dimentional L-cure as funcion of \gamma_s for A and C





%% First read in all the restart files, just make sure that this finds all of them
%  This may need to be modifed.
MR="20km";
MR="10km";
MR="5km";
switch Experiment

    case "As"

        files=dir("InverseRestartFile-Weertman-Ca1-Cs1000-Aa1-As*-"+MR+".mat") ;
        % files=dir("InverseRestartFile-Weertman-Ca1000-Cs1000-Aa1000-As*-"+MR+".mat") ;
        % files=dir("InverseRestartFile-Weertman-Ca10-Cs1000-Aa10-As*-"+MR+".mat") ;


    case "Cs"
        
        files=dir("InverseRestartFile-Weertman-Ca1-Cs*-Aa1-As1000-"+MR+".mat") ;
        % files=dir("InverseRestartFile-Weertman-Ca1000-Cs*-Aa1000-As1000-"+MR+".mat") ;
        % files=dir("InverseRestartFile-Weertman-Ca10-Cs*-Aa10-As1000-"+MR+".mat") ;

    case "AsCs"

          files=dir("InverseRestartFile-Weertman-Ca1-Cs*-Aa1-As*-"+MR+"-Alim-.mat");
          files=dir("InverseRestartFile-Cornford-Ca1-Cs*-Aa1-As*-"+MR+"-Alim-.mat");
          % files=dir("InverseRestartFile-Weertman-Ca1-Cs*-Aa1-As*-"+MR+".mat") ;

    otherwise

        error("case not found")

end

NF=numel(files);
DataID=strings(NF,1) ;

%% So now we have all the restart files in the structure 'files'
%
% Possibly not much more needs to be adjusted.

J=nan(NF,1);
R=nan(NF,1);
I=nan(NF,1);
RCa=nan(NF,1);
RCs=nan(NF,1);
RAa=nan(NF,1);
RAs=nan(NF,1);
As=nan(NF,1); Aa=As ; Ca=As ; Cs=As ; 

% loop over inverse restart files and calculate I and R
for i=1:numel(files)

    fprintf("File: %s \n",files(i).name)
    load(files(i).name)

    load(files(i).name,'CtrlVarInRestartFile','UserVarInRestartFile','RunInfo','InvFinalValues');
    % WriteAdjointRestartFile(UserVar,CtrlVar,MUA,BCs,F,F.GF,l,RunInfo,InvStartValues,Priors,Meas,BCsAdjoint,InvFinalValues);

    UserVar=UserVarInRestartFile ; CtrlVar=CtrlVarInRestartFile; CtrlVar.Inverse.CalcGradI=false ;

    % Actually no need to calculate this here, but I do so just to check that all is as it should be
    Ji=RunInfo.Inverse.J(end);  % This infomation is in the RunInfo variable from the inverse run
    Ri=Regularisation(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ;
    Ii=Misfit(UserVar,CtrlVar,MUA,BCs,F,l,Priors,Meas,BCsAdjoint,RunInfo) ;


    As(i)=CtrlVarInRestartFile.Inverse.Regularize.logAGlen.gs;
    Aa(i)=CtrlVarInRestartFile.Inverse.Regularize.logAGlen.ga;
    Ca(i)=CtrlVarInRestartFile.Inverse.Regularize.logC.ga;
    Cs(i)=CtrlVarInRestartFile.Inverse.Regularize.logC.gs;

    J(i)=InvFinalValues.J;
    I(i)=InvFinalValues.I;
    R(i)=InvFinalValues.R;    % this is the total value of the regularisation term, including the multiplication by the regularisation parameters.

    dJi=norm(Ji-J(i)) ;
    dIi=norm(Ii-I(i)) ;
    dRi=norm(Ri-R(i)) ;

    if dJi>1000*eps
        fprintf("check if J(i) and Ji are equal: J(i)=%g and Ji=%g \n",J(i),Ji)
    end
    if dIi>1000*eps
        fprintf("check if I(i) and Ii are equal: I(i)=%g and Ii=%g \n",I(i),Ii)
    end

    if dRi>1000*eps
        fprintf("check if R(i) and Ri are equal: R(i)=%g and Ri=%g \n",R(i),Ri)
    end

    if isempty(InvFinalValues.RCa)
        RCa(i)=nan;  % OK, these will be old inverse restart files where this infomation was not yet provided
        RCs(i)=nan;
        RAa(i)=nan;
        RAs(i)=nan;
    else
        RCa(i)=InvFinalValues.RCa;  % these are the values of the terms before multiplied by the regularisation parameters
        RCs(i)=InvFinalValues.RCs;
        RAa(i)=InvFinalValues.RAa;
        RAs(i)=InvFinalValues.RAs;
    end

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
        case "AsCs"
            DataID(i)= sprintf("As%g-Cs%g",CtrlVarInRestartFile.Inverse.Regularize.logAGlen.gs,CtrlVarInRestartFile.Inverse.Regularize.logC.gs);
        otherwise
            error("case not found")
    end



end



% PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);

%% And now plot the L curve (which may or may not actually look like an L)


if Experiment=="AsCs"

    figlog=FindOrCreateFigure("RAs:RCs:I"+Experiment) ;clf(figlog) ;
    plot3(RAs,RCs,I,"or");
    xlabel("RAs" ) ; ylabel("RCs" ) ;   zlabel("I")

    figlog=FindOrCreateFigure("log10 of RAs:RCs:I"+Experiment) ;clf(figlog) ;
    plot3(log10(RAs),log10(RCs),log10(I),"or");
    xlabel("$\log_{10}(R_{As})$",Interpreter="latex")  ;
    ylabel("$\log_{10}(R_{Cs})$",Interpreter="latex")  ;
    zlabel("$\log_{10}(I)$",Interpreter="latex")

    figlog=FindOrCreateFigure("pathplot I(RAs,RCs)"+Experiment) ;clf(figlog) ;
    [PatchObject,ColorbarHandel,tri]=PatchPlot(log10(RAs),log10(RCs), log10(I));
    hold on
    plot(log10(RAs),log10(RCs),"or",MarkerFaceColor="w",MarkerSize=3)
    axis equal tight
    xlabel("$\log_{10}(R_{As})$",Interpreter="latex")  ;
    ylabel("$\log_{10}(R_{Cs})$",Interpreter="latex")  ;
    title("$\log_{10}(I)$",Interpreter="latex")  ;


    figlog=FindOrCreateFigure("As:Cs"+Experiment) ;clf(figlog) ;
    loglog(As,Cs,"or")
    xlabel("As")  ; ylabel("Cs")



    figlog=FindOrCreateFigure("I, RAs, CAs (Ags,Cgs)"+Experiment) ;clf(figlog) ;
    plot3(log10(As),log10(Cs),log10(I),"or",MarkerFaceColor="r")
    hold on 
    plot3(log10(As),log10(Cs),log10(RAs),"ob",MarkerFaceColor="b")
    plot3(log10(As),log10(Cs),log10(RCs),"og",MarkerFaceColor="g")
    xlabel("$\log_{10}(\gamma_{As})$",Interpreter="latex")  ;
    ylabel("$\log_{10}(\gamma_{Cs})$",Interpreter="latex")  ;
    zlabel("$\log_{10}(I)$,  $\log_{10}(RAs)$ , $\log_{10}(RCs)$",Interpreter="latex")
    legend("I","RAs","CAs")

    figlog=FindOrCreateFigure("I:As:Cs"+Experiment) ;clf(figlog) ;
    plot3(log10(As),log10(Cs),log10(I),"or",MarkerFaceColor="r")
    xlabel("$\log_{10}(\gamma_{As})$",Interpreter="latex")  ;
    ylabel("$\log_{10}(\gamma_{Cs})$",Interpreter="latex")  ;
    zlabel("$\log_{10}(I)$",Interpreter="latex")
    legend("I")

    figlog=FindOrCreateFigure("pathplot I:As:Cs"+Experiment) ;clf(figlog) ;
    [PatchObject,ColorbarHandel,tri]=PatchPlot(log10(As),log10(Cs), log10(I));
    hold on 
    plot(log10(As),log10(Cs),"or",MarkerFaceColor="w",MarkerSize=3)
    axis equal tight
    xlabel("$\log_{10}(\gamma_{As})$",Interpreter="latex")  ;
    ylabel("$\log_{10}(\gamma_{Cs})$",Interpreter="latex")  ;
    title("$\log_{10}(I)$",Interpreter="latex")  ;

    figlog=FindOrCreateFigure("pathplot RAs(As,Cs)"+Experiment) ;clf(figlog) ;
    [PatchObject,ColorbarHandel,tri]=PatchPlot(log10(As),log10(Cs), log10(RAs));
    axis equal tight
    hold on 
    plot(log10(As),log10(Cs),"or",MarkerFaceColor="w",MarkerSize=3)
    xlabel("$\log_{10}(\gamma_{As})$",Interpreter="latex")  ;
    ylabel("$\log_{10}(\gamma_{Cs})$",Interpreter="latex")  ;
    title("$\log_{10}(R_{As})$",Interpreter="latex")  ;

    figlog=FindOrCreateFigure("pathplot RCs(As,Cs)"+Experiment) ;clf(figlog) ;
    [PatchObject,ColorbarHandel,tri]=PatchPlot(log10(As),log10(Cs), log10(RCs));
    axis equal tight
     hold on 
    plot(log10(As),log10(Cs),"or",MarkerFaceColor="w",MarkerSize=3)
    xlabel("$\log_{10}(\gamma_{As})$",Interpreter="latex")  ;
    ylabel("$\log_{10}(\gamma_{Cs})$",Interpreter="latex")  ;
    title("$\log_{10}(R_{Cs})$",Interpreter="latex")  

else




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

    figlog=FindOrCreateFigure("LCurve Analysis (log-log)"+Experiment) ;clf(figlog) ;

    loglog(I,RTerm,'o-r') ;
    xlabel("I") ; ylabel("R")

    text(I,RTerm,DataID)
    % J must be equal to R+I if all is as is should be

    figlin=FindOrCreateFigure("LCurve Analysis (lin-lin)"+Experiment) ;clf(figlin) ;

    plot(I,RTerm,'o-r') ;
    xlabel("I") ; ylabel("R")

    text(I,RTerm,DataID)

    figlin=FindOrCreateFigure("LCurve Analysis (lin-lin) 2"+Experiment) ;clf(figlin) ;
    plot(RTerm,I,'o-r') ;
    xlabel("R") ; ylabel("I")
    text(RTerm,I,DataID)

end


%%



