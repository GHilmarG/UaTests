

warning('off','MATLAB:triangulation:PtsNotInTriWarnId')
warning('off','MATLAB:decomposition:SaveNotSupported')
warning('off','MATLAB:decomposition:genericError')
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:SaveNotSupported');




%%  Define geometry and key input variables needed to solve for uv
UserVar=[];
CtrlVar=Ua2D_DefaultParameters(); 

CtrlVar.Parallel.uvhAssembly.spmd.isOn=true ;        % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.uvAssembly.spmd.isOn=true;          % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.BuildWorkers=true;
CtrlVar.Parallel.isTest=false;                        % Runs both with and without parallel approach, and prints out some information on relative performance. 

RunInfo=UaRunInfo;
BCs=BoundaryConditions;

CtrlVar.uvDesiredWorkAndForceTolerances=[inf inf];
CtrlVar.uvDesiredWorkOrForceTolerances=[1e-15 1e-10];
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

% Calculate initial phi for undamaged ice, and do some local mesh refinement around initial crack


F=DefineF(CtrlVar,MUA) ;


A0=F.AGlen(1);
rhoi=F.rho(1) ;
rhow=F.rhow;
n=F.n(1) ;
Gc=1e6;  l=10e3;

phi=zeros(MUA.Nnodes,1); % phi=0, undamaged,
% phi=1, fully damaged


nMeshRefinements=5;
iMeshRefinements=0;

while true


    BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs) ;
    lm=UaLagrangeVariables ;
   

    [F.AGlen,F.rho]=Arho(phi,rhoi,rhow,A0,n) ;
    [F.s,F.h]=sPFF(F.S,F.b,rhoi,rhow,phi);

    [UserVar,RunInfo,F,lm,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;

   

    %  phi field

    BCsphi=BoundaryConditions;

    % y=0 nodes
    lEleMin=min(sqrt(2*MUA.EleAreas)) ; 
    % Iy0=find(abs(F.y)<lEleMin & F.x > 50e3 );
    Iy0=find(abs(F.y)<(l/2) & F.x > 50e3 );

    iBoundary=setdiff(MUA.Boundary.Nodes,Iy0);

    % set all phi values along boundary to 0 and over crack to 1
    % BCsphi.hFixedNode=[Iy0;iBoundary] ;  BCsphi.hFixedValue=[Iy0*0+1; iBoundary*0];
    
    % only set \phi values over the crack to 1 and use the natural boundary condition elsewhere
    BCsphi.hFixedNode=Iy0 ;  BCsphi.hFixedValue=Iy0*0+1 ;
    % Set phi values along y=0 to 1
  
    
    Psi=0 ;  % If I set Psi to zero, the damage field (\phi) does not evolve
    
    [UserVar,phi,lambda,HEmatrix,HErhs]=PFFequation(UserVar,CtrlVar,MUA,BCsphi,Gc,l,Psi);
    
    [Psi,e,eInt]=StrainRateEnergy(CtrlVar,MUA,F,A0) ; % just here for plotting purposes
    PFFPlots(UserVar,CtrlVar,MUA,F,BCs,BCsphi,phi,Psi,e) ; 

    
 

    % Refine mesh
    iMeshRefinements=iMeshRefinements+1;

    if iMeshRefinements>nMeshRefinements
        break
    end

    MUAold=MUA;
    phiEle=Nodes2EleMean(MUAold.connectivity,phi) ;
    ElementsToBeCoarsened=false(MUAold.Nele,1);
    ElementsToBeRefined=phiEle > 0.3 ;  % I could add here limits on min ele size

    CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection' ; CtrlVar.InfoLevelAdaptiveMeshing=1;
    [MUAnew,RunInfo]=LocalMeshRefinement(CtrlVar,RunInfo,MUAold,ElementsToBeRefined,ElementsToBeCoarsened) ;
    MUA=MUAnew; 
    Fnew=DefineF(CtrlVar,MUAnew) ;
    OutsideValues=[] ; 
    [RunInfo,Fnew.ub,Fnew.vb,phi]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,F.ub,F.vb,phi);
    F=Fnew; 

end



PFFPlots(UserVar,CtrlVar,MUA,F,BCs,BCsphi,phi,Psi,e) ; 


%%
save("PFFinitial.mat","UserVar","RunInfo","CtrlVar","MUA","F","BCs","lm","phi")

%% Now uv and phi for the initial prescribed crack have been calculated 
% attempt to do a transient simulation for phi

load("PFFinitial.mat","UserVar","RunInfo","CtrlVar","MUA","F","BCs","lm","phi")



CtrlVar.Parallel.uvhAssembly.spmd.isOn=true ;        % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.uvAssembly.spmd.isOn=true;          % speedup of about 7 to 8 on PCWIN64 with two sockets each with 8 physical cores, ie total of 16 cores and 32 logical processors
CtrlVar.Parallel.BuildWorkers=true;
CtrlVar.Parallel.Distribute=true;                    % slows things down

CtrlVar.Parallel.isTest=true;         


MUA=UpdateMUA(CtrlVar,MUA) ; 





ub=F.ub ; vb=F.vb;

F=DefineF(CtrlVar,MUA) ;
F.ub=ub; F.vb=vb; 
A0=F.AGlen;
rhoi=F.rho ;
rhow=F.rhow;
n=F.n(1) ;

[F.AGlen,F.rho]=Arho(phi,rhoi,rhow,A0,n) ;

xphi0=nan ; yphi0=nan;

Vstring=sprintf("PFF_Gc%i_l%i_",Gc,l) ;


CreateFiguresAndVideo=false ; 


if CreateFiguresAndVideo
    Vphi=VideoWriter(Vstring+"phi.avi"); open(Vphi)
    Vuv=VideoWriter(Vstring+"uv.avi"); open(Vuv)
    VPsi=VideoWriter(Vstring+"Psi.avi"); open(VPsi)
end

tCPU=tic;
for I=1:2


   
    Psi=StrainRateEnergy(CtrlVar,MUA,F,A0);
    phiLast=phi;
    [UserVar,phi]=PFFequation(UserVar,CtrlVar,MUA,BCsphi,Gc,l,Psi);

    Iphi=phi<phiLast;
    phi(Iphi)=phiLast(Iphi) ; % irreversibility 

    [F.AGlen,F.rho]=Arho(phi,rhoi,rhow,A0,n) ;
    [F.s,F.h]=sPFF(F.S,F.b,rhoi,rhow,phi);


    [UserVar,RunInfo,F,lm]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;

    if CreateFiguresAndVideo
        % Plots
        xphi0=xphi ; yphi0=yphi;
        [xphi,yphi]=CalcMuaFieldsContourLine(CtrlVar,MUA,phi,0.85) ;


        cbar=UaPlots(CtrlVar,MUA,F,phi,FigureTitle="phi") ;
        title(cbar,"$\phi$",interpreter="latex")
        CM=cmocean('balanced',25,'pivot',0.5) ; colormap(CM);
        hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
        title(sprintf("$\\phi$ iStep=%i",I),Interpreter="latex")
        frame=getframe(gcf) ;  writeVideo(Vphi,frame);


        cbar=UaPlots(CtrlVar,MUA,F,phi-phiLast,FigureTitle="dphi") ;
        title(cbar,"$\Delta \phi$",interpreter="latex")
        hold on ;
        plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
        plot(xphi0/CtrlVar.PlotXYscale,yphi0/CtrlVar.PlotXYscale,Color="k",LineWidth=1,LineStyle="--")
        title(sprintf("$\\Delta \\phi$ iStep=%i",I),Interpreter="latex")



        cbar=UaPlots(CtrlVar,MUA,F,Psi,FigureTitle="Psi") ;  set(gca,'ColorScale','log')
        title(cbar,"$\Psi$",interpreter="latex")
        hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
        title(sprintf("$\\Psi$ iStep=%i",I),Interpreter="latex")
        frame=getframe(gcf) ;  writeVideo(VPsi,frame);

        UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="uv")
        hold on ;  plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
        title(sprintf("$(u,v)$ iStep=%i",I),Interpreter="latex")
        frame=getframe(gcf) ;  writeVideo(Vuv,frame);
    end
    %


end

tCPU=toc(tCPU) ;

fprintf( "CPU time = %g \n",tCPU)  ;  % 183 without spmd, 75 sec with spmd, speedup of 2.44

if CreateFiguresAndVideo
    close(Vuv)
    close(Vphi)
    close(VPsi)
end

fprintf(" done \n")

%%



function gphi=DegradationFunction(phi)

%  phi=0 : undamaged 
%  phi=1 : fully damaged 
%
%  gphi=0 : fully damaged
%  gphi=1 : undamaged
%

k=1e-3; 
gphi=(1-k)* (1-phi).^2 + k ;


end

function rhoE=DensityEffective(rhoi,rhow,phi)


gphi=DegradationFunction(phi) ;

rhoE=gphi.*rhoi+(1-gphi).*rhow ;


end



function [AE,rhoE]=Arho(phi,rhoi,rhow,A0,n)

% calculates AGlen effective and the effective density as a function of phi

gphi=DegradationFunction(phi) ;
rhoE=DensityEffective(rhoi,rhow,phi) ;

AE=A0./ (gphi.^n)  ;


end




function [s,h]=sPFF(S,b,rhoi,rhow,phi)


% Calculates upper ice surface elevation, s, from flotation.
% Does not conserve ice thickness!

rhoE=DensityEffective(rhoi,rhow,phi) ; 

% flotation:  (s-b) rhoE = (S-b) rhow
s=b+(S-b).*rhow./rhoE ; 
h=s-b ; 


end


function [Psi,e,eInt]=StrainRateEnergy(CtrlVar,MUA,F,A0)



[dudx,dudy,xint,yint]=calcFEderivativesMUA(F.ub,MUA,CtrlVar) ; 
[dvdx,dvdy]=calcFEderivativesMUA(F.vb,MUA,CtrlVar) ; 

exx=dudx;
eyy=dvdy;
exy=0.5*(dudy+dvdx);

eInt=real(sqrt(CtrlVar.EpsZero^2+exx.^2+eyy.^2+exx.*eyy+exy.^2));

e=ProjectFintOntoNodes(MUA,eInt);
e(e<0)=0; 


Psi=2*A0.^(-1./F.n) .* e.^((F.n+1)./F.n) ; 



end


























