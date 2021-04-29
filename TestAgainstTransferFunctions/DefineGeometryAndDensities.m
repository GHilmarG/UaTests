function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


rho=900+zeros(MUA.Nnodes,1) ; rhow=1030; g=9.81/1000;



hmean=1000;


B=zeros(MUA.Nnodes,1);
b=B;
S=B*0-1e10;

s=b+hmean;


end




