
function  [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F)
    
%%    
    m=3;
    q=1;
    muk=0.5;
    C0=3.16e6^(-m)*1000^m*365.2422*24*60*60;
    C=C0+zeros(MUA.Nnodes,1);

    switch UserVar.RunType

        case 'inverse_run'
            C=C0+zeros(MUA.Nnodes,1);

        case {'spin-up','forward_run'}
            load('C-Estimate.mat');
            C=C;
    end
    
    
    
end
