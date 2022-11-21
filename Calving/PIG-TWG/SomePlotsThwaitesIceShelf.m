% Restart-FT-P-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat  at t=42.8286
% Restart-FT-P-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat  at t=161.564 
% Restart-FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat  at t=53.3 
% Restart-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat  at t=105.55 



WorkDir=pwd ;


if ~contains(WorkDir,"ResultsFiles")
    [~,hostname]=system('hostname') ;
    if contains(hostname,"DESKTOP-G5TCRTD")
        UserVar.ResultsFileDirectory="F:\Runs\Calving\PIG-TWG\ResultsFiles\";
    elseif contains(hostname,"DESKTOP-BU2IHIR")
        UserVar.ResultsFileDirectory="D:\Runs\Calving\PIG-TWG\ResultsFiles\";
    elseif contains(hostname,"DESKTOP-014ILS5")
        UserVar.ResultsFileDirectory="E:\Runs\Calving\PIG-TWG\ResultsFiles\";
    else
        error("case not implemented")
    end
    cd(UserVar.ResultsFileDirectory)
end




Experiment="AC-lim" ;
Experiment="5km-New";


Experiment="5km-New-Cornford";
Experiment="10km-New-Cornford";
Experiment="20km-New-Cornford"; 

Experiment="SUPG"  ;

Experiment="5km-New-Cornford";

%Experiment="Compare with ref" ;

CreateVideo=false; 
CalculateVAF=true;


% Experiment= "ConvergenceStudy";

VAFStep=25; 
VideoStep=10; 
PlotCase=""  ; 

switch Experiment

    case "AC-lim"

        MS="5km"; LM=" 2.3km" ;
        % MS="10km"; LM=" 4.6km" ;
        % MS="20km"; LM=" 9.3km" ;
        % MS="30km"; LM=" 14km" ;

        SubString(1)="T-P-TWIS-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile"+MS+"-PIG-TWG";
        %SubString(1)="T-P-TWIS-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile"+MS+"-PIG-TWG";

        SubString(2)="T-P-TWIS-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile"+MS+"-PIG-TWG";
        SubString(3)="T-P-TWISC0-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC0-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile"+MS+"-PIG-TWG";
        IRange=1:3;

        LegendEntry=[...
            "TWIS"+LM,"TWIS AClim"+LM, "TWISC AClim"+LM
            ];

    case "ConvergenceStudy"


        SubString(1)="T-P-TWIS-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile30km-PIG-TWG";
        SubString(2)="T-P-TWIS-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile20km-PIG-TWG";
        SubString(3)="T-P-TWIS-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(4)="T-P-TWIS-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";


        LegendEntry=[...
            "14km","9.3km","4.6km","2.3km",...
            ];

        IRange=1:4;

    case "10km"


        % 10km
        SubString(1)="T-P-TWIS-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(2)="T-P-TWISC-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(3)="T-P-TWISC2-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC2-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(4)="T-P-TWISC5-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC5-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(5)="T-P-TWISC10-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC10-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";


        LegendEntry=[...
            "4.6km: Thwaites ice shelf","4.6km: Thwaites ice shelf removed","4.6km: Thwaites ice shelf removed 2km downstream","4.6km: Thwaites ice shelf removed 5km downstream","4.6km: Thwaites ice shelf removed 10km downstream",...
            ];

    case "10km-New"
        

        SubString(1)="FT-P-TWIS-MR4-SM-10km.mat";
        SubString(2)="FT-P-TWISC0-MR4-SM-10km.mat";
        SubString(3)="FT-P-TWIS-MR4-SM-10km-Alim-.mat";
        SubString(4)="FT-P-TWISC0-MR4-SM-10km-Alim.mat";

        LegendEntry=[...
            "4.6km: Thwaites ice shelf",...
            "4.6km: Thwaites ice shelf removed",...
            "4.6km: Thwaites ice shelf (Alim)",...
            "4.6km: Thwaites ice shelf removed (Alim)",...
            ];

        IRange=1:4 ;

