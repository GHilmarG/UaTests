
%%
%
% Creates plots with four velocity panels, comparing two runs, all shown side by side at same times.
%
%%


RunType="Weertman-MRIM6HadGEM2-abMask0A-P-BCVel";
% RunType="Weertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel";
% RunType="Weertman-Duvh-MRZERO-P-BCVel";

RunType="Reversibility-MRlASE3" ; 

ES=["0.82 km","1.64 km","3.28","6.56 km","9.80 km"] ; 

iCompare=[1 ; 2] ;
dT=100 ; % 
%dT=2 ;
Titles=[]; 
switch RunType

    case "Reversibility-MRlASE3"

        RunString(1)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";    
        RunString(2)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-Rgl50-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";    

       Titles=["3.25km"; "3.35km/Rgl50"];


    case "Weertman-MRIM6HadGEM2-abMask0A-P-BCVel"

        RunString(1)="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2203
        RunString(2)="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2203
        RunString(3)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2203
        RunString(4)="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2203
        RunString(5)="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % 2203


    case "Weertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel"

        RunString(1)="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %
        RunString(2)="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %
        RunString(3)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %
        RunString(4)="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %
        RunString(5)="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %

    case "Weertman-Duvh-MRZERO-P-BCVel"


        RunString(1)="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-" ; % 2500
        RunString(2)="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"   ; % 2500#
        RunString(3)="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"   ; % 2500
        RunString(4)="ES20km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"   ; % 2500
        RunString(5)="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"   ; % 2500

    otherwise

        error(" case not found")

end

ES1=str2double(extractBetween(RunString(1),"ES","km"));
ES2=str2double(extractBetween(RunString(2),"ES","km"));

ES1=ElementSizeCorrection(ES1);
ES2=ElementSizeCorrection(ES2);

if isempty(Titles)  % create default figure titles of not already specified
    Titles=["Element size "+ES1+"km"; "Element size "+ES2+"km"];
end

TitleText="("+extractBetween(RunString(iCompare(1)),"-Duvh-","-P-")+")";



%                       -side of a perfect square of equal area-
% 30km = 14km                        9.806 km
% 20km = 9.3km                       6.559 km
% 10km = 4.6km                       3.28  km
%  5km = 2.3km                       1.64  km
% 2.5km = 1.16km                     0.821 km

CtrlVar=Ua2D_DefaultParameters();

UserVar.RunType=RunString(iCompare(1)) ;

UserVar=FileDirectories(UserVar) ;
UserVar.GeometryInterpolant="create the name of inverse restart file from User.RunType";
UserVar.InverseRestartFile="create the name of inverse restart file from User.RunType";

