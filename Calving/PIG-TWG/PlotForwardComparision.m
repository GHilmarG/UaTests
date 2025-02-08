
%%

RunString{1}="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
RunString{2}="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";

RunString{1}="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
RunString{2}="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
Titles=["ES5km-uv-h-" ; "ES5km-uvh-" ] ;

RunString{1}="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2463 (no collapes)
RunString{2}="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 2338 (collapse)
Titles=["uvh-implicit, Element size 1.65km" ; "uvh-implicit, Element size 3.28km" ] ;

TitleText=extractBetween(RunString{1},"-Duvh-","-P-");


RunString{1}="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % year 2459  (no collapse)
RunString{2}="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % year 2459 (collapse)
Titles=["uvh-implicit, Element size 1.65km" ; "uvh-implicit, Element size 3.28km" ] ;

RunString{2}="ES2.5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % 
Titles=["uvh-implicit, Element size 1.65km" ; "uvh-implicit, Element size 0.82 km" ] ;


RunString{1}="ES20km-uvh-DV1-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-" ; 
RunString{2}="ES20km-uvh-DV1-TH1-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-" ; 
Titles=["uvh-implicit, dev, 9.3km" ; "uvh-implicit, dev, theta=1, 9.3 km" ] ;

RunString{2}="ES20km-uvh-DV0-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-" ; 
Titles=["uvh-implicit, dev, 9.3km" ; "uvh-implicit, ~dev, 9.3 km" ] ;

%                       -side of a perfect square of equal area-
% 30km = 14km                        9.806 km

% 20km = 9.3km                       6.559 km
% 10km = 4.6km                       3.28  km
%  5km = 2.3km                       1.64  km
% 2.5km = 1.16km                     0.821 km

CtrlVar=Ua2D_DefaultParameters();

UserVar.RunType=RunString{1} ;

UserVar=FileDirectories(UserVar) ;
UserVar.GeometryInterpolant="create the name of inverse restart file from User.RunType";
UserVar.InverseRestartFile="create the name of inverse restart file from User.RunType";

