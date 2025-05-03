function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)


persistent MeshBoundaryCoordinates FuMeas FvMeas


% Since the mesh does not change in this run, I only need to define the boundary conditions once.



if isempty(FuMeas)

    if contains(UserVar.RunType,"-BCVel-")

        fprintf('Loading interpolants for surface velocity data: %-s ',UserVar.SurfaceVelocityInterpolant)
        load(UserVar.SurfaceVelocityInterpolant,'FuMeas','FvMeas','FerrMeas')
        fprintf(' done.\n')
    else
        FuMeas=nan; FvMeas=nan; 
    end
end


MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar);
I= DistanceToLineSegment([F.x(MUA.Boundary.Nodes) F.y(MUA.Boundary.Nodes)],MeshBoundaryCoordinates,[],1000);


BCs.vbFixedNode=MUA.Boundary.Nodes(I);
BCs.ubFixedNode=MUA.Boundary.Nodes(I);

% [BCs.ubFixedValue,BCs.vbFixedValue]=EricVelocities(CtrlVar,[x(Boundary.Nodes(I)) y(Boundary.Nodes(I))]);



if contains(UserVar.RunType,"-BCVel-")
    
    BCs.ubFixedValue=FuMeas(F.x(BCs.ubFixedNode),F.y(BCs.ubFixedNode)) ;
    BCs.vbFixedValue=FvMeas(F.x(BCs.vbFixedNode),F.y(BCs.vbFixedNode)) ;
    
else
    BCs.ubFixedValue=BCs.ubFixedNode*0;
    BCs.vbFixedValue=BCs.vbFixedNode*0;
end


%% Check if there are any nodes were velocies are oriented into the domain
% Only select those nodes which are afloat.
%
% Also need to not included any nodes that have velocity or thickness constraints
% applied already.

InfluxNodes=InfluxOutfluxNodes(CtrlVar,MUA,F,plot=true,afloat=true,MinSpeed=100) ;   % Find boundary nodes with velcity pointing into the domain that are afloat
InNodes=setdiff(InfluxNodes,[BCs.ubFixedNode;BCs.vbFixedNode]);                      % exclude nodes for which vel BCs have been applied to
BCs.hFixedNode=InNodes ; BCs.hFixedValue=BCs.hFixedNode*0+CtrlVar.ThickMin ;

% PlotBoundaryConditions(CtrlVar,MUA,BCs) ;





return




end