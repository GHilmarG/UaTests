function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

m=1;


x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

%% Slipperiness perturbation.

% Gaussian
%     x0=0.0;  % location of perturbation
%     y0=0.0;
%dc=UserVar.ampl_c*exp(-UserVar.w_c_x * (x-x0).^2 - UserVar.w_c_y * (y-y0).^2).*UserVar.C0;

% Sinusoidal perturbation.
Lx=max(x)-min(x); Ly=max(y)-min(y); nxC=UserVar.nxC; nyC=UserVar.nyC;
phase = 0.0;

dc = UserVar.ampl_c.*UserVar.C0.*sin(2*pi*nxC*x/Lx + 2*pi*nyC*y/Ly+phase);


dc=dc-mean(dc(:));
C_peturbed = UserVar.C0 + dc;

%% Slipperiness perturbation in log space.
%
% % Sinusoidal perturbation.
% Lx=max(x)-min(x); Ly=max(y)-min(y); nxC=UserVar.nxC; nyC=UserVar.nyC;
% phase = 0.0;
%
% dlogC = UserVar.ampl_c.*log10(UserVar.C0).*sin(2*pi*nxC*x/Lx + 2*pi*nyC*y/Ly+phase);
%
%
% dlogC=dlogC-mean(dlogC(:));
% C_peturbed = 10.^(log10(UserVar.C0) + dlogC);


if contains(UserVar.RunType,"FT-")


    C = C_peturbed;

elseif contains(UserVar.RunType,"IR-")

    C = UserVar.C0;

else

    error('case error')
end

end