[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ;

SearchString=cell(2,1) ;
ResultFiles=strings(2,1000) ; % 1000 might be OK
dirOutput=cell(2,1);

dT=25; time=2020-dT; timeMax=2500; iTime=0; iFile=0;

dT=5; time=2020-dT; timeMax=2040; iTime=0; iFile=0;

while time <= timeMax

    iTime=iTime+1;
    time=time+dT;
    TimeString=sprintf("%07i",100*time);

    for iRuns=1:2

        SearchString{iRuns}=replaceBetween(RunString{iRuns},"-FR","-","*");
        SearchString{iRuns}=replace(SearchString{iRuns},"2.5","2k5");
        SearchString{iRuns}=replace(SearchString{iRuns},"ES","");  % for some reason the output files were named with ES missing

        % SearchString="*"+SearchString;
        % SearchString=replace(SearchString,"**","*") ;

        % SearchString{iRuns}="000-FR*"+"-"+SearchString{iRuns};

        SS=TimeString+"-FR*-"+SearchString{iRuns}+".mat" ; 

        dirOutput{iRuns}=dir(UserVar.ResultsFileDirectory+SS);
    end

    if ~isempty(dirOutput{1}) && ~isempty(dirOutput{2})

        fprintf("Found outputs files for time %s \n",TimeString)

        iFile=iFile+1;
        ResultFiles(1,iFile)=dirOutput{1}.name ;
        ResultFiles(2,iFile)=dirOutput{2}.name ;

        % ResultFiles(iRuns,iTime)=dir(UserVar.ResultsFileDirectory+"*"+SearchString{iRuns}+".mat");

    end

end

nFile=iFile; 

fprintf("Number of files pairs found is %i \n",iFile)

if iFile==0

    fprintf("No output files found. \n ")
    return

end


%%
hVector=nan(10,100) ;
uVector=nan(10,100);
vVector=nan(10,100);
tVector=nan(10,100) ;
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

VideoVel=VideoWriter(UserVar.VideoFileDirectory+UserVar.RunType+"Velocities.avi"); open(VideoVel)






for iFile=1:nFile

    
      

     % Was in the process of making sure the files are actually from same time, need to rethink my approach, and start again
     % possibly best just to create a search string anew

    %% Reading in files from those two runs
    for iRuns=1:2

        

        FhPrevious{iRuns}=Fh{iRuns}; timePrevious=F{iRuns}.time;
        FuPrevious{iRuns}=Fu{iRuns};
        FvPrevious{iRuns}=Fv{iRuns};

        fprintf("%s \n ",ResultFiles(iRuns,iFile)); 

        Vars=load(UserVar.ResultsFileDirectory+ResultFiles(iRuns,iFile)); 
        % Vars=load(ResultFiles{iRuns}(ifile).folder+"\"+ResultFiles{iRuns}(ifile).name) ; % ,"CtrlVar","MUA","F")

        F{iRuns}=Vars.F;
        MUA{iRuns}=Vars.MUA;
        CtrlVar{iRuns}=Vars.CtrlVar;

   
        MeltParameterisation=extractBetween(UserVar.RunType,"Duvh-","-P");


        Fh{iRuns}=scatteredInterpolant(F{iRuns}.x,F{iRuns}.y,F{iRuns}.h)  ;
        Fu{iRuns}=scatteredInterpolant(F{iRuns}.x,F{iRuns}.y,F{iRuns}.ub)  ;
        Fv{iRuns}=scatteredInterpolant(F{iRuns}.x,F{iRuns}.y,F{iRuns}.vb)  ;


    end

    fprintf("File 1 at time %f \n",F{1}.time)
    fprintf("File 2 at time %f \n",F{2}.time)

    Tile=tiledlayout(1,3) ;

    nexttile
    speed=sqrt(F{1}.ub.*F{1}.ub+F{1}.vb.*F{1}.vb);
    MaxSpeedPlot=ceil(max(speed/1000))*1000 ;
    MaxSpeedPlot=5000;
    CtrlVar{1}.QuiverColorSpeedLimits=[0 MaxSpeedPlot] ;
    UaPlots(CtrlVar{1},MUA{1},F{1},[F{1}.ub F{1}.vb],CreateNewFigure=false)
    
    [Emin,Emax,Emean,Emedian]=PrintInfoAboutElementsSizes(CtrlVar{1},MUA{1},LengthMeasure="-side of a perfect square of equal area-",print=false);
    Ti=title(Titles(1)); Ti.Color="blue"; Ti.FontSize=14;
    nexttile

    % speed=sqrt(F{2}.ub.*F{2}.ub+F{2}.vb.*F{2}.vb);
    % MaxSpeedPlot=ceil(max(speed/1000))*1000 ;
    CtrlVar{2}.QuiverColorSpeedLimits=[0 MaxSpeedPlot] ;
    UaPlots(CtrlVar{2},MUA{2},F{2},[F{2}.ub F{2}.vb],CreateNewFigure=false)
    Ti=title(Titles(2)); Ti.Color="blue"; Ti.FontSize=14;
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
   

    Ti=title("$\Delta \mathbf{v}$",Interpreter="latex"); Ti.Color="blue"; Ti.FontSize=14;

    CurrFig=gcf; CurrFig.Position=[100 500 2300 800];

    
    Tile.Title.String=sprintf("time=%-7.1f (yr)      %s",F{1}.time,TitleText);
    Tile.Title.FontSize=16; Tile.Title.Color="blue";
    % Tile.Subtitle.String=sprintf("time=%f3.1 Element size=%g",F{1}.time,Emedian);

    frame=getframe(gcf) ;  writeVideo(VideoVel,frame);


end


% close(VideoDhDt)
close(VideoVel)

%%