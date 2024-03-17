function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,ubFixedValue,b,h,S,B,ub,vb,ud,vd,GF)
%%
% BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)

%%
% [rg,Domain_radius,shelf_width,h0,Bedrock,rho,rhow,g,thinice,ur,n,AGlen]=DefineMyParameters();

rg=UserVar.rg;
h0=UserVar.h0; 
ur=UserVar.ur; 

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

%LS u=ur*x/sqrt(x^2+y^2) turn radial velocity to cartesean
%LS v=ur*y/sqrt(x^2+y^2)

%Find the rg boundary , on BOUNDARY NODES ONLY
%Iinn=sqrt((x(MUA.Boundary.Nodes).^2+y(MUA.Boundary.Nodes).^2))<=(rg+shelf_width);
%nodesinn=MUA.Boundary.Nodes(Iinn);

%% Find the rg boundary , on BOUNDARY NODES + SHELF WIDTH NODES
%{
Iinn=sqrt((x.^2+y.^2))<=(rg+shelf_width);
nodesinn=find(Iinn);

normal=sqrt(x(nodesinn).^2+y(nodesinn).^2);

BCs.ubFixedNode=[nodesinn];
BCs.ubFixedValue=ur.*x(nodesinn)./normal;
BCs.vbFixedNode=[nodesinn];
BCs.vbFixedValue=ur.*y(nodesinn)./normal;



BCs.hFixedNode = [nodesinn] ;
BCs.hFixedValue = (nodesinn./nodesinn)*h0;

%}

%% Inner boundary only - no shelf width
dx=rg/20;
mask=x(MUA.Boundary.Nodes).^2+y(MUA.Boundary.Nodes).^2 <= rg*rg+dx; %Make sure all inner nodes are included, not the outer nodes
nodesIn=MUA.Boundary.Nodes(mask); %list of nodes IDs 

normal=sqrt(x(nodesIn).^2+y(nodesIn).^2);

% Set a constant radial veolicty ur on the inner boundary r=rg
BCs.ubFixedNode=[nodesIn];
BCs.ubFixedValue=ur.*x(nodesIn)./normal;
BCs.vbFixedNode=[nodesIn];
BCs.vbFixedValue=ur.*y(nodesIn)./normal;

%Set a constant thickness h0 on that inner boundary r=rg
BCs.hFixedNode = nodesIn ;
BCs.hFixedValue = (nodesIn./nodesIn)*h0;

end


