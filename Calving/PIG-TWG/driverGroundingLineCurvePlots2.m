

PlotType="Bubble" ;   
PlotType="Histograms" ;   % OK

Region="DotsonCrosson"; % actually Crosson and Dotson Ice Shelves, and Pope, Smith anbd Kohler glaciers
Region="Thwaites"; 
Region="PIG" ; 
Region="Whole"; 




SaveFigures=true;  
% FigureDirectory="C:\Users\lapnjc6\OneDrive - Northumbria University - Production Azure AD\Work\Manuscripts\2022 ThwaitesIceShelfButtressing\Figures\"; 
FigureDirectory="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Work\Manuscripts\2022 ThwaitesIceShelfButtressing\Figures\";
%% Get data and do some simple plots to check all is good.


FileName="D:\Runs\Calving\PIG-TWG\ResultsFiles\0000050-Nodes83632-Ele166223-Tri3-kH10000-FT-P-TWIS-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-" ;


% FileName="D:\Runs\C



fprintf(' Loading %s ',FileName)
load(FileName,"CtrlVar","MUA","F");
fprintf(' done \n ')

% Now get some measure
% ments as well
UserVar.SurfaceVelocityInterpolant='../../../Interpolants/SurfVelMeasures990mInterpolants.mat';
fprintf('Loading interpolants for surface velocity data: %-s ',UserVar.SurfaceVelocityInterpolant)
load(UserVar.SurfaceVelocityInterpolant,'FuMeas','FvMeas','FerrMeas')
fprintf(' done.\n')
uMeas=FuMeas(F.x,F.y);
vMeas=FvMeas(F.x,F.y);

F.LSFMask=CalcMeshMask(CtrlVar,MUA,F.LSF,0); I=F.LSFMask.NodesOut ;

speedMeas=sqrt(uMeas.^2+vMeas.^2);  speedMeas(I)=NaN;
speed=sqrt(F.ub.^2+F.vb.^2); speed(I)=NaN;

FigGL=FindOrCreateFigure("Speed Calculated") ;
UaPlots(CtrlVar,MUA,F,speed) ; title("calculated speed")

FigGL=FindOrCreateFigure("Speed Measured") ;
UaPlots(CtrlVar,MUA,F,speedMeas) ; title("measured speed")


FigGL=FindOrCreateFigure("Speed Measured - Calculated") ;
UaPlots(CtrlVar,MUA,F,speedMeas-speed) ; title("measured-calculated speed")




%% OK here to the bubble plots




