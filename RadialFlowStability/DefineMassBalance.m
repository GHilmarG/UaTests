function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
[rg,Domain_radius,shelf_width,h0,Bedrock,rho,rhow,g,thinice,ur,n,AGlen]=DefineMyParameters();

%% For the case we only use Dirichlet velocity on inner boundary to get new mass into the system
as=zeros(MUA.Nnodes,1);
ab=zeros(MUA.Nnodes,1);

end

