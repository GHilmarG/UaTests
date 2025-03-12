function dV=CompareThinIceWithDeactivation(UserVar,RunInfo,CtrlVar,MUA,BCs,F) 


%% check if deactivating "fully" ThinIce elements gives about the same solution
%
% On input F should have ThinIce sections where phi>0.9
%
% Here those elements are deactivated, and the uv solution recalculated for the resulting deactivated mesh.
%
% This is then compared to the solution over the initial mesh.
%
% The differences should, in general, be small as severely ThinIce elements are expected to behave as if they had been
% deactivated.
%
%
%%


% here I use the field F.phi to determine where to deactivate or create a region of very thin ice.

% TestCase="Eq. water column" ;
% TestCase="all water" ;
% TestCase="thin ice"; 

switch UserVar.TestCase

    case "thin ice"  % rifts are thin ice above inviscid water

        % As long as the ice is very thin, there is no difference between damage and deactivation and A and rho can have any values
        % over the thin ice region. 
        % 
        % This is also the case when using the previous dint calculation as used in U2024a and
        % earlier!
        %
        % However, when using Ua2024a, there is a significant difference between deactivated without any density variations, 
        % and deactivated with density variations. This is due to sharp density gradients in the border elements, and the fact
        % that dint was based on 
        % 
        %   H^+ (Sint-bint) 
        %
        % and bint had been calculated based on flotation at the nodes. Interpolation within elements caused the term 
        %
        %   hint rhoint - dint rhow 
        %
        % not to be zero at all integration points.
        %
        % Calculating dint instead as
        %
        % (1-Gint) hint rhoint/rhow + G h^{+}
        %
        % ensures that now 
        %
        %   hint rhoint - dint rhow = 0
        %
        % when afloat, ie when (1-Gint)=1 ;
        %

        ThinIceNodes=F.phi>0.99 ;

        F.h(ThinIceNodes)=CtrlVar.ThickMin ;
        F.rho(ThinIceNodes)=F.rho(ThinIceNodes)/100;
        F.AGlen(ThinIceNodes)=F.AGlen(ThinIceNodes)*1000;

    case "Eq. water column"  % rifts are viscous water columns

        % send density within "crack" to that of ocean, and upper surface to that of ocean
        ThinIceNodes=F.phi>0.99 ;

        % gphi=DegradationFunction(CtrlVar,F.phi) ;
        % F.AGlen=F.AGlen./(gphi.^F.n);

        F.AGlen(ThinIceNodes)=F.AGlen(ThinIceNodes)*1e20;
        F.rho(ThinIceNodes)=F.rho(ThinIceNodes)*0+F.rhow ;

        F.s(ThinIceNodes)=F.S(ThinIceNodes); 
        F.h=F.s-F.b ; 

    case "all water"  % simple test case where ALL elements are 'water'

        %
        % as expected, all velocities are zero, for all Ua versions
        %
        %
        F.rho=F.rho*0+F.rhow; 
        F.s=F.S;
        F.h=F.s-F.b ; 

        

    case "PFF"


        [F.AGlen,F.rho]=ArhoPFF(CtrlVar,F.phi,F.rho0,F.rhow,F.AGlen0,F.n) ;
        [F.s,F.h]=sPFF(CtrlVar,F.S,F.b,F.rho,F.rhow,F.phi);  % redefine upper surface s, and ice thickness, to reflect changes in effective density

    otherwise

        error("case not found")

end

[F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow);


lm=UaLagrangeVariables ;
[UserVar,RunInfo,F,lm]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;  

UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="b") ; title("b")
UaPlots(CtrlVar,MUA,F,F.AGlen,FigureTitle="A") ; set(gca,'ColorScale','log')

phiEmean=Nodes2EleMean(MUA.connectivity,F.phi);
UaPlots(CtrlVar,MUA,F,phiEmean,FigureTitle="phi Ele")

