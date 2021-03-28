

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
% Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","ExCFAa10000CFAb2000CFBa5000CFBb500-RTinf-FAB0k01-CFp2q4-LinearMF-CAisNum-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1","PlotType","-collect-","PlotTimestep",100); 
% save('Data-RTinf-FAB0k01-Linear-Fine.mat','Data')

% Data=ReadPlotSequenceOfResultFiles("FileNameSubstring","ExCFAa10000CFAb2000CFBa5000CFBb500-RTinf-FAB0k01-CFp2q4-CubicMF-CAisNumTau-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1","PlotType","-collect-","PlotTimestep",1); 
% save("Data-FAB0k01-CFp2q4-CubicMF-CAisNumTau-LevelSetWithMeltFeedback.mat","Data")

% 
% to plot
SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB100k-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
D{1}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 

SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB10k-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
D{2}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 

SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB1k-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
D{3}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 

SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB0k1-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
D{4}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 

SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB0k01-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
D{5}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 

SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB0k001-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
D{6}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 

%
%SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB0k0001-CFp2q4-CubicMF-CAisZero-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
%D{5}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-1dIceShelf-","PlotTimestep",1); 



CurDir=pwd ;
if ~contains(CurDir,"ResultsFiles")
    cd ResultsFiles\
end


figure

for I=1:3
    
    Data=D{I};
    
    plot(Data.time,Data.LSFmean/1000,'o')
    hold on
    %plot(Data.time,Data.LSFmin/1000)
    %plot(Data.time,Data.LSFmax/1000)
    plot(Data.time,Data.Lx/1000,'b')
    
end

    
    

xlabel('$t$ (yr)','interpreter','latex')
ylabel('$x_c$ (km)','interpreter','latex')


%continue here for analytical comparision
p=-2 ; 
k=86320694.4400036;
dt=0.1;
N=10000;
xc=NaN(N,1) ;
t=NaN(N,1);

xc(1)=200e3 ;
t(1)=0;
n=1;

while t(n)<35
    
    [s,b,u]=AnalyticalOneDimentionalIceShelf([],xc(n)) ;
    h=s-b;
    c=k*h^p ;

    c=5000; 
    
   
    xc(n+1)=xc(n)+(u-c)*dt;
    t(n+1)=t(n)+dt ;
    n=n+1;
    
end
xc(xc<0)=NaN; 

hold on; plot(t,xc/1000,'r','LineWidth',2) ;

% ylim([50 200]) ; xlim([0 max(Data.time)])








