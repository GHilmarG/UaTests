function B=DefineCones(x,y)

x0=[-50e3,50e3,0 ,0 , 0] ; y0=[0,0,-50e3,50e3,0]; dBds=[-0.2,-0.1,-0.1,-0.05,-0.1 ];  B0=[4000,4500,5000,3000,2500];

PlaneElevation=0;

B=x*0+PlaneElevation-10;



for I=1:numel(x0)
    dist=sqrt((x-x0(I)).^2+(y-y0(I)).^2);
    Btemp=B0(I)+dist*dBds(I);
    ind=Btemp>PlaneElevation ; % & B < 1000 ;
    B(ind)=B(ind)+Btemp(ind);
end

B(B<PlaneElevation)=PlaneElevation;


end



