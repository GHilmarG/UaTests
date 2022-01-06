%%
load TestSave

%%
CtrlVar.LineUpGLs=false ; Threshold=0 ;

[xc,yc]=CalcMuaFieldsContourLine(CtrlVar,MUA,F0.LSF,Threshold);


Dist=pdist2([xc(:) yc(:)],[MUA.xEle MUA.yEle],'euclidean','Smallest',1) ;
Dist=Dist(:) ;

StripWidth=100e3 ; 
ElementsToBeDeactivated=Dist>StripWidth;

[MUAnew,K]=DeactivateMUAelements(CtrlVar,MUA,ElementsToBeDeactivated)  ;
F0new.LSF=F0.LSF(K) ; 

FindOrCreateFigure("MUA before")  ; PlotMuaMesh(CtrlVar,MUA) ; 
FindOrCreateFigure("LSF before")  ; PlotMeshScalarVariable(CtrlVar,MUA,F0.LSF) ;
PlotCalvingFronts(CtrlVar,MUA,F0.LSF,'r')

FindOrCreateFigure("MUA after")  ; PlotMuaMesh(CtrlVar,MUAnew) ; 
FindOrCreateFigure("LSF after")  ; PlotMeshScalarVariable(CtrlVar,MUAnew,F0new.LSF) ;
hold on ; 
PlotCalvingFronts(CtrlVar,MUAnew,F0new.LSF,'r')
