function [UserVar,C,m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F);


%m=3 ; C=0.0145300017528364 ; % m=3
%m=1 ; C=1.13263129082193    ; % m=1


C0=UserVar.C0;

dc=UserVar.ampl_c*exp(-F.x.^2./UserVar.sigma_cx^2-F.y.^2./UserVar.sigma_cy^2); 
dc=dc-mean(dc(:)) ;

C=C0*(1+dc);
m=UserVar.m ;

end
