


%%

 %l        Qn                  Qint
% 3-node
T= [ ...
25000      0.33            25.1327 ; ...
20000      34.00           25.1327 ; ...
15000      35.72           25.1327 ; ...
12500      30.447          25.1327 ; ...
10000      23.1            25.1327 ;  ...
7500       24.0            25.1327 ; ...
6000       24.637          25.1327 ;  ...
5000       24.859          25.1327 ;  ...
4500       25.1912         25.1327 ; ...
3000       24.154          25.1327 ; ...
2500       24.645          25.1327 ;  ...
1500       24.8517         25.1327 ; ...
1000       24.8898         25.1327 ] ; 


figure(1000) ; 
hold off
plot(T(:,1)/1000,T(:,2),"or-")
hold on 
yline(25.1327)   
xlabel("Element size (km)")
ylabel("Total flux through fluxgate")
%%

