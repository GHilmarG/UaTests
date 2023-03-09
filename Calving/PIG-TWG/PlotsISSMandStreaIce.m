
cd("C:\cygwin64\home\Hilmar\Ua\UaTests\Calving\PIG-TWG")

CurDir=pwd ; 

%% ISSM

cd("C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Shared\Dan - Mathieu- Jowan - Hilmar\Hilmar\Thwaites Ice Shelf Removal Experiments\VAF change estimates for Thwaites - Ua ISSM StreamIce\ISSM")

FindOrCreateFigure("ISSM abs")
for fric_type=[0 1 2]
	switch(fric_type)
		case 0; linecolor = 'r';
		case 1; linecolor = 'b';
		case 2; linecolor = 'g';
	end
	load(['VAF_fric' num2str(fric_type) '_WithShelf']);

    plot(time-time(1),deltaSLR,'Color',linecolor,'LineStyle','-','LineWidth',2); hold on


	load(['VAF_fric' num2str(fric_type) '_WithoutShelf']);
	plot(time-time(1),deltaSLR,'Color',linecolor,'LineStyle','--','LineWidth',2); hold on

end

set(gca,'FontSize',10); xlabel('years'); ylabel('SLR (mm)'); set(gcf,'Color','w'); grid on;
legend('Full shelf, Weertman','Remove shelf, Weertman ','Full shelf, Budd','Remove shelf, Budd','Full shelf, Cornford','Remove shelf, Cornford')


FindOrCreateFigure("ISSM rel")



for fric_type=[0 1 2]
    switch(fric_type)
        case 0; linecolor = 'r';
        case 1; linecolor = 'b';
        case 2; linecolor = 'g';
    end
    load(['VAF_fric' num2str(fric_type) '_WithShelf']);


    % plot(time-time(1),deltaSLR,'Color',linecolor,'LineStyle','-','LineWidth',2); hold on
    t1=time; dSLR1=deltaSLR;


    load(['VAF_fric' num2str(fric_type) '_WithoutShelf']);
    % plot(time-time(1),deltaSLR,'Color',linecolor,'LineStyle','--','LineWidth',2); hold on
    t2=time; dSLR2=deltaSLR;

    if ~isequal(t1,t2)

        dSLR21=interp1(t2,dSLR2,t1);
        dSLR21=dSLR21(:) ;
    else
        dSLR21=dSLR2;
    end


    switch(fric_type)
        case 0

            ISSM.Weertman.WithIceShelf.time=t1;
            ISSM.Weertman.WithoutIceShelf.time=t1;
            ISSM.Weertman.WithIceShelf.SLR=dSLR1;
            ISSM.Weertman.WithoutIceShelf.SLR=dSLR21;


        case 1

            ISSM.Budd.WithIceShelf.time=t1;
            ISSM.Budd.WithoutIceShelf.time=t1;
            ISSM.Budd.WithIceShelf.SLR=dSLR1;
            ISSM.Budd.WithoutIceShelf.SLR=dSLR21;


        case 2


            ISSM.Cornford.WithIceShelf.time=t1;
            ISSM.Cornford.WithoutIceShelf.time=t1;
            ISSM.Cornford.WithIceShelf.SLR=dSLR1;
            ISSM.Cornford.WithoutIceShelf.SLR=dSLR21;

    end




    plot(t1(:)-t1(1),dSLR21(:)-dSLR1(:),'Color',linecolor,'LineStyle','-','LineWidth',2); hold on

end

xlabel('years'); ylabel('SLR (mm)'); set(gcf,'Color','w'); grid on;
legend('Weertman','Budd','Cornford')




%% StreamIce



%%


cd("C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Shared\Dan - Mathieu- Jowan - Hilmar\Hilmar\Thwaites Ice Shelf Removal Experiments\VAF change estimates for Thwaites - Ua ISSM StreamIce\StreamIce")
load VAF

figure(1);

%SLR_cornford_full    SLR_weertman_full    yrs
%SLR_cornford_nomelt  SLR_weertman_nomelt
%SLR_cornford_remove  SLR_weertman_remove

plot(yrs,SLR_cornford_full,'k','linewidth',2);
hold on
plot(yrs,SLR_cornford_remove,'r','linewidth',2);
hold on
plot(yrs,SLR_weertman_full,'k--','linewidth',2);
hold on
plot(yrs,SLR_weertman_remove,'r--','linewidth',2);
hold off
set(gca,'fontsize',16,'fontweight','bold','xtick',0:25:100);
xlabel ('years');
ylabel ('SLR (mm)');
legend('full shelf, cornford','remove shelf, cornford','full shelf, weertman','remove shelf, weertman','location','northwest');
%title('weertman sliding')
grid on

FindOrCreateFigure("StreamIce rel")

