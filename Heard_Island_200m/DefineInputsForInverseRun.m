function [UserVar,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=...
    DefineInputsForInverseRun(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo)

%% get measurments and define error covariance matrices

[u,R] = readgeoraster('u.tif');
[v,R] = readgeoraster('v.tif');
x=R.XWorldLimits(1):(R.XWorldLimits(2) - R.XWorldLimits(1))/(R.RasterSize(2)-1):R.XWorldLimits(2); x=x.';
y=R.YWorldLimits(1):(R.YWorldLimits(2) - R.YWorldLimits(1))/(R.RasterSize(1)-1):R.YWorldLimits(2); y=y.';
u=u.'; v=v.';

N = 1;
x = x(1:N:end); y = y(1:N:end);
u = u(1:N:end, 1:N:end);
v = v(1:N:end, 1:N:end);

[X,Y] = ndgrid(double(x),double(y));
us = griddedInterpolant(X,Y,fliplr(double(u)));
vs = griddedInterpolant(X,Y,fliplr(double(v)));
Meas.us = us(F.x, F.y);
Meas.vs = vs(F.x, F.y);

% Define data errors
usError = zeros(MUA.Nnodes,1)+100;
vsError = zeros(MUA.Nnodes,1)+100;

% Here I set any NaN values to 0. The assumption here is that these NaN values represent missing data and I set these values to 0. This
% may, or may not, be a good idea. But the important thing is to set the errors where data is missing to some really high value. Here I
% set the errors to 1e10.
MissingData=isnan(Meas.us) | isnan(Meas.vs) | isnan(usError) | (usError==0) | isnan(vsError) | (vsError==0);
Meas.us(MissingData)=0 ;  Meas.vs(MissingData)=0 ; usError(MissingData)=1e10; vsError(MissingData)=1e10;

% The data errors as specified by these covariance matrices.
% The data errors are assumed to be uncorrelated, hence we are here using diagonal covariance matrices.
Meas.usCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,usError.^2,MUA.Nnodes,MUA.Nnodes);
Meas.vsCov=sparse(1:MUA.Nnodes,1:MUA.Nnodes,vsError.^2,MUA.Nnodes,MUA.Nnodes);

%% Define Priors

temp = 273.8184-273.15;
A0=AGlenVersusTemp(temp);
m=3;
Priors.C=3.16e6^(-m)*1000^m*365.2422*24*60*60;
Priors.m=m;
Priors.AGlen=A0;
Priors.n=3;

%% Define Start Values
% This is only used at the very start of the inversion. (In an inverse restart run the initial value is always the last values from
% previous run.)
InvStartValues.C=Priors.C;
InvStartValues.m=F.m;
InvStartValues.q=F.q;
InvStartValues.muk=F.muk;
InvStartValues.AGlen=Priors.AGlen;
InvStartValues.n=F.n;

end
