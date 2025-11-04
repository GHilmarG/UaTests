function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


%%
%
% Defines model geometry and ice densities
%
%  [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
%
% FieldsToBeDefined is a string indicating which return values are required. For
% example if
%
%   FieldsToBeDefined="-s-b-S-B-rho-rhow-g-"
%
% then s, b, S, B, rho, rhow and g needed to be defined.
%
% Typically, in a transient run
%
%   FieldsToBeDefined="-S-B-rho-rhow-g-"
%
% implying that only s and b do not needed to be defined, and s and b can be set to any
% value, for example s=NaN and b=NaN.
%
% It is OK to define values that are not needed, these will simply be ignored by Úa.
%
% As in all other calls:
%
%  s           is upper ice surface
%  b           is lower ice surface
%  B           is bedrock
%  S           is ocean surface
%
%   rhow    :  ocean density (scalar variable)
%   rho     :  ice density (nodal variable)

%   g       :  gravitational acceleration
%
% These fields need to be returned at the nodal coordinates. The nodal
% x and y coordinates are stored in MUA.coordinates, and also in F as F.x and F.y
%
%%

switch UserVar.Experiment

    case "ice shelf stream flow"
        h=700;
    case "ice shelf constricted"
        h=700;
    case "ice shelf single notch"
        h=1000;
    otherwise
        h=300;
end

n=MUA.Nnodes;

% 
% if nargin>3
%     h=hIce;
% end
% 

h=zeros(n,1)+h;
S=zeros(n,1);
B=zeros(n,1)-1e10;
rho=zeros(n,1)+920;
rhow=1030;
g=9.81/1000;


[b,s]=Calc_bs_From_hBS(CtrlVar,MUA,h,S,B,rho,rhow);




end




