
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)



x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);


alpha=0.0;


B=zeros(MUA.Nnodes,1) ;
S=B*0-1e10;
b=B;

%ampl=0; sigma_x=10000 ; sigma_y=10000;
%s=b+0+ampl*exp(-((x/sigma_x).^2+(y/sigma_y).^2));

if contains(CtrlVar.Experiment,"GaussMelting")
    h0=100;
    s=b+h0;
elseif contains(CtrlVar.Experiment,"GaussMelting")
    s=b*0+1;
else
    error(' which case')
end

end