[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ;

SearchString=strings(5,1) ;
ResultFiles=strings(2,1000) ; % 1000 might be OK
dirOutput=cell(2,1);



time=2020; timeMax=2500; iTime=0; iFile=0;

SLR1mm=nan;
SLR2mm=nan;


while time <= timeMax

    %iTime=iTime+1;
   
    TimeString=sprintf("%07i",100*time);

    for iRuns=1:2

        SearchString(iCompare(iRuns))=replaceBetween(RunString(iCompare(iRuns)),"-FR","-","*");
        SearchString(iCompare(iRuns))=replace(SearchString(iCompare(iRuns)),"2.5","2k5");
        SearchString(iCompare(iRuns))=replace(SearchString(iCompare(iRuns)),"ES","");  % for some reason the output files were named with ES missing

        % SearchString="*"+SearchString;
        % SearchString=replace(SearchString,"**","*") ;

        % SearchString{iRuns}="000-FR*"+"-"+SearchString{iRuns};
        fprintf("Searching for files from year %i \n",time)
        SS=TimeString+"-FR*-"+SearchString(iCompare(iRuns))+".mat" ; 

        dirOutput{iRuns}=dir(UserVar.ResultsFileDirectory+SS); % this works, but the problem is that this becomes slow if there is a large number of files in the directory 
    end

    if ~isempty(dirOutput{1}) && ~isempty(dirOutput{2})

        fprintf("Found outputs files for time %s \n",TimeString)

        iFile=iFile+1;
        ResultFiles(1,iFile)=dirOutput{1}.name ;
        ResultFiles(2,iFile)=dirOutput{2}.name ;



    end
     
    time=time+dT;

end

time=time-dT ; 

nFile=iFile; 

fprintf("Number of files pairs found is %i \n",iFile)

if iFile==0

    fprintf("No output files found. \n ")
    return

end


%%

%hVector=nan(10,100) ;
%uVector=nan(10,100);
%vVector=nan(10,100);

tVector=nan(1000,2) ;
VAFvector=nan(1000,2);
AreaVector=nan(1000,2);
TextVector=strings(10,1) ;
Location(1,:)=[-1585e3 -240e3 ]  ; TextVector(1)="PIG 20km upstream of GL" ;
Location(2,:)=[-1595e3 -271e3 ]  ; TextVector(2)="PIG about 20km downstream of GL" ;

nloc=size(Location,1) ;

Fh=cell(2,1) ;
Fu=cell(2,1) ;
Fv=cell(2,1);


F{1}=UaFields ;
F{2}=UaFields ;
MUA=cell(2,1) ;
CtrlVar=cell(2,1) ;
FhPrevious=cell(2,1);
FuPrevious=cell(2,1);
FvPrevious=cell(2,1);

tMax=inf;
CreateReferenceFile=true;

% VideoDhDt=VideoWriter(UserVar.VideoFileDirectory+UserVar.RunType+"DhDt.avi"); open(VideoDhDt)

VideoVel=VideoWriter(UserVar.VideoFileDirectory+UserVar.RunType+"Velocities.mp4","MPEG-4");
VideoVel.FrameRate=5;
open(VideoVel)
%VideoVel.FrameRate=5;





for iFile=1:nFile

    
      

  
    %% Reading in files from those two runs
    CouldLoadData=true;
    
    for iRuns=1:2

        

        FhPrevious{iRuns}=Fh{iRuns}; timePrevious=F{iRuns}.time;
        FuPrevious{iRuns}=Fu{iRuns};
        FvPrevious{iRuns}=Fv{iRuns};

        fprintf("%s \n ",ResultFiles(iRuns,iFile)); 

        FileName=UserVar.ResultsFileDirectory+ResultFiles(iRuns,iFile);

        try
            Vars=load(FileName);
        catch
            fprintf("could not load %s \n",FileName)
            CouldLoadData=false;
            break
        end
        % Vars=load(ResultFiles{iRuns}(ifile).folder+"\"+ResultFiles{iRuns}(ifile).name) ; % ,"CtrlVar","MUA","F")

        
        [VAF,IceVolume,GroundedArea]=CalcVAF(Vars.CtrlVar,Vars.MUA,Vars.F.h,Vars.F.B,Vars.F.S,Vars.F.rho,Vars.F.rhow,Vars.F.GF);
        tVector(iFile,iRuns)=Vars.F.time;
        VAFvector(iFile,iRuns)=VAF.Total;
        AreaVector(iFile,iRuns)=GroundedArea.Total ; 


        F{iRuns}=Vars.F;
        MUA{iRuns}=Vars.MUA;
        CtrlVar{iRuns}=Vars.CtrlVar;


        MeltParameterisation=extractBetween(UserVar.RunType,"Duvh-","-P");


        Fh{iRuns}=scatteredInterpolant(F{iRuns}.x,F{iRuns}.y,F{iRuns}.h)  ;
        Fu{iRuns}=scatteredInterpolant(F{iRuns}.x,F{iRuns}.y,F{iRuns}.ub)  ;
        Fv{iRuns}=scatteredInterpolant(F{iRuns}.x,F{iRuns}.y,F{iRuns}.vb)  ;


    end

    if ~CouldLoadData
        continue
    end

    fprintf("File 1 at time %f \n",F{1}.time)
    fprintf("File 2 at time %f \n",F{2}.time)

   

    Tile=tiledlayout(2,2) ;

    nexttile
    speed=sqrt(F{1}.ub.*F{1}.ub+F{1}.vb.*F{1}.vb);
    MaxSpeedPlot=ceil(max(speed/1000))*1000 ;
    MaxSpeedPlot=5000;
    CtrlVar{1}.QuiverColorSpeedLimits=[0 MaxSpeedPlot] ;
    UaPlots(CtrlVar{1},MUA{1},F{1},[F{1}.ub F{1}.vb],CreateNewFigure=false)
    
    [Emin,Emax,Emean,Emedian]=PrintInfoAboutElementsSizes(CtrlVar{1},MUA{1},LengthMeasure="-side of a perfect square of equal area-",print=false);
    Ti=title(Titles(1)); Ti.Color="blue"; Ti.FontSize=16;
    subtitle("")
    PlotLatLonGrid(); axis off ; ScaleBar
    nexttile

    % speed=sqrt(F{2}.ub.*F{2}.ub+F{2}.vb.*F{2}.vb);
    % MaxSpeedPlot=ceil(max(speed/1000))*1000 ;
    CtrlVar{2}.QuiverColorSpeedLimits=[0 MaxSpeedPlot] ;
    UaPlots(CtrlVar{2},MUA{2},F{2},[F{2}.ub F{2}.vb],CreateNewFigure=false)
    Ti=title(Titles(2)); Ti.Color="blue"; Ti.FontSize=16;
    subtitle("")
    PlotLatLonGrid(); axis off ; ScaleBar
    nexttile


    if MUA{1}.Nnodes ~= MUA{2}.Nnodes

       F{2}.ub=Fu{2}(F{1}.x,F{1}.y);
       F{2}.vb=Fv{2}(F{1}.x,F{1}.y);
       F{2}.h=Fh{2}(F{1}.x,F{1}.y);

    end

    dub=F{2}.ub-F{1}.ub ; dvb=F{1}.vb-F{2}.vb;
    speed=sqrt(dub.*dub+dvb.*dvb) ;
    MaxSpeedPlot=ceil(max(speed/1000))*1000 ;
    MaxSpeedPlot=5000;

    CtrlVar{1}.QuiverSameVelocityScalingsAsBefore=false ; 
    CtrlVar{1}.QuiverColorSpeedLimits=[0 MaxSpeedPlot] ;
    CtrlVar{1}.MaxPlottedSpeed=[];
    CtrlVar{1}.MinPlottedSpeed=[];
    
    UaPlots(CtrlVar{1},MUA{1},F{1},[F{2}.ub-F{1}.ub F{1}.vb-F{2}.vb],CreateNewFigure=false)
    hold on 
    PlotGroundingLines(CtrlVar{2},MUA{2},F{2}.GF.node,[],[],[],"r-");
   

    Ti=title("$\Delta \mathbf{v}$",Interpreter="latex"); Ti.Color="blue"; Ti.FontSize=16;
    subtitle("")
    PlotLatLonGrid(); axis off ; ScaleBar

    nexttile

    %%

  

    SLR1mm=-(VAFvector(:,1)-VAFvector(1,1))/362.5e9;
    SLR2mm=-(VAFvector(:,2)-VAFvector(1,2))/362.5e9;

    RateOfSeaLevelRise1=SLR1mm*0+nan;
    RateOfSeaLevelRise2=SLR2mm*0+nan;

    RateOfSeaLevelRise1(2:end)=(SLR1mm(2:end)-SLR1mm(1:end-1))./(tVector(2:end,1)-tVector(1:end-1,1));
    RateOfSeaLevelRise2(2:end)=(SLR2mm(2:end)-SLR2mm(1:end-1))./(tVector(2:end,1)-tVector(1:end-1,1));


    yyaxis left
    plot(tVector(:,1),SLR1mm/10,"-ob",LineWidth=2,DisplayName=Titles(1))
    hold on
    plot(tVector(:,2),SLR2mm/10,"-xb",LineWidt=1,DisplayName=Titles(2))
    yMax=max(ceil(max([SLR1mm;SLR2mm])/10/10)*10,10) ; % first /10 is to get cm instead of mm
    ylim([0 yMax])
    ylabel(" Sea Level Rise (cm)",FontSize=14) ;
    yyaxis right

    AreadOfGreatBritain=209331; % sq km
    dArea1=(AreaVector(:,1)-AreaVector(1,1))/1e6/AreadOfGreatBritain;
    dArea2=(AreaVector(:,2)-AreaVector(1,1))/1e6/AreadOfGreatBritain;

    

    plot(tVector(:,1),RateOfSeaLevelRise1,"-or",LineWidth=2,DisplayName=Titles(1))
    hold on
    plot(tVector(:,2),RateOfSeaLevelRise2,"-xr",LineWidth=1,DisplayName=Titles(2))
    yMax=max(ceil(max([RateOfSeaLevelRise1;RateOfSeaLevelRise2])),1) ; 
    ylim([0 yMax])
    % yMin=min(floor(min([dArea1;dArea2])*10)/10,-0.1); ylim([yMin 0])
    
    ylabel("Rate of Sea Level Rise (mm/yr) ",FontSize=14) ;



    xlabel("time (yr)")

    lg=legend(Location="west");
    lg.NumColumns=2;
    title(lg,"Resolution")
    lg.FontSize=14;
    lg.BackgroundAlpha=0.75;
    %%

    CurrFig=gcf; CurrFig.Position=[100 50 1400 1300];

    
    Tile.Title.String=sprintf("time=%-7.1f (yr)      %s",F{1}.time,TitleText);
    Tile.Title.FontSize=20; Tile.Title.Color="blue";
    Tile.TileSpacing="tight"; 
    Tile.Padding="compact" ; 
    % Tile.Subtitle.String=sprintf("time=%f3.1 Element size=%g",F{1}.time,Emedian);
     set(gcf,'Color','white')
    frame=getframe(gcf) ;  writeVideo(VideoVel,frame);


end


% close(VideoDhDt)
close(VideoVel)
fprintf("Vido saved in directory %s \n",VideoVel.Path)
fprintf("Vido file %s \n",VideoVel.Filename)
%%