plot(yrs,SLR_cornford_remove-SLR_cornford_full,'k','linewidth',2);
hold on
plot(yrs,SLR_weertman_remove-SLR_weertman_full,'k--','linewidth',2);
hold off
set(gca,'fontsize',16,'fontweight','bold','xtick',0:25:100);
xlabel ('years');
ylabel ('SLR (mm)');
legend('Cornford','Weertman','location','northwest');
%title('weertman sliding')
grid on

StreamIce.Weertman.WithIceShelf.time=yrs;
StreamIce.Weertman.WithoutIceShelf.time=yrs;
StreamIce.Weertman.WithIceShelf.SLR=SLR_weertman_full;
StreamIce.Weertman.WithoutIceShelf.SLR=SLR_weertman_remove;

StreamIce.Cornford.WithIceShelf.time=yrs;
StreamIce.Cornford.WithoutIceShelf.time=yrs;
StreamIce.Cornford.WithIceShelf.SLR=SLR_cornford_full;
StreamIce.Cornford.WithoutIceShelf.SLR=SLR_cornford_remove;

%% Ua Jowan

cd("C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Shared\Dan - Mathieu- Jowan - Hilmar\Hilmar\Thwaites Ice Shelf Removal Experiments\VAF change estimates for Thwaites - Ua ISSM StreamIce\Ua")


pos=[40 40 1200 900];

Tmax=100;
Ymin=0; Ymax=15000;

list = dir('VAF-*ForHilmar*.mat');
labels = [...
    "Cornford - Control",...
    "Cornford - Shelf removed",...
    "Cornford - Control (Dan's inversion)",...
    "Cornford - Shelf removed (Dan's inversion)",...
    "Weertman - Control",...
    "Weertman - Shelf removed"];


nFiles=length(list);
iFile=1;

%% Plot VAF change

while iFile<=nFiles
    
    try
        load(list(iFile).name)
        fprintf(' %s \n ',list(iFile).name)
    catch
        fprintf('could not load %s \n ',list(iFile).name)
    end
    
    VAFloss = -dVAF.*1e-9;  %Convert to km^3
    
    if iFile==1
        figVAF=figure('DefaultAxesFontSize',14);
        figVAF.Position=pos;
        set(gca,'fontsize',14)
    end
    
    if iFile<=2
        plot(VAFTime,VAFloss,'LineWidth',1.5)
    elseif iFile>2 && iFile<=4
        plot(VAFTime,VAFloss,'--','LineWidth',1.5)
    else
        plot(VAFTime,VAFloss,':','LineWidth',1.5)
    end
    hold on
    
    if iFile==nFiles
        xlabel('Time (years)');
        xlim([0 Tmax])
        ylabel('Loss of volume above flotation (km^3)');
        ylim([Ymin, Ymax]);
        ymax=max(ylim);
        ymin=min(ylim);
        yyaxis right
        ylabel('Contribution to sea level (mm)');
        yl=ymin*(0.917/361.8);
        yu=ymax*(0.917/361.8);
        ylim([yl yu])
    end
    
    if iFile==2 || iFile==4
        set(gca,'ColorOrderIndex',1)
    end
    iFile=iFile+1;
    
end

legend(labels,'Location','northwest')


VAF2SLR=-1e-9*0.917/361.8;


iFile=1 ; load(list(iFile).name)
UaJowan.Cornford.WithIceShelf.time=VAFTime;
UaJowan.Cornford.WithIceShelf.SLR=dVAF*VAF2SLR; 

iFile=2 ; load(list(iFile).name)
UaJowan.Cornford.WithoutIceShelf.time=VAFTime;
UaJowan.Cornford.WithoutIceShelf.SLR=dVAF*VAF2SLR; 


iFile=5 ; load(list(iFile).name)
UaJowan.Weertman.WithIceShelf.time=VAFTime;
UaJowan.Weertman.WithIceShelf.SLR=dVAF*VAF2SLR; 

iFile=6 ; load(list(iFile).name)
UaJowan.Weertman.WithoutIceShelf.time=VAFTime;
UaJowan.Weertman.WithoutIceShelf.SLR=dVAF*VAF2SLR; 

iFile=3 ; load(list(iFile).name)
UaJowan.CornfordStreamIce.WithIceShelf.time=VAFTime;
UaJowan.CornfordStreamIce.WithIceShelf.SLR=dVAF*VAF2SLR; 
iFile=4 ; load(list(iFile).name)
UaJowan.CornfordStreamIce.WithoutIceShelf.time=VAFTime;
UaJowan.CornfordStreamIce.WithoutIceShelf.SLR=dVAF*VAF2SLR; 

%%

cd(CurDir)


%% Ua (Hilmar)

cd("C:\cygwin64\home\Hilmar\Ua\UaTests\Calving\PIG-TWG")

load("UaVAFcomparision.mat","DataCollect")         % Created using SomePlotsThwaitesIceShelf
col=["r","b","g","m","y","c","k","b","r","g","m","y","c","k"]  ;

lw=[1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ];
M=["+","o","*","^","s","<",">","d","h","v","+","o","*"];
IRange=1:3 ;

