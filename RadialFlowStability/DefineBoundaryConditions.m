




%function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,ubFixedValue,b,h,S,B,ub,vb,ud,vd,GF)

function [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)



%%
% [rg,Domain_radius,shelf_width,h0,Bedrock,rho,rhow,g,thinice,ur,n,AGlen]=DefineMyParameters();

rg=UserVar.rg;
h0=UserVar.h0; 
ur=UserVar.ur; 



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

TareaMin=min(TriAreaFE(MUA.coordinates,MUA.connectivity));
dx=sqrt(TareaMin)/5; 

mask=F.x(MUA.Boundary.Nodes).^2+F.y(MUA.Boundary.Nodes).^2 <= (rg+dx)^2; %Make sure all inner nodes are included, not the outer nodes
nodesIn=MUA.Boundary.Nodes(mask); %list of nodes IDs 

normal=sqrt(F.x(nodesIn).^2+F.y(nodesIn).^2);

% Set a constant radial veolicty ur on the inner boundary r=rg
BCs.ubFixedNode=nodesIn;
BCs.ubFixedValue=ur.*F.x(nodesIn)./normal;
BCs.vbFixedNode=nodesIn;
BCs.vbFixedValue=ur.*F.y(nodesIn)./normal;

%Set a constant thickness h0 on that inner boundary r=rg
BCs.hFixedNode = nodesIn ;
BCs.hFixedValue = nodesIn*0 + h0;

end


