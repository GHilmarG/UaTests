function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


persistent iCounter Diagnostics


%%
%
% The $\mathcal{L}^2$ inner product is defined as: 
% 
% $$(u,v)_{\mathcal{L}^2}:= \frac{1}{\mathcal{A}} \int f(x,y) \, g(x,y) \; dx \,  dy $$
% 
% where
%
%
% $$\mathcal{A} := \int  \; dx \,  dy $$
%
%
% The norm of the variation in surface elevation $s$ is defined as
%
% $$ \| \Delta s \| := \sqrt{ (s-\bar{s},s-\bar{s})_{\mathcal{L}^2} } $$
% 
% The norm of the difference between numerically-modeled, $s_n$, and analytically-calculated, $s_a$, surface elevations
% is similarly:
%
% $$ \| s_n - s_a  \| := \sqrt{ (s_n-s_a, s_n-s_n)_{\mathcal{L}^2} } $$
%
%
%%


plots='-ubvb-e-save-';
plots='-sbB-udvd-ubvb-ub-';
plots='-ubvb-stresses-';
plots='-flowline-';
plots="";

if F.solution=="-none-"
    iCounter=[]; 
    Diagnostics=[] ; 
    return
end

if CtrlVar.DefineOutputsInfostring=="Last call"

    
    OutputString=replace(UserVar.Experiment,".","k");
    save(OutputString+".mat","Diagnostics")


end


%% Transfer


 [sAna,uAna,vAna,wAna]=TransferFunctionsGauss(UserVar,CtrlVar,MUA,F) ;

if contains(plots,'-flowline-')
    % this plot is most useful if the perturbations only vary in x direction
   
    
    FindOrCreateFigure("-s-ub-")
    hold off
    yyaxis left
    plot(F.x/1000,F.s,"ob")
    hold on
    plot(F.x/1000,sAna,".b")
    ylabel("$s(x,t)$ (m)","interpreter","latex") ;
    ylim([900 1100])
    yyaxis right
    hold off
    plot(F.x/1000,F.ub,"or")
    hold on
    plot(F.x/1000,uAna,".r")
    ylim([900 1100])
    ylabel("$u_b(x,t)$ (m)","interpreter","latex") ;
    xlabel("$x$ (km)","interpreter","latex") ;
    title(sprintf("upper surface and basal velocity at t=%f",F.time),"interpreter","latex")
    legend("$s$ (numerical)","$s$ (analytical)","$u_b$ (numerical)","$u_b$ (analytical)",...
        "interpreter","latex","location","southeast")
    hold off
    
end

ds=F.s-sAna;
du=F.ub-uAna;
dv=F.vb-vAna;
MUA.M=MassMatrix2D1dof(MUA);

h0=UserVar.h0;



