




function [UserVar,uo,vo,Co,mo,ua,va,Ca,ma]=DefineSeaIceParameters(UserVar,CtrlVar,MUA,F)

%%
%
% This m-file is used to define drag due to prescribed ocean current and wind speed.
%
%
% 
% The relationship between (prescribed) currents and winds and the resulting drag is formally identical to Weertman sliding law, but
% only acts over the floating sections of the domain.
%
%
%   (uo,vo)              ocean velocity, defined on nodes, can be spatially variable
%   (ua,va)              wind velocity, defined on nodes, can be spatially variable
%
%   Co , mo              parameters related to ocean-induced drag.  See the UaCompendium for exact definition
%   Ca , ma              parameters related to wind-induced drag.  See the UaCompendium for exact definition
%
%
% For example:
% 
%   uo=zeros(MUA.Nnodes,1);
%   vo=zeros(MUA.Nnodes,1);
%   ua=zeros(MUA.Nnodes,1);
%   va=zeros(MUA.Nnodes,1);
%
%   mo=2; Co=1e+10;
%   ma=1; Ca=1e+10;
%
%  The ocean drag, tauo, is calculated as 
%
%    tauo= Co^{-1/m} |VelIce-VelOcean|^{1/mo-1} (VelIcea-VelOcean)
%
% so if, for example, mo=1, we have 
%
%    tau0= (1/Co) (VelOcean-VelIce)
%
% C0 has the units of velocity/stress or the SI units (m/s)/Pa = (m/s)/(kg m/s^2) = s/kg
%
% 
% If a typical velocity differential between ice and ocean is 1000 m/yr and Co=1 [m/(Pa yr)] then
%
%  tau = 1000 kPa, which is a lot
%
% It is difficult to say what "correct" value should be used for Co, but for the resulting drag to be small compared to
% typical stresses in the ice, c0 needs to be large, maybe Co=1e10 for m0=1; 
%
%
%%

uo=zeros(MUA.Nnodes,1);
vo=zeros(MUA.Nnodes,1);
ua=zeros(MUA.Nnodes,1);
va=zeros(MUA.Nnodes,1);

mo=1; Co=1e6;
ma=1; Ca=1e20;


% Setting:  mo=1; Co=1e20;  and m=1 and Ca=1e20 , as a reference (almost singular and MATLAB produces warnings to that effect)
% and then solving again for Ca=Co=1e10 shows almost no change for a large ice sheet using the units m, kPa and yr
% Ca=Co=1e5 also seems to be very similar to Ca=C0=1e20

end