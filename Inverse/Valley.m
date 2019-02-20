function [s,b,B,S]=Valley(UserVar,CtrlVar,MUA,pert)

narginchk(4,4)

x=MUA.coordinates(:,1);
y=MUA.coordinates(:,2);
s0=10000 ;
lx=max(x)-min(x) ;
ly=max(y)-min(y);
beta=s0/lx;
s=s0-(x-min(x))*beta ;


if pert
    
    h0=500 ; xc=min(x)+(max(x)-min(x))/2 ;  yc=min(y)+(max(y)-min(y))/2 ;
    wx=lx/10 ; wy=ly/30 ;
    h=h0- ( ((x-xc)/wx).^4 +  (( y-yc)/wy).^4 ) ;
    h(h<10)=10;
    
else
    
    %
    % Let the unperturbed thickness tailor off to zero at the boundaries 
    %  
    %  h =  
    %
    xc=min(x)+lx/2 ; yc=min(y)+ly/2 ; 
    h0=500 ; hmin=10 ; 
    h=h0*cos(2*pi*(x-xc)/lx/2).*cos(2*pi*(y-yc)/ly/2)+hmin;
    %h=500;
    %figure ; PlotMeshScalarVariable(CtrlVar,MUA,h) ;
end

% Make sure s is the same 
vShift=UserVar.vShift;
s=s+vShift ;

b=s-h;
B=b;
S=x*0 ;

[~,rho,rhow,g]=DefineDensities(UserVar,CtrlVar,MUA,CtrlVar.time,s,b,h,S,B);
[b,s,h,GF]=Calc_bs_From_hBS(CtrlVar,MUA,h,S,B,rho,rhow);





end