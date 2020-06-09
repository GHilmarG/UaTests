function [UserVar,LSF,CalvingRate]=DefineCalving(UserVar,CtrlVar,MUA,F,BCs)
    
    
    LSF=F.LSF ;
    
    if CtrlVar.CurrentRunStepNumber< 2  % initialize the Level-Set-Field
        
        xc=200e3;  % this is the initial calving front
        LSF=xc-MUA.coordinates(:,1) ;
        % figure ; plot(CalvingFront(:,1)/1000,CalvingFront(:,2)/1000,'-o'); axis equal
    end
    
    q=-2;
    k=86322275.9814533 ;
    
    switch UserVar.Calving
        
        case "Function of analytical thickness"
            % First for testing, define calving rate as a function of the analytical thickness
            % profile.
            A=AGlenVersusTemp(-10); a=0.3 ; n=3 ; rho=910; rhow=1030 ; g=9.81/1000; hgl=1000; xgl=0; ugl=300;
            [s,b]=AnalyticalOneDimentionalIceShelf(CtrlVar,MUA,[],hgl,ugl,xgl,MUA.coordinates(:,1),A,n,rho,rhow,a,g);
            h=s-b;
            
            
            CalvingRate=k*h.^q;
            
        case "Function of numerical thickness"
            
            CalvingRate=k*F.h.^q;
            % The issue is that this goes to infinity with h to zero. 
            % 
            CalvingRate(CalvingRate>2000)=2000; 
    end
    
    CalvingRate=CalvingRate(:) ;
    CalvingRate=CalvingRate.*(1-F.GF.node) ;

end
