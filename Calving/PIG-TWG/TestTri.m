
%%
close all

load('PIG-TWG-RestartFile.mat','CtrlVarInRestartFile','MUA','F')
speed=sqrt(F.ub.*F.ub+F.vb.*F.vb);
Col=parula(1028);
figSpeed=FindOrCreateFigure("speed over surface mesh") ;
colormap(Col);
AspectRatio=50; 
PatchObject=PlotMeshScalarVariableAsSurface(CtrlVarInRestartFile,MUA,F.s,AspectRatio) ;
cbar=colorbar;
PatchObject.FaceVertexCData=speed;
PatchObject.EdgeColor="none";
title(cbar,["speed","(m/a)"],interpreter="latex")
xlabel("xps (km)",Interpreter="latex")
ylabel("yps (km)",Interpreter="latex")
zlabel("$s\, \mathrm{(m.a.s.l.)}$",Interpreter="latex")
% lighting phong ; lightangle(gca,-45,20);
camlight