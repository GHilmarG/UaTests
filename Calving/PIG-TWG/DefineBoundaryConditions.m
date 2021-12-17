function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)




switch UserVar.Region


    case "PIG"

        I=F.x(MUA.Boundary.Nodes) >-1650e3 & F.x(MUA.Boundary.Nodes) <-1580e3 & F.y(MUA.Boundary.Nodes) < -300e3 ;

    case "PIG-TWG"

        I=F.x(MUA.Boundary.Nodes) <-1605e3 ...
            & F.y(MUA.Boundary.Nodes) < -400e3 ;

end


BCs.vbFixedNode=MUA.Boundary.Nodes(~I);
BCs.ubFixedNode=MUA.Boundary.Nodes(~I);

% [BCs.ubFixedValue,BCs.vbFixedValue]=EricVelocities(CtrlVar,[x(Boundary.Nodes(I)) y(Boundary.Nodes(I))]);

BCs.ubFixedValue=BCs.ubFixedNode*0;
BCs.vbFixedValue=BCs.vbFixedNode*0;
%

%
%FindOrCreateFigure("BCs") ; PlotBoundaryConditions(CtrlVar,MUA,BCs);

end