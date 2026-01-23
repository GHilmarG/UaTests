


function  ProfilePlots(UserVar,CtrlVar,RunInfo,MUA,BCs,F,l,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint)



if isstring(UserVar) && (isfile(UserVar)  || isfile(UserVar+".mat")) 

    fprintf("loading and plotting results from %s \n",UserVar)

    load(UserVar,"UserVarInRestartFile","CtrlVarInRestartFile","MUA","BCs","F","InvStartValues","InvFinalValues","Priors","Meas","RunInfo") ;

    CtrlVar=CtrlVarInRestartFile;
    UserVar=UserVarInRestartFile;

end



%% FindOrCreateFigure("MESH") ; PlotMuaMesh(CtrlVar,MUA)


%%  center line profile, 1/2 channel width
iProfile=abs(F.y) < 1 ;

PM=CtrlVar.Inverse.AdjointGradientPreMultiplier;




if ~isempty(InvFinalValues.dJdC)

    if PM=="M"
        T="$\nabla_C J = M^{-1} dJ/dC$";
    else
        T="$\nabla_C J=dJ/dC$";
    end

    FgradC=FindOrCreateFigure("grad_C profile") ; clf(FgradC)

    iProfile=abs(F.y) < 1 ;
    plot(F.x(iProfile)/1000,InvFinalValues.dJdC(iProfile),"or-",DisplayName="$\nabla_C J$ at $y$=0 km") ;
    hold on 
   
    iProfile=abs(F.y-25000) < 1 ;
    plot(F.x(iProfile)/1000,InvFinalValues.dJdC(iProfile),"og-",DisplayName="$\nabla_C J$ at $y$=25 km") ;
    
    iProfile=abs(F.y-50000) < 1 ;
    plot(F.x(iProfile)/1000,InvFinalValues.dJdC(iProfile),"ob-",DisplayName="$\nabla_C J$ at $y$=50 km") ;

    title(T,Interpreter="latex");
    xlabel("x (km)") ; 
    ylabel(T,Interpreter="latex")
    lg=legend(Interpreter="latex",Location="best");
end





if ~isempty(InvFinalValues.dJdAGlen)

    if PM=="M"
        T="$\nabla_A J = M^{-1} dJ/dA$";
    else
        T="$\nabla_A J=dJ/dA$";
    end

    FgradA=FindOrCreateFigure("grad_A profile") ; clf(FgradA)

    iProfile=abs(F.y) < 1 ;
    plot(F.x(iProfile)/1000,InvFinalValues.dJdAGlen(iProfile),"or-",DisplayName="$\nabla_A J$ at $y$=0 km") ;
    hold on

    iProfile=abs(F.y-25000) < 1 ;
    plot(F.x(iProfile)/1000,InvFinalValues.dJdAGlen(iProfile),"og-",DisplayName="$\nabla_A J$ at $y$=25 km") ;

    iProfile=abs(F.y-50000) < 1 ;
    plot(F.x(iProfile)/1000,InvFinalValues.dJdAGlen(iProfile),"ob-",DisplayName="$\nabla_A J$ at $y$=50 km") ;

    title(T,Interpreter="latex");
    xlabel("x (km)") ;
    ylabel(T,Interpreter="latex")
    lg=legend(Interpreter="latex",Location="best");


end

if PM=="I"

    dJdA=MUA.M\InvFinalValues.dJdAGlen;
    dJdC=MUA.M\InvFinalValues.dJdC;

    if ~isempty(InvFinalValues.dJdC)
        FindOrCreateFigure("M\dJ/dC profile") ;
        plot(F.x(iProfile)/1000,dJdC(iProfile),"or") ;
        title("$M^{-1} dJ/dC$ along centre line, pre-multipiler: "+PM,Interpreter="latex");
        xlabel("x (km)") ; ylabel("y (km)")
    end

    if ~isempty(InvFinalValues.dJdAGlen)
        FindOrCreateFigure("M\dJ/dA profile") ;
        plot(F.x(iProfile)/1000,dJdA(iProfile),"or")  ;
        title("$M^{-1} dJ/dA$ along centre line, pre-multipiler: "+PM,Interpreter="latex");
        xlabel("x (km)") ; ylabel("y (km)")
    end

end



 


%%



Fig0=FindOrCreateFigure("dh/dt profiles ") ; clf(Fig0)

