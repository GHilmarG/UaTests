

function [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)



% all velocitiews along boundary set to zero


BCs.ubFixedNode=MUA.Boundary.Nodes ; BCs.ubFixedValue=BCs.ubFixedNode*0 ;
BCs.vbFixedNode=MUA.Boundary.Nodes ; BCs.vbFixedValue=BCs.vbFixedNode*0 ;




end
