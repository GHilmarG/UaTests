

warning('off','MATLAB:triangulation:PtsNotInTriWarnId')
warning('off','MATLAB:decomposition:SaveNotSupported')
warning('off','MATLAB:decomposition:genericError')
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:SaveNotSupported');



%%
UserVar=[];
CtrlVar=Ua2D_DefaultParameters(); %
CtrlVar.PlotXYscale=1000; 
 CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
% Note; When creating this mesh using Úa, only the following 
% three lines are required in the Ua2D_InitialUserInput.m
CtrlVar.MeshSizeMax=1000e3; 
CtrlVar.MeshSizeMin=1e3;
CtrlVar.MeshSize=5e3;
CtrlVar.TriNodes=6;
xmin=-100e3 ; xmax=100e3 ; ymin=-100e3 ; ymax=100e3; 

MeshBoundaryCoordinates=[xmin ymin ; xmax ymin ; xmax ymax ; xmin ymax];

CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
% Now generate mesh (When using Úa this is done internally, no such call
% then needed).


[UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA); drawnow


FindOrCreateFigure("ele sizes histogram") ; histogram( sqrt(2*MUA.EleAreas)) ; xlabel("Element size")

%%
close all
F=UaFields; 
n=MUA.Nnodes;

h=300;
rho=920;
rhow=1030;

F.s=zeros(n,1);
F.b=zeros(n,1);
F.h=zeros(n,1)+h;
F.S=zeros(n,1);
F.B=zeros(n,1)-1e10; 
F.ub=zeros(n,1);
F.vb=zeros(n,1);
F.rho=zeros(n,1)+rho;
F.rhow=rhow;
F.AGlen=zeros(n,1)+AGlenVersusTemp(-10) ;
F.C=zeros(n,1)+1 ;
F.g=9.81/1000;
F.alpha=0; 

F.x=MUA.coordinates(:,1) ;
F.y=MUA.coordinates(:,2) ;


F.n=zeros(n,1)+3;
F.m=zeros(n,1)+3;


 [F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow); 

%

BCs=BoundaryConditions;
tolerance=1;
UpperEdgeNodes= MUA.Boundary.Nodes(abs(F.y(MUA.Boundary.Nodes)-ymax) <tolerance) ; 
LowerEdgeNodes= MUA.Boundary.Nodes(abs(F.y(MUA.Boundary.Nodes)-ymin) <tolerance) ; 


BCs.ubFixedNode=[UpperEdgeNodes; LowerEdgeNodes] ;  BCs.ubFixedValue=BCs.ubFixedNode*0;

BCs.vbFixedNode=[UpperEdgeNodes ; LowerEdgeNodes] ; BCs.vbFixedValue=[UpperEdgeNodes*0+1000 ; LowerEdgeNodes*0-1000]; 
% BCs.ubFixedNode=1 ;  BCs.ubFixedValue=BCs.ubFixedNode*0;

FindOrCreateFigure("BCs") ; PlotBoundaryConditions(CtrlVar,MUA,BCs);


lm=UaLagrangeVariables ;
RunInfo=UaRunInfo;
UserVar=[];

% F.ub(BCs.ubFixedNode)=BCs.ubFixedValue; F.vb(BCs.vbFixedNode)=BCs.vbFixedValue;

%%  uv solve
[UserVar,RunInfo,F,lm,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;



%Figures

FindOrCreateFigure("uv") ; QuiverColorGHG(F.x,F.y,F.ub,F.vb,CtrlVar) ;

[txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e,eta]=CalcNodalStrainRatesAndStresses(CtrlVar,UserVar,MUA,F) ;

N=20;


[X,Y]=ndgrid(linspace(min(F.x),max(F.x),20),linspace(min(F.y),max(F.y),20));


if isempty(MUA.TR)
    [MUA.Boundary,MUA.TR]=FindBoundary(MUA.connectivity,MUA.coordinates);
end

I=nearestNeighbor(MUA.TR,[X(:) Y(:)]);  % find nodes within computational grid closest to the regularly scape X and Y grid points.


FindOrCreateFigure("dev stresses")
scale=1e-2;
PlotTensor(F.x(I)/CtrlVar.PlotXYscale,F.y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
hold on
PlotMuaBoundary(CtrlVar,MUA,'k') ; axis equal

%%  phi field

BCsphi=BoundaryConditions;

% y=0 nodes
Iy0=find(abs(F.y)<CtrlVar.MeshSize/2 & F.x > 0 ); 

iBoundary=setdiff(MUA.Boundary.Nodes,Iy0); 




% set all phi values along boundary to 0
BCsphi.hFixedNode=[Iy0;iBoundary] ;  BCsphi.hFixedValue=[Iy0*0+1; iBoundary*0];
% Set phi values along y=0 to 1



FindOrCreateFigure("BCs Phi") ; PlotBoundaryConditions(CtrlVar,MUA,BCsphi);


Gc=1;
l=10e3;
Psi=0 ; 
[UserVar,phi,lambda,HEmatrix,HErhs]=PPFequation(UserVar,CtrlVar,MUA,BCsphi,Gc,l,Psi);


FindOrCreateFigure("phi")  ; UaPlots(CtrlVar,MUA,F,phi) ; 

FindOrCreateFigure("Phi(y)") ; plot(F.y/CtrlVar.PlotXYscale,phi,'.r') ;


Aold=F.AGlen;
%%  Reaclculate velocities with moddified A

phi(phi<0)=0; phi(phi>1)=1; 

phiMax=0.99 ; phi(phi>phiMax)=phiMax ;



F.AGlen=(1-phi).^2.*Aold ;


[UserVar,RunInfo,F,lm,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;



%Figures

FindOrCreateFigure("uv 2") ; QuiverColorGHG(F.x,F.y,F.ub,F.vb,CtrlVar) ;

[txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e,eta]=CalcNodalStrainRatesAndStresses(CtrlVar,UserVar,MUA,F) ;

N=20;


[X,Y]=ndgrid(linspace(min(F.x),max(F.x),40),linspace(min(F.y),max(F.y),40));


if isempty(MUA.TR)
    [MUA.Boundary,MUA.TR]=FindBoundary(MUA.connectivity,MUA.coordinates);
end

I=nearestNeighbor(MUA.TR,[X(:) Y(:)]);  % find nodes within computational grid closest to the regularly scape X and Y grid points.


FindOrCreateFigure("dev stresses 2")
scale=1e-2;
PlotTensor(F.x(I)/CtrlVar.PlotXYscale,F.y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
hold on
PlotMuaBoundary(CtrlVar,MUA,'k') ; axis equal


FindOrCreateFigure("e2") ;
UaPlots(CtrlVar,MUA,F,e);



