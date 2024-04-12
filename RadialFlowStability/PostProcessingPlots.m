

%%
ResultsFileDirectory=".\ResultsFiles\" ;

ResultsFile(1)="0000000-MR150-AM0-.mat";
ResultsFile(2)="0000000-MR500-AM0-.mat";

for I=1:2
    load(ResultsFileDirectory+ResultsFile(I))
    UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle=ResultsFile(I))
    subtitle(ResultsFile(I),Interpreter="latex")
end


%%  Original approach by Lielle

Curdir=pwd;

ResultsFileDirectory="C:\Users\pcnj6\OneDrive - Northumbria University - Production Azure AD\Work\Ua\nn_hilmar\res";
cd(ResultsFileDirectory)
Ffiles=dir("F*.mat"); 
MUAfiles=dir("MUA*.mat") ;
CtrlVar=Ua2D_DefaultParameters();

for I=1:numel(Ffiles)

    I
    load(Ffiles(I).name,"F")
    load(MUAfiles(I).name,"MUA")

    CtrlVar.time=F.time;
    UaPlots(CtrlVar,MUA,F,"-uv-")
end

%%

%%   sequence of files

Curdir=pwd;


ResultsFileDirectory="C:\cygwin64\home\pcnj6\Ua\UaTests\RadialFlowStability\ResultsFiles";
cd(ResultsFileDirectory)

ResFiles=dir("*-MR250-AM0-RG0k015-n1-.mat") ;
ResFiles=dir("*-MR250-AM0-RG0k015-n6-.mat") ;

nstrive=1 ;

for I=1:nstrive:numel(ResFiles)

    load(ResFiles(I).name,"CtrlVar","F","MUA")

    UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="-uv-",CreateNewFigure=true)

    UaPlots(CtrlVar,MUA,F,F.h,FigureTitle="-h-",CreateNewFigure=true)

    speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
    r=sqrt(F.x.*F.x+F.y.*F.y) ; 
    [rSort,ir]=sort(r) ;

    FindOrCreateFigure(" h(r) ")
    plot(rSort,F.h(ir),".r")
    xlabel("r",Interpreter="latex")
    ylabel("h",Interpreter="latex")
    title(sprintf("$t$=%g",F.time),Interpreter="latex")

    FindOrCreateFigure(" h speed r ")
    % Check mass conservatio by plottingL h*speed*r
    hvr=F.h.*speed.*r ; 

    plot(rSort,hvr(ir),".r")
    xlabel("r",Interpreter="latex")
    ylabel("hvr",Interpreter="latex")
    title(sprintf("$t$=%g",F.time),Interpreter="latex")

    drawnow
    pause(0.1)

end




%%
