%%

load TestSave


%%

tic
[xc,yc,LSF]=CalvingFrontLevelSetGeometricalInitialisation(CtrlVar,MUA,Xc,Yc,LSF,plot=false,ResampleCalvingFront=false,method="EleEdges");
toc

% Evaluate distance between prescribed calving front [Xc Yc] and the resulting calving front [xc yc], geometries.
xy=[Xc Yc ; nan nan ; xc yc];
ShapeDifference=polyshape(xy);
A=area(ShapeDifference);

ShapeInput=polyshape([Xc Yc]);
ShapeOutput=polyshape([xc yc]);

L=perimeter(ShapeInput); 
MeanDeviation=A/L;

FindOrCreateFigure("Shape Difference 2") ;
plot(ShapeDifference) ; axis equal

fprintf("Area/Length %f (km)\n ",MeanDeviation/1000)

%%



tic
[xc,yc,LSF]=CalvingFrontLevelSetGeometricalInitialisation(CtrlVar,MUA,Xc,Yc,LSF,plot=false,ResampleCalvingFront=true,method="InputPoints");
toc

xy=[Xc Yc ; nan nan ; xc yc];
ShapeDifference=polyshape(xy);
A=area(ShapeDifference);

ShapeInput=polyshape([Xc Yc]);
ShapeOutput=polyshape([xc yc]);

L=perimeter(ShapeInput); 
MeanDeviation=A/L;

FindOrCreateFigure("Shape Difference 2") ;
plot(ShapeDifference) ; axis equal

fprintf("Area/Length %f (km)\n ",MeanDeviation/1000)
