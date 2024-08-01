function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l)





plots='-save-';
% plots='-plot-';

%% plots plot

FindOrCreateFigure("BCs")
CtrlVar.BoundaryConditionsFixedNodeArrowScale=0.1; 
PlotBoundaryConditions(CtrlVar,MUA,BCs);

UaPlots(CtrlVar,MUA,F,"-uv-")

UaPlots(CtrlVar,MUA,F,F.h,FigureTitle=" h ",PlotUnderMesh=true)
title(sprintf("time=%g dt=%g",F.time,F.dt),interpreter="latex")


drawnow

%% plots save
if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if exist(fullfile(cd,'ResultsFiles'),'dir')~=7
        mkdir('ResultsFiles') ;
    end

    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0


        FileName=sprintf('%s/%07i%s.mat',"ResultsFiles",round(100*F.time),UserVar.RunType);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,"UserVar","CtrlVar","MUA","F","BCs","l")

    end

end

end