LegendEntry=[...
    "2.3km: Thwaites ice shelf (Alim, Cornford)",...
    "2.3km: Thwaites ice shelf removed 2km downstream (Alim, Cornford)",...
    "2.3km: Thwaites ice shelf removed (Alim, Cornford)",...
    ];

fig=FindOrCreateFigure("VAF"); clf(fig);
for I=IRange


    VAF0=DataCollect{I}.VAF(1);  % The ref value, but this could be re-defined for each run in princple
    yyaxis left
    % plot loss in VAF, that is plot VAF(t=t0)-VAF(t). So if VAF decreases, which causes an increase in sea level, plot \Delta
    % VAF as a positive quantity
    dVAF=(DataCollect{I}.VAF-VAF0) ;

    % Plot loss in VAF, ie loss in VAF is positive if VAF is lost
    plot(DataCollect{I}.time,-dVAF/1e9,'-o',color=col(I),DisplayName=LegendEntry(I),LineWidth=lw(I),Marker=M(I));
    tt=ylim;
    ylabel("Loss in VAF $(\mathrm{ km^3})$",Interpreter="latex")
    yyaxis right


    ylabel("Equivalent global sea level change (mm)")
    xlabel("time (yr)",Interpreter="latex") ;

    %FindOrCreateFigure("Grounded area");
    %plot(DataCollect.time,DataCollect.GroundedArea/1e6,'-or');
    %xlabel("time (yr)") ; ylabel(" Grounded area(km^2)")
    hold on

end
AreaOfTheOcean=3.625e14; % units m^2.

ax=gca();
ax.YAxis(2).Limits=ax.YAxis(1).Limits/362.5 ; % *1000*1e9/AreaOfTheOcean;  % Sea level rise is positive for loss (ie negative) VAF
% Note!!!:  If zooming in, the zoom only is with respect to the left y-axis, after each zoom, the above statement must be
% rerun in the command line to get the right y limits on the right y-axis


lgVAF=legend(Interpreter="latex");
yyaxis left
fig.CurrentAxes.YAxis(1).Exponent=0;


UaHilmar.Cornford.WithIceShelf.time=DataCollect{1}.time ;
UaHilmar.Cornford.WithIceShelf.SLR=VAF2SLR*DataCollect{1}.VAF ; 

UaHilmar.Cornford.WithoutIceShelf.time=DataCollect{3}.time ;
UaHilmar.Cornford.WithoutIceShelf.SLR=VAF2SLR*DataCollect{3}.VAF ; 


%% All plot


FindOrCreateFigure("SLR")

plot(ISSM.Cornford.WithIceShelf.time,ISSM.Cornford.WithIceShelf.SLR,LineWidth=1,color="k")
hold on
plot(ISSM.Cornford.WithoutIceShelf.time,ISSM.Cornford.WithoutIceShelf.SLR,LineWidth=1,color="r")

plot(StreamIce.Cornford.WithIceShelf.time,StreamIce.Cornford.WithIceShelf.SLR,LineWidth=2,color="k")
plot(StreamIce.Cornford.WithoutIceShelf.time,StreamIce.Cornford.WithoutIceShelf.SLR,LineWidth=2,color="r")


plot(UaJowan.Cornford.WithIceShelf.time,UaJowan.Cornford.WithIceShelf.SLR,LineWidth=3,color="k")
plot(UaJowan.Cornford.WithoutIceShelf.time,UaJowan.Cornford.WithoutIceShelf.SLR,LineWidth=3,color="r")


xlabel("Time (years)") ; ylabel("SLR (mm)")



FindOrCreateFigure("SLR rel")


plot(ISSM.Cornford.WithoutIceShelf.time,ISSM.Cornford.WithoutIceShelf.SLR-ISSM.Cornford.WithIceShelf.SLR,LineWidth=2,color="r")
hold on

plot(StreamIce.Cornford.WithoutIceShelf.time,StreamIce.Cornford.WithoutIceShelf.SLR-StreamIce.Cornford.WithIceShelf.SLR,LineWidth=2,color="b")
plot(UaJowan.Cornford.WithoutIceShelf.time,UaJowan.Cornford.WithoutIceShelf.SLR-UaJowan.Cornford.WithIceShelf.SLR,LineWidth=2,color="m")

plot(UaJowan.Cornford.WithoutIceShelf.time,UaJowan.CornfordStreamIce.WithoutIceShelf.SLR-UaJowan.CornfordStreamIce.WithIceShelf.SLR,LineWidth=2,color="c")

plot(UaHilmar.Cornford.WithoutIceShelf.time(1:100),UaHilmar.Cornford.WithoutIceShelf.SLR(1:100)-UaHilmar.Cornford.WithIceShelf.SLR(1:100),LineWidth=2,color="g")


xlabel("Time (years)") ; ylabel("SLR (mm)")
legend("ISSM","StreamIce","Ua Jowan","Ua with StreamIce Inversion","Ua Hilmar")
grid on

% f=gcf; exportgraphics(f,"SLRmodelComparision.pdf")





