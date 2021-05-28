
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

% B         is bedrock
% s and b   are upper and lower ice surfaces
% S         is ocean surface
% alpha     is the tilt of the z axis of the coordinate system with respect to vertical


x=MUA.coordinates(:,1); % these are the x coordinates of the nodes

alpha=0.0; %  tilt of the coordinate system, do not change.

%  Define the bedrock elevation within the computational domain
BedSlope=0.05;
B0=4000;
B=B0-sign(x).*tan(BedSlope).*x;

b=B;         % lower ice surface (glacier sole) set equal to bedrock
h=x*0+2;     % initial thickness set to 2 meters
s=b+h;       % upper surface

S=x*0-1e10;  % Just make sure the ocean surface is so low that all ice is grounded at all times

end
