function TestLevelSetPlots(CtrlVar,UserVar,MUA,F)


persistent LSFlast timelast

fig=FindOrCreateFigure("1d Profile");

hold off ;

yyaxis left ;

plot(F.x/1000,F.s,'.') ;
hold on ; plot(F.x/1000,F.b,'.') ;
ylabel("$s(x)\,\mathrm{and}\; b(x)\;(\mathrm{m/yr})$","interpreter","latex")
yyaxis right ; hold off
plot(F.x/1000,F.ub,'o')
hold on ; plot(F.x/1000,-F.c,'.c')
ylabel("$u(x) \hbox{and} c(x) \,\mathrm{(m/yr)}$","interpreter","latex")
title(sprintf('time %f ',CtrlVar.time))
legend('$s$','$b$','$u_b$','$-c$','interpreter','latex')
hold off


fig=FindOrCreateFigure("Geometry and level set");

hold off ;

yyaxis left ;

plot(MUA.coordinates(:,1)/1000,F.s,'.') ;
hold on ; plot(F.x/1000,F.b,'.') ;
ylabel("$s(x)\,\mathrm{and}\; b(x)\;(\mathrm{m/yr})$","interpreter","latex")
yyaxis right ; hold off
plot(F.x/1000,F.LSF/1000,'.')
hold on
plot(xlim,[0 0],'-r')
ylabel("$\varphi/1000$","interpreter","latex")
title(sprintf('time %f ',CtrlVar.time))
legend('$s$','$b$','$\varphi$','interpreter','latex')
hold off

fig=FindOrCreateFigure("Mesh and level set");

hold off
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,F.LSF) ;
hold on
PlotMuaMesh(CtrlVar,MUA) ;
title(cbar,'LSF')



if numel(LSFlast) == numel(F.LSF)
    fig=FindOrCreateFigure("change in LSF");
    plot(F.x/1000,(F.LSF-LSFlast)/(CtrlVar.time-timelast)/1000,'.') ;
    xlabel("x (km)","interpreter","latex")
    ylabel("$d\varphi/dt$ (km/yr)","interpreter","latex")
    title(sprintf("time=%f",CtrlVar.time),"interpreter","latex");
end


LSFlast=F.LSF ; timelast=CtrlVar.time ;

end
