

%%

function PostProcessingPlots

persistent hLast tLast h0

ResultsFileDirectory=".\forward_run\" ;
Curdir=pwd;

cd(ResultsFileDirectory)

ResFiles=dir("*.mat") ;


nstrive=1 ;

for I=1:nstrive:numel(ResFiles)

    load(ResFiles(I).name,"CtrlVar","F","MUA")

    cbar=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="-uv-",CreateNewFigure=true);
    title(sprintf("Velocities at t=%4.1f",F.time),Interpreter="latex")
    title(cbar,"(m/a)",Interpreter="latex")

    cbar=UaPlots(CtrlVar,MUA,F,F.h,FigureTitle="-h-",CreateNewFigure=true);
    title(sprintf("Ice thicknesses at t=%4.1f",F.time),Interpreter="latex")
    title(cbar,"(m)",Interpreter="latex")


    if isempty(h0)
        h0=F.h;
    end

    cbar=UaPlots(CtrlVar,MUA,F,F.h-h0,FigureTitle="-h-h0-",CreateNewFigure=true);
    title(sprintf("$\\Delta h=h(t=%g)-h(t=0)$",F.time),Interpreter="latex")
    title(cbar,"(m)",Interpreter="latex")



    if ~isempty(hLast)
        dhdt=(hLast-F.h)/(F.time-tLast) ;
        cbar=UaPlots(CtrlVar,MUA,F,dhdt,FigureTitle="-dh/dt-",CreateNewFigure=true);
        title(sprintf("dh/dt at t=%4.1f",F.time),Interpreter="latex")
        title(cbar,"(m/a)",Interpreter="latex");
        cbar.Limits=[min(cbar.Limits(1),-10) max(cbar.Limits(2),10)];
    end

    drawnow
    pause(0.1)

    hLast=F.h ; tLast=F.time;

end


cd(Curdir)

end

%%
