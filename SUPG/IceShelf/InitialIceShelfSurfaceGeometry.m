function h = InitialIceShelfSurfaceGeometry(UserVar,x,y)


hmin=10; hmax=1000;
x0=50e3; 

h=hmax+zeros(size(x)) ;
h(x>x0)=hmin ; 


end


