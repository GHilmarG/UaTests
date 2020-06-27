

%%
CurDir=pwd ;
if ~contains(CurDir,"ResultsFiles")
    cd ResultsFiles\
end
%ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",10,"PlotTimeInterval",[1700 inf])
%ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",10);
%ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT0100-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",10);
%ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT0100-FAB0-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",1);
%ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT10-FAB1k0-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",10);
ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT1000-FAB1k0-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",10);

cd(CurDir)
%%
CurDir=pwd ;
if ~contains(CurDir,"ResultsFiles")
    cd ResultsFiles\
end

%Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-LevelSetWithMeltFeedback","PlotType","-collect-","PlotTimestep",20);

% This one with RT1000 and FAB1k0 looks good before the re-initialization is applied. Shows that
% something is wrong with the reinitilization. But also shows that the FAB is good. Getting rigth
% stady-state at x=100km! 
% Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT1000-FAB1k0-LevelSetWithMeltFeedback","PlotType","-collect-","PlotTimestep",5);


Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT10-FAB1k0-LevelSetWithMeltFeedback","PlotType","-collect-","PlotTimestep",5);

cd(CurDir)

%%

figure 
plot(Data.time,Data.LSFmean/1000)
hold on
plot(Data.time,Data.LSFmin/1000)
plot(Data.time,Data.LSFmax/1000)
xlabel('$t$ (yr)','interpreter','latex')
ylabel('$x_c$ (km)','interpreter','latex')