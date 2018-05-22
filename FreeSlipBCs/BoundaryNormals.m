%%


% to which element does a boundary node belong?

% all free elements (boundary elements)

load Ua2D_Restartfile

%%
clc
OneBoundaryNode=MUA.Boundary.Nodes(22);
OneBoundaryNode=37;

OneBoundaryNode

[M] = AdjacentNodes(MUA.connectivity) ;

ConnectedNodes=find(M(OneBoundaryNode,:));

NeighbouringBoundaryNodes=intersect(ConnectedNodes,MUA.Boundary.Nodes)

if numel(NeighbouringBoundaryNodes)~=2 
    fprintf(' Given boundary nodes appears not to be a boundary node as it does not have exactly two neighbouring boundary nodes \n')
end


E=FindAllElementsContainingGivenNodes(MUA.connectivity,NeighbouringBoundaryNodes);

% it is possible that this is EleA and EleB are the same element, and just different sections of the boundary
EleA=E{NeighbouringBoundaryNodes(1)};
EleB=E{NeighbouringBoundaryNodes(2)};




IAa=find(MUA.connectivity(EleA,:)==NeighbouringBoundaryNodes(1));
IAb=find(MUA.connectivity(EleA,:)==OneBoundaryNode);
%if (IAb-IAb)~=1 ; temp=IAa ; IAa=IAb ; IAb=temp ; end

IBa=find(MUA.connectivity(EleB,:)==NeighbouringBoundaryNodes(2));
IBb=find(MUA.connectivity(EleB,:)==OneBoundaryNode);

% I know that IAb and IAb are two nodes of element EleA,
% I now need to make sure that they are connected in a `directed sense'
% i.e. that IAb is next node to IAb in a clockwise sense
% need to write:
% [NodeA,NodeB]=DirectedNeighbours(connectivity,EleA,NodeA,NodeB)

MUA.connectivity(EleA,:)
[IAa IAb]

MUA.connectivity(EleB,:)
[IBa IBb]


%%
% another approach
%FEmeshCPT=CreateFEmeshCornerPointTriangulation(MUA.connectivity,MUA.coordinates);
%FreeEdges=freeBoundary(FEmeshCPT);

[nx,ny,xn,yn,Nx,Ny] = CalcEdgeAndNodalNormals(MUA.connectivity,MUA.coordinates,MUA.Boundary.Edges);


QuiverColorGHG(MUA.coordinates(MUA.Boundary.Nodes,1),MUA.coordinates(MUA.Boundary.Nodes,2),...
    Nx(MUA.Boundary.Nodes),Ny(MUA.Boundary.Nodes),CtrlVarInRestartFile);










