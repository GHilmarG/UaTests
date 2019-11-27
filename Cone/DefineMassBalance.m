function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

as=zeros(size(s),'like',s);
ab=zeros(size(s),'like',s);


%T=1000 ; dELA=1000;
%ELA=3000+dELA* sin(2*pi*time/T);

ELA=2900;


if time>250 && time < 1000
    ELA=1500;
end



dadzAboveEla=0.004;
dadzBelowEla=0.008;
I=s>ELA;


as(I)=dadzAboveEla*(s(I)-ELA);   % positive
as(~I)=dadzBelowEla*(s(~I)-ELA); % negative
as(as>3)=3;

end

