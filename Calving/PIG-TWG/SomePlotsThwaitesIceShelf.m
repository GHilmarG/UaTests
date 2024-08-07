% Restart-FT-P-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat  at t=42.8286
% Restart-FT-P-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat  at t=161.564
% Restart-FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat  at t=53.3
% Restart-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat  at t=105.55

% 30km = 14km
% 20km = 9.3km
% 10km = 4.6km
%  5km = 2.3km
% 2.5km = 1.16km

WorkDir=pwd ;


if ~contains(WorkDir,"ResultsFiles")
    [~,hostname]=system('hostname') ;
    if contains(hostname,"DESKTOP-G5TCRTD")
        UserVar.ResultsFileDirectory="F:\Runs\Calving\PIG-TWG\ResultsFiles\";
    elseif contains(hostname,"DESKTOP-BU2IHIR")
        UserVar.ResultsFileDirectory="D:\Runs\Calving\PIG-TWG\ResultsFiles\";
    elseif contains(hostname,"DESKTOP-014ILS5")
        UserVar.ResultsFileDirectory="E:\Runs\Calving\PIG-TWG\ResultsFiles\";
    elseif contains(hostname,"C23000099")
        UserVar.ResultsFileDirectory="E:\Runs\Calving\PIG-TWG\ResultsFiles\"; 
    else
        error("case not implemented")
    end
    cd(UserVar.ResultsFileDirectory)
end

FigureDirectory="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Work\Manuscripts\2022 ThwaitesIceShelfButtressing\Figures\";

xb=[-1520 -1445 -1100 -1100 -1350 -1590 -1520] ;yb=[-510  -547  -547 -180 -180   -390 -510];
xyBoundary=[xb(:) yb(:)]*1000;

TimeInterval=[0 inf] ; 

Experiment="AC-lim" ;
Experiment="5km-New";


Experiment="5km-New-Cornford";

Experiment="20km-New-Cornford";

Experiment="SUPG"  ;


Experiment="10km-New-Cornford";

Experiment="5km-New-Weertman";
Experiment="5km-New-Cornford";





Experiment="5km-New-Cornford-PIG";


Experiment= "Compare with ref: TWIS and PIG" ;
Experiment="Compare Cornford and Weertman with respective ref"  ; % C and W for MR4 and Thwaites removal

Experiment="5km-New-Cornford";
Experiment="5km-New-Weertman"; 
Experiment="5km-New-Cornford";   % now includes Weertman as well
Experiment="Compare with ref: mesh convergence" ;

CreateVideo=true; CalculateVAF=false;  % defaults


% Experiment= "ConvergenceStudy";

