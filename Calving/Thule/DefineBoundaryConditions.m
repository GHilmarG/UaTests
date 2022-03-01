function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)





I=F.x(MUA.Boundary.Nodes) >-1650e3 & F.x(MUA.Boundary.Nodes) <-1580e3 & F.y(MUA.Boundary.Nodes) < -300e3 ; 


BCs.vbFixedNode=MUA.Boundary.Nodes(~I);
BCs.ubFixedNode=MUA.Boundary.Nodes(~I);

% [BCs.ubFixedValue,BCs.vbFixedValue]=EricVelocities(CtrlVar,[x(Boundary.Nodes(I)) y(Boundary.Nodes(I))]);

BCs.ubFixedValue=BCs.ubFixedNode*0;
BCs.vbFixedValue=BCs.vbFixedNode*0;
%

%
FindOrCreateFigure("BCs") ; PlotBoundaryConditions(CtrlVar,MUA,BCs);

end