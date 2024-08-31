
%%

RunString{1}="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
RunString{2}="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";

RunString{1}="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
RunString{2}="ES5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";

TitleText=extractBetween(RunString{1},"-Duvh-","-P-");



CtrlVar=Ua2D_DefaultParameters();

UserVar.RunType=RunString{1} ;

UserVar=FileDirectories(UserVar) ;
UserVar.GeometryInterpolant="create the name of inverse restart file from User.RunType";
UserVar.InverseRestartFile="create the name of inverse restart file from User.RunType";

[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ;

SearchString=cell(2,1) ;
ResultFiles=cell(2,1);

for iRuns=1:2

    SearchString{iRuns}=replaceBetween(RunString{iRuns},"-FR","-","*");
    SearchString{iRuns}=replace(SearchString{iRuns},"2.5","2k5");
    SearchString{iRuns}=replace(SearchString{iRuns},"ES","");  % for some reason the output files were named with ES missing

    % SearchString="*"+SearchString;
    % SearchString=replace(SearchString,"**","*") ;

    ResultFiles{iRuns}=dir(UserVar.ResultsFileDirectory+"*"+SearchString{iRuns}+".mat");

end

if isempty(ResultFiles{1})

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


nFiles=min(numel(ResultFiles{1}),numel(ResultFiles{2}));


for ifile=1:nFiles

    %% Reading in files from those two runs
    for iRuns=1:2

        FhPrevious{iRuns}=Fh{iRuns}; timePrevious=F{iRuns}.time;
        FuPrevious{iRuns}=Fu{iRuns};
        FvPrevious{iRuns}=Fv{iRuns};

        fprintf("%s \n ",ResultFiles{iRuns}(ifile).name)
        Vars=load(ResultFiles{iRuns}(ifile).folder+"\"+ResultFiles{iRuns}(ifile).name) ; % ,"CtrlVar","MUA","F")

        F{iRuns}=Vars.F;
        MUA{iRuns}=Vars.MUA;
        CtrlVar{iRuns}=Vars.CtrlVar;

        [Emin,Emax,Emean,Emedian]=PrintInfoAboutElementsSizes(CtrlVar{iRuns},MUA{iRuns},LengthMeasure="-side of a perfect square of equal area-",print=false);
        MeltParameterisation=extractBetween(UserVar.RunType,"Duvh-","-P");


        Fh{iRuns}=scatteredInterpolant(F{iRuns}.x,F{iRuns}.y,F{iRuns}.h)  ;
        Fu{iRuns}=scatteredInterpolant(F{iRuns}.x,F{iRuns}.y,F{iRuns}.ub)  ;
        Fv{iRuns}=scatteredInterpolant(F{iRuns}.x,F{iRuns}.y,F{iRuns}.vb)  ;

    end


    Tile=tiledlayout(1,3) ;

    nexttile
    speed=sqrt(F{1}.ub.*F{1}.ub+F{1}.vb.*F{1}.vb);
    MaxSpeedPlot=ceil(max(speed/1000))*1000 ;
    CtrlVar{1}.QuiverColorSpeedLimits=[0 MaxSpeedPlot] ;
    UaPlots(CtrlVar{1},MUA{1},F{1},[F{1}.ub F{1}.vb],CreateNewFigure=false)
    Ti=title("Semi-implicit uv-h solve "); Ti.Color="blue"; Ti.FontSize=14;
    nexttile

    speed=sqrt(F{2}.ub.*F{2}.ub+F{2}.vb.*F{2}.vb);
    MaxSpeedPlot=ceil(max(speed/1000))*1000 ;
    CtrlVar{2}.QuiverColorSpeedLimits=[0 MaxSpeedPlot] ;
    UaPlots(CtrlVar{2},MUA{2},F{2},[F{2}.ub F{2}.vb],CreateNewFigure=false)
    Ti=title("Implicit uvh solve"); Ti.Color="blue"; Ti.FontSize=14;
    nexttile

    dub=F{2}.ub-F{1}.ub ; dvb=F{1}.vb-F{2}.vb;
    speed=sqrt(dub.*dub+dvb.*dvb) ;
    MaxSpeedPlot=ceil(max(speed/1000))*1000 ;
    MaxSpeedPlot=500;
    CtrlVar{2}.QuiverColorSpeedLimits=[0 MaxSpeedPlot] ;
    UaPlots(CtrlVar{2},MUA{2},F{2},[F{2}.ub-F{1}.ub F{1}.vb-F{2}.vb],CreateNewFigure=false)
    Ti=title("$\Delta \mathbf{v}$",Interpreter="latex"); Ti.Color="blue"; Ti.FontSize=14;

    CurrFig=gcf; CurrFig.Position=[100 500 2300 800];

    
    Tile.Title.String=sprintf("time=%-7.1f (yr)       Element size=%-6.0f (m)    %s",F{1}.time,Emedian,TitleText);
    Tile.Title.FontSize=16; Tile.Title.Color="blue";
    % Tile.Subtitle.String=sprintf("time=%f3.1 Element size=%g",F{1}.time,Emedian);

    frame=getframe(gcf) ;  writeVideo(VideoVel,frame);


end


% close(VideoDhDt)
close(VideoVel)

%%