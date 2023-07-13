

function driverTestSaveuvSolve()

%%

load("TestSaveuvSolve.mat","UserVar","RunInfo","CtrlVar","MUAnew","BCsNew","Fnew","lnew");

CtrlVar.uvDesiredWorkAndForceTolerances=[inf 1e-15];
CtrlVar.uvDesiredWorkOrForceTolerances=[1 1e-15];
CtrlVar.uvExitBackTrackingStepLength=1e-4;
CtrlVar.uvAcceptableWorkAndForceTolerances=[inf 1e-6];
CtrlVar.uvAcceptableWorkOrForceTolerances=[1 1e-8];

% changin kh and quad degree does not affect this
% CtrlVar.kH=10; CtrlVar.QuadratureRuleDegree=8;

% CtrlVar.QuadratureRuleDegree=3; MUAnew=UpdateMUA(CtrlVar,MUAnew) ;

Box= [-1628.8      -1603.5      -704.61      -677.35]*1000;
In=IsInBox(Box,Fnew.x,Fnew.y) ;
Fnew.B(In)=-1000; 


[UserVar,BCsNew]=DefineBoundaryConditions(UserVar,CtrlVar,MUAnew,Fnew,BCsNew); 


[UserVar,RunInfo,FnewTest,lnewTest]= uv(UserVar,RunInfo,CtrlVar,MUAnew,BCsNew,Fnew,lnew);


figuv=FindOrCreateFigure("uv kh=10 Q3") ; clf(figuv) 

QuiverColorGHG(FnewTest.x,FnewTest.y,FnewTest.ub,FnewTest.vb,CtrlVar) ;
hold on
[xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUAnew,FnewTest.GF) ;
[xc,yc]=PlotCalvingFronts(CtrlVar,MUAnew,FnewTest) ; 
PlotMuaBoundary(CtrlVar,MUAnew);
axis tight equal
end