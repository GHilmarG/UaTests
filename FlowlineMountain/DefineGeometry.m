
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

    
    x=MUA.coordinates(:,1); 
    
    alpha=0.0; 
    
    BedSlope=0.05; B0=4000;    
    
    B=B0-sign(x).*tan(BedSlope).*x;
    
    b=B;
    h=x*0+2;
    s=b+h;
    
    S=x*0-1e10;
    
end
