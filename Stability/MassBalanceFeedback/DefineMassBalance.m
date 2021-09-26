
function [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


ELA=UserVar.ELA; 
lambda=UserVar.lambda ;


as=lambda*((h+b)-ELA);  % Here h0 is similar to ELA
dasdh=lambda;




ab=zeros(MUA.Nnodes,1);
dabdh=zeros(MUA.Nnodes,1);

end

