
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

[rg,Domain_radius,shelf_width,h0,Bedrock,rho,rhow,g,thinice,ur,n,AGlen]=DefineMyParameters();
alpha = 0.0;  % zero slope of the coordinate system

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

B=zeros(MUA.Nnodes,1)-Bedrock; %LS: Deep bedrock underneath the ocean to assure floatation.
S=B*0; %Ocean Surface, sea-level is zero
b=S-thinice*(rho/rhow);  %The thin layer of ice/polymer everywhere in the computational domain.
s=S+thinice*(1-rho/rhow);

%Now set the geometry on the boundary inner BC, r=rg:
dx=rg/20;
mask=x(MUA.Boundary.Nodes).^2+y(MUA.Boundary.Nodes).^2 <= rg*rg+dx; %Make sure all inner nodes are included, not the outer nodes
nodesIn=MUA.Boundary.Nodes(mask);

b(nodesIn)=0-h0*(rho/rhow); % This region is the circular shape with a constant thickness given by h0
s(nodesIn)=h0*(1-rho/rhow);

%Now definition of the geometric perturbation of the 2D shape:
Ri=1.3*rg;
k=9;
Delta=Ri-rg;
A=0.5*Delta; % A must be such that A/Delta<1 ! Otherwise the perturbation intercept into rg

shape_p=Ri+A*cos(k*atan2(y,x)-pi/2);

shape=sqrt((x.^2+y.^2))<=shape_p;
b(shape)=0-h0*(rho/rhow);
s(shape)=h0*(1-rho/rhow);
hi=s-b;

% save('my_hi','hi'); %just to have a quick initial look BEFORE adaptive mesh is done to improve it
% save('my_MUAi','MUA');
% 
% clear nodesIn; clear mask; clear x; clear y;
end
