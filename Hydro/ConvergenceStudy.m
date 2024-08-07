
%%





dxQ = [1162   38.5098 ; ...
    1549.8   38.5114 ; ...
    2323   38.519 ; ...
    100e3/20   35.5623 ; ...
    100e3/10   52.8255 ; ...
    3098   38.4845 ;
    930   38.5091 ;
    3716.44 39.5892 ;
    4642      35.5623 ; 
    5578      34.2695 ; 
    6526       48.6736 ; 
    7404       50.7211 ; 
    6868.73    47.3885 ; 
    6637       36.843 ;
    6634   37.2335 ;
    4184   40.4768 ; 
    13865  36.9323 ; 
    2981   38.4036 ; 
    1859.44    38.513  ;
    465.18     38.5086] ;


dx=dxQ(:,1); Q=dxQ(:,2);

[dx,I]=sort(dx) ; Q=Q(I);


figure(10)
semilogx(dx,Q,"o-")
%plot(dx,Q,"o-")

Q=pi*35000^2*10/1e9;

yline(Q,"--")
xlabel("$\Delta x \;\mathrm{(km)}$",Interpreter="latex")
ylabel("$Q\;\mathrm{(Gt/yr)}$",Interpreter="latex")


% dy=10; ylim([Q-dy Q+dy])
%%