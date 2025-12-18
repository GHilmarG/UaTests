function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)


if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call') ; return ; end


%%


iCentre=abs(F.y) < 1 ; 

FindOrCreateFigure("dJ/dC profile") ; plot(F.x(iCentre),InvFinalValues.dJdC(iCentre),"or") ; title("dJ/dC along centre line")
FindOrCreateFigure("dJ/dA profile") ; plot(F.x(iCentre),InvFinalValues.dJdC(iCentre),"or")  ; title("dA/dC along centre line")



FindOrCreateFigure("A profile") ; 

plot(F.x(iCentre),InvFinalValues.AGlen(iCentre),"or",DisplayName="Retrieved A")  ; 
hold on 
plot(F.x(iCentre),Priors.TrueAGlen(iCentre),"xk",DisplayName="true A")  ; 


title("A along centre line")
legend



FindOrCreateFigure("C profile") ; 

plot(F.x(iCentre),InvFinalValues.C(iCentre),"or",DisplayName="Retrieved C")  ; 
hold on 
plot(F.x(iCentre),Priors.TrueC(iCentre),"xk",DisplayName="true C")  ; 


title("C along centre line")
legend

%%







