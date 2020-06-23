

function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

% Defines model geometry

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
alpha=0.;


B=-1000+zeros(MUA.Nnodes,1);
S=B*0;
b=B;
h0=300;
s=b+h0;

end
