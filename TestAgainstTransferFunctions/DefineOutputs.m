function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


persistent iCounter Diagnostics



         

plots='-ubvb-e-save-';
plots='-sbB-udvd-ubvb-ub-';
plots='-ubvb-stresses-';
plots='-flowline-';


x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);
GLgeo=[];
xGL=[];
yGL=[];

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



if contains(plots,'-flowline-')
    
    [sAna,uAna,vAna,wAna]=TransferFunctionsGauss(UserVar,CtrlVar,MUA,F) ;
    
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
uError= sqrt(((du'*MUA.M* du)))/MUA.Area; 
vError= sqrt(((dv'*MUA.M* dv)))/MUA.Area; 

if isempty(Diagnostics)
    Diagnostics.time=nan(10000,1);
    Diagnostics.sNumerical=nan(10000,1);
    Diagnostics.sAnalytical=nan(10000,1);
    Diagnostics.sError=nan(10000,1);
    iCounter=0;
end

iCounter=iCounter+1;
Diagnostics.time(iCounter)=F.time; 
Diagnostics.sNumerical(iCounter)=sNumericalNorm; 
Diagnostics.sAnalytical(iCounter)=sAnalyticalNorm; 
Diagnostics.sError(iCounter)=sError; 


FindOrCreateFigure("diagnostics")
plot(Diagnostics.time,Diagnostics.sNumerical,"-or",DisplayName="Numerical")
hold on 
plot(Diagnostics.time,Diagnostics.sAnalytical,"-xb",DisplayName="Analytical")
plot(Diagnostics.time,Diagnostics.sError,"-sm",DisplayName="Error")
xlabel("time (yr)")
title("Norm of surface perturbances")
lg=legend;


%%

UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="bedrock")
title("bedrock")

UaPlots(CtrlVar,MUA,F,F.C,FigureTitle="C")
title("basal slipperiness")

UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="numerical velocities")
title("numerical velocities ")


UaPlots(CtrlVar,MUA,F,[uAna vAna],FigureTitle="analytical velocities")
title("numerical velocities ")

UaPlots(CtrlVar,MUA,F,[F.ub-uAna F.vb-vAna],FigureTitle="numerical - analytical velocities")
title("numerical - analytical velocities ")

FindOrCreateFigure("s diff")
ts=tiledlayout(3,1) ;
nexttile
UaPlots(CtrlVar,MUA,F,F.s-UserVar.hmean,CreateNewFigure=false) ; 
title("Surface perturbations (numerical)")
nexttile
UaPlots(CtrlVar,MUA,F,sAna-UserVar.hmean,CreateNewFigure=false) ; 
title("Surface perturbations (analytical)")
nexttile
UaPlots(CtrlVar,MUA,F,F.s-sAna,CreateNewFigure=false) ; 
title("numerical surface - analytical surface ")




end