

syms phi h rhoi rhow g 
syms d(phi) txx(phi)

assume(rhoi > 0 )
assume(rhow > 0 )
assume(g > 0 )
assume(h>0)


d(phi) = ((1-phi).^2 .* rhoi./rhow  + (1-(1-phi).^2) ) .* h ; 
txx(phi)=(1/4)*rhoi.*g.*h+ (1/4)* ( (1-(1-phi).^2)./(1-phi).^2).*rhow.*g.*h - (1/4) * (1./(1-phi).^2).*rhow.*g.*d(phi).^2./h ;   

limit(txx,phi,0)

%%


rhoi=917; rhow=1030; 

g=9.81/1000; 
A=AGlenVersusTemp(-10);
n=3; 

h=1000;

phi=linspace(0,1);


D=(1-phi).^2; 

rhoE=(1-phi).^2 .* rhoi +  (1-(1-phi).^2) .*rhow ; 

txx0=(1/4)*rhoi *g *h* (1-rhoi./rhow) ; 


d = ((1-phi).^2 .* rhoi./rhow  + (1-(1-phi).^2) ) .* h ; 
%d=(rhoi/rhow)*h+phi*0 ; % for phi=0;



txx=(1/4)*rhoi.*g.*h+ (1/4)* ( (1-(1-phi).^2)./(1-phi).^2).*rhow.*g.*h - (1/4) * (1./(1-phi).^2).*rhow.*g.*d.^2./h ;    


FindOrCreateFigure("rho(phi)")
plot(D,rhoE)
ylabel("$\rho$",Interpreter="latex")
xlabel("$(1-\phi)^2$",Interpreter="latex")



FindOrCreateFigure("txx and d/h")
yyaxis left
plot(D,txx/txx0)
ylabel("$\frac{\tau_{xx}}{\tau_{xx}(\phi=0)}$",Interpreter="latex")
yyaxis right
plot(D,h./d)
ylabel("$h/d$",Interpreter="latex")

xlabel("$(1-\phi)^2$",Interpreter="latex")

legend("$\frac{\tau_{xx}}{\tau_{xx}(\phi=0)}$","$\frac{h}{d}$",Interpreter="latex",location="best")

%%

exx= A.*(txxE.^n) ; 


FindOrCreateFigure("exx")

plot(phi,exx)
xlabel("$\phi$",Interpreter="latex")
ylabel("$\dot{\epsilon}_{xx}$",Interpreter="latex")


%%