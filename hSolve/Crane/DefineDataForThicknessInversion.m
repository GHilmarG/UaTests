
function [UserVar,CtrlVar,MUA,F,BCs,Priors,Meas,htrue,kIso,kAlong,kCross,Method]=DefineDataForThicknessInversion(CtrlVar) 




%%

Method="(h-hmeas) P (h-hmeas) / 2 + (h-hprior) Q (h-hprior) / 2 +  (K h - b) M (K h - b) / 2" ; 

CtrlVar.SUPG.beta0=1;

kIso=0.0*1e6; 
kAlong=0.01*1e5; 
kCross=0.1*1e5; 


%%

UserVar=[];
BCs=BoundaryConditions ;
F=UaFields;


%%

load("MeshFile.mat","MUA","MeshBoundaryCoordinates")
load("MeshFile250m.mat","MUA","MeshBoundaryCoordinates")
F.x=MUA.coordinates(:,1);  F.y=MUA.coordinates(:,2);

%
% h boundary conditions


Ind=find(DistanceToLineSegment2([F.x F.y], MeshBoundaryCoordinates([1 end],:),[],10,10)); 

FindOrCreateFigure("MUA")  ; PlotMuaMesh(CtrlVar,MUA) ;c
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


F.as=F.as-F.dhdt; 

%%  Priors

Priors=PriorProbabilityDistribution ;
Priors.h=F.h*0 ;

%% Define "soft" boundary conditions for the ice thickness h.
% These need to be defined over all of the nodes, both values and errors.
% The errors are uncorrelated and defined

Meas=Measurements;
Meas.h=zeros(MUA.Nnodes,1);
Meas.hCov=1e10+zeros(MUA.Nnodes,1);  % very high errors


%%






end