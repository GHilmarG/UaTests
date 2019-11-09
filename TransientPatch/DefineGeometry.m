
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
    
    
    
    x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
    
    L=max(x);
    
    alpha=0.0; 
    
        
    B=zeros(MUA.Nnodes,1) ;
    S=B*0-1e10;
    b=B;
    
    hmax=500;
    s=hmax-(L-abs(x)).*(L-abs(y))*hmax/L^2;
    %I=(s-b)<1; s(I)=b(I)+1;
    
    %I=(s-b)<1;
    %s(I)=b(I)+1;
    
end
