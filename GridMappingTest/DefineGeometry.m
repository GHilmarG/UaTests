
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
    % FieldsToBeDefined='sbSB' ; 
    
    x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
  
    
    alpha=0.0; hmean=1000; Bmean=-800 ;
    
    ampl_b=-20*hmean; sigma_bx=2.5e3 ; sigma_by=2.5e3;
    
    Deltab=ampl_b*exp(-((x/sigma_bx).^2+(y/sigma_by).^2));
    Deltab=Deltab-mean(Deltab);
    
    B=zeros(MUA.Nnodes,1) + Bmean + Deltab ;
    S=B*0;
    b=B;
    s=Bmean+hmean;    % surface is flat
    
    rho=900+zeros(MUA.Nnodes,1) ; rhow=1030; 
    b=Calc_bh_From_sBS(CtrlVar,MUA,s,B,S,rho,rhow) ;
    
end
