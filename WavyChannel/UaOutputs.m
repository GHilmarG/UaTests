function UserVar=UaOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

v2struct(F);

time=CtrlVar.time; 

disp('helle')

plots='-ubvb-e-save-';
plots='-sbB-udvd-ubvb-ub-BasalStresses-';
plots='-BasalStresses-';

TRI=[];
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);


[uFS,vFS,wFS]=LinearizedFullStokesFlowSolutions(MUA,s,b,S,B,h,rho,AGlen,n,C,m);


if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if strcmp(CtrlVar.UaOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7 
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.UaOutputsInfostring,'Last call')==0
        %FileName=['ResultsFiles/',sprintf('%07i',round(100*time)),'-TransPlots-',CtrlVar.Experiment]; good for transient runs
        
        FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.UaOutputsCounter),'-TransPlots-',CtrlVar.Experiment];
        
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','MUA','time','s','b','S','B','h','u','v','dhdt','dsdt','dbdt','C','AGlen','m','n','rho','rhow','as','ab','GF')
        
    end
end

% only do plots at end of run
if ~strcmp(CtrlVar.UaOutputsInfostring,'Last call') ; return ; end

if contains(plots,'-BasalStresses-')

    [txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,GF,s,b,ub,vb,ud,vd);
    [tbx,tby,tb,beta2] = CalcBasalTraction(CtrlVar,MUA,ub,vb,C,m,GF); % returns nodal values
    [taux,tauy]=CalcDrivingStress(CtrlVar,MUA,rho,g,s,h);
    [udSIA,vdSIA]=uvSSHEET(CtrlVar,MUA,BCs,AGlen,n,rho,g,s,h);
    
%     figure
%     subplot(3,1,1) ; PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,tbx,CtrlVar) ; title('tbx tangential traction')
%     subplot(3,1,2) ; PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,txzb,CtrlVar) ; title('txzb basal shear stress')
%     subplot(3,1,3) ; PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,tx,CtrlVar) ; title('tx driving stress')
% 
%     figure
%     subplot(2,1,1) ; PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,txzb-tbx,CtrlVar) ; title('txzb-tbx basal shear stress')
%     subplot(2,1,2) ; PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,tx-tbx,CtrlVar) ; title('tx-tbx basal shear stress')
%     
    Fig=figure;
    subplot(4,1,1)
    [temp,I]=sort(x);
    plot(x(I),tbx(I),'r-+') ; hold on
    plot(x(I),txzb(I),'g-o') ; hold on
    plot(x(I),taux(I),'b-*') ; hold on
    plot(x(I),txx(I),'c-^') ; hold on
    plot(x(I),txzb(I)-taux(I),'m.-','LineWidth',3)
    %plot(x(I),txy(I),'-d') ; hold on
    %plot(x(I),tyy(I),'-d') ; hold on
    legend('tbx','txzb','driving stress','txx','txzb-driving stess')
    save TestSave tbx txzb taux txx tb I
    subplot(4,1,2)
    plot(x(I),ub(I)) ; hold on
    legend('ub')
    
    subplot(4,1,3)
    plot(x(I),ud(I),'-o') ; hold on
    plot(x(I),udSIA(I),'.-') ; hold on
    plot(x(I),ud-udSIA(I)) ; hold on
    legend('ud^+','udSIA','ud^+-udSIA')
    
    subplot(4,1,4)
    plot(x(I),h(I)/max(h) ); hold on
    legend('h')
    
    figure
    plot(x(I),b(I))
    hold on 
    plot(x(I),s(I))
    legend('b','s')
    axis equal tight
    %Fig.Position=[1114 821 777 855];
    
    figure ; plot(x(I),ud(I)) ; 
    hold on ; plot(x(I),udSIA(I)) ; legend('ud','uSIA')
    figure ; plot(x(I),txzb(I)) ; 
    hold on ; plot(x(I),taux(I)); legend('txzb','taux')
    
end

if contains(plots,'-sbB-')
    figure(5)
    hold off
    if isempty(TRI) ;  TRI = delaunay(x,y); end
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,s,'EdgeColor','none') ; hold on
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,b,'EdgeColor','none') ;
    trisurf(TRI,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,B,'EdgeColor','none') ;
    view(50,20); lightangle(-45,30) ; lighting phong ;
    xlabel('y') ; ylabel('x') ;
    colorbar ; title(colorbar,'(m)')
    hold on
    
    title(sprintf('sbB at t=%#5.1g ',time))
    axis equal ; tt=daspect ; daspect([mean(tt(1)+tt(2)) mean(tt(1)+tt(2)) tt(3)*CtrlVar.PlotXYscale]); axis tight
    hold off
end


if contains(plots,'-ubvb-')
    % plotting horizontal velocities
    figure
    N=1;
    speed=sqrt(ub.*ub+vb.*vb);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    %CtrlVar.VelColorMap='hot';
    CtrlVar.RelativeVelArrowSize=10;
    QuiverColorGHG(x(1:N:end),y(1:N:end),ub(1:N:end),vb(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ub,vb) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if contains(plots,'-udvd-')
    % plotting horizontal velocities
    figure
    N=1;
    speed=sqrt(ud.*ud+vd.*vd);
    CtrlVar.MinSpeedWhenPlottingVelArrows=0; CtrlVar.MaxPlottedSpeed=max(speed); %CtrlVar.VelPlotIntervalSpacing='log10';
    CtrlVar.RelativeVelArrowSize=10;
    %CtrlVar.VelColorMap='hot';
    QuiverColorGHG(x(1:N:end),y(1:N:end),ud(1:N:end),vd(1:N:end),CtrlVar);
    hold on
    title(sprintf('(ud,vd) t=%-g ',time)) ; xlabel('xps (km)') ; ylabel('yps (km)')
    axis equal tight
    
end

if contains(plots,'-e-')
    % plotting effectiv strain rates
    
    % first get effective strain rates, e :
    [etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,u,v,AGlen,n);
    % all these variables are are element variables defined on integration points
    % therfore if plotting on nodes, must first project these onto nodes
    eNod=ProjectFintOntoNodes(MUA,e);
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,eNod,CtrlVar)    ;
    title(sprintf('e t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end

if contains(plots,'-ub-')
    
    figure
    [FigHandle,ColorbarHandel,tri]=PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,ub,CtrlVar)    ;
    title(sprintf('ub t=%-g ',time)) ; xlabel('x (km)') ; ylabel('y (km)')
    
end


end
