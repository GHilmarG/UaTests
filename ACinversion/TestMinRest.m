

function TestMinRest(Hfull,g0)

%  load("MinRest.mat","Hfull","g0")

dp=Hfull\(-g0);  % Here I need to add in the BCs, I need BCs on dp, i.e. dA and dC
%   [L,cuv]=AssembleLuvSSTREAM(CtrlVar,MUA,BCs) ;

L=chol(Hfull) ;
tol=1e-6; maxit=15 ;
[dpTest,fl,rr,it,rv1,rvcgl]=minres(Hfull,-g0,tol,maxit,L',L);
Fig=FindOrCreateFigure("minres") ; plot(0:length(rv1)-1,rv1/norm(g0),"-or") ; ax=gca ; ax.YScale="log";



afun=@(x) HVP(x,Hfull) ;

[dpTest,fl,rr,it,rv1,rvcgl]=minres(afun,-g0,tol,maxit,L',L);
FigHVP=FindOrCreateFigure("minres HVP") ; plot(0:length(rv1)-1,rv1/norm(g0),"-or") ; ax=gca ; ax.YScale="log";


afun=@(x) HessianVectorProduct
HVP=HessianVectorProduct(p,d,func)


    function y=HVP(x,Hfull)
        y=Hfull*x;

    end


end