switch PlotType

    case "Bubble"

        UserVar=[];


        GLQ=GroundingLineCurvePlots2(UserVar,CtrlVar,MUA,F,ds=2e3,smoothing=1e-9,Plot=false);


        TN=FindOrCreateFigure("ThetaN");  clf(TN)  ;
        fprintf(' Plotting normal and tangential buttressing ratio \n ')


        ax1=axes ;  % first axes
        UaPlots(CtrlVar,MUA,F,"-speed-") ; %  plots (basal) speed
        title(ax1,"")

        % map=othercolor("YlOrRd9",1024) ;  colormap(ax1,map);
        map=othercolor("BuPu4",1024) ;  colormap(ax1,map);
        xlabel("xps (km)",Interpreter="latex")
        ylabel("yps (km)",Interpreter="latex")

        ax2=axes ; % second axes

        % ACHTUNG:  Here is get rid of "outliers", this is possibly questionable, and should ony be done for plotting purposes and
        % after having having checked that this is justified.
        I=isoutlier(GLQ.ThetaN) ;


        x=GLQ.xglc(~I)/1000 ; y=GLQ.yglc(~I)/1000 ; Values=GLQ.ThetaN(~I) ;


        % map=othercolor("YlOrRd9",Ncol) ;
        Ncol=1024;
        map=jet(Ncol);

        % ACHTUNG: Now be carefull as here I truncate the values above and below given max and min values!!!
        ValuesMin=-0.5 ;  ValuesMax=1.5 ;  Values(Values>ValuesMax)= ValuesMax ; Values(Values<ValuesMin)=ValuesMin ;
        % ValuesMin=min(ValuesMax)  ; ValuesMax=max(ValuesMin) ; % better to do this first, and then possibly truncate afterwards

        ind=round((Ncol-1)*(Values-ValuesMin)/(ValuesMax-ValuesMin))+1 ; % index into colormap
        ValueOne=1;

        indOneUpper=round((Ncol-1)*(ValueOne*1.1-ValuesMin)/(ValuesMax-ValuesMin))+1 ; % index into colormap
        indOneLower=round((Ncol-1)*(ValueOne*0.9-ValuesMin)/(ValuesMax-ValuesMin))+1 ; % index into colormap

        map(indOneLower:indOneUpper,:)=map(indOneLower:indOneUpper,:)*0 ;
        % Note: For this colormapping to be correct, the limits of caxis must be manually set to [ValuesMin ValuesMax]
        %
        colormap(ax2,map);

        hold on
        % scatter(x,y,100*Values,map(ind,:),'filled');
        bc=bubblechart(ax2,x,y,Values*0+1,map(ind,:)) ; %,'filled');
        axis equal ;
        hold on
        plot(GLQ.xglc/1000,GLQ.yglc/1000,"-r");



        xlabel("xps (km)",Interpreter="latex")
        ylabel("yps (km)",Interpreter="latex")


        linkaxes([ax1,ax2])
        hold off
        ax2.Visible = 'off';
        ax2.XTick = [];
        ax2.YTick = [];
        set([ax1,ax2],'Position',[.17 .11 .685 .815]);
        cb1 = colorbar(ax1,'Position',[.07 .2 .05 .6]);
        cb2 = colorbar(ax2,'Position',[.88 .2 .05 .6]);  clim(ax2,[ValuesMin ValuesMax]) ; %

        title(cb2,"$\Theta_N$",interpreter="latex")
        title(cb1,["speed","$(\mathrm{m/yr})$"],interpreter="latex")
        
        %colormap(ax1,'hot')
        %colormap(ax2,'cool')
        % axis([-1700 -1100 -700 -200])
        axis([-1700 -1400 -700 -200])
        bubblesize([3 20])
        TN.Position=[50 150 800 1100] ;
        cb2.Position=[0.900 0.550 0.0300 0.3500];
        cb1.Position=[0.900 0.1400 0.0300 0.3500];



        % bl=bubblelegend("$\Theta$",Interpreter="latex");

        %%

        Fig=gca ;



        switch Region

            case "Whole"
                bubblesize([3 10])
                PlotLatLonGrid(1000,5/4,10/2); % All

                text(-1560,-565,"Crosson",Color="k",FontSize=12,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
                text(-1570,-650,"Dotson",Color="k",FontSize=12,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")

                text(-1610,-225,["Pine Island Glacier"],Color="k",FontSize=12,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
                text(-1510,-425,["Thwaites"," Glacier"],Color="k",FontSize=12,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
                text(-1590,-605,["\ \ \ \ Bear","Peninsula"],Color="k",FontSize=10,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")

                text(-1610,-490,"TWGT",Color="k",FontSize=10,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
                text(-1620,-450,"TEIS",Color="k",FontSize=10,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")

                clim(ax1,[0 4500]) ; %

            case "PIG"

                Fig.XLim=[-1680 -1550];  Fig.YLim=[-370 -220];
                bl.Location="NorthWest";  % PIG
                TN.Position=[50 460 760 790];
                PlotLatLonGrid(1000,5/2^3,10/2^2);

                text(-1610,-230,["Pine Island Glacier"],Color="k",FontSize=12,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
                % exportgraphics(Fig,'C:\Users\lapnjc6\OneDrive - Northumbria University - Production Azure AD\Work\Manuscripts\2022 ThwaitesIceShelfButtressing\Figures\ButtressingRatioPIG.pdf')

            case "Thwaites"

                Fig.XLim=[-1585 -1515];  Fig.YLim=[-480 -390];
                clim(ax1,[0 3000]) ; %
                TN.Position=[50 345 790 903];
                PlotLatLonGrid(1000,5/2^4,10/2^3); 


            case "DotsonCrosson" % actually Pope, Smith and Kohler

                Fig.XLim=[-1600 -1470];  Fig.YLim=[-710 -520];
                PlotLatLonGrid(1000,5/2^3,10/2^2);
                clim(ax1,[0 1800]) ; %
                text(-1540,-565,"Crosson",Color="k",FontSize=14,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
                text(-1540,-650,"Dotson",Color="k",FontSize=14,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")

            otherwise

                error("what case")

        end

        if SaveFigures

            FigureName="ButtressingRatio"+Region;
            exportgraphics(TN,FigureDirectory+FigureName+".pdf")
            savefig(TN,FigureDirectory+FigureName+".fig","compact")

        end
        %
        %%
        % calc again, but without the plots, and higher res, but make sure to have saved plots ahead of this

    case "Histograms"

        [xGL,yGL]=PlotGroundingLines(CtrlVar,MUA,F.GF) ;   CtrlVar.PlotGLs=0;
        I=find(isnan(xGL)) ; xgl=xGL(1:I(1));  ygl=yGL(1:I(1));

        GLQ=GroundingLineCurvePlots2(UserVar,CtrlVar,MUA,F,ds=0.5e3,xgl=xgl,ygl=ygl,smoothing=1e-9,Plot=false);

        % consider cutting Thwaites accross
        BoxTG=[-1580 -1515 -470 -400]*1e3; InTG=IsInBox(BoxTG,xgl,ygl) ;
        xgl(InTG)=[]; ygl(InTG)=[];


        GLQThwaitesSimplified=GroundingLineCurvePlots2(UserVar,CtrlVar,MUA,F,ds=0.5e3,xgl=xgl,ygl=ygl,smoothing=1e-9,Plot=false);


        BoxPIG=[-1625 -1570 -290 -250]*1e3;  InPIG=IsInBox(BoxPIG,GLQ.xglc,GLQ.yglc) ;
        BoxTG=[-1580 -1515 -480 -400]*1e3;   InTG=IsInBox(BoxTG,GLQ.xglc,GLQ.yglc) ;
        BoxPSK=[-1580 -1470 -695 -540]*1e3;  InPSK=IsInBox(BoxPSK,GLQ.xglc,GLQ.yglc) ; % Pope, Smith, Kohler glaciers



    % Theta_N Histograms
        FH=FindOrCreateFigure("Hist ThetaN") ; clf(FH)
        tiledlayout(3,1)
        nexttile
        hg1=histogram(GLQ.ThetaN(InPIG)) ;  hg1.Normalization="probability" ; hg1.BinWidth=0.05 ;
        xlim([-1 1.5]) ; legend("PIG") ; xlabel("$\Theta_N$",interpreter="latex")
        nexttile
        hg2=histogram(GLQ.ThetaN(InTG)) ;  hg2.Normalization="probability" ; hg2.BinWidth=0.05 ;
        xlim([-1 1.5]) ; legend("Thwaites",Location="northwest") ; xlabel("$\Theta_N$",interpreter="latex")
        nexttile
        hg3=histogram(GLQ.ThetaN(InPSK)) ; hg3.Normalization="probability" ; hg3.BinWidth=0.05 ;
        xlim([-1 1.5]) ; legend("Pope, Smith, Kohler") ; xlabel("$\Theta_N$",interpreter="latex")

        if SaveFigures

            FigureName="HistogramTheta";
            exportgraphics(FH,FigureDirectory+FigureName+".pdf")
            savefig(FH,FigureDirectory+FigureName+".fig","compact")

        end

        FHkappaThwaites=FindOrCreateFigure("Hist ThetaN Thwaites simplified") ; clf(FHkappaThwaites)
        hgT1=histogram(GLQ.ThetaN(InTG)) ;  hgT1.Normalization="probability" ; hgT1.BinWidth=0.05 ;
        hold on
        hgT2=histogram(GLQThwaitesSimplified.ThetaN(InTG)) ;  hgT2.Normalization="probability" ; hgT2.BinWidth=0.05 ;
        xlim([-0.5 1.5]) ;
        legend("Along Thwaites' Grounding Line","Downstream of Thwaites' grounding line",Location="northwest") ; ylabel("$\Theta_N$",interpreter="latex")


        if SaveFigures

            FigureName="HistogramThetaThwaites";
            exportgraphics(FHkappaThwaites,FigureDirectory+FigureName+".pdf")
            savefig(FHkappaThwaites,FigureDirectory+FigureName+".fig","compact")

        end


    % K_N histograms (consider renaming K to \kappa)
        FHkappa=FindOrCreateFigure("Hist kappaN") ; clf(FHkappa)
        tiledlayout(3,1)
        nexttile
        hg1=histogram(GLQ.kappaN(InPIG)) ;  hg1.Normalization="probability" ; hg1.BinWidth=0.05 ;
        xlim([-0.5 2]) ; legend("PIG") ; xlabel("$K_N$",interpreter="latex")
        nexttile
        hg2=histogram(GLQ.kappaN(InTG)) ;  hg2.Normalization="probability" ; hg2.BinWidth=0.05 ;
        xlim([-0.5 2]) ; legend("Thwaites",Location="northeast") ; xlabel("$K_N$",interpreter="latex")
        nexttile
        hg3=histogram(GLQ.kappaN(InPSK)) ; hg3.Normalization="probability" ; hg3.BinWidth=0.05 ;
        xlim([-0.5 2]) ; legend("Crosson and Dotson",Location="northwest") ; xlabel("$K_N$",interpreter="latex")


        if SaveFigures
            
            FigureName="HistogramKappa";
            exportgraphics(FHkappa,FigureDirectory+FigureName+".pdf")
            savefig(FHkappa,FigureDirectory+FigureName+".fig","compact")

        end


        FHkappaThwaites=FindOrCreateFigure("Hist kappaN Thwaites") ; clf(FHkappaThwaites)
        hgT1=histogram(GLQ.kappaN(InTG)) ;  hgT1.Normalization="probability" ; hgT1.BinWidth=0.05 ;
        hold on
        hgT2=histogram(GLQThwaitesSimplified.kappaN(InTG)) ;  hgT2.Normalization="probability" ; hgT2.BinWidth=0.05 ;
        xlim([-0.5 2]) ;
        legend("Along Thwaites' Grounding Line","Downstream of Thwaites' grounding line",Location="northeast") ; ylabel("$K_N$",interpreter="latex")


        if SaveFigures
            
            FigureName="HistogramKappaThwaites";
            exportgraphics(FHkappaThwaites,FigureDirectory+FigureName+".pdf")
            savefig(FHkappaThwaites,FigureDirectory+FigureName+".fig","compact")

        end



        BL=FindOrCreateFigure("Boxes locations") ; clf(BL)
        CtrlVar.PlotGLs=1;
        cbar=UaPlots(CtrlVar,MUA,F,"-speed-");
        clim([0 4500])
        cbar.Location='East';
        cbar.Position=[0.7 0.6 0.04 0.25];
        hold on

        plot([BoxPIG(1) BoxPIG(2) BoxPIG(2) BoxPIG(1) BoxPIG(1)]/1e3,[BoxPIG(3) BoxPIG(3) BoxPIG(4) BoxPIG(4) BoxPIG(3)]/1e3,"k")
        plot([BoxTG(1) BoxTG(2) BoxTG(2) BoxTG(1) BoxTG(1)]/1e3,[BoxTG(3) BoxTG(3) BoxTG(4) BoxTG(4) BoxTG(3)]/1e3,"k")
        plot([BoxPSK(1) BoxPSK(2) BoxPSK(2) BoxPSK(1) BoxPSK(1)]/1e3,[BoxPSK(3) BoxPSK(3) BoxPSK(4) BoxPSK(4) BoxPSK(3)]/1e3,"k")
        axis([-1680 -1400 -700 -200])


        plot(GLQ.xglc(InPIG)/1e3,GLQ.yglc(InPIG)/1e3,LineWidth=2,Color="r");
        plot(GLQ.xglc(InTG)/1e3,GLQ.yglc(InTG)/1e3,LineWidth=2,Color="r");
        plot(GLQ.xglc(InPSK)/1e3,GLQ.yglc(InPSK)/1e3,LineWidth=2,Color="r");

        InTGs=IsInBox(BoxTG,GLQThwaitesSimplified.xglc,GLQThwaitesSimplified.yglc) ;
        plot(GLQThwaitesSimplified.xglc(InTGs)/1e3,GLQThwaitesSimplified.yglc(InTGs)/1e3,LineWidth=2,Color="r",LineStyle="--");


        
        title(cbar,["speed","$(\mathrm{m/yr})$"],Interpreter="latex")
        xlabel("xps (km)",Interpreter="latex")
        ylabel("yps (km)",Interpreter="latex")
        BL.Position=[220 432 500 718];
        title("")

        BL.Position=[220 432 500 718];
        cbar.Position=[0.7 0.6 0.04 0.25];
        
        PlotLatLonGrid(1000);
        text(-1560,-565,"Crosson",Color="k",FontSize=10,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
        text(-1570,-650,"Dotson",Color="k",FontSize=10,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")

        text(-1620,-225,["Pine Island Glacier"],Color="k",FontSize=10,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
        text(-1510,-425,["Thwaites"," Glacier"],Color="k",FontSize=10,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
        text(-1600,-605,["\ \ \ \ Bear","Peninsula"],Color="k",FontSize=9,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")

        text(-1630,-490,"TWGT",Color="k",FontSize=10,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
        text(-1630,-450,"TEIS",Color="k",FontSize=10,Interpreter="latex",FontWeight="bold",Rotation=0,BackgroundColor="w")
        drawnow
        BL.Position=[220 432 500 718];
        if SaveFigures

            FigureName="HistogramBoxes";
            exportgraphics(BL,FigureDirectory+FigureName+".pdf")
            savefig(BL,FigureDirectory+FigureName+".fig","compact")

        end

    otherwise

        error("case not found")

end
%%
