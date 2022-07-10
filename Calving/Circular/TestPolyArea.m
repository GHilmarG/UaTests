
%%

close all
xy=[0 0 ; 2 0 ; 2 1 ; 1 -1 ; 0 1 ];

xy=[-1 0 ; 1 0 ; 0 1 ; 0 -1 ; -1 0];

Poly1=[0 0 ; 1 0 ; 1 1 ; 0 1 ; 0 0 ];
Poly2=[0 0 ; 1 0 ; 1 1 ; 0 1.1 ; 0 0 ];
xy=[Poly1; nan nan ; Poly2 ];

polyarea(xy(:,1),xy(:,2))

figure ; plot(xy(:,1),xy(:,2),'r.-')  ; axis equal


shape=polyshape(xy);
A=area(shape)
L=perimeter(polyshape(Poly1));
fprintf("Area/Length %f \n ",A/L)



%%

close all
inan=find(isnan(xc));
Inan=find(isnan(Xc));

Inan=[1;Inan;numel(Xc)];
inan=[1;inan;numel(xc)];

ii=1;
II=2; 

x=[xc(inan(ii)+1:inan(ii+1)-1) ; nan ; Xc(Inan(II)+1:Inan(II+1)-1)]; 
y=[yc(inan(ii)+1:inan(ii+1)-1) ; nan ; Yc(Inan(II)+1:Inan(II+1)-1)];

x=[xc(inan(ii)+1:inan(ii+1)-1) ; nan ; xc(inan(ii)+1:inan(ii+1)-1)]; 
y=[yc(inan(ii)+1:inan(ii+1)-1) ; nan ; yc(inan(ii)+1:inan(ii+1)-1)];

xy=[x y];

xy=[Xc Yc ; nan nan ; xc yc];


shape=polyshape(xy);
A=area(shape)
L=perimeter(shape)
fprintf("Area/Length %f (km)\n ",A/L/1000)


figure ; plot(xy(:,1)/1000,xy(:,2)/1000,'r.-')  ; axis equal
  