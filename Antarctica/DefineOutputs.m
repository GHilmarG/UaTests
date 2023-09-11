function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)

if CtrlVar.InverseRun
    return
end


OutputFile=sprintf('./ResultsFiles/%010i-%s',round(100*CtrlVar.time),UserVar.OutputFile);

fprintf('UaOutputs: Saving data in %s \n',OutputFile)
save(OutputFile,'CtrlVar','UserVar','MUA','F','GF','RunInfo')

if CtrlVar.DefineOutputsInfostring=="Last call" && contains(UserVar.Plots,"-CreateFiguresInDefineOutputs-")
    %%
    xGL=[];
    yGL=[] ;
    GLgeo=[] ;
    x=MUA.coordinates(:,1);
    y=MUA.coordinates(:,2);
    
    
    FigMesh=FindOrCreateFigure("Mesh") ;
    PlotMuaMesh(CtrlVar,MUA) ;
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    xlabel('xps (km)') ; ylabel('yps (km)')
    
    FigSpeed=FindOrCreateFigure("Speed") ;
    speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,log10(speed));
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    title(cbar,"log10 (m/yr)",'interpreter','latex')
    title("Speed (logarithmic)",'interpreter','latex')
    xlabel('xps (km)') ; ylabel('yps (km)')
    
    FigVel=FindOrCreateFigure('calculated velocities') ;
    PlotBoundary(MUA.Boundary,MUA.connectivity,MUA.coordinates,CtrlVar,'k')
    hold on
    QuiverColorGHG(x,y,F.ub,F.vb,CtrlVar); axis equal ;
    title(sprintf("modelled horizontal velocities at t=%f",CtrlVar.time),'interpreter','latex') ;
    hold on ;  [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    xlabel('xps (km)') ; ylabel('yps (km)')
    
    FigC=FindOrCreateFigure('log(C)') ;
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,log10(F.C)) ;
    hold on
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    title("log(C)",'interpreter','latex')
    title(cbar,sprintf("$\\mathrm{m\\,kPa^{-%i} \\,yr^{-1}}$",F.n(1)),'interpreter','latex')
    
    FigA=FindOrCreateFigure('log(A)') ;
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,log10(F.AGlen)) ;
    hold on ;
    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r');
    title("log(A)",'interpreter','latex')
    title(cbar,sprintf("$\\mathrm{kPa^{-%i} \\,yr^{-1}}$",F.n(1)),'interpreter','latex')
    xlabel('xps (km)') ; ylabel('yps (km)')
    
end

return

end