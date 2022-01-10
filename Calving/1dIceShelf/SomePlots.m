

CurDir=pwd ;
if ~contains(CurDir,"ResultsFiles")
    cd("D:\Runs\Calving\1dIceShelf\ResultsFiles\")
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
% SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB100k-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
% D{1}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 
% 
% SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB10k-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
% D{2}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 
% 
% SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB1k-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
% D{3}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 
% 
% SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB0k1-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
% D{4}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 
% 
% SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB0k01-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
% D{5}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 
% 
% SubString="ExCFAa10000CFAb10000CFBa5000CFBb5000-RTinf-FAB0k001-CFp2q4-CubicMF-CAisConstant-LevelSetWithMeltFeedback-1dIceShelf-MBice0-SUPGtaus-Adapt1";
% D{6}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",1); 
% 
% 

isCollect=1;

if isCollect

               
    SubString="uvhPrescribed-muScale-u-cl-muValue0k1-geometric-Ini1-PDist1-AD0-Strip1-SW=25000-hqk-=+1k0-int-dt=0k1-MS=10km-T3-Adapt1";  Text(1)=" (T3-10km)";
    D{1}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",10);

    SubString="uvhPrescribed-muScale-u-cl-muValue0k1-geometric-Ini1-PDist1-AD0-Strip1-SW=25000-hqk-=+1k0-int-dt=0k1-MS=10km-T6-Adapt1";     Text(2)=" (T6-10km)";
    D{2}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",10);

    SubString="uvhPrescribed-muScale-u-cl-muValue0k1-geometric-Ini1-PDist1-AD0-Strip1-SW=25000-hqk-=+1k0-int-dt=0k1-MS=10km-T10-Adapt1";     Text(3)=" (T10-10km)";
    D{3}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",10);

    SubString="uvhPrescribed-muScale-u-cl-muValue0k1-geometric-Ini1-PDist1-AD0-Strip1-SW=25000-hqk-=+1k0-int-dt=0k1-MS=5km-T3-Adapt1";     Text(4)=" (T3-5km)";
    D{4}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",10);

    SubString="uvhPrescribed-muScale-u-cl-muValue0k1-geometric-Ini1-PDist1-AD0-Strip1-SW=25000-hqk-=+1k0-int-dt=0k1-MS=2km-T3-Adapt1";     Text(5)=" (T3-2km)";
    D{5}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",10);

  %  SubString="uvhPrescribed-muScale-ucl-muValue0k1-IniInf-PDist1-AD0-Strip1-SW=25000-hqk-=+1k0-int-dt=0k1-MS=1km-T3-Adapt1";     Text(6)=" (T3-1km)";
  %  D{6}=ReadPlotSequenceOfResultFiles("FileNameSubstring",SubString,"PlotType","-collect-","PlotTimestep",10);

    IRange=[1 2 3 4 5];

    %%

else

    % Create a video of one run
    SubString="uvhPrescribed-muScale-ucl-muValue0k1-IniInf-PDist1-AD0-Strip1-SW=25000-hqk-=+1k0-int-dt=0k1-MS=5km-T3-Adapt1";     Text(4)=" (T3-5km)";
    VideoFileName="Video-Circular"+SubString ;
    ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString,PlotTimestep=100,VideoFileName="Video-1dAna-",PlotType="-1dIceShelf-") 
    return

end




%% continue here for analytical comparision
p=-2 ; 
k=86320694.4400036;
dt=0.1;  % this is my rough dt for simple explicit integration
tMax=max(D{1}.time);


tMax=10000 ; 
N=floor(tMax/dt);
xcAna=NaN(N,1) ;
t=NaN(N,1);

xcAna(1)=200e3 ;
t(1)=0;
n=1;

while t(n)<=tMax
    
    [s,b,u]=AnalyticalOneDimentionalIceShelf([],xcAna(n)) ;
    h=s-b;
    c=k*h^p ;

    %c=5000; 
    
   
    xcAna(n+1)=xcAna(n)+(u-c)*dt;
    t(n+1)=t(n)+dt ;
    n=n+1;
    
end
xcAna(xcAna<0)=NaN; 

fig=FindOrCreateFigure("Compare") ;  clf(fig) ; 

plot(t,xcAna/1000,'k',LineWidth=2,DisplayName="Analytical")
hold on; 

col=["b","r","g","c","m"] ;
k=0;
for I=IRange
    I
    k=k+1;
    Data=D{I};
    plot(D{I}.time,D{I}.xcMean/1000,'--o',Color=col(k), DisplayName="Numerical"+Text(I))
    hold on
