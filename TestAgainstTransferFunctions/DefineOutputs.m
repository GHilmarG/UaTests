function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


persistent iCounter Diagnostics



         

plots='-ubvb-e-save-';
plots='-sbB-udvd-ubvb-ub-';
plots='-ubvb-stresses-';
plots='-flowline-';
plots="";


if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if strcmp(CtrlVar.DefineOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7 
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
        %FileName=['ResultsFiles/',sprintf('%07i',round(100*time)),'-TransPlots-',CtrlVar.Experiment]; good for transient runs
        
        FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.DefineOutputsCounter),'-TransPlots-',CtrlVar.Experiment];
        
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,"CtrlVar","MUA","F")
        
    end
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

hmean=UserVar.hmean;


sNumericalNorm=sqrt((((F.s-hmean)'*MUA.M* (F.s-hmean))))/MUA.Area; 
sAnalyticalNorm=sqrt((((sAna-hmean)'*MUA.M* (sAna-hmean))))/MUA.Area; 
sError= sqrt(((ds'*MUA.M* ds)))/MUA.Area; 


SpeedNumerical=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
SpeedAnalytical=sqrt(uAna.*uAna+vAna.*vAna) ;
SpeedError=sqrt(du.*du+dv.*dv); 

SpeedNumericalNorm=sqrt(((SpeedNumerical'*MUA.M* SpeedNumerical)))/MUA.Area; 
SpeedAnalyticalNorm=sqrt(((SpeedAnalytical'*MUA.M* SpeedAnalytical)))/MUA.Area; 

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
Diagnostics.sNumerical(iCounter)=sNumericalNorm; 
Diagnostics.sAnalytical(iCounter)=sAnalyticalNorm; 
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
lg=legend(Location="northwest");

%%
FindOrCreateFigure("Speed Norms")
plot(Diagnostics.time,Diagnostics.SpeedNumerical,"-or",DisplayName="Numerical speed")
hold on 
plot(Diagnostics.time,Diagnostics.SpeedAnalytical,"-xb",DisplayName="Analytical speed")
plot(Diagnostics.time,Diagnostics.SpeedError,"-sm",DisplayName="Error in speed")
xlabel("time (yr)")
title("Norms of speed")
lg=legend(Location="northwest");
%%

UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="bedrock")
title("bedrock")
UaPlots(CtrlVar,MUA,F,F.C,FigureTitle="C")
title("basal slipperiness")

% uv velocities
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

% surface perturbations 
FindOrCreateFigure("s diff")
ts=tiledlayout(1,3) ;
nexttile
UaPlots(CtrlVar,MUA,F,F.s-UserVar.hmean,CreateNewFigure=false) ; 
title("Surface perturbations (numerical)")
nexttile
UaPlots(CtrlVar,MUA,F,sAna-UserVar.hmean,CreateNewFigure=false) ; 
title("Surface perturbations (analytical)")
nexttile
UaPlots(CtrlVar,MUA,F,F.s-sAna,CreateNewFigure=false) ; 
title("numerical surface - analytical surface ")
ts.Padding="tight" ; ts.TileSpacing="compact" ; 



end