
%%
CurDir=pwd ;
cd ResultsFiles\
Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","LevelSetWithMeltFeedback","PlotType","-collect-","PlotTimestep",20);

cd(CurDir)

%%

figure 
plot(Data.time,Data.LSFmean/1000)
hold on
plot(Data.time,Data.LSFmin/1000)
plot(Data.time,Data.LSFmax/1000)
xlabel('$t$ (yr)','interpreter','latex')
ylabel('$x_c$ (km)','interpreter','latex')