dsNumericalNorm=sqrt((((F.s-h0)'*MUA.M* (F.s-h0))))/MUA.Area; 
dsAnalyticalNorm=sqrt((((sAna-h0)'*MUA.M* (sAna-h0))))/MUA.Area; 
sError= sqrt(((ds'*MUA.M* ds)))/MUA.Area; 


dSpeedNumerical=sqrt((F.ub-UserVar.ub0).*(F.ub-UserVar.ub0)+F.vb.*F.vb) ;
dSpeedAnalytical=sqrt((uAna-UserVar.ub0).*(uAna-UserVar.ub0)+vAna.*vAna) ;
SpeedError=sqrt(du.*du+dv.*dv); 

SpeedNumericalNorm=sqrt(((dSpeedNumerical'*MUA.M* dSpeedNumerical)))/MUA.Area; 
SpeedAnalyticalNorm=sqrt(((dSpeedAnalytical'*MUA.M* dSpeedAnalytical)))/MUA.Area; 

SpeedErrorNorm=sqrt(((SpeedError'*MUA.M* SpeedError)))/MUA.Area; 



% collect some information about the overall agreement between analytical and numerical solution and store this in a
% persistent variable to allow for plot as function of times being created in the course of the run.
if isempty(Diagnostics)
    Diagnostics.time=nan(10000,1);
    Diagnostics.sNumerical=nan(10000,1);
    Diagnostics.sAnalytical=nan(10000,1);
    Diagnostics.sError=nan(10000,1);
    Diagnostics.SpeedNumerical=nan(10000,1);
    Diagnostics.SpeedAnalytical=nan(10000,1);
    Diagnostics.SpeedError=nan(10000,1);
    iCounter=0;
end

iCounter=iCounter+1;
Diagnostics.time(iCounter)=F.time; 
Diagnostics.sNumerical(iCounter)=dsNumericalNorm; 
Diagnostics.sAnalytical(iCounter)=dsAnalyticalNorm; 
Diagnostics.sError(iCounter)=sError; 

Diagnostics.SpeedNumerical(iCounter)=SpeedNumericalNorm; 
Diagnostics.SpeedAnalytical(iCounter)=SpeedAnalyticalNorm; 
Diagnostics.SpeedError(iCounter)=SpeedErrorNorm; 

FindOrCreateFigure("Surface topography Norms")
plot(Diagnostics.time,Diagnostics.sNumerical,"-or",DisplayName="Numerical surface topography")
hold on 
plot(Diagnostics.time,Diagnostics.sAnalytical,"-xb",DisplayName="Analytical surface topography")
plot(Diagnostics.time,Diagnostics.sError,"-sm",DisplayName="Error in topography")
xlabel("time (yr)")
title("Norm of surface perturbances")
lg=legend(Location="northwest",Interpreter="latex");

%%
FindOrCreateFigure("Norm of speed variations around mean speed")
plot(Diagnostics.time,Diagnostics.SpeedNumerical,"-or",DisplayName="Numerical speed variations")
hold on 
plot(Diagnostics.time,Diagnostics.SpeedAnalytical,"-xb",DisplayName="Analytical speed variations")
plot(Diagnostics.time,Diagnostics.SpeedError,"-sm",DisplayName="$\|\mathrm{numerical-analytical}\|$")
xlabel("time (yr)")
title("Norms of speed")
lg=legend(Location="northwest",Interpreter="latex");
%%

UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="bedrock")
title("bedrock")
UaPlots(CtrlVar,MUA,F,F.C,FigureTitle="C")
title("basal slipperiness")

%% uv velocities
FindOrCreateFigure("uv diff")
tuv=tiledlayout(1,3) ;
nexttile
UaPlots(CtrlVar,MUA,F,"-uv-",CreateNewFigure=false);
title("numerical velocities ")

nexttile
UaPlots(CtrlVar,MUA,F,[uAna vAna],CreateNewFigure=false);
title("analytical velocities ")

nexttile
UaPlots(CtrlVar,MUA,F,[F.ub-uAna F.vb-vAna],CreateNewFigure=false) ;
title("numerical - analytical velocities ")
tuv.Padding="tight" ; tuv.TileSpacing="compact" ; 

%% surface perturbations 
FindOrCreateFigure("s diff")
ts=tiledlayout(1,3) ;
nexttile
UaPlots(CtrlVar,MUA,F,F.s-UserVar.h0,CreateNewFigure=false) ; 
title("Surface perturbations (numerical)")
CL=clim;
nexttile
UaPlots(CtrlVar,MUA,F,sAna-UserVar.h0,CreateNewFigure=false) ; 
title("Surface perturbations (analytical)")
clim(CL)
nexttile
UaPlots(CtrlVar,MUA,F,F.s-sAna,CreateNewFigure=false) ; 
title("numerical surface - analytical surface ")
ts.Padding="tight" ; ts.TileSpacing="compact" ; 
CM=cmocean('balanced',25,'pivot',0) ; colormap(CM);

%% simple xy plot of analytical versus modeled surface elevations 
figure(1000) ; 
hold off ; 
plot(F.s,sAna,".b") ; 
axis equal ; tt=axis ; 
hold on ; 
axis([tt(1) tt(2) tt(1) tt(2)]) ; 
plot([tt(1) tt(2)],[tt(1) tt(2)]) ;
ylabel("analytical surface topography (m)")
xlabel("numerical surface topography (m)")
title("analytical versus numerical topography")
%%
%dtcritical=CalcCFLdt2D(UserVar,RunInfo,CtrlVar,MUA,F) ; 


dtCFL=CalcCFLdt2D(UserVar,RunInfo,CtrlVar,MUA,F);

fprintf("The time step used is dt=%f \t the CFL limit is %f \n",CtrlVar.dt,dtCFL)

end