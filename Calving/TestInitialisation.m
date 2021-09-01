
%%
close all
clearvars
load TestSaveInitialisation.mat


%
 I=F1.LSF> 20e3 ; F1.LSF(I)=20e3; 
 I=F1.LSF<-20e3 ; F1.LSF(I)=10e3; 
%
CtrlVar.LevelSetReinitializePDist=true ;
[UserVar,RunInfo,LSF,Mask,l,LSFqx,LSFqy]=LevelSetEquationInitialisation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,l) ; 

AspectRatio=1000; 

figBefore=FindOrCreateFigure("LSF before initalisation") ;
PlotMeshScalarVariableAsSurface(CtrlVar,MUA,F1.LSF/CtrlVar.PlotXYscale,AspectRatio) ;

figAfter=FindOrCreateFigure("LSF after initalisation") ;
PlotMeshScalarVariableAsSurface(CtrlVar,MUA,LSF/CtrlVar.PlotXYscale,AspectRatio) ;


figDifference=FindOrCreateFigure("LSF difference initalisation") ;
PlotMeshScalarVariableAsSurface(CtrlVar,MUA,(LSF-F1.LSF)/CtrlVar.PlotXYscale,AspectRatio) ;