ElementsToBeDeactivated=phiEmean>0.99 ;
CtrlVar.UpdateMUAafterDeactivating=true;
[MUAdeactivated,k,l]=DeactivateMUAelements(CtrlVar,MUA,ElementsToBeDeactivated) ;
Fdeactivated=DeactivateF(CtrlVar,MUA,F,k) ;
BCsdeactivated=DeactivateBoundaryConditions(UserVar,CtrlVar,MUA,MUAdeactivated,BCs,k,l) ;

lm=UaLagrangeVariables ;


[UserVar,RunInfo,Fdeactivated,lm]= uv(UserVar,RunInfo,CtrlVar,MUAdeactivated,BCsdeactivated,Fdeactivated,lm) ;



[xphi,yphi]=CalcMuaFieldsContourLine(CtrlVar,MUA,F.phi,0.99) ;
UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,Fdeactivated.phi,FigureTitle="new",PlotUnderMesh=true,MeshColor="w") ; CM=cmocean('balanced',25,'pivot',0.5) ; colormap(CM);

FindOrCreateFigure("MeshDeactivated") ; PlotMuaMesh(CtrlVar,MUAdeactivated);
CtrlVar.QuiverSameVelocityScalingsAsBefore=false ;

% CtrlVar.QuiverColorSpeedLimits=[0 250];     
[cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,"-uv-",FigureTitle="uv deactivated") ; 
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title("Velocity for ThinIce elements deactivated "+UserVar.TestCase)
% f=gcf ; exportgraphics(f,"DeactivatedVel.pdf") ; saveas(f,"DeactivatedVel.fig")do

CtrlVar.QuiverSameVelocityScalingsAsBefore=true ;
[cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="uv with damage") ; 
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title("Velocity with ThinIce elements included "+UserVar.TestCase)



CtrlVar.QuiverSameVelocityScalingsAsBefore=false ;
CtrlVar.MaxPlottedSpeed=[] ;
CtrlVar.MinPlottedSpeed=[] ;
CtrlVar.QuiverColorSpeedLimits=[];

% f=gcf ; exportgraphics(f,"ThinIceVel.pdf") ; saveas(f,"ThinIceVel.fig")


% UaPlots(CtrlVar,MUA,F,F.rho,FigureTitle="rho full mesh "+UserVar.TestCase)
% UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,Fdeactivated.rho,FigureTitle="rho deactivated mesh")
% 
% cbar=UaPlots(CtrlVar,MUA,F,F.AGlen,FigureTitle="A full mesh") ; set(gca,'ColorScale','log') ; title("$A$",Interpreter="latex") ; title(cbar,"$A$",Interpreter="latex")
% cbar=UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,Fdeactivated.AGlen,FigureTitle="A deactivated mesh") ; set(gca,'ColorScale','log') ; title("$A$",Interpreter="latex") ; title(cbar,"$A$",Interpreter="latex")
% 


CalcDiff="over all remaining nodes" ;
CalcDiff="over nodes not belonging to deactivated elements" ;


if CalcDiff=="over nodes not belonging to deactivated elements" 

    NodesOfDeactivatedElements=unique(MUA.connectivity(ElementsToBeDeactivated,:)) ;
    NodesNotBelongingToDeactivatedElements=setdiff(1:MUA.Nnodes,NodesOfDeactivatedElements);

    uDiff=zeros(MUA.Nnodes,1) ; vDiff=zeros(MUA.Nnodes,1) ;
    uDiff(NodesNotBelongingToDeactivatedElements)=Fdeactivated.ub(l(NodesNotBelongingToDeactivatedElements))-F.ub(NodesNotBelongingToDeactivatedElements);
    vDiff(NodesNotBelongingToDeactivatedElements)=Fdeactivated.vb(l(NodesNotBelongingToDeactivatedElements))-F.vb(NodesNotBelongingToDeactivatedElements) ;


    dspeed=sqrt(uDiff.*uDiff+vDiff.*vDiff);

    CtrlVar.QuiverSameVelocityScalingsAsBefore=false ;
    CtrlVar.MaxPlottedSpeed=[] ;
    CtrlVar.MinPlottedSpeed=[] ;
    CtrlVar.QuiverColorSpeedLimits=[];

    [cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUA,F,[uDiff vDiff],FigureTitle="uv diff") ;
    hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
    title("Velocity differences deactivated/damaged "+UserVar.TestCase)


    
   
    [cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUA,F,dspeed,FigureTitle="diff speed") ;
    hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
    title("difference in speed deactivated/damated "+UserVar.TestCase)

    DiffNorm=sqrt((uDiff'*MUA.M*uDiff+vDiff'*MUA.M*vDiff)) ;
    SpeedNorm=sqrt(F.ub'*MUA.M*F.ub+F.vb'*MUA.M*F.vb);

    dV=DiffNorm/SpeedNorm ;


