function B=DefineCone(x,y)

x0=[0] ; y0=[0 ]; dBds=[-0.2];  B0=[5000];

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
