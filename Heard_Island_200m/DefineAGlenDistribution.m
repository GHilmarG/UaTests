
function  [UserVar,AGlen,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)

%% 

n=3;
temp = 273.8184-273.15;
A0=AGlenVersusTemp(temp);

switch UserVar.RunType

    case 'inverse_run'
        AGlen=A0+zeros(MUA.Nnodes,1);

    case {'spin-up','forward_run'}
        load('AGlen-Estimate.mat');
        AGlen=AGlen;
end

end

