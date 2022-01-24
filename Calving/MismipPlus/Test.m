
%%
clearvars
load TestSave

fprintf("\n\n------------------------------------------------------------------------------------------------------------------------------------------------------ \n")

CtrlVar.LSF.PG=1;
CtrlVar.LevelSetTheta=0.5 ;   [UserVar,RunInfo,LSF,l,LSFqx,LSFqy]=LevelSetEquationNewtonRaphson(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,[]);   

% CtrlVar.LevelSetTheta=0.9 ;   [UserVar,RunInfo,LSF,l,LSFqx,LSFqy]=LevelSetEquationNewtonRaphson(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,[]);   



%% 
% testing projections onto the calving from 

load TestSaveDefineCalving.mat



I=F.LSF< 0 ; 
CliffHeightTest=CliffHeight; 
CliffHeightTest(I)=NaN;


FindOrCreateFigure("CliffHeight")     ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeight) ;
FindOrCreateFigure("CliffHeightTest") ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeightTest) ;

GFLSF.node=sign(F.LSF) ;  [GFLSF,GLgeo,GLnodes,GLele]=IceSheetIceShelves(CtrlVar,MUA,GFLSF);

x=MUA.coordinates(:,1) ; y=MUA.coordinates(:,2) ;
figure
 
hold on
plot(x(GFLSF.NodesDownstreamOfGroundingLines)/CtrlVar.PlotXYscale,y(GFLSF.NodesDownstreamOfGroundingLines)/CtrlVar.PlotXYscale,'.b')
hold on
plot(x(GFLSF.NodesUpstreamOfGroundingLines)/CtrlVar.PlotXYscale,y(GFLSF.NodesUpstreamOfGroundingLines)/CtrlVar.PlotXYscale,'.k')
plot(x(GFLSF.NodesCrossingGroundingLines)/CtrlVar.PlotXYscale,y(GFLSF.NodesCrossingGroundingLines)/CtrlVar.PlotXYscale,'.r')
axis equal


Fonto=scatteredInterpolant() ; 
Fonto.Points=[x(GFLSF.NodesUpstreamOfGroundingLines) y(GFLSF.NodesUpstreamOfGroundingLines)];
Fonto.Values=CliffHeightTest(GFLSF.NodesUpstreamOfGroundingLines);
Fonto.ExtrapolationMethod='nearest'; Fonto.Method='nearest';

CliffHeightNew=CliffHeightTest ;
%CliffHeightNew(GFLSF.NodesCrossingGroundingLines)=Fonto(x(GFLSF.NodesCrossingGroundingLines),y(GFLSF.NodesCrossingGroundingLines));
CliffHeightNew(~GFLSF.NodesUpstreamOfGroundingLines)=Fonto(x(~GFLSF.NodesUpstreamOfGroundingLines),y(~GFLSF.NodesUpstreamOfGroundingLines));

FindOrCreateFigure("CliffHeightNew") ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeightNew) ;
FindOrCreateFigure("CliffHeightNew-CliffHeight") ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeightNew-CliffHeight) ;