VAFStep=25;
VideoStep=25;
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


        SubString(1)="FT-P-TWIS-MR4-SM-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";

        SubString(2)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";  % 161 years
        SubString(3)="ThickMin0k01-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";  % 359 years

        SubString(4)="FT-P-TWISC0-MR4-SM-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(5)="ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";  % 232 years

        SubString(6)="FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";  % 224 years

        SubString(7)="FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";  % 200 years

        SubString(8)="FT-P-Duvh-TWISC0MGL-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";

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
        % IRange=11:12;  PlotCase=""  ;
        %  IRange=5;

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

        SubString(1)="-FT-P-TWIS-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(3)="-FT-P-TWISC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

        SubString(4)="-FT-P-TWIS-MR0-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(5)="-FT-P-TWISC2-MR0-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";  % has not been done
        SubString(6)="-FT-P-TWISC0-MR0-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

        % adding Weertman in here as well
        SubString(10)="-ThickMin0k01-FT-P-Duvh-TWIS-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(11)="-ThickMin0k01-FT-P-Duvh-TWISC0-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(12)="-ThickMin0k01-FT-P-Duvh-TWIS-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(13)="-ThickMin0k01-FT-P-Duvh-TWISC0-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

        IRange=[4  6  10  11  12  13] ;


        LegendEntry=[...
            "2.3km: Thwaites ice shelf (Alim, Cornford)",...
            "2.3km: Thwaites ice shelf removed 2km downstream (Alim, Cornford)",...
            "2.3km: Thwaites ice shelf removed (Alim, Cornford)",...
            ];

      VideoStep=1;


    case "5km-New-Cornford-PIG"

        SubString(1)="-FT-P-PIGC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(2)="-FT-P-PIGC0-MR0-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        IRange=1; 

        VideoStep=1;  CreateVideo=true; CalculateVAF=false;
        xyBoundary=NaN;

    case "5km-New-Weertman"


        SubString(1)="-ThickMin0k01-FT-P-Duvh-TWIS-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-"; 
        SubString(2)="-ThickMin0k01-FT-P-Duvh-TWISC0-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

        VideoStep=1;

        % These runs are not finalized:
        % SubString(1)="-ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-";  
        % SubString(2)="-ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-"; 

        IRange=1:2;

        LegendEntry=[...
            "2.3km: Thwaites ice shelf (Alim, Weertman)",...
            "2.3km: Thwaites ice shelf removed (Alim, Weertman)",...
            ];


    case "Compare with ref: TWIS and PIG"   % MR0 and MR4 for removing either PIG or Thwaites

        PlotCase="Compare"  ;  

        ComparisionMatrix=[1 nan; 2 1 ; 3 1  ; 4 nan ; 5 4 ; 6 4 ]  ;

        IRange=ComparisionMatrix(:,1); IRange=IRange' ;

        IRange=[1 2 3 4 5 6 ];


        % MR4
        SubString(1)="-FT-P-TWIS-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(2)="-FT-P-TWISC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(3)="-FT-P-PIGC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        
        % MR0
        SubString(4)="-FT-P-TWIS-MR0-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(5)="-FT-P-TWISC0-MR0-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(6)="-FT-P-PIGC0-MR0-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        



        LegendEntry=[...
            "Reference    (2.3km, MR4, Cornford)",...
            "TWIS removed (2.3km, MR4, Cornford)",...
            "PIIS removed (2.3km, MR4, Cornford)",...
            "Reference    (2.3km, MR0, Cornford)",...
            "TWIS removed (2.3km, MR0, Cornford)",...
            "PIIS removed (2.3km, MR0, Cornford)",...
            ];


        LegendEntry=[...
            "Reference    (MR4)",...
            "TWIS removed (MR4)",...
            "PIIS removed (MR4)",...
            "Reference    (MR0)",...
            "TWIS removed (MR0)",...
            "PIIS removed (MR0)",...
            ];


        
        TimeInterval=[0 100] ; 
        VAFStep=5;
        xyBoundary=nan;  % since this is always with respect to a reference run, I think that limiting the region is not needed




    case "Compare Cornford and Weertman with respective ref"   % C and W for MR4 and Thwaites removal

        PlotCase="Compare"  ;  

        ComparisionMatrix=[1 nan; 2 1 ; 3 1 ; 4 nan  ; 5 4  ; 6 4 ; 7 nan ; 8 7 ; 9 7 ; 10 nan ; 11 10 ; 12 10 ];

        IRange=ComparisionMatrix(:,1); IRange=IRange' ;


        % Cornford:MR4
        SubString(1)="-FT-P-TWIS-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";      % ref Cornford:M4
        SubString(2)="-FT-P-TWISC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(3)="-FT-P-PIGC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";

        % Weertman:MR4
        SubString(4)="-FT-P-Duvh-TWIS-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";    % ref Weertman:M4
        SubString(5)="-FT-P-Duvh-TWISC0-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(6)="-FT-P-PIGC0-MR4-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";

        % Cornford:MR0
        SubString(7)="-FT-P-TWIS-MR0-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";             % ref Cornford:M0
        SubString(8)="-FT-P-TWISC0-MR0-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(9)="-FT-P-PIGC0-MR0-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";

        % Weertman:MR0
        SubString(10)="-FT-P-TWIS-MR0-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";    % ref Weertman:M0
        SubString(11)="-FT-P-TWISC0-MR0-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(12)="-FT-P-PIGC0-MR0-SM-TM001-Weertman-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";


        LegendEntry=[...
            "Reference    (2.3km, MR4, rCWm)",...
            "TWIS removed (2.3km, MR4, rCWm)",...
            "PIIS removed (2.3km, MR4, rCWm)",...
            "Reference    (2.3km, MR4, W)",...
            "TWIS removed (2.3km, MR4, W)",...
            "PIIS removed (2.3km, MR4, W)",...
            "Reference    (2.3km, MR0, rCWm)",...
            "TWIS removed (2.3km, MR0, rCWm)",...
            "PIIS removed (2.3km, MR0, rCWm)",...
            "Reference    (2.3km, MR0, W)",...
            "TWIS removed (2.3km, MR0, W)",...
            "PIIS removed (2.3km, MR0, W)",...
            ];

        TimeInterval=[0 400] ;  VAFStep=25;
        % TimeInterval=[0 100] ;  VAFStep=5;
        xyBoundary=nan;  % since this is always with respect to a reference run, I think that limiting the region is not needed

        % IRange=[1 2 4 5] ;

       IRange=[9 12] ; CreateVideo=true; CalculateVAF=false; VideoStep=25;  TimeInterval=[0 400] ;


    case "Compare with ref: mesh convergence"  % Mesh convergence for Cornford

        PlotCase=""  ;  

        ComparisionMatrix=[1 nan; 2 1 ; 3 1  ; 4 nan ; 5 4 ; 6 4 ; 7 nan ; 8 7]  ;

        IRange=ComparisionMatrix(:,1); IRange=IRange' ;

        IRange=[1  3  4  6  7  8]; 
        IRange=[4  7 ]; 
        IRange=[9]; 
       % IRange=[10]; 
       % IRange=[11]; 




        % MR4
        SubString(1)="-FT-P-TWIS-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(2)="-FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(3)="-FT-P-TWISC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";


        SubString(4)="FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(5)="FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(6)="FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";

        SubString(4)="FT-P-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(5)="FT-P-TWISC2-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(6)="FT-P-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";


        SubString(7)="-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";
        SubString(8)="-FT-P-TWISC0-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";

        SubString(9)="-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-2k5km-Alim-Clim-Ca1-Cs100000-Aa1-As100000-InvMR5.mat"; 
        SubString(10)="-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-5km-Alim-Clim-Ca1-Cs100000-Aa1-As100000-.mat"; 
        SubString(11)="-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Clim-Ca1-Cs100000-Aa1-As100000-.mat"; 


        LegendEntry=[...
            "2.3km: Thwaites ice shelf kept (Alim, Cornford, MR4)",...
            "2.3km: Thwaites ice shelf removed 2km downstream (Alim, Cornford, MR4)",...
            "2.3km: Thwaites ice shelf removed (Alim, Cornford, MR4)",...
            "4.6km: Thwaites ice shelf kept (Alim, Cornford, MR4)",...
            "4.6km: Thwaites ice shelf removed 2km downstream (Alim, Cornford, MR4)",...
            "4.6km: Thwaites ice shelf removed (Alim, Cornford, MR4)",...
            "9.3km: Thwaites ice shelf kept (Alim, Cornford, MR4)",...
            "9.3km: Thwaites ice shelf removed (Alim, Cornford, MR4)",...
            "1.16km: MR4",...
            "2.3km:  MR4",...
            "4.6km:  MR4",...
            ];


        TimeInterval=[0 inf] ;  VAFStep=5; VideoStep=5;  CreateVideo=true; CalculateVAF=false; 

        xyBoundary=nan;  % since this is always with respect to a reference run, I think that limiting the region is not needed




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




% xyBoundary=nan;

if CreateVideo
    Step=VideoStep;
    for I=IRange


        %        ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-h-") ;
        % ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-s-",AxisLimits=[-1700 -1050 -700 0]) ;
        % ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-B-") ;
        % ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-VAF-",VAFBoundary=xyBoundary) ;
        % ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ubvb-ds-",VAFBoundary=xyBoundary) ;
        ReadPlotSequenceOfResultFiles2(FileNameSubstring=SubString(I),PlotTimestep=Step,PlotType="-ds-VAF-",VAFBoundary=xyBoundary,PlotTimeInterval=TimeInterval) ;
    end
end

col=["r","b","g","m","c","y","k","r","b","g","m","c","y","k"]  ;

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
            PlotTimeInterval=TimeInterval,...
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
    % AreaOfTheOcean=3.625e14; % units m^2.

    ax=gca();
    ax.YAxis(2).Limits=ax.YAxis(1).Limits/362.5 ; % *1000*1e9/AreaOfTheOcean;  % Sea level rise is positive for loss (ie negative) VAF
    % Note!!!:  If zooming in, the zoom only is with respect to the left y-axis, after each zoom, the above statement must be
    % rerun in the command line to get the right y limits on the right y-axis


    lgVAF=legend(Interpreter="latex");
    yyaxis left
    fig.CurrentAxes.YAxis(1).Exponent=0;
    %%

    if PlotCase=="Compare"

        figCompare=FindOrCreateFigure("Compare"); clf(figCompare);
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
            % ylabel("Relative loss in VAF $(\mathrm{ km^3})$",Interpreter="latex")
            ylabel("VAF(no ice shelf)-VAF(ice shelf) $(\mathrm{ km^3})$",Interpreter="latex")
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
        ax.YAxis(2).Limits=ax.YAxis(1).Limits*1000*1e9/AreaOfTheOcean;
        % Note!!!:  If zooming in, the zoom only is with respect to the left y-axis, after each zoom, the above statement must be
        % rerun in the command line to get the right y limits on the right y-axis


        lgRel=legend(ax,Interpreter="latex");
        yyaxis left
        figCompare.CurrentAxes.YAxis(1).Exponent=0;
        yline(0) ; lgRel.String(end)=[];
    end
    %%

    if PlotCase=="Comparing ThickMin for 4.6km"

        figVAFdVAF=FindOrCreateFigure("VAF and dVAF"); clf(figVAFdVAF);

        for I=IRange



            In=~isnan(DataCollect{1}.time);
            timeRefVector=DataCollect{1}.time(In) ;
            VAFRefVector=DataCollect{1}.VAF(In) ;
            [~,ia]=unique(timeRefVector) ;
            timeRefVector=timeRefVector(ia);
            VAFRefVector=VAFRefVector(ia);

            In=~isnan(DataCollect{I}.time);
            timeVector=DataCollect{I}.time(In) ;
            VAFVector=DataCollect{I}.VAF(In) ;

            [~,ia]=unique(timeVector) ;
            timeVector=timeVector(ia);
            VAFVector=VAFVector(ia);

            VAFVectorAtTimeRef = interp1(timeVector,VAFVector,timeRefVector) ;



            yyaxis left
            % plot loss in VAF, that is plot VAF(t=t0)-VAF(t). So if VAF decreases, which causes an increase in sea level, plot \Delta
            % VAF as a positive quantity
            plot(timeRefVector,-(VAFVectorAtTimeRef-VAFVectorAtTimeRef(1))/1e9,'-o',color=col(I),DisplayName=LegendEntry(I),LineWidth=lw(I),Marker=M(I));
            hold on
            ylabel("Loss in VAF $(\mathrm{ km^3})$",Interpreter="latex")


            yyaxis right
            plot(timeRefVector,(VAFVectorAtTimeRef-VAFRefVector)/1e9,'-o',color=col(I),DisplayName=LegendEntry(I),LineWidth=lw(I),Marker=M(I),LineStyle='--');
            hold on

            ylabel("Change in VAF with respect to $h_{\mathrm{min}}=1\,\mathrm{m}\,(\mathrm{km}^3)$",Interpreter="latex")


        end

        xlabel("time (yr)",Interpreter="latex") ;
        lg=legend(Interpreter="latex");


        lg.String{1}="$h_{\mathrm{min}}=1\,\mathrm{m}$";  lg.String{2}="$h_{\mathrm{min}}=0.01\,\mathrm{m}$";  lg.String{3}="$h_{\mathrm{min}}=0.01\,\mathrm{m}$ and deactivation";
        lg.String(4:6)=[] ;
    end
    %%

end

% switch Experiment
% 
%     case "Compare Cornford and Weertman with respective ref"   % C and W for MR4 and Thwaites removal
% 
%         cd(FigureDirectory)   ; exportgraphics(figCompare,'VAFcomparisionTWISandPIGforMR0andMR4.pdf')
% 
%
%   lgRel.String{1}="Regularized Coulomb (rCWm)" ;  lgRel.String{2}="Weertman (W)" ;
%   cd(FigureDirectory)   ; exportgraphics(figCompare,'VAFcomparisionCornfordWeertmanforMR4.pdf')
%
% end

% f=gcf; exportgraphics(f,'ThwaitesIceShelf.pdf')

fprintf("Plots and videos were saved in the folder %s \n",pwd)

cd(WorkDir)