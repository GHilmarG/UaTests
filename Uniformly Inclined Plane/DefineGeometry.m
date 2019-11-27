
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
    % FieldsToBeDefined='sbSB' ; 
    
    x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
    
    alpha=0.00; hmean=1000; 
    
    slope=0.1;
    B=zeros(MUA.Nnodes,1)+hmean-x*tan(slope);
    S=B*0-1e10;
    b=B;
    s=b+hmean; 
    
    % +0.5*hmean*exp(-(x.*x+y.*y)/l^2);
    
    
end
