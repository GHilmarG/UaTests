%% Testing comparision between damaged and deactivated elements


warning('off','MATLAB:triangulation:PtsNotInTriWarnId')
warning('off','MATLAB:decomposition:SaveNotSupported')
warning('off','MATLAB:decomposition:genericError')
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:SaveNotSupported');




%%  Define geometry and key input variables needed to solve for uv
UserVar=[];
UserVar.Experiment="1D ice shelf"; 
CtrlVar=Ua2D_DefaultParameters(); 

CtrlVar.Parallel.uvhAssembly.spmd.isOn=false ;        % assembly in parallel using spmd over sub-domain (domain decomposition)  
CtrlVar.Parallel.uvAssembly.spmd.isOn=false ;          % assembly in parallel using spmd over sub-domain (domain decomposition)  
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
CtrlVar.MeshSize=1e3; 
CtrlVar.MeshSizeMin=0.1e3 ; 
CtrlVar.TriNodes=3;  % with 10-node the jump seems much smaller
CtrlVar.ThickMin=1e-6; 

CtrlVar.QuadratureRuleDegree=[] ;


CtrlVar.PhaseFieldFracture.Video=true;


lIce=100e3 ; lGap=20e3 ;

xmin=-lIce-lGap; xmax=lIce+lGap;
ymin=-20e3 ; ymax=20e3;



MeshBoundaryCoordinates=[(-lIce-lGap) ymin ;  -lGap ymin ; -lGap ymax ; -lGap ymin ; lGap ymin ; lGap ymax ; lGap ymin ; (lIce+lGap) ymin ; (lIce+lGap) ymax ; (-lIce-lGap) ymax ; (-lIce-lGap) ymin ] ;

                         

CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
% Now generate mesh (When using Úa this is done internally, no such call
% then needed).


[UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=true;
FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA); drawnow



hIce=300; 
F=DefineF(UserVar,CtrlVar,MUA,hIce) ;

g=F.g ; 
AIce=F.AGlen(1);
rhoi=F.rho(1);

hGap=hIce/2; 
AGap=AIce; 
rhoGap=rhoi; 

rhow=F.rhow;
n=F.n(1); 


Extension="min thick" ;
% Extension="water" ;

IGap=F.x >= -lGap & F.x <= lGap ; 

switch Extension

    case "min thick"

        F.h(IGap)=hGap;  
        F.rho(IGap)=rhoGap;
        F.AGlen(IGap)=AGap;

    case "water"
        
        % here the gap is water
        F.h(IGap)=F.h(IGap)*rhoi/rhow; 
        F.rho(IGap)=rhow; 
        F.AGlen(IGap)=AGap;

    otherwise

        error("sdfa")

end

[F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow);

CtrlVar.BCs="-uv-" ;
BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs) ;


lm=UaLagrangeVariables ;
[UserVar,RunInfo,F,lm]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;  

UaPlots(CtrlVar,MUA,F,"-uv-")
UaPlots(CtrlVar,MUA,F,"-e-") ; % integration point values
UaPlots(CtrlVar,MUA,F,F.h,FigureTitle="h")
UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="b")

[tbx,tby,txx,tyy,txy,exx,eyy,exy,eNumerical,eta]=CalcNodalStrainRatesAndStresses(CtrlVar,UserVar,MUA,F) ;

[etaInt,xint,yint,exxInt,eyyInt,exyInt,Eint,eInt,txxInt,tyyInt,txyInt]=calcStrainRatesEtaInt(CtrlVar,MUA,F.ub,F.vb,F.AGlen,F.n);
xint=xint(:) ; eInt=eInt(:); 


txx0=rhoi.*F.g.*hIce.*(1-rhoi/rhow)/4;
exx0=AIce*txx0^n;

switch Extension

    case "min thick"

    
        
        %hw = bGap-b =  (S-hGap*rGap/rhow) - (S-hIce*rhoi/rhow) ; 
        hw = hIce*rhoi/rhow-hGap*rhoGap/rhow ;

        r= 1+ (hGap/hIce)*  ((lIce/lGap)*(AIce/AGap))^(1/n)  ;
        K= 0.25*rhoi*g*hIce^2 - 0.25*rhow*g*hw^2 - 0.5*rhoGap*g*hGap*hw - 0.25*rhoGap*g*hGap^2;
       
        tauIce = K/(r*hIce) +zeros(MUA.Nnodes,1);
        tauGap = (((lIce/lGap)*(AIce/AGap))^(1/n)) .* tauIce; % the effective is pos, the txx is negative

        eAnalyticalIce=AIce.*(tauIce.^F.n);
        eAnalyticalGap=AGap.*(tauGap.^F.n);

    case "water"

        r=1 /(1+ (rhoi/rhow)*((lIce/lGap)*(AIce/AGap))^(1/n)) ;

        
        tauIce=r*txx0+zeros(MUA.Nnodes,1);

        tauGap = (((lIce/lGap)*(AIce/AGap))^(1/n)) .* tauIce; % the effective is pos, the txx is negative

        eAnalyticalIce=AIce.*tauIce.^F.n;
        eAnalyticalGap=AGap.*tauGap.^F.n;


end



eAnalytical=zeros(MUA.Nnodes,1);
eAnalytical(~IGap)=eAnalyticalIce(~IGap);
eAnalytical(IGap)=eAnalyticalGap(IGap);

de=(eNumerical-eAnalytical);

UaPlots(CtrlVar,MUA,F,de,FigureTitle="de")
title("error in calculated effective effective strain rates",Interpreter="latex")

[xsorted,ixSort]=sort(F.x); 
[xIntSorted,IxIntSort]=sort(xint);


fige=FindOrCreateFigure("e(x) 2") ;  clf(fige)

hold off
plot(F.x(ixSort)/1000,eAnalytical(ixSort),".r-",DisplayName="$\dot{\epsilon}$ Analytical",LineWidth=2) ;
hold on ; 
plot(xIntSorted/1000,eInt(IxIntSort),".b",DisplayName="$\dot{\epsilon}$ Numerical")

%plot(F.x(ixSort)/1000,eNumerical(ixSort),".b",DisplayName="$e$ Numerical")
emin=min(eAnalytical) ;
emax=max(eAnalytical) ;
eD=(emax-emin)*0.1; 
yline(exx0,DisplayName="$\dot{\epsilon}$ for $r=1$",LineStyle="--")
%ylim([emin-eD emax+eD])
xlabel("$x$ (km)",Interpreter="latex")
ylabel("$\dot{e}$ (1/yr)",Interpreter="latex")
legend(Interpreter="latex")
xlim([xmin xmax ]/1000)

de=(eNumerical-eAnalytical)./eAnalytical;
%de=(eNumerical-eAnalytical);

%D=sqrt((de'*MUA.M*de)/MUA.Area);

fprintf("intergrated fractional difference in calculated and analytical e values: %g \n",D)

%%