case "20km-New-Cornford"

        SubString(1)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-";    % 200 years
        SubString(2)="ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-";  % 200 years

        LegendEntry=[...
            "9.3km: (Alim, Cornford, hmin=0.01m)",...
            "9.3km: removed (Alim, Cornford, hmin=0.01m)",...
            ];

        IRange=1;   
        VideoStep=10; 

    case "10km-New-Cornford"


        SubString(1)="FT-P-TWIS-MR4-SM-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";
        
        SubString(2)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";  % 161 years
        
        SubString(3)="FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";  % 359 years

        SubString(4)="FT-P-TWISC0-MR4-SM-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(5)="ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";  % 232 years

        SubString(6)="FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";  % 224 years

        SubString(7)="FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";  % 200 years

        SubString(8)="FT-P-Duvh-TWISC0MGL-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";

        SubString(9)="FT-P-TWIS-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(10)="FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

        SubString(11)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(12)="ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-";

        

        LegendEntry=[...
            "4.6km: (Alim, Cornford, hmin=1m)",...
            "4.6km: (Alim, Cornford, hmin=0.01m)",...
            "4.6km: (Alim, Cornford, hmin=0.01m, LSF Deactivation)",...
            "4.6km: removed (Alim, Cornford, hmin=1m)",...
            "4.6km: removed (Alim, Cornford, hmin=0.01m)",...
            "4.6km: removed (Alim, Cornford, hmin=0.01m, LSF Deactivation)",...
            "4.6km: removed (Alim, Cornford, hmin=0.01m, LSF Deactivation, C2)",...
            "4.6km: removed (Alim, Cornford, hmin=0.01m, LSF Deactivation, MGL)",...
            "2.3km: (Alim, Cornford, hmin=1m)",...
            "2.3km: removed (Alim, Cornford, hmin=1m)",...
            "9.3km: (Alim, Cornford, hmin=0.01m)",...
            "9.3km: removed (Alim, Cornford, hmin=0.01m)",...
            ];

        IRange=1:6 ;
        IRange=1:10;
        IRange=1:3;    PlotCase="Comparing ThickMin for 4.6km"  ; 
        IRange=11:12;  PlotCase=""  ; 
        IRange=5; 

      VAFStep=5; 

    case "5km"

        % 5 km
        SubString(6)="T-P-TWIS-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
        SubString(7)="T-P-TWISC-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
        SubString(8)="T-P-TWISC2-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC2-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
        SubString(9)="T-P-TWISC5-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC5-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";
        SubString(10)="T-P-TWISC10-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC10-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";



        LegendEntry=[...
            "2.3km: Thwaites ice shelf","2.3km: Thwaites ice shelf removed","2.3km: Thwaites ice shelf removed 2km downstream","2.3km: Thwaites ice shelf removed 5km downstream","2.3km: Thwaites ice shelf removed 10km downstream",...
            ];

        IRange=6:10;

    case "5km-New"

        SubString(1)="-FT-P-TWIS-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-FT-P-TWISC0-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        IRange=1:2;
        LegendEntry=[...
            "2.3km: Thwaites ice shelf (Alim)",...
            "2.3km: Thwaites ice shelf removed (Alim)",...
            ];


       VideoStep=5; 

    case "5km-New-Cornford"


        SubString(1)="-FT-P-TWIS-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(3)="-FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

        SubString(1)="-ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";  % 107 years
        SubString(2)="-ThickMin0k01-FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(3)="-ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";  % 285 years

        IRange=1:3;
     
        LegendEntry=[...
            "2.3km: Thwaites ice shelf (Alim, Cornford)",...
            "2.3km: Thwaites ice shelf removed 2km downstream (Alim, Cornford)",...
            "2.3km: Thwaites ice shelf removed (Alim, Cornford)",...
            ];

        VAFStep=1;
        VideoStep=25; 

    case "Compare with ref"

        PlotCase="Compare"  ;

        ComparisionMatrix=[1 nan; 2 1 ; 3 1  ; 4 nan ; 5 4 ; 6 4 ; 7 nan ; 8 7]  ;
        
        IRange=ComparisionMatrix(:,1); IRange=IRange' ;

        IRange=[1  3  4  6  7  8];


        SubString(1)="-FT-P-TWIS-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(3)="-FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";



        SubString(4)="FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(5)="FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";
        SubString(6)="FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";
        


        SubString(7)="-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(8)="-FT-P-TWISC0-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-";

        LegendEntry=[...
            "2.3km: Thwaites ice shelf (Alim, Cornford)",...
            "2.3km: Thwaites ice shelf removed 2km downstream (Alim, Cornford)",...
            "2.3km: Thwaites ice shelf removed (Alim, Cornford)",...
            "4.6km: Thwaites ice shelf (Alim, Cornford)",...
            "4.6km: Thwaites ice shelf removed 2km downstream (Alim, Cornford)",...
            "4.6km: Thwaites ice shelf removed (Alim, Cornford)",...
            "9.3km: Thwaites ice shelf (Alim, Cornford)",...
            "9.3km: Thwaites ice shelf removed (Alim, Cornford)",...
            ];

        VAFStep=25;


    case "SUPG"  

        SubString(1)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";    
        SubString(2)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-taut-beta01.mat";    % 200 years
        SubString(3)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-tau1-beta01.mat";    % 200 years
        SubString(4)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-tau2-beta01.mat";    % 200 years
 
        SubString(5)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-taus-SUPGm100.mat";    % 200 years
        SubString(6)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-taut-SUPGm100.mat";    % 400 years
        SubString(7)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-tau1-SUPGM100.mat";    % 400 years
        SubString(8)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-tau2-SUPGm100.mat";    % 400 years


        SubString(9)="ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";  

        IRange=[9];   
        VideoStep=10; 

