function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,F)


%%
% Defines mass balance along upper and lower ice surfaces.
%
%   [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
%
%   [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,F);
%
%   [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,CtrlVar.time,s,b,h,S,B,rho,rhow,GF);
%
%   as        mass balance along upper surface 
%   ab        mass balance along lower ice surface
%   dasdh     upper surface mass balance gradient with respect to ice thickness
%   dabdh     lower surface mass balance gradient with respect to ice thickness
%  
% dasdh and dabdh only need to be specified if the mass-balance feedback option is
% being used. 
%
% In Úa the mass balance, as returned by this m-file, is multiplied internally by the local ice density. 
%
% The units of as and ab are water equivalent per time, i.e. usually
% as and ab will have the same units as velocity (something like m/yr or m/day).
%
% As in all other calls:
%
%  F.s       : is upper ice surface
%  F.b       : lower ice surface
%  F.B       : bedrock
%  F.S       : ocean surface
%  F.rhow    :  ocean density (scalar variable)
%  F.rho     :  ice density (nodal variable)
%  F.g       :  gravitational acceleration
%  F.x       : x nodal coordinates 
%  F.y       : y nodal coordinates 
%  F.GF      : The nodal grounded/floating mask (has other subfields)
%
%
%
% These fields need to be returned at the nodal coordinates. The nodal
% x and y coordinates are stored in MUA.coordinates, and also in F as F.x and F.y
%
%
% *Examples* : 
%
% *To set upper surface mass balance to zero, and melt along the lower ice
% surface to 10 over all ice shelves:* 
%
%   as=zeros(MUA.Nnodes,1);
%   ab=-(1-F.GF.node)*10 
%
%
% *To set upper surface mass balance as a function of local surface elevation and
% prescribe mass-balance feedback for the upper surface:* 
%
%   as=0.1*F.h+F.b;
%   dasdh=zeros(MUA.Nnodes,1)+0.1;
%   ab=F.s*0;
%   dabdh=zeros(MUA.Nnodes,1);
%
% *To add basal melt due to sliding as a mass-balance term:* 
%
%   [tbx,tby,tb,beta2] = CalcBasalTraction(CtrlVar,MUA,F.ub,F.vb,F.C,F.m,F.GF);
%   L=333.44 ;                                        % Enthalpy of fusion = L = [J/gramm = kJ/kg]  Make sure that the units are correct.
%   F.ab=-(tbx.*F.ub+tby.*F.vb)./(F.rho.*L);          % Ablation (Melt) is always negative, accumulation is positive
%
% 
%
%%

load('as_control.mat'); %m/yr
as=as;
dasdh=zeros(MUA.Nnodes,1);
ab=F.s*0;
dabdh=zeros(MUA.Nnodes);


end

