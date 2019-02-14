

function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined,F)

% Defines model geometry

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
alpha=0.;
B=MismBed(x,y);
S=B*0;

if time< eps
    b=B;
    h0=1000-1000/640e3*x;
    s=b+h0;
else
    Draft=F.h.*(1-F.rho/F.rhow);
    b=[] ;
    s=[] ;
end




end
