
function [UserVar,s,b,S,B,alpha]=DefineGeometry(Experiment,coordinates,CtrlVar,FieldsToBeDefined)
    
    
    
    x=coordinates(:,1); y=coordinates(:,2);
    Nnodes=numel(x);
    
    alpha=0.00; 
    
        
    B=zeros(Nnodes,1) ;
    S=B*0-1e10;
    b=B;
    
    ampl=100; sigma_x=10000 ; sigma_y=10000;
    h=ampl*exp(-((x/sigma_x).^2+(y/sigma_y).^2))+800;  h(h<0)=0;
    %h=zeros(Nnodes,1)+500;
    
    s=b+h;

    
end
