
%%


UserVar=[];
CtrlVar=Ua2D_DefaultParameters();
BCs=BoundaryConditions ;
F=UaFields;
load("MeshFile.mat","MUA","MeshBoundaryCoordinates")
load("MeshFile250m.mat","MUA","MeshBoundaryCoordinates")
F.x=MUA.coordinates(:,1);  F.y=MUA.coordinates(:,2);

%
% h boundary conditions


Ind=find(DistanceToLineSegment2([F.x F.y], MeshBoundaryCoordinates([1 end],:),[],10,10)); 

FindOrCreateFigure("MUA")  ; PlotMuaMesh(CtrlVar,MUA) ;
hold on ; plot(F.x(Ind)/1000,F.y(Ind)/1000,"*r")

BCs.hFixedNode=setdiff(MUA.Boundary.Nodes,Ind);
BCs.hFixedValue=BCs.hFixedNode*0 ; 

FindOrCreateFigure("BCs") ; PlotBoundaryConditions(CtrlVar,MUA,BCs);

%% Data


load("RegionalInterpolants","Fs","Fvx","Fvy","FvxError","FvyError","Fas","Frock","Fice") ; 




%%  floating/grounded mask

[cGL,yGL]=PlotGroundingLines([],"Bindschadler");
[isInside,isOnBounday]=InsideOutside([F.x F.y],[cGL yGL]) ;


%% Plot over mesh


F.s=Fs(F.x,F.y);
F.ub=Fvx(F.x,F.y);
F.vb=Fvy(F.x,F.y);
F.as=Fas(F.x,F.y);
Rock=Frock(F.x,F.y);
Ice=Fice(F.x,F.y);

F.dhdt=F.x*0;
F.ab=F.s*0; 




%%  WARNING: For some reason REMA seems about 20 meters off and the min elevation is not zero even when ocean is in the domain
% Not sure why this is, or what is the best approach to deal with this.
% For the time being I subtract the min value
F.s=F.s-min(F.s);  


F.as=F.as+2;  % WARNING: Modifying surface mass-balance for test purposes

FindOrCreateFigure("s"); UaPlots(CtrlVar,MUA,F,F.s);
cmocean('topo',100,'pivot',20)

FindOrCreateFigure("Measured Velocities"); 
hold off
Par.VelPlotIntervalSpacing="log10";

%PlotMuaMesh(CtrlVar,MUA); 
hold on
QuiverColorGHG(F.x/1000,F.y/1000,F.ub,F.vb,Par) ; 
PlotMuaBoundary(CtrlVar,MUA); 
PlotGroundingLines();



FindOrCreateFigure("Rock"); UaPlots(CtrlVar,MUA,F,Rock);

FindOrCreateFigure("Surface mass balance"); UaPlots(CtrlVar,MUA,F,F.as);


%% Define further BCs for h-problem

if ~exist("BCs","var")
   BCs=BoundaryConditions ;
end

% add min thickness constraints over rock outcrops
Irock=find(Rock>0.1);
BCs.hFixedNode=[BCs.hFixedNode ; Irock] ;
BCs.hFixedValue=[BCs.hFixedValue; Irock*0+CtrlVar.ThickMin] ; 

%  fix ice thickness where floating based on surface elevation and
%  flotation condition
ifloating=find(~isInside) ;
BCs.hFixedNode=[BCs.hFixedNode ; ifloating] ;
rhoice=920; rhoOcean=1030;  hflotation=F.s(ifloating)/(1-rhoice/rhoOcean) ;
BCs.hFixedValue=[BCs.hFixedValue; hflotation] ; 

% set thickness over high elevation areas to zero  
Iele=find(F.s>1600);
BCs.hFixedNode=[BCs.hFixedNode ; Iele] ;
BCs.hFixedValue=[BCs.hFixedValue; Iele*0+CtrlVar.ThickMin] ; 


FindOrCreateFigure("BCs") ; PlotBoundaryConditions(CtrlVar,MUA,BCs);


F.h=F.s*0+CtrlVar.ThickMin ; F.h(BCs.hFixedNode)=BCs.hFixedValue; 


FindOrCreateFigure("h fixed")  ; UaPlots(CtrlVar,MUA,F,F.h) ;
hold on ; [cGL,yGL]=PlotGroundingLines([],"Bindschadler");

%%

% Using cross diffusion is very effective as "smoothing" the solution and results insensitive to the exact diffusion coefficient value 

CtrlVar.SUPG.beta0=1;

kIso=F.x*0+0.0*1e6; 
kAlong=F.x*0+0.01*1e5; 
kCross=F.x*0+0.1*1e5; 

F.as=F.as-F.dhdt; 
[UserVar,hest,lambda]=hEquation(UserVar,CtrlVar,MUA,F,BCs,kIso,kAlong,kCross);


% Results

FigTitle=sprintf("h est: kIso=%5.1f kAlong=%5.1f kAcross=%5.1f",mean(kIso),mean(kAlong),mean(kCross)); 
hEst=FindOrCreateFigure(FigTitle);
clf(hEst)
hold off
UaPlots(CtrlVar,MUA,F,hest) ;
hold on ; [cGL,yGL]=PlotGroundingLines([],"Bindschadler");
hold on ; scale=2 ; quiver(F.x/1000,F.y/1000,F.ub,F.vb,scale) ;
hold on ; plot(F.x(BCs.hFixedNode)/1000,F.y(BCs.hFixedNode)/1000,'.k')
% hold on ; QuiverColorGHG(F.x/1000,F.y/1000,F.ub,F.vb) ;
cmocean('topo',10,'pivot',0)

FindOrCreateFigure("sb") ; Plot_sbB(CtrlVar,MUA,F.s,F.s-hest,F.s-hest) ;

FindOrCreateFigure("hest") ; PlotMeshScalarVariableAsSurface(CtrlVar,MUA,hest) ;

