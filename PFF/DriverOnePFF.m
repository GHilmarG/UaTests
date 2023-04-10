

warning('off','MATLAB:triangulation:PtsNotInTriWarnId')
warning('off','MATLAB:decomposition:SaveNotSupported')
warning('off','MATLAB:decomposition:genericError')
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:SaveNotSupported');



%%
UserVar=[];
CtrlVar=Ua2D_DefaultParameters(); %
RunInfo=UaRunInfo;
BCs=BoundaryConditions;

CtrlVar.uvDesiredWorkAndForceTolerances=[inf inf];
CtrlVar.uvDesiredWorkOrForceTolerances=[1e-15 1e-15];
CtrlVar.uvExitBackTrackingStepLength=1e-4;
CtrlVar.uvAcceptableWorkAndForceTolerances=[inf 1e-6];
CtrlVar.uvAcceptableWorkOrForceTolerances=[1 1e-8];
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

F=DefineF(CtrlVar,MUA) ;

nMeshRefinements=5;
iMeshRefinements=0;

while true

    
    BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs) ;
    lm=UaLagrangeVariables ;
    figBCs=FindOrCreateFigure("BCs") ; clf(figBCs) ;  PlotBoundaryConditions(CtrlVar,MUA,BCs);

    [UserVar,RunInfo,F,lm,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;


    FindOrCreateFigure("uv") ; QuiverColorGHG(F.x,F.y,F.ub,F.vb,CtrlVar) ;
    [txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e,eta]=CalcNodalStrainRatesAndStresses(CtrlVar,UserVar,MUA,F) ;

    % [X,Y]=ndgrid(linspace(min(F.x),max(F.x),20),linspace(min(F.y),max(F.y),20));
    % I=nearestNeighbor(MUA.TR,[X(:) Y(:)]);  % find nodes within computational grid closest to the regularly scape X and Y grid points.
    % FindOrCreateFigure("dev stresses")
    % scale=1e-2;
    % PlotTensor(F.x(I)/CtrlVar.PlotXYscale,F.y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
    % hold on
    % PlotMuaBoundary(CtrlVar,MUA,'k') ; axis equal
    fige=FindOrCreateFigure("e") ;  clf(fige);   UaPlots(CtrlVar,MUA,F,e);

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
    [UserVar,phi,lambda,HEmatrix,HErhs]=PFFequation(UserVar,CtrlVar,MUA,BCsphi,Gc,l,Psi);


    figphi=FindOrCreateFigure("phi")  ; clf(figphi) ;  UaPlots(CtrlVar,MUA,F,phi) ;
    figphiy=FindOrCreateFigure("Phi(y)") ; clf(figphiy) ; Ind=F.x>50e3 & F.x <60e3 ;   plot(F.y(Ind)/CtrlVar.PlotXYscale,phi(Ind),'.r') ;

    %% Refine mesh
    iMeshRefinements=iMeshRefinements+1;

    if iMeshRefinements>nMeshRefinements
        break
    end

    MUAold=MUA;
    phiEle=Nodes2EleMean(MUAold.connectivity,phi) ;
    ElementsToBeCoarsened=false(MUAold.Nele,1);
    ElementsToBeRefined=phiEle >0.9 ;

    CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection' ; CtrlVar.InfoLevelAdaptiveMeshing=1;
    [MUAnew,RunInfo]=LocalMeshRefinement(CtrlVar,RunInfo,MUAold,ElementsToBeRefined,ElementsToBeCoarsened) ;
    MUA=MUAnew; 
    Fnew=DefineF(CtrlVar,MUAnew) ;
    OutsideValues=[] ; 
    [RunInfo,Fnew.ub,Fnew.vb]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,F.ub,F.vb);
    F=Fnew; 

end

%%
save("PFFinitial.mat","UserVar","RunInfo","CtrlVar","MUA","F","BCs","lm","phi")

%%
load("PFFinitial.mat","UserVar","RunInfo","CtrlVar","MUA","F","BCs","lm","phi")

UserVar=[] ; RunInfo=UaRunInfo;
Aold=F.AGlen;

% Some constraints on phi
phi(phi<0)=0; phi(phi>1)=1; phiMax=0.50 ; phi(phi>phiMax)=phiMax ;


D=(1-phi).^(2*F.n(1));
F.AGlen=Aold./D;



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



