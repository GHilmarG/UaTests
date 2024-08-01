


%%

l=100e3 ; 
x=linspace(0,l,200) ;
hl=0; aw=1;
rhow=1000; g=9.81 ; k=1e6 ;


% prescribing q(x=0)=0 and hw(x=l)=hl :
C1=0 ;
C2=rhow*g*k*hl^2+aw*l^2 ;

% prescribing hw(x=l)= hl and q(x=l)=0
% hl=10;
%C 1=aw*l ; C2=rhow*g*k*hl^2-aw*l^2 ;
%

hw2= (-aw*x.^2 + 2*C1*x+C2)/(rhow*g*k);  q=aw*x-C1 ;  hw=sqrt(hw2); 

figure(1)
yyaxis left
plot(x/1000,hw,"k")
ylabel("$h_w(x)\,(\mathrm{m})$",Interpreter="latex")
ylim([0 max(hw)])
yyaxis right
plot(x/1000,q/1e6,"r")
ylabel("$q_w(x)\,(\mathrm{km^2/yr})$",Interpreter="latex")
%plot(x/1000,qTest,"k--")

xlabel("$x\,(\mathrm{km})$",Interpreter="latex")


%%

ax = gca; exportgraphics(ax,'HydroAnalytical.pdf','ContentType','vector')