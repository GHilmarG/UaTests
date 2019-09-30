

function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

% Defines model geometry

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
alpha=0.;


%B=MismBed(x,y);

B=zeros(MUA.Nnodes,1)-1000;

S=zeros(MUA.Nnodes,1);
b=B;

l=5e3; xm=mean(x);
h=10*exp( -(x-xm).^2/l^2) + 10 ;



s=b+h;

end
