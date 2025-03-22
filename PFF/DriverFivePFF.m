

%% approaches to simulating rifts by changing thickens, density, rate factor, etc.
%


warning('off','MATLAB:triangulation:PtsNotInTriWarnId')
warning('off','MATLAB:decomposition:SaveNotSupported')
warning('off','MATLAB:decomposition:genericError')
parfevalOnAll(gcp("nocreate"), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfevalOnAll(gcp("nocreate"), @warning, 0, 'off','MATLAB:decomposition:SaveNotSupported');




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
%% In the gap, thickness is reduced, density and rho are not
hGap=hIce/1e6;
AGap=AIce*1e10; 
rhoGap=rhoi; 


rhow=F.rhow;
n=F.n(1); 



%
 Extension="min thick" ;
% Extension="water" ;
CtrlVar.Development.Pre2025uvAssembly=false ;

UserVar.TestCase="Eq. water column";
UserVar.TestCase="thin ice";

IGap=F.x > -lGap & F.x < lGap ; 

switch UserVar.TestCase

    case "thin ice"

        F.h(IGap)=hGap;  
        %F.rho(IGap)=rhoGap;
        %F.AGlen(IGap)=AGap;

    case "Eq. water column"
        
        % here the gap is water
        F.h(IGap)=F.h(IGap)*rhoi/rhow; % reducing full ice thickness to equivalent water thickness 
        F.rho(IGap)=rhow; 
        F.AGlen(IGap)=AGap;

    otherwise

        error("sdfa")

end

[F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow);

CtrlVar.BCs="-uv-" ;
[UserVar,BCs]=GetBoundaryConditions(UserVar,CtrlVar,MUA,BCs,F) ;
       


lm=UaLagrangeVariables ;
[UserVar,RunInfo,F,lm]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;  

UaPlots(CtrlVar,MUA,F,"-uv-")
UaPlots(CtrlVar,MUA,F,"-e-") ; % integration point values
UaPlots(CtrlVar,MUA,F,F.h,FigureTitle="h")
UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="b")

[tbx,tby,txx,tyy,txy,exx,eyy,exy,eNumerical,eta]=CalcNodalStrainRatesAndStresses(CtrlVar,UserVar,MUA,F) ;

[etaInt,xint,yint,exxInt,eyyInt,exyInt,Eint,eInt,txxInt,tyyInt,txyInt]=calcStrainRatesEtaInt(CtrlVar,MUA,F.ub,F.vb,F.AGlen,F.n);



txx0=rhoi.*F.g.*hIce.*(1-rhoi/rhow)/4;
exx0=AIce*txx0^n;

switch Extension

    case "min thick"  % rifts are think ice above inviscid water 

    
        
        %hw = bGap-b =  (S-hGap*rGap/rhow) - (S-hIce*rhoi/rhow) ; 
        hw = hIce*rhoi/rhow-hGap*rhoGap/rhow ;

        r= 1+ (hGap/hIce)*  ((lIce/lGap)*(AIce/AGap))^(1/n)  ;
        K= 0.25*rhoi*g*hIce^2 - 0.25*rhow*g*hw^2 - 0.5*rhoGap*g*hGap*hw - 0.25*rhoGap*g*hGap^2;
       
        tauIce = K/(r*hIce) ;%  +zeros(MUA.Nnodes,1);
        tauGap = -(((lIce/lGap)*(AIce/AGap))^(1/n)) .* tauIce; % the effective is pos, the txx is negative

    

    case "water" % rifts are viscous water columns 

        r=1+ (rhoi/rhow)*((lIce/lGap)*(AIce/AGap))^(1/n) ;

        tauIce=txx0/r; % +zeros(MUA.Nnodes,1);

        tauGap = -(((lIce/lGap)*(AIce/AGap))^(1/n)) .* tauIce; % the effective is pos, the txx is negative

    

end



eAnalyticalIce=AIce.*(abs(tauIce).^n);
eAnalyticalGap=AGap.*(abs(tauGap).^n);

exxAnalyticalIce=AIce.*(abs(tauIce).^(n-1)).*tauIce;
exxAnalyticalGap=AGap.*(abs(tauGap).^(n-1)).*tauGap;


% comparison of exx at integration points

iIce=xint < (-lGap) | xint > (lGap) ;
exxAnalytical=exxInt*0 ;
exxAnalytical(iIce)=exxAnalyticalIce;
exxAnalytical(~iIce)=exxAnalyticalGap;

dexxInt=exxInt-exxAnalytical ;
UaPlots(CtrlVar,MUA,F,dexxInt,FigureTitle="exxInt error") ; 
title("diff in exx analytical and numerical"); subtitle("integration points")

D2int=dexxInt.^2 ;
Int=FEintegrate2D(CtrlVar,MUA,D2int);
D=sqrt(sum(Int)/MUA.Area);

fprintf("Numerical - Anlytical, RMS=%g \n",D)

%% exx: comparison between numerically and analytically calculated values
xint=xint(:);
exxInt=exxInt(:); 
[xsorted,ixSort]=sort(F.x); 
[xIntSorted,IxIntSort]=sort(xint(:));
exxNumerical=exxInt(IxIntSort);
exxAnalytical=xIntSorted*0; 
iIce=xIntSorted < -lGap | xIntSorted >lGap ;
exxAnalytical(iIce)=exxAnalyticalIce; 
exxAnalytical(~iIce)=exxAnalyticalGap;

% set numerical values around jump to nan for 
% id= abs(xIntSorted+lGap) < 5e3 |  abs(xIntSorted-lGap) < 5e3 ;
% exxNumerical(id)=nan;

% Important to do so at integration points
fige=FindOrCreateFigure("exx") ;  clf(fige)
hold off
yyaxis left
plot(xIntSorted/1000,exxInt(IxIntSort),".b",DisplayName="$\dot{\epsilon}_{xx}$ Numerical")
hold on
plot(xIntSorted/1000,exxAnalytical,DisplayName="$\dot{\epsilon}_{xx}$ analytical",LineStyle="--",Color="m",LineWidth=1)

%yline(exxAnalyticalGap,DisplayName="$\dot{\epsilon}_{xx}$ Gap analytical",LineStyle="--",Color="m",LineWidth=2)
%yline(exxAnalyticalIce,DisplayName="$\dot{\epsilon}_{xx}$ Ice analytical",LineStyle="--",Color="r",LineWidth=2)
yline(exx0,DisplayName="$\dot{\epsilon}$ for $r=1$",LineStyle="-.",Color="k",LineWidth=2)

ylabel("$\dot{e}$ (1/yr)",Interpreter="latex")

delta=exxNumerical-exxAnalytical;
yyaxis right ; plot(xIntSorted/1000,delta,DisplayName="numerical-analytical",LineStyle="none",marker=".", Color="r",LineWidth=1)

xlabel("$x$ (km)",Interpreter="latex")
legend(Interpreter="latex",Location="best")
xlim([min(F.x) max(F.x) ]/1000)
title(sprintf("RMS difference: %g ",D))


%% compare with deactivation


F.phi=zeros(MUA.Nnodes,1);
F.phi(IGap)=1;
dV=CompareDamageWithDeactivation(UserVar,RunInfo,CtrlVar,MUA,BCs,F)  ;


%%