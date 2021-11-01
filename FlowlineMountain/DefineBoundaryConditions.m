function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)

% fix vd along boundary

BCs.vdFixedNode=MUA.Boundary.Nodes ; 
BCs.vdFixedValue=MUA.Boundary.Nodes*0 ; 

BCs.vbFixedNode=MUA.Boundary.Nodes ; 
BCs.vbFixedValue=MUA.Boundary.Nodes*0 ; 

end


