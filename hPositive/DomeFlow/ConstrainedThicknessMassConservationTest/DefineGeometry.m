
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)



x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);


alpha=0.00;


B=zeros(MUA.Nnodes,1) ;
S=B*0-1e10;
b=B;

if strfind(FieldsToBeDefined,'s')
    
    ampl=1000; sigma_x=10000 ; sigma_y=10000;
    platau=0;
    h=ampl*exp(-((x/sigma_x).^2+(y/sigma_y).^2)) + platau;
    
    h(h<10)=0;
    
    %h=zeros(Nnodes,1)+500;
    
    
    s=b+h;
end

end
