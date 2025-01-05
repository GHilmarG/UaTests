

function dV=CompareDamageWithDeactivativation(UserVar,RunInfo,CtrlVar,MUA,BCs,F) 


%% check if deactivating "fully" damaged elements gives about the same solution
%
% On input F should have damaged sections where phi>0.9
%
% Here those elements are deactivated, and the uv solution recalculated for the resulting deactivated mesh.
%
% This is then compared to the solution over the initial mesh.
%
% The differences should, in general, be small as severely damaged elements are expected to behave as if they had been
% deactivated.
%
%
%%

lm=UaLagrangeVariables ;


%% This will not be needed if the uv solve has already been done ahead of the call.

[F.AGlen,F.rho]=ArhoPFF(CtrlVar,F.phi,F.rho0,F.rhow,F.AGlen0,F.n) ; 
[F.s,F.h]=sPFF(CtrlVar,F.S,F.b,F.rho,F.rhow,F.phi);  % redefine upper surface s, to reflect changes in effective density

%%
[F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow);

[UserVar,RunInfo,F,lm]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;  


phiEmean=Nodes2EleMean(MUA.connectivity,F.phi);
UaPlots(CtrlVar,MUA,F,phiEmean,FigureTitle="phi Ele")

ElementsToBeDeactivated=phiEmean>0.99 ;
CtrlVar.UpdateMUAafterDeactivating=true;
[MUAdeactivated,k,l]=DeactivateMUAelements(CtrlVar,MUA,ElementsToBeDeactivated) ;
Fdeactivated=DeactivateF(CtrlVar,MUA,F,k) ;
BCsdeactivated=DeactivateBoundaryConditions(UserVar,CtrlVar,MUA,MUAdeactivated,BCs,k,l) ;

lm=UaLagrangeVariables ;
% Fdeactivated=DefineF(UserVar,CtrlVar,MUAdeactivated);  % redefine 

[UserVar,RunInfo,Fdeactivated,lm]= uv(UserVar,RunInfo,CtrlVar,MUAdeactivated,BCsdeactivated,Fdeactivated,lm) ;



[xphi,yphi]=CalcMuaFieldsContourLine(CtrlVar,MUA,F.phi,0.99) ;
UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,Fdeactivated.phi,FigureTitle="new",PlotUnderMesh=true,MeshColor="w") ; CM=cmocean('balanced',25,'pivot',0.5) ; colormap(CM);

FindOrCreateFigure("MeshDeactivated") ; PlotMuaMesh(CtrlVar,MUAdeactivated);

CtrlVar.QuiverSameVelocityScalingsAsBefore=false ;
[cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,"-uv-",FigureTitle="uv deactivated") ; 
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title("Velocity for damaged elements deactivated")
% f=gcf ; exportgraphics(f,"DeactivatedVel.pdf") ; saveas(f,"DeactivatedVel.fig")do

CtrlVar.QuiverSameVelocityScalingsAsBefore=true ;
[cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="uv with damage") ; 
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title("Velocity with damaged elements included")
% f=gcf ; exportgraphics(f,"DamagedVel.pdf") ; saveas(f,"DamagedVel.fig")




CalcDiff="over all remaining nodes" ;
CalcDiff="over nodes not belonging to deactivated elements" ;


if CalcDiff=="over nodes not belonging to deactivated elements" 

    NodesOfDeactivatedElements=unique(MUA.connectivity(ElementsToBeDeactivated,:)) ;


    uDiff=zeros(MUA.Nnodes,1) ; vDiff=zeros(MUA.Nnodes,1) ;

    NodesNotBelonginToDeactivatedElements=setdiff(1:MUA.Nnodes,NodesOfDeactivatedElements);
    uDiff(NodesNotBelonginToDeactivatedElements)=Fdeactivated.ub(l(NodesNotBelonginToDeactivatedElements))-F.ub(NodesNotBelonginToDeactivatedElements);
    vDiff(NodesNotBelonginToDeactivatedElements)=Fdeactivated.vb(l(NodesNotBelonginToDeactivatedElements))-F.vb(NodesNotBelonginToDeactivatedElements) ;


    [cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUA,F,[uDiff vDiff],FigureTitle="uv diff") ;
    hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
    title("Velocity differences")


    CtrlVar.QuiverSameVelocityScalingsAsBefore=true ;
    dspeed=sqrt(uDiff.*uDiff+vDiff.*vDiff);
    [cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUA,F,dspeed,FigureTitle="diff speed") ;
    hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
    title("difference in speed")

    DiffNorm=sqrt((uDiff'*MUA.M*uDiff+vDiff'*MUA.M*vDiff)) ;
    SpeedNorm=sqrt(F.ub'*MUA.M*F.ub+F.vb'*MUA.M*F.vb);

    dV=DiffNorm/SpeedNorm ;


else

    uDiff=Fdeactivated.ub-F.ub(k) ;  vDiff=Fdeactivated.vb-F.vb(k) ;


    [cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,[uDiff vDiff],FigureTitle="uv diff") ;
    hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
    title("Velocity differences")


    CtrlVar.QuiverSameVelocityScalingsAsBefore=true ;
    dspeed=sqrt(uDiff.*uDiff+vDiff.*vDiff);
    [cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,dspeed,FigureTitle="diff speed") ;
    hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
    title("difference in speed")

    DiffNorm=sqrt((uDiff'*MUAdeactivated.M*uDiff+vDiff'*MUAdeactivated.M*vDiff)) ;
    SpeedNorm=sqrt(Fdeactivated.ub'*MUAdeactivated.M*Fdeactivated.ub+Fdeactivated.vb'*MUAdeactivated.M*Fdeactivated.vb);

    dV=DiffNorm/SpeedNorm ;


end

UaPlots(CtrlVar,MUAdeactivated,Fdeactivated,Fdeactivated.rho,FigureTitle="rho deactivated") ;
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)

UaPlots(CtrlVar,MUA,F,F.rho,FigureTitle="rho damaged") ;
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)


% f=gcf ; exportgraphics(f,"DeactivatedDamagedDiffVel.pdf") ; saveas(f,"DeactivatedDamagedDiffVel.fig")

%title("$\sqrt{ \int  ((\Delta u)^2 + (\Delta v)^2) \; d \mathcal{A}}/\sqrt{ \int  (u^2 + v^2) \; d \mathcal{A}} $",Interpreter="latex")





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