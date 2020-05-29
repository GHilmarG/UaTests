
function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
    
    ab=zeros(MUA.Nnodes,1);
    x=MUA.coordinates(:,1); 
    y=MUA.coordinates(:,2);
    
    
    if contains(CtrlVar.Experiment,"GaussMelting")
        
        if time<150
            ampl=-1;
            sigma_x=25000 ; sigma_y=25000;
            as=ampl.*exp(-((x/sigma_x).^2+(y/sigma_y).^2));
        else
            as=zeros(MUA.Nnodes,1);
        end
        
    elseif contains(CtrlVar.Experiment,"GaussMelting")
        
        as=zeros(MUA.Nnodes,1)-1;

    else
        
        error(' which case')
        
    end
    
end