end

xlabel('$t$ (yr)','interpreter','latex')
ylabel('$x_c$ (km)','interpreter','latex')

I=isnan(t) ; t=t(~I) ; xcAna=xcAna(~I) ; 

yyaxis right
k=0;
for I=IRange
    k=k+1;
    xcAnalytical = interp1(t,xcAna,D{I}.time,'spline');
    plot(D{I}.time,(D{I}.xcMean-xcAnalytical)/1000,'--',color=col(k),DisplayName="Numerical-Analytical"+Text(I))
end


ylabel('$x_c$ analytical-numerical  (km)','interpreter','latex')

plot(xlim,xlim*0,'-r',DisplayName="")

leg=legend(Interpreter="latex") ; 
leg.String(end)=[] ; 


ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

cd(CurDir)

% exportgraphics(gca,ResultsFile+"-t"+num2str(round(CtrlVar.time))+".pdf") ;

return

%%








%%  TestLSF2d plots
Klear

FileName(1)="TestLSF2d-p2q2-muScaleucl-muValue1k000000e-01-dt0k10-2000-1-xc50000-l5000-N3";
FileName(2)="TestLSF2d-p2q2-muScaleucl-muValue1k000000e-02-dt0k10-2000-1-xc50000-l5000-N3";
FileName(3)="TestLSF2d-p2q2-muScaleucl-muValue1k000000e-03-dt0k10-2000-1-xc50000-l5000-N3" ;
FileName(4)="TestLSF2d-p2q2-muScaleucl-muValue1k000000e-04-dt0k10-2000-1-xc50000-l5000-N3";
FileName(5)="TestLSF2d-p2q2-muScaleucl-muValue1k000000e-04-dt0k10-200-2-xc50000-l5000-N3";
FileName(6)="TestLSF2d-p2q2-muScaleucl-muValue1k000000e-04-dt0k10-100-4-xc50000-l5000-N3";
FileName(7)="TestLSF2d-p2q2-muScaleucl-muValue5k000000e-04-dt0k10-2000-1-xc50000-l5000-N3";
FileName(8)="TestLSF2d-p2q2-muScaleucl-muValue5k000000e-04-dt0k10-200-10-xc50000-l5000-N3";
FileName(9)="TestLSF2d-p2q2-muScaleucl-muValue1k000000e-03-dt0k10-200-10-xc50000-l5000-N3";



for KFile=5:6
    
    load(FileName(KFile))
    % Plot comparision
    fig=FindOrCreateFigure("xc comparision"+num2str(KFile)) ;
    hold off
    yyaxis left
    plot(tVector,RcAnalytical/1000,'k',LineWidth=2) ;
    hold on ;
    plot(tVector,RcNumerical/1000,'ob')
    xlabel("$t \; \mathrm{(yr)}$","Interpreter","latex")
    ylabel("$x_c\;\mathrm{(km)}$","Interpreter","latex")
    
    yyaxis right
    plot(tVector,(RcAnalytical-RcNumerical)/1000,'.r')
    ylabel("$\Delta x_c$ (Analytical-Numerical) $\;\mathrm{(km)}$","Interpreter","latex")
    
    %legend("$x_c$ analytical","$x_c$ numerical","Nearest node to $x_c$","$\Delta x_c$ (Analytical-Numerical)",...
    %    "interpreter","latex","location","northwest")
    %
    
    legend("$x_c$ analytical","$x_c$ numerical","$\Delta x_c$ (Analytical-Numerical)",...
        "interpreter","latex","location","northeast")
    title(sprintf("std %f (km)",std((RcAnalytical-RcNumerical)/1000,'omitnan')))
    
    % exportgraphics(gca,ResultsFile+"-t"+num2str(round(CtrlVar.time))+".pdf") ;
    
    
    I=RunInfo.LevelSet.Phase=="Propagation and FAB";
    FindOrCreateFigure("Propagation and FAB"+num2str(KFile))
    plot(RunInfo.LevelSet.time(I),RunInfo.LevelSet.Iterations(I),'ro')
    title("Propagation and FAB")
    xlabel("time")
    ylabel("#NR iterations")
    
    I=RunInfo.LevelSet.Phase=="Initialisation";
    FindOrCreateFigure("Initialisation"+num2str(KFile))
    plot(RunInfo.LevelSet.time(I),RunInfo.LevelSet.Iterations(I),'b*')
    title("Initialisation")
    xlabel("time")
    ylabel("#NR iterations")
    
    
end