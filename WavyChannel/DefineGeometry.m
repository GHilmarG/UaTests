

function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
    % FieldsToBeDefined='sbSB' ; 
    
    
    
    x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
    
    
    
    
    b=UserVar.ab*sin(x*2*pi/UserVar.lambda);
    s=UserVar.as*sin(x*2*pi/UserVar.lambda)+UserVar.h;
    
    
    figure ; plot(x,s) ; hold on ; plot(x,b) 
    
    % Rotate, to do
    %xt = x*cos(UserVar.alpha)+ y*sin(UserVar.alpha);
    %yt =-x*sin(UserVar.alpha)+ y*cos(UserVar.alpha);
    
    b=b-x*tan(UserVar.alpha);
    s=s-x*tan(UserVar.alpha);
    
    figure ; plot(x,s) ; hold on ; plot(x,b) 
    
    B=b; 
    S=x*0-1e10;
    alpha=0;
    
    
end