iProfile=abs(F.y) < 1 ; 
plot(F.x(iProfile)/1000,F.dhdt(iProfile),"or-",DisplayName="$\dot{h}$ at $y=0$")  ; 
hold on 

iProfile=abs(F.y-25000) < 1 ; 
plot(F.x(iProfile)/1000,F.dhdt(iProfile),"og-",DisplayName="$\dot{h}$ at $y=25$ km")  ; 

iProfile=abs(F.y-50000) < 1 ; 
plot(F.x(iProfile)/1000,F.dhdt(iProfile),"ob-",DisplayName="$\dot{h}$ at $y=50$ km") 
xlabel("$x$ (km)",Interpreter="latex") ;  ylabel("$\dot{h}$ (m/yr)",Interpreter="latex")
legend(Interpreter="latex",Location="best")

title("$\dot{h}$",Interpreter="latex")
xlabel("$x$ (km)",Interpreter="latex") ;  ylabel("$\dot{h}$ (m/yr)",Interpreter="latex")

%%
% Note all true C are the same here so only need one profile

FigCP=FindOrCreateFigure("C profiles ") ; clf(FigCP)

iProfile=abs(F.y) < 1 ; 
plot(F.x(iProfile)/1000,InvFinalValues.C(iProfile),"or-",LineWidth=2,DisplayName="$C$ retrieved at $y=0$ km")  ; 
hold on 
%plot(F.x(iProfile)/1000,Priors.TrueC(iProfile),"*r-",DisplayName="$C$ true at $y=0$ km")  ; 

hold on 
iProfile=abs(F.y-25000) < 1 ; 
plot(F.x(iProfile)/1000,InvFinalValues.C(iProfile),"og-",LineWidth=2,DisplayName="$C$ retrieved at $y=25$ km")  ; 
%plot(F.x(iProfile)/1000,Priors.TrueC(iProfile),"sg-",DisplayName="$C$ true at $y=25$ km")  ; 


iProfile=abs(F.y-50000) < 1 ; 
plot(F.x(iProfile)/1000,InvFinalValues.C(iProfile),"ob-",LineWidth=2,DisplayName="$C$ retrieved at $y=50$ km")  ; 
plot(F.x(iProfile)/1000,Priors.TrueC(iProfile),"*k-",DisplayName="$C$ true")  ; 

xlabel("$x$ (km)",Interpreter="latex") ;  ylabel("$\dot{h}$ (m/yr)",Interpreter="latex")
lg=legend(Interpreter="latex",Location="best");
lg.NumColumns=3;

title("$C$ retrieved and true",Interpreter="latex")
xlabel("$x$ (km)",Interpreter="latex") ;  
ylabel("$A \; [\mathrm{m} \, (\mathrm{yr}\;\mathrm{kPa})^{-1}]$",Interpreter="latex")


%%

%%
% Note all true C are the same here so only need one profile

FigAP=FindOrCreateFigure("A profiles ") ; clf(FigAP)

iProfile=abs(F.y) < 1 ; 
plot(F.x(iProfile)/1000,InvFinalValues.AGlen(iProfile),"or-",LineWidth=2,DisplayName="$A$ retrieved at $y=0$ km")  ; 
hold on 


hold on 
iProfile=abs(F.y-25000) < 1 ; 
plot(F.x(iProfile)/1000,InvFinalValues.AGlen(iProfile),"og-",LineWidth=2,DisplayName="$A$ retrieved at $y=25$ km")  ; 


iProfile=abs(F.y-50000) < 1 ; 
plot(F.x(iProfile)/1000,InvFinalValues.AGlen(iProfile),"ob-",LineWidth=2,DisplayName="$A$ retrieved at $y=50$ km")  ; 
plot(F.x(iProfile)/1000,Priors.TrueAGlen(iProfile),"*k-",DisplayName="$A$ true")  ; 

xlabel("$x$ (km)",Interpreter="latex") ;  ylabel("$\dot{h}$ (m/yr)",Interpreter="latex")
lg=legend(Interpreter="latex",Location="best");
lg.NumColumns=3;

title("$A$ retrieved and true",Interpreter="latex")
xlabel("$x$ (km)",Interpreter="latex") ;  
ylabel("$A \; [(\mathrm{yr}\;\mathrm{kPa})^{-1}]$",Interpreter="latex")


end

% title("") ; Fig=gca ; exportgraphics(gcf,"ACInversionExampleOfGradAatStart.pdf",Padding="tight")    ;
%% 

