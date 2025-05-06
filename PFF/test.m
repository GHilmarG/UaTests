function test
lm=UaLagrangeVariables ;
[UserVar,RunInfo,F,lm]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;


phiEmean=Nodes2EleMean(MUA.connectivity,F.phi);
UaPlots(CtrlVar,MUA,F,phiEmean,FigureTitle="phi Ele")

ElementsToBeDeactivated=phiEmean>0.95 ;
CtrlVar.UpdateMUAafterDeactivating=true;
[MUAnew,k,l]=DeactivateMUAelements(CtrlVar,MUA,ElementsToBeDeactivated) ;
Fnew=DeactivateF(CtrlVar,MUA,F,k) ;

BCsnew=BoundaryConditions;
BCsnew=DefineBoundaryConditions(UserVar,CtrlVar,MUAnew,Fnew,BCsnew) ;
lm=UaLagrangeVariables ;
[UserVar,RunInfo,Fnew,lm]= uv(UserVar,RunInfo,CtrlVar,MUAnew,BCsnew,Fnew,lm) ;



[xphi,yphi]=CalcMuaFieldsContourLine(CtrlVar,MUA,F.phi,0.9) ;
CtrlVar.QuiverSameVelocityScalingsAsBefore=true ;
UaPlots(CtrlVar,MUAnew,Fnew,Fnew.phi,FigureTitle="new",PlotUnderMesh=true,MeshColor="w") ; CM=cmocean('balanced',25,'pivot',0.5) ; colormap(CM);
figure ; PlotMuaMesh(CtrlVar,MUAnew);


CtrlVar.QuiverSameVelocityScalingsAsBefore=false ;
[cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="uv") ; 
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title("Velocity with damaged elements included")
f=gcf ; exportgraphics(f,"DamagedVel.pdf") ; saveas(f,"DamagedVel.fig")

[cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUAnew,Fnew,"-uv-",FigureTitle="uv new") ; 
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title("Velocity for damaged elements deactivated")
f=gcf ; exportgraphics(f,"DeactivatedVel.pdf") ; saveas(f,"DeactivatedVel.fig")

uDiff=Fnew.ub-F.ub(k) ; 
vDiff=Fnew.vb-F.vb(k) ; 

CtrlVar.QuiverSameVelocityScalingsAsBefore=true ;
[cbar,~,~,~,~,CtrlVar]=UaPlots(CtrlVar,MUAnew,Fnew,[uDiff vDiff],FigureTitle="uv diff") ; 
hold on ; plot(xphi/CtrlVar.PlotXYscale,yphi/CtrlVar.PlotXYscale,Color="r",LineWidth=2)
title("Velocity differences")
f=gcf ; exportgraphics(f,"DeactivatedDamagedDiffVel.pdf") ; saveas(f,"DeactivatedDamagedDiffVel.fig")

%title("$\sqrt{ \int  ((\Delta u)^2 + (\Delta v)^2) \; d \mathcal{A}}/\sqrt{ \int  (u^2 + v^2) \; d \mathcal{A}} $",Interpreter="latex")

DiffNorm=sqrt((uDiff'*MUAnew.M*uDiff+vDiff'*MUAnew.M*vDiff)) ;
SpeedNorm=sqrt(Fnew.ub'*MUAnew.M*Fnew.ub+Fnew.vb'*MUAnew.M*Fnew.vb);

dV=DiffNorm/SpeedNorm
end