
function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

v2struct(F);

time=CtrlVar.time; 



plots='-h(x)-ub(x)-dhdt(x)-';

TRI=[];


if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if strcmp(CtrlVar.DefineOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7 
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
        %FileName=['ResultsFiles/',sprintf('%07i',round(100*time)),'-TransPlots-',CtrlVar.Experiment]; good for transient runs
        
        FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.DefineOutputsCounter),'-TransPlots-',CtrlVar.Experiment];
        
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','F')
        
    end
end

% To only do plots at end of run:
% if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end

%%
[~,I]=sort(F.x) ;


if contains(plots,'-ub(x)-')
    figub=FindOrCreateFigure("-ub(x)-") ; clf(figub) 
    plot(F.x(I)/CtrlVar.PlotXYscale,F.ub(I)) ;
    title(sprintf("$u_b(x)$ at $t$=%-g ",F.time),Interpreter="latex") ; 
    xlabel("$x$ (km)",interpreter="latex" ); 
    ylabel("$u_b$ (m/yr)",Interpreter="latex")
    drawnow
end


if contains(plots,'-dhdt(x)-')
    figdhdt=FindOrCreateFigure("-dh/dt(x)-") ; clf(figdhdt) 
    plot(F.x(I)/CtrlVar.PlotXYscale,F.dhdt(I)) ;
    title(sprintf('$\\dot{h}(x)$ at t=%-g ',F.time),Interpreter="latex") ;
    xlabel("$x$ (km)",Interpreter="latex") ; 
    ylabel("$\dot{h}$ (m/yr)",Interpreter='latex')
    drawnow
end


if contains(plots,'-h(x)-')

    figh=FindOrCreateFigure("h(x)") ; clf(figh)
    yyaxis left
    plot(F.x(I)/CtrlVar.PlotXYscale,h(I))
    ylabel(" ice thickness, $h$ (m)",Interpreter="latex")
    yyaxis right 
    plot(F.x(I)/CtrlVar.PlotXYscale,GF.node(I)) ;
    ylabel("Floating/Grounding mask, GF")
    title(sprintf("$h(x)$ at t=%-g",time),Interpreter="latex")
    subtitle(sprintf("Forward time integration : %s",CtrlVar.ForwardTimeIntegration))

    xlabel("$x$ (km)",Interpreter="latex") ; 
    drawnow
end

%%

end
