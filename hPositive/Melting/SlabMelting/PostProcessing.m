


Klear ; load Restart-GaussMelting-Nod10-MeshSize10000-lambdak10000

%%

%load('Restart-GaussMelting-Nod10-MeshSize10000-lambdak0.mat','RunInfo')
% load('Restart-GaussMelting-Nod10-MeshSize10000-lambdak1000000.mat','RunInfo')
% load('Restart-GaussMelting-Nod10-MeshSize2000-lambdak0.mat','RunInfo')
load('Restart-GaussMelting-Nod10-MeshSize2000-lambdak0-WorkResiduals.mat','RunInfo')

FindOrCreateFigure("time-dt")
yyaxis left
stairs(RunInfo.Forward.time,RunInfo.Forward.dt)
set(gca, 'YScale', 'log')
ylabel('dt (yr)')
yyaxis right
stairs(RunInfo.Forward.time,RunInfo.Forward.uvhIterations)
ylabel('# NR uvh iterations')
xlabel('time (yr)') ; 


FindOrCreateFigure("NRuvh residuals")
yyaxis left
stairs(RunInfo.Forward.time,RunInfo.Forward.uvhResidual)
set(gca, 'YScale', 'log')
ylabel('dt (yr)')
yyaxis right
stairs(RunInfo.Forward.time,RunInfo.Forward.uvhIterations)
ylabel('# NR uvh iterations')
xlabel('time (yr)') ; 


FindOrCreateFigure("active set")
yyaxis left
stairs(RunInfo.Forward.time,RunInfo.Forward.uvhActiveSetConstraints)
ylabel('#active thickness constraints')
yyaxis right
stairs(RunInfo.Forward.time,RunInfo.Forward.uvhActiveSetIterations)
ylabel('Active set iterations')
xlabel('time (yr)') ; 


FindOrCreateFigure("active set cyclical")
stairs(RunInfo.Forward.time,RunInfo.Forward.uvhActiveSetCyclical)
xlabel('time (yr)') ; ylabel('Active set cyclical')
ylim([-0.1 1.1] )

%%
Klear
load('Restart-GaussMelting-Nod10-MeshSize10000-lambdak10000000.mat','RunInfo')
RunInfoA=RunInfo;

load('Restart-GaussMelting-Nod10-MeshSize10000-lambdak0','RunInfo')
RunInfoB=RunInfo;

figure

yyaxis left
plot(RunInfoA.Forward.time,RunInfoA.Forward.uvhActiveSetCyclical,'LineWidth',2)
ylim([0 2])
ylabel('active set is cyclical ')
yyaxis right
plot(RunInfoB.Forward.time,RunInfoB.Forward.uvhActiveSetCyclical,'LineWidth',2)
ylim([-1 1])

xlabel('time (yr)') ; 
ylabel('active set is cyclical')
legend('$\lambda=100e3$','$\lambda$=0','interpreter','latex')

%%
ReadPlotSequenceOfResultFiles("FileNameSubstring","Nod10-MeshSize10000-lambdak100","PlotType","-hPositive-","PlotTimeInterval",[130 300])
%

%%
Klear
Runs=[...
    "Nod10-MeshSize10000-lambdak100.mat" ; ...
    "Nod10-MeshSize10000-lambdak10000.mat" ; ...
    "Nod10-MeshSize10000-lambdak10000000.mat" ; ...
    ] ;

for I=1:3
    DataCollect{I}=ReadPlotSequenceOfResultFiles("FileNameSubstring",Runs(I),"PlotType","-collect-","PlotTimeInterval",[130 300]);
end


figure ;
for I=1:3
    plot(DataCollect{I}.time,DataCollect{I}.hCentre)
    hold on
end

