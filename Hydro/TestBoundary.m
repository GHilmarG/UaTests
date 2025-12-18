

load("..\Calving\PIG-TWG\MeshFile20km-PIG-TWG.mat","MUA")
CtrlVar=Ua2D_DefaultParameters();
%%

figb3=FindOrCreateFigure("boundary3") ; clf(figb3)

PlotMuaMesh(CtrlVar,MUA)
hold on
plot(MUA.Boundary.x/CtrlVar.PlotXYscale,MUA.Boundary.y/CtrlVar.PlotXYscale,"-or")

% x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
% plot(x(MUA.Boundary.Nodes(:,1)) /CtrlVar.PlotXYscale,y(MUA.Boundary.Nodes(:,1))/CtrlVar.PlotXYscale,"*b")

plot(MUA.Boundary.Coordinates/CtrlVar.PlotXYscale,MUA.Boundary.Coordinates/CtrlVar.PlotXYscale,'--+g',LineWidth=2)

%%

CtrlVar.TriNodes=6;  MUA=UpdateMUA(CtrlVar,MUA);


figb6=FindOrCreateFigure("boundary6") ; clf(figb6)

PlotMuaMesh(CtrlVar,MUA)
hold on
%plot(MUA.Boundary.x/CtrlVar.PlotXYscale,MUA.Boundary.y/CtrlVar.PlotXYscale,"-or")

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

%plot(x(MUA.Boundary.Nodes(:,1)) /CtrlVar.PlotXYscale,y(MUA.Boundary.Nodes(:,1))/CtrlVar.PlotXYscale,"^b")

%plot(x(MUA.Boundary.Edges)'/CtrlVar.PlotXYscale,y(MUA.Boundary.Edges)'/CtrlVar.PlotXYscale,'-*g',LineWidth=2)



xx=x(MUA.Boundary.Edges(:,2:end))'; xx=xx(:) ;
yy=y(MUA.Boundary.Edges(:,2:end))'; yy=yy(:) ;

plot(MUA.Boundary.Coordinates(:,1)/CtrlVar.PlotXYscale,MUA.Boundary.Coordinates(:,2)/CtrlVar.PlotXYscale,'--+b',LineWidth=2)



%%

CtrlVar.TriNodes=10;  MUA=UpdateMUA(CtrlVar,MUA);


figb10=FindOrCreateFigure("boundary10") ; clf(figb10)

PlotMuaMesh(CtrlVar,MUA)
hold on
%plot(MUA.Boundary.x/CtrlVar.PlotXYscale,MUA.Boundary.y/CtrlVar.PlotXYscale,"-or")

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

%plot(x(MUA.Boundary.Nodes(:,1)) /CtrlVar.PlotXYscale,y(MUA.Boundary.Nodes(:,1))/CtrlVar.PlotXYscale,"^b")

%plot(x(MUA.Boundary.Edges)'/CtrlVar.PlotXYscale,y(MUA.Boundary.Edges)'/CtrlVar.PlotXYscale,'-*g',LineWidth=2)



xx=x(MUA.Boundary.Edges(:,2:end))'; xx=xx(:) ;
yy=y(MUA.Boundary.Edges(:,2:end))'; yy=yy(:) ;

plot(MUA.Boundary.Coordinates(:,1)/CtrlVar.PlotXYscale,MUA.Boundary.Coordinates(:,2)/CtrlVar.PlotXYscale,'--+b',LineWidth=2)













