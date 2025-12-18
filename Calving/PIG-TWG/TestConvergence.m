
%%
clearvars

load DumpWTSHTD.mat

%%
FindOrCreateFigure("F0 (u,v)") ; QuiverColorGHG(F0.x,F0.y,F0.ub,F0.vb,CtrlVar) ;
hold on ; PlotMuaBoundary(CtrlVar,MUA) ;
PlotGroundingLines(CtrlVar,MUA,F0.GF);
PlotCalvingFronts(CtrlVar,MUA,F0) ; 

FindOrCreateFigure("F1 (u,v) ") ; QuiverColorGHG(F1.x,F1.y,F1.ub,F1.vb,CtrlVar) ;
hold on ; PlotMuaBoundary(CtrlVar,MUA) ;
PlotGroundingLines(CtrlVar,MUA,F1.GF);
PlotCalvingFronts(CtrlVar,MUA,F1) ; 

FindOrCreateFigure("F1 d(u,v)/dt ") ; QuiverColorGHG(F1.x,F1.y,F1.dubdt,F1.dvbdt,CtrlVar) ;
hold on ; PlotMuaBoundary(CtrlVar,MUA) ;
PlotGroundingLines(CtrlVar,MUA,F1.GF);
PlotCalvingFronts(CtrlVar,MUA,F1) ;

FindOrCreateFigure("F0 d(u,v)/dt ") ; QuiverColorGHG(F0.x,F0.y,F0.dubdt,F0.dvbdt,CtrlVar) ;
hold on ; PlotMuaBoundary(CtrlVar,MUA) ;
PlotGroundingLines(CtrlVar,MUA,F0.GF);
PlotCalvingFronts(CtrlVar,MUA,F0) ;

FindOrCreateFigure("F0 dh/dt ") ;
PlotMeshScalarVariable(CtrlVar,MUA,F0.dhdt) ;
hold on ; PlotMuaBoundary(CtrlVar,MUA) ;
PlotGroundingLines(CtrlVar,MUA,F0.GF);
PlotCalvingFronts(CtrlVar,MUA,F0) ;

FindOrCreateFigure("F1 dh/dt ") ;
PlotMeshScalarVariable(CtrlVar,MUA,F1.dhdt) ;
hold on ; PlotMuaBoundary(CtrlVar,MUA) ;
PlotGroundingLines(CtrlVar,MUA,F1.GF);
PlotCalvingFronts(CtrlVar,MUA,F1) 

%F=F0;
% [UserVar,RunInfo,F,l,BCs,dt]=uvh(UserVar,RunInfo,CtrlVar,MUA,F0,F,l,l,BCs);