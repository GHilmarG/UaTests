



function [s,b,B,S]=Valley(UserVar,CtrlVar,MUA,F,pert)

narginchk(5,5)



s0=10000 ;
lx=max(F.x)-min(F.x) ;
ly=max(F.y)-min(F.y);
beta=s0/lx;
s=s0-(F.x-min(F.x))*beta ;


if pert  % This is really the true bed, i.e. the bed for which the synthetic measurements are created for 
    
    h0=500 ; 
    xc=min(F.x)+(max(F.x)-min(F.x))/2 ;  
    yc=min(F.y)+(max(F.y)-min(F.y))/2 ;
    wx=lx/10 ; wy=ly/30 ;
    
    h=h0- ( ((F.x-xc)/wx).^4 +  (( F.y-yc)/wy).^4 ) ;
    
    
    % add a ridge
    % ridge=h0/2-1e-7*(x-xc).^2 ; ridge(ridge<0)=0 ; h=h-ridge; 
    
    
    h(h<10)=10;
else
    
    %
    % Let the unperturbed thickness tailor off to zero at the boundaries 
    %  
    %  h =  
    %
    xc=min(F.x)+lx/2 ; yc=min(F.y)+ly/2 ; 
    h0=500 ; hmin=10 ; 
    h=h0*cos(2*pi*(F.x-xc)/lx/2).*cos(2*pi*(F.y-yc)/ly/2)+hmin;
    %h=500;
    %figure ; PlotMeshScalarVariable(CtrlVar,MUA,h) ;
end

% Make sure s is the same 
vShift=UserVar.vShift;
s=s+vShift ;

b=s-h;
B=b;
S=F.x*0 ;

[~,~,~,~,~,rho,rhow]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,[],"-rho-");


[b,s]=Calc_bs_From_hBS(CtrlVar,MUA,h,S,B,rho,rhow);





end