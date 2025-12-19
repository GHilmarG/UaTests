

function  [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)



% linear viscosity with eta=5e3
n=1 ;
eta0=1/(2*UserVar.AGlen0);



%% gaussian perturbation in eta
%     x0=0.0; y0 = -1.5e4;
%     deta=UserVar.ampl_eta*exp(-UserVar.w_eta_x * (x-x0).^2 - UserVar.w_eta_y * (y-y0).^2).*eta0;

%% Sinusoidal perturbation.
Lx=max(F.x)-min(F.x); Ly=max(F.y)-min(F.y); nx=UserVar.nxA; ny=UserVar.nyA;

phase = pi;
deta = UserVar.ampl_eta.*eta0.*sin(2*pi*nx*F.x/Lx + 2*pi*ny*F.y/Ly+phase);

deta=deta-mean(deta(:));

eta = eta0 + deta;

AGlen_peturbed = 1./(2.*eta);

%% Sinusoidal perturbation in log space
% Lx=max(x)-min(x); Ly=max(y)-min(y); nx=UserVar.nxA; ny=UserVar.nyA;
%
% phase = pi;
% dlogA = UserVar.ampl_eta.*log10(UserVar.AGlen0).*sin(2*pi*nx*x/Lx + 2*pi*ny*y/Ly+phase);
%
% dlogA=dlogA-mean(dlogA(:));
%
% AGlen_peturbed = 10.^(log10(UserVar.AGlen0) + dlogA);
%


if contains(UserVar.RunType,"FT-")



    AGlen = AGlen_peturbed;

elseif contains(UserVar.RunType,"IR-")

    AGlen = UserVar.AGlen0;

else

    error('case error')
end




end

