function He=LinTaper(x,a,b)


He=x ;
He(x<a)=0;
He(x>b)=1;

I=x>=a & x<= b ;

He(I)=(x(I)-a)./(b-a) ;

% He(I)=sqrt((x(I)-a)./(b-a)) ;




end