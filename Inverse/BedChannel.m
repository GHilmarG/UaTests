function [s,B]=BedChannel(x,y)



B0=1000;

Lx=(max(x)-min(x)) ; 
Ly=(max(y)-min(y)) ; 
x0=min(x); 
dc0=2000; 
wc=Ly;
fc=Ly; 
beta=0.001;


sy=Ly/10 ; 
Channel=-d0*exp((y-y0).^2/sy) ;
Dome=

Channel=dc.*(1./(1+exp(-2*(y-wc)/fc))+1./(1+exp(2*(y+wc)/fc)));
B=B0*exp(-(x-x0).*(x-x0)/Lx^2)+Channel ; 

s=B+100; 


end