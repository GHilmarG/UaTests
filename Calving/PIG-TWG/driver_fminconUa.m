

doPlotFunction=1;


a=1 ; 



func=@(x) RosenbrockFunction(x) ;




%% optimisation

A=[] ; b=[] ; Aeq=[] ; beq=[] ; xLb=[] ; xUb=[] ; nonlcon=[] ;

x0=[-1 ; 6] ;


CtrlVar.fminconUa.Itmax=10;




CtrlVar.fminconUa.TolNorm=1e-6 ;
CtrlVar.fminconUa.Step="Newton" ;
CtrlVar.fminconUa.Step="Cauchy" ;
CtrlVar.fminconUa.Step="Steepest" ;
CtrlVar.fminconUa.Step="Auto" ;

CtrlVar.fminconUa.ReturnEachIterate=true ; 
CtrlVar.fminconUa.Backtracking=true ;
[x,Jexit,exitflag,output] = fminconUa(func,x0,A,b,Aeq,beq,xLb,xUb,nonlcon,CtrlVar) ;



%% Plotting


if doPlotFunction
    n=100 ;
    x1=linspace(-3,2,n);
    x2=linspace(-1,7,n);

    [X,Y]=ndgrid(x1,x2); Z=X*0;  % for plotting

    for I=1:n
        for J=1:n
            x=[x1(I) , x2(J)] ;
            Z(I,J)=func(x);
        end
    end


    fpath=FindOrCreateFigure("path") ; clf(fpath);
    contourf(X,Y,Z,40) ; colorbar ; axis equal
    hold on
    xSeq=output.xSeq;


    if ~isempty(xSeq)
        plot(xSeq(:,1),xSeq(:,2),'-or',MarkerFaceColor="r")
    end

    Nit=numel(output.JSeq) ;
    I=~isnan(output.JSeq);
    N=numel(find(I));
    fprog=FindOrCreateFigure("prog") ; clf(fprog) ;
    semilogy(0:(N-1),output.JSeq(I),"ob-",LineWidth=1.5) ; 

    ylabel("$J$",Interpreter="latex")

    yyaxis right

      I=~isnan(output.JGrad);
    semilogy(0:(N-1),output.JGrad(I),"or-") ; 

    xlabel("Iteration",Interpreter="latex")
    title(sprintf("J=%g \t",Jexit))
    legend("$J$","$\|\nabla J\|$",interpreter="latex")

end