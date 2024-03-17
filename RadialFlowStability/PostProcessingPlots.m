

%%
ResultsFileDirectory=".\ResultsFiles\" ;

ResultsFile(1)="0000000-MR150-AM0-.mat";
ResultsFile(2)="0000000-MR500-AM0-.mat";

for I=1:2
    load(ResultsFileDirectory+ResultsFile(I))
    UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle=ResultsFile(I))
    subtitle(ResultsFile(I),Interpreter="latex")
end


%%