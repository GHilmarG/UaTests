%%
clearvars
load TestSave

[LSF,UserVar,RunInfo]=ReinitializeLevelSet(UserVar,RunInfo,CtrlVar,MUA,LSF)  ;
F1.LSF=LSF ;


figMesh=FindOrCreateFigure("Mesh and LSF");
if ~isempty(figMesh.CurrentAxes)
    KeepAxes=true;
    xL=figMesh.CurrentAxes.XLim ; yL=figMesh.CurrentAxes.YLim ;
else
    KeepAxes=false;
end
clf(figMesh) ;

PlotMuaMesh(CtrlVar,MUA); hold on
[xGL,yGL]=PlotGroundingLines(CtrlVar,MUA,F1.GF,[],[],[],'r','LineWidth',2);
if ~isempty(xGL)
    Temp=figMesh.CurrentAxes.Title.String;
    figMesh.CurrentAxes.Title.String={Temp,"Grounding line in red"};
end
if ~isempty(F1.LSF) && CtrlVar.LevelSetMethod
    hold on ; [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F1,'b','LineWidth',2) ;
    Temp=figMesh.CurrentAxes.Title.String;
    figMesh.CurrentAxes.Title.String={Temp,"Calving front in blue"};
end
Par.RelativeVelArrowSize=10 ;
QuiverColorGHG(MUA.coordinates(:,1)/1000,MUA.coordinates(:,2)/1000,F1.ub,F1.vb,Par) ;
if KeepAxes
    xlim(xL) ; ylim(yL) ;
end