else

    uDiff=Fdeactivated.ub-F.ub(k) ;  vDiff=Fdeactivated.vb-F.vb(k) ;


    CtrlVar.QuiverSameVelocityScalingsAsBefore=false ;
    CtrlVar.MaxPlottedSpeed=[] ;
    CtrlVar.MinPlottedSpeed=[] ;
    CtrlVar.QuiverColorSpeedLimits=[];
    [cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,[uDiff vDiff],FigureTitle="uv diff") ;
    hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
    title("Velocity differences deactivated/damaged "+UserVar.TestCase)



    dspeed=sqrt(uDiff.*uDiff+vDiff.*vDiff);
    [cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,dspeed,FigureTitle="diff speed") ;
    hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
    title("difference in speed")

    DiffNorm=sqrt((uDiff'*MUAdeactivated.M*uDiff+vDiff'*MUAdeactivated.M*vDiff)) ;
    SpeedNorm=sqrt(Fdeactivated.ub'*MUAdeactivated.M*Fdeactivated.ub+Fdeactivated.vb'*MUAdeactivated.M*Fdeactivated.vb);

    dV=DiffNorm/SpeedNorm ;


end

% UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,Fdeactivated.rho,FigureTitle="rho deactivated "+UserVar.TestCase) ;
% hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
% 
% UaPlots(CtrlVar,MUA,F,F.rho,FigureTitle="rho ThinIce") ;
% hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
% 
% UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,Fdeactivated.s,FigureTitle="s deactivated") ;
% hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
% 
% UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s ThinIce") ;
% hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)

% f=gcf ; exportgraphics(f,"DeactivatedThinIceDiffVel.pdf") ; saveas(f,"DeactivatedThinIceDiffVel.fig")

%title("$\sqrt{ \int  ((\Delta u)^2 + (\Delta v)^2) \; d \mathcal{A}}/\sqrt{ \int  (u^2 + v^2) \; d \mathcal{A}} $",Interpreter="latex")

% save("ThinIceOnlyDeactivated.mat","MUAdeactivated","Fdeactivated")



[etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,F.ub,F.vb,F.AGlen,F.n); % returns integration point values

UaPlots(CtrlVar,MUA,F,e,FigureTitle="effective strain rates at int. points") ; set(gca,'ColorScale','log') ; 

return
%% deviatoric stresses : This takes some time
[xphi,yphi]=CalcMuaFieldsContourLine(CtrlVar,MUA,F.phi,0.99) ;
[~,~,txx,tyy,txy]=CalcNodalStrainRatesAndStresses(CtrlVar,[],MUA,F) ;
[X,Y]=ndgrid(linspace(min(F.x),max(F.x),80),linspace(min(F.y),max(F.y),80));
I=nearestNeighbor(MUA.TR,[X(:) Y(:)]);  % find nodes within computational grid closest to the regularly shape X and Y grid points.
fstress=FindOrCreateFigure("dev stresses") ; clf(fstress)
scale=1e-1;

 
iphi=F.phi>0.99 ;
txx(iphi)=nan;
txy(iphi)=nan;
tyy(iphi)=nan;

PlotTensor(F.x(I)/CtrlVar.PlotXYscale,F.y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
hold on ; 
plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
PlotMuaBoundary(CtrlVar,MUA,'k') ; axis equal



end