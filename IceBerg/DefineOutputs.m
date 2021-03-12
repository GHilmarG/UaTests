function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


time=CtrlVar.time; 
  

% plots='-ubvb-e-save-';
% plots='-sbB-udvd-ubvb-ub-ub(x)-';
plots='-plot-';

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
if contains(plots,'-plot-')
    

    
    FigName='DefineOutputs';
    fig=FindOrCreateFigure(FigName);

    subplot(2,2,1)
    hold off
    PlotMeshScalarVariable(CtrlVar,MUA,F.h); title(sprintf('h at t=%g',time))
    
    
    subplot(2,2,2)
    hold off
%     speed=sqrt(F.ub.*F.ub+F.vb.*F.vb);
%     PlotMeshScalarVariable(CtrlVar,MUA,speed); title(sprintf('speed at t=%g',time))
%     caxis([min(speed) max(speed)])
%    
    N=1;
    QuiverColorGHG(x(1:N:end),y(1:N:end),F.ub(1:N:end),F.vb(1:N:end),CtrlVar);
    hold on ;
    PlotMuaBoundary(CtrlVar,MUA,'b') 
    title(sprintf('velocity at t=%g',time))
    
    subplot(2,2,3)
    hold off
    PlotMeshScalarVariable(CtrlVar,MUA,F.dhdt);   title(sprintf('dhdt at t=%g',time))
    
    
    
    subplot(2,2,4);
    hold off
    PlotBoundaryConditions(CtrlVar,MUA,BCs,'k');
    axis tight
    
%     subplot(2,2,5);
%     hold off
%     I=abs(MUA.coordinates(:,2))<1000;
%     
%     plot(MUA.coordinates(I,1)/1000,F.h(I),'o')
%     xlabel('x (km)') ; ylabel('h (m)')
%     title('Ice thickness profile along the medial line')
%     
%     
%     subplot(3,2,6);
%     hold off
%     
%     [txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e]=CalcNodalStrainRatesAndStresses(CtrlVar,UserVar,MUA,F);
%     N=10;
%     
%     [X,Y]=ndgrid(linspace(min(x),max(x),N),linspace(min(y),max(y),N));
%     I=nearestNeighbor(MUA.TR,[X(:) Y(:)]);  % find nodes within computational grid closest to the regularly spaced X and Y grid points.
%     
%     scale=1e-3;
%     PlotTensor(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
%     hold on
%     PlotMuaBoundary(CtrlVar,MUA,'k')
%     
%     axis equal
%     
%     title(' Deviatoric stresses ' )
%     
    
    
end

 