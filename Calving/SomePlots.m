

%%
CurDir=pwd ;
if ~contains(CurDir,"ResultsFiles")
    cd ResultsFiles\
end
%ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",10,"PlotTimeInterval",[1700 inf])
%ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",10);
% ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT0100-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",10);
%ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT0100-FAB0-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",1);
%ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT10-FAB1k0-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",10);
% ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT1000-FAB1k0-LevelSetWithMeltFeedback","PlotType","-1dIceShelf-","PlotTimestep",10);

% ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT0k5-FAB0-LevelSetWithMeltFeedback-1dIceShelf-","PlotType","-Level Set-","PlotTimestep",1);
% ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT0k5-FAB0-LevelSetWithMeltFeedback-1dIceShelf-","PlotType","-1dIceShelf-","PlotTimestep",10);

% ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT0k5-FAB0-CubicMF-LevelSetWithMeltFeedback-1dIceShelf-","PlotType","-Level Set-","PlotTimestep",10);
% ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT0k5-FAB0-CubicMF-LevelSetWithMeltFeedback-1dIceShelf-","PlotType","-1dIceShelf-","PlotTimestep",10);

% ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-CFAa10000CFAb2000CFBa5000CFBb200-RT0k5-FAB0-CubicMF-LevelSetWithMeltFeedback-1dIceShelf-","PlotType","-Level Set-","PlotTimestep",1);
% ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-CFAa10000CFAb2000CFBa5000CFBb200-RT0k5-FAB0-CubicMF-LevelSetWithMeltFeedback-1dIceShelf-","PlotType","-1dIceShelf-","PlotTimestep",1);

% ReadPlotSequenceOfResultFiles("FileNameSubstring","ExCFAa10000CFAb2000CFBa5000CFBb500-RTinf-FAB0k01-CFp2q4-CubicMF-LevelSetWithMeltFeedback-1dIceShelf-","PlotType","-1dIceShelf-","PlotTimestep",10);

% ReadPlotSequenceOfResultFiles("FileNameSubstring","ExCFAa10000CFAb2000CFBa5000CFBb500-RTinf-FAB0k01-CFp2q4-LinearMF-CAisNum-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1","PlotType","-1dIceShelf-","PlotTimestep",10);
ReadPlotSequenceOfResultFiles("FileNameSubstring","ExCFAa10000CFAb2000CFBa5000CFBb500-RTinf-FAB0k01-CFp2q4-LinearMF-CAisNum-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1","PlotType","-Level Set-","PlotTimestep",10);


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

% cd('C:\Users\hilma\OneDrive - Northumbria University - Production Azure AD\Sandbox\ResultsFiles')
%Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT10-FAB1k0-LevelSetWithMeltFeedback","PlotType","-collect-","PlotTimestep",1);
% Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT1-FAB0-LevelSetWithMeltFeedback","PlotType","-collect-","PlotTimestep",1); save('DataRI1FAB0.mat','Data')
% Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT0k5-FAB0-LevelSetWithMeltFeedback","PlotType","-collect-","PlotTimestep",1); save('DataRI0k5FAB0.mat','Data')
% Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","Ex-Reinitialize-RT0k5-FAB0-CubicMF-LevelSetWithMeltFeedback","PlotType","-collect-","PlotTimestep",1); save('DataRI0k5FAB0Cubic.mat','Data')
% Data=Edit ("FileNameSubstring","Ex-Reinitialize-CFAa10000CFAb2000CFBa5000CFBb200-RT0k5-FAB0-CubicMF-LevelSetWithMeltFeedback-1dIceShelf-","PlotType","-collect-","PlotTimestep",1); save('DataRI0k5FAB0CubicFine.mat','Data')


Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","ExCFAa10000CFAb2000CFBa5000CFBb500-RTinf-FAB0k01-CFp2q4-LinearMF-CAisNum-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1","PlotType","-collect-","PlotTimestep",100); save('Data-RTinf-FAB0k01-Linear-Fine.mat','Data')

 cd(CurDir)

%%
load('DataRI1000FAB1k0.mat','Data') ; D{1}=Data;
load('DataRI10FAB1k0.mat','Data')   ; D{2}=Data;
load('DataRI1FAB0.mat','Data')      ; D{3}=Data;
load('DataRI0k5FAB0.mat','Data')    ; D{4}=Data;
load('DataRI0k5FAB0Cubic.mat','Data')    ; D{5}=Data;
load('DataRI0k5FAB0CubicFine.mat','Data')    ; D{6}=Data;
load('Data-RTinf-FAB0k01-Linear-Fine.mat','Data') ; D{7}=Data;
 
figure

for I=7:numel(D)
    
    Data=D{I};
    
    plot(Data.time,Data.LSFmean/1000,'o')
    hold on
    plot(Data.time,Data.LSFmin/1000)
    plot(Data.time,Data.LSFmax/1000)
    
end

xlabel('$t$ (yr)','interpreter','latex')
ylabel('$x_c$ (km)','interpreter','latex')


p=-2 ; 
k=86322275.9814533 ;
dt=0.1;
N=100000;
xc=NaN(N,1) ;
t=NaN(N,1);

xc(1)=200e3 ;
t(1)=0; 
n=1; 

while n<N

    [s,b,u]=AnalyticalOneDimentionalIceShelf([],xc(n)) ;
    h=s-b; 
    c=k*h^p ;
    
    dxcdt=u-c;
    xc(n+1)=xc(n)+dxcdt*dt;
    t(n+1)=t(n)+dt ; 
    n=n+1; 
    
end
hold on; plot(t,xc/1000,'r','LineWidth',2) ; 

ylim([50 200]) ; xlim([0 5000])



%%  This is for testing level set

File{1}="TestLevelSet-RTinf-FAB0k1-CFp2q4-RCS-.mat";
File{2}="TestLevelSet-RTinf-FAB1-CFp2q4-RCS-.mat";
File{3}="TestLevelSet-RTinf-FAB2-CFp2q4-RCS-.mat";
File{4}="TestLevelSet-RTinf-FAB10-CFp2q4-RCS-.mat";
col={'b','g','c','m'};

fig=FindOrCreateFigure("Zero level position with time");
for I=1:4
    load(File{I})
    
    
    
    plot(xcVector.time,xcVector.Value/1000,'o','color',col{I})
    hold on
    tt=xlim;
    hold on; plot(tAna,xcAna/1000,'r','LineWidth',2) ;
    xlim(tt)
    title(sprintf('time %f ',CtrlVar.time))
    ylabel('$x_c$ (km)','interpreter','latex')
    xlabel('$t$ (yr)','interpreter','latex')
    
end















