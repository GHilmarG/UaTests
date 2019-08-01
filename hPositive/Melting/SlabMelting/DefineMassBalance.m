
function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)


ab=zeros(MUA.Nnodes,1);


x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

switch CtrlVar.Experiment
    
    case 'GaussMelting'
        
        if time<200e10
            ampl=-1;
            %ampl=-10*(max(y)-y)/(max(y)-min(y));
            sigma_x=25000 ; sigma_y=25000;
            as=ampl.*exp(-((x/sigma_x).^2+(y/sigma_y).^2));
            %as=ampl.*exp(-((x/sigma_x).^2));
        else
            as=zeros(MUA.Nnodes,1);
        end
        
        
    case 'UniformMelting'
        
        as=zeros(MUA.Nnodes,1)-1;
        
        
        
        
        
    otherwise
        error(' which case')
        
end

end
