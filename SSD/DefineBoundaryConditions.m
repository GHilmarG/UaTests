function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)


if UserVar.BCs=="-uv-"

    

    BoundaryNodes=false(MUA.Nnodes,1);
    BoundaryNodes(MUA.Boundary.Nodes)=true ; 

    Nodes=find(BoundaryNodes & F.GF.node>0.5) ; 

    BCs.ubFixedNode=Nodes; BCs.ubFixedValue=Nodes*0;
    BCs.vbFixedNode=Nodes; BCs.vbFixedValue=Nodes*0;


elseif UserVar.BCs=="-D-"



    BCs.hFixedNode=MUA.Boundary.Nodes ;
    BCs.hFixedValue=BCs.hFixedNode*0;

else

    error(" case not found ")

end




end