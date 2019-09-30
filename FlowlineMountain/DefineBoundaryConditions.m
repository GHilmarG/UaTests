function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)

% fix vd along boundary

BCs.vdFixedNode=MUA.Boundary.Nodes ; BCs.vdFixedValue=BCs.vdFixedNode*0;



end


