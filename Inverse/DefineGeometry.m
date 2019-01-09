
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

switch lower(UserVar.RunType)
    
    case 'icestream'
        
        hmean=1000;
        b=zeros(MUA.Nnodes,1) ;
        S=zeros(MUA.Nnodes,1)-1e10;
        B=b ;
        s=hmean+b;
        
        alpha=0.01;
        
    case 'iceshelf'
        
        hmean=1000;
        b=zeros(MUA.Nnodes,1) ;
        S=zeros(MUA.Nnodes,1);
        B=S*0-1e10;
        s=hmean+b;
        
        alpha=0 ;
        
    case 'icestream+iceshelf'
        
        beta=0.01;
        hmean=1000;
        B0=500;
        
        x=MUA.coordinates(:,1);
        y=MUA.coordinates(:,2);
        
        
        B=B0-beta*x ;
        
        Ly=max(y)-min(y);
        B=B+0.25*hmean*cos(4*pi*y/Ly);
        
        b=B; 
        S=B*0;
        s=hmean+b;
        
        alpha=0 ;
        
        [b,s,h,GF]=Calc_bs_From_hBS(CtrlVar,MUA,s-b,S,B,900,1030);
        
        
        
end

if UserVar.Inverse.CreateSyntData==2 && UserVar.Inverse.SynthData.Pert=="-b-"
    
    fprintf(' Creating b pertubation for the generation of synthetic measurements.\n')
    
    
    x=MUA.coordinates(:,1) ;
    y=MUA.coordinates(:,2);
    
    dbType='circ' ;
    switch dbType
        case 'Gauss'
            
            sx=20e3 ; sy=20e3;
            db=hmean/2;
            bpert=db*exp(-(x.*x/sx^2+y.*y./sy^2));
            
        case 'circ'
            
            R=sqrt(x.*x+y.*y) ;
            I=R<10e3 ;
            bpert=b*0;
            bpert(I)=hmean/2;
            
    end
    b=b+bpert ;
    B=B+bpert;
    
    
    
    
    
    figure ; Plot_sbB(CtrlVar,MUA,s,b,B) ; title(' with perturbation ' )
    
    
end


switch lower(UserVar.RunType)
    
    case 'icestream'

        B=b ;
        
    case 'iceshelf'

        B=b-1e10;

        
end



end

