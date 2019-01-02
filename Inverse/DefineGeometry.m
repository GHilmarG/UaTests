
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

switch lower(UserVar.RunType)
    
    case 'icestream'
        
        hmean=1000;
        b=zeros(MUA.Nnodes,1) ;
        S=zeros(MUA.Nnodes,1)-1e10;
        B=b ;
        s=hmean+b;
        
        alpha=0.01 ;
        
    case 'iceshelf'
        
        hmean=1000;
        b=zeros(MUA.Nnodes,1) ;
        S=zeros(MUA.Nnodes,1);
        B=S*0-1e10;
        s=hmean+b;
        
        alpha=0 ;
        
end

if UserVar.Inverse.CreateSyntData==2 && UserVar.Inverse.SynthData.Pert=="-b-"
    
    fprintf(' Creating b pertubation for the generation of synthetic measurements.\n')
    
    
    x=MUA.coordinates(:,1) ;
    y=MUA.coordinates(:,2);
    
    sx=20e3 ; sy=20e3;
    db=hmean/10;
    bpert=db*exp(-(x.*x/sx^2+y.*y./sy^2));
    b=b+bpert ;
    B=b;
    
    
    
end


end

