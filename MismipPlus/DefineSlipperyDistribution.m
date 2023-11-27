
function [UserVar,C,m,q,muk,V0]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


m=3; % Weertman
C0=3.16e6^(-m)*1000^m*365.2422*24*60*60;
C=C0+zeros(MUA.Nnodes,1);

q=m;                % Budd 
muk=0.5 ;           % Tsai 


pattern=["Joughin","rCW-V0"];
if contains(CtrlVar.SlidingLaw,pattern)
    % V0=0;             % Joughin, works
    V0=1e5; C=C/V0;     % This is the corresponding C value for Weertman for V0 \to +\infty, 
                        %  and gives almost exaclty the same results as using Weertman
else
    V0=[];
end

end
