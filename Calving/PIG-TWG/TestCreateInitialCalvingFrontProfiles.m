%%
load SaveCreateInitialCalvingFrontProfiles

% calculate signed distance from grounding line

load("GroundingLineForAntarcticaBasedOnBedmachine.mat","xGL","yGL") ;

iNaN=find(isnan(xGL));  xGL=xGL(1:iNaN(1)-1); yGL=yGL(1:iNaN(1)-1);

Dist=pdist2([xGL(:) yGL(:)],MUA.coordinates,'euclidean','Smallest',1) ;
Dist=Dist(:) ;

PM=sign(F.GF.node-0.5) ;
Field=PM.*Dist;
Value=-10e3 ; 

[Xc,Yc]=CalcMuaFieldsContourLine(CtrlVar,MUA,Field,Value,lineup=true,plot=false,subdivide=false) ; 
iNaN=find(isnan(Xc));  Xc=Xc(1:iNaN(1)-1); Yc=Yc(1:iNaN(1)-1);

figure ; UaPlots(CtrlVar,MUA,F,Field) ;   hold on ; plot(Xc/1000,Yc/1000,'.k') ; axis equal


[Xc,Yc]=CreateInitialCalvingFrontProfiles(CtrlVar,MUA,CFI=[Xc(:) Yc(:)],CalvingFront='-TWISC-');

%%

% [xc,yc,LSF]=CalvingFrontLevelSetGeometricalInitialisation(CtrlVar,MUA,Xc,Yc,LSF,plot=true);

%