end

% 30km = 14km
% 20km = 9.3km
% 10km = 4.6km
%  5km = 2.3km



xb=[-1520 -1445 -1100 -1100 -1350 -1590 -1520] ;yb=[-510  -547  -547 -180 -180   -390 -510];
xyBoundary=[xb(:) yb(:)]*1000;
% xyBoundary=nan;

if CreateVideo
    Step=VideoStep; 
    for I=IRange


%        ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-h-") ;
        % ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-s-",AxisLimits=[-1700 -1050 -700 0]) ;
        % ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-B-") ;
        % ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-VAF-",VAFBoundary=xyBoundary) ;
        % ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-ds-",VAFBoundary=xyBoundary) ;
        ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ds-",VAFBoundary=xyBoundary,PlotTimeInterval=[0 400]) ;
    end
end

col=["r","b","g","m","y","c","k","b","r","g","m","y","c","k"]  ;

lw=[1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ];
M=["+","o","*","^","s","<",">","d","h","v","+","o","*"];
DataCollect=cell(10) ;


if CalculateVAF
    Step=VAFStep ;


    for I=IRange
        fprintf("\n Reading %s \n",SubString(I))
      
        DataCollect{I}=ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),...
            PlotType="-collect-",...
            PlotTimestep=Step,...
            PlotTimeInterval=[0 400],...
            VAFBoundary=xyBoundary) ;
        
        fprintf("done. \n \n")
    end

    


    %% VAF and sea-level change plot
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
    %%

    if PlotCase=="Compare"
        
        fig=FindOrCreateFigure("Compare"); clf(fig);
        %for I=1:size(ComparisionMatrix,1)
        for I=IRange
           

            yyaxis left
            % plot loss in VAF, that is plot VAF(t=t0)-VAF(t). So if VAF decreases, which causes an increase in sea level, plot \Delta
            % VAF as a positive quantity


            iRef=ComparisionMatrix(I,2);
            iData=ComparisionMatrix(I,1);

            if isnan(iRef)
                continue
            end

            % Where do I have common data?
          

            timeRef=round(DataCollect{iRef}.time(find(~isnan(DataCollect{iRef}.time)))) ;
            timeCompare=round(DataCollect{iData}.time(find(~isnan(DataCollect{iData}.time)))) ;
            TimeVector=intersect(timeRef,timeCompare) ;  % These are the times where I have data in the ref and the comparision arrays


            dVAF=nan(numel(TimeVector),1);

            for k=1:numel(TimeVector)  

                [dtRef,iRefTime]=min(abs(DataCollect{iRef}.time - TimeVector(k)));          
                [dtCompare,iCompareTime]=min(abs(DataCollect{iData}.time - TimeVector(k)));

                dtMin=0.001; 
                if dtRef<dtMin && dtCompare<dtMin  % should not really be needed, 
                                                         % because  I know that I have data here at these times, 
                                                         % since I already restricted TimeVector to common times 

                    dVAF(k)= DataCollect{iData}.VAF(iCompareTime)-DataCollect{iRef}.VAF(iRefTime) ;
                else
                    dVAF(k)=nan;
                end
            end

            yyaxis left
            plot(TimeVector, -dVAF/1e9,'-o',color=col(I),DisplayName=LegendEntry(iData),LineWidth=lw(I),Marker=M(iData));
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

    end
    AreaOfTheOcean=3.625e14; % units m^2.

    ax=gca();  
    ax.YAxis(2).Limits=ax.YAxis(1).Limits*1000*1e9/AreaOfTheOcean;
    % Note!!!:  If zooming in, the zoom only is with respect to the left y-axis, after each zoom, the above statement must be
    % rerun in the command line to get the right y limits on the right y-axis


    legend(ax,Interpreter="latex")
    yyaxis left
    fig.CurrentAxes.YAxis(1).Exponent=0;

    %%

    if PlotCase=="Comparing ThickMin for 4.6km"

        figVAFdVAF=FindOrCreateFigure("VAF and dVAF"); clf(figVAFdVAF);

        for I=IRange


            VAF0=DataCollect{I}.VAF(1);  % The ref value, but this could be re-defined for each run in princple
            yyaxis left
            % plot loss in VAF, that is plot VAF(t=t0)-VAF(t). So if VAF decreases, which causes an increase in sea level, plot \Delta
            % VAF as a positive quantity
            plot(DataCollect{I}.time, (VAF0-DataCollect{I}.VAF)/1e9,'-o',color=col(I),DisplayName=LegendEntry(I),LineWidth=lw(I),Marker=M(I));
            hold on
            ylabel("Loss in VAF $(\mathrm{ km^3})$",Interpreter="latex")


            % Where do I have common data?
            IRef=IRange(1);
            timeRef=round(DataCollect{IRef}.time(find(~isnan(DataCollect{IRef}.time)))) ;
            timeCompare=round(DataCollect{I}.time(find(~isnan(DataCollect{I}.time)))) ;
            TimeVector=intersect(timeRef,timeCompare) ;  % These are the times where I have date in the ref and the comparision arrays
            dVAF=nan(numel(TimeVector),1);

            for k=1:numel(TimeVector)  % Now presumably this can be done better using some vectorized approach...

                [dtRef,iRef]=min(abs(DataCollect{IRef}.time - TimeVector(k)));          % I know that I have data here at these times, because I've already restricted TimeVector to those times
                [dtCompare,iCompare]=min(abs(DataCollect{I}.time - TimeVector(k)));
                dVAF(k)= DataCollect{I}.VAF(iCompare)-DataCollect{IRef}.VAF(iCompare) ;

            end

            yyaxis right
            plot(TimeVector,dVAF/1e9,'-o',color=col(I),DisplayName=LegendEntry(I),LineWidth=lw(I),Marker=M(I),LineStyle='--');
            hold on

            ylabel("Change in VAF with respect to $h_{\mathrm{min}}=1\,\mathrm{m}\,(\mathrm{km}^3)$",Interpreter="latex")


        end

        xlabel("time (yr)",Interpreter="latex") ;
        lg=legend(Interpreter="latex");


        lg.String{1}="$h_{\mathrm{min}}=1\,\mathrm{m}$";  lg.String{2}="$h_{\mathrm{min}}=0.01\,\mathrm{m}$";  lg.String{3}="$h_{\mathrm{min}}=1\,\mathrm{m}$ and deactivation";
        lg.String(4:6)=[] ;
    end
    %%

end



% f=gcf; exportgraphics(f,'ThwaitesIceShelf.pdf')

fprintf("Plots and videos were saved in the folder %s \n",pwd)

cd(WorkDir)