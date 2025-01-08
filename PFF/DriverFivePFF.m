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


lIce=100e3 ; lGap=10e3 ;

xmin=-lIce-lGap; xmax=lIce+lGap;
ymin=-20e3 ; ymax=20e3;
xc=0 ; 

MeshBoundaryCoordinates=[(-lIce-lGap) ymin ;  -lGap ymin ; -lGap ymax ; -lGap ymin ; lGap ymin ; lGap ymax ; lGap ymin ; (lIce+lGap) ymin ; (lIce+lGap) ymax ; (-lIce-lGap) ymax ; (-lIce-lGap) ymin ] ;

% left-hand part of the symmetrical geometry only
% MeshBoundaryCoordinates=[(-lIce-lGap) ymin ;  -lGap ymin ; -lGap ymax ; -lGap ymin ; 0 ymin ; 0 ymax ; (-lIce-lGap) ymax ; (-lIce-lGap) ymin ] ; 


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

%% good parameter example for demonstration
hGap=hIce/10; 
AGap=AIce/10; 
rhoGap=rhoi/10; 
%%
hGap=hIce/10; 
AGap=AIce*10; 
rhoGap=rhoi/1000; 


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
       
        tauIce = K/(r*hIce) ;%  +zeros(MUA.Nnodes,1);
        tauGap = -(((lIce/lGap)*(AIce/AGap))^(1/n)) .* tauIce; % the effective is pos, the txx is negative

    

    case "water"

        r=1+ (rhoi/rhow)*((lIce/lGap)*(AIce/AGap))^(1/n) ;

        tauIce=txx0/r; % +zeros(MUA.Nnodes,1);

        tauGap = (((lIce/lGap)*(AIce/AGap))^(1/n)) .* tauIce; % the effective is pos, the txx is negative

    

end

eAnalyticalIce=AIce.*(abs(tauIce).^n);
eAnalyticalGap=AGap.*(abs(tauGap).^n);

exxAnalyticalIce=AIce.*(abs(tauIce).^(n-1)).*tauIce;
exxAnalyticalGap=AGap.*(abs(tauGap).^(n-1)).*tauGap;

eAnalytical=zeros(MUA.Nnodes,1);
eAnalytical(~IGap)=eAnalyticalIce;
eAnalytical(IGap)=eAnalyticalGap;

de=(eNumerical-eAnalytical);


iIce=F.x < (-2*lGap) | F.x > (2*lGap) ;
iGap=F.x > (-lGap/2) & F.x < (lGap/2) ;

exxNumericalIce=mean(exx(iIce));  % this could be estimated better by performing an integration, but ...
exxNumericalGap=mean(exx(iGap));

fprintf(" Ice exx:  analytical %g \t numerical %g \t rel error %g%s \n",exxAnalyticalIce,exxNumericalIce,100*(exxNumericalIce-exxAnalyticalIce)/exxAnalyticalIce,"%")
fprintf(" Gap exx:  analytical %g \t numerical %g \t rel error %g%s \n",exxAnalyticalGap,exxNumericalGap,100*(exxNumericalGap-exxAnalyticalGap)/exxAnalyticalGap,"%")

fprintf(" exx analytical integrated: %g \n", (xmax-lGap)*exxAnalyticalIce+lGap*exxAnalyticalGap)
fprintf("  exx numerical integrated: %g \n", (xmax-lGap)*exxNumericalIce+lGap*exxNumericalGap)

fprintf(" exx numerical integrated: %g \n ",sum(FEintegrate2D(CtrlVar,MUA,exx)))

UaPlots(CtrlVar,MUA,F,de,FigureTitle="de")
title("error in calculated effective effective strain rates",Interpreter="latex")

[xsorted,ixSort]=sort(F.x); 
[xIntSorted,IxIntSort]=sort(xint);

%% exx: comparison between numerically and analytically calculated values
fige=FindOrCreateFigure("exx") ;  clf(fige)
hold off
plot(xIntSorted/1000,exxInt(IxIntSort),".b",DisplayName="$\dot{\epsilon}_{xx}$ Numerical")
yline(exxNumericalGap,DisplayName="$\dot{\epsilon}_{xx}$ Gap",LineStyle="--",Color="m",LineWidth=2)
yline(exxNumericalIce,DisplayName="$\dot{\epsilon}_{xx}$ Ice",LineStyle="--",Color="r",LineWidth=2)
yline(exx0,DisplayName="$\dot{\epsilon}$ for $r=1$",LineStyle="--",Color="k",LineWidth=2)
ylabel("$\dot{e}$ (1/yr)",Interpreter="latex")
xlabel("$x$ (km)",Interpreter="latex")
legend(Interpreter="latex",Location="best")
xlim([min(F.x) max(F.x) ]/1000)
%%

% fige=FindOrCreateFigure("e(x) 2") ;  clf(fige)
% hold off
% yyaxis left
% plot(F.x(ixSort)/1000,eAnalytical(ixSort),".r-",DisplayName="$\dot{\epsilon}$ Analytical",LineWidth=2) ;
% hold on ; 
% plot(xIntSorted/1000,eInt(IxIntSort),".b",DisplayName="$\dot{\epsilon}$ Numerical")
% yline(exx0,DisplayName="$\dot{\epsilon}$ for $r=1$",LineStyle="--")
% % plot(F.x(ixSort)/1000,eNumerical(ixSort),".b",DisplayName="$e$ Numerical")
% % emin=min(eAnalytical) ;
% % emax=max(eAnalytical) ;
% % eD=(emax-emin)*0.1; 
% % ylim([emin-eD emax+eD])
% ylabel("$\dot{e}$ (1/yr)",Interpreter="latex")
% xlabel("$x$ (km)",Interpreter="latex")
% legend(Interpreter="latex")
% xlim([min(F.x) max(F.x) ]/1000)
%%


de=(eNumerical-eAnalytical)./eAnalytical;
%de=(eNumerical-eAnalytical);

%D=sqrt((de'*MUA.M*de)/MUA.Area);

fprintf("intergrated fractional difference in calculated and analytical e values: %g \n",D)

%%