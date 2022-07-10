function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

%%
% Defines mass balance along upper and lower ice surfaces.
%
%   [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
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
% Examples:  
%
% To set upper surface mass balance to zero, and melt along the lower ice
% surface to 10 over all ice shelves:
%
%   as=zeros(MUA.Nnodes,1);
%   ab=-(1-GF.node)*10 
%
%
% To set upper surface mass balance as a function of local surface elevation and
% prescribe mass-balance feedback for the upper surface:
%
%   as=0.1*h+b;
%   dasdh=zeros(MUA.Nnodes,1)+0.1;
%   ab=s*0;
%   dabdh=zeros(MUA.Nnodes,1);
%
% 
%%


%rhofw=1000;
%L=3.34e5;
%rho=917;
%cw=3974 ;
%Gt=5e-2;
%Gs=1.e3-3;


%uH=u0*tanh(Hc/Hc0);
%Tzd=T0*(b-B)/zref;
%ab=rho*cw*Gt*uH.*Tzd/rhofw/L;


% zd is the ice draft, here it is b when afloat
% zb is the bedrock elevation, or B
% Hc=zd-db = b=B

as=0.3; 
ab=0 ; 


end

