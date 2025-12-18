


DataFile="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS5km-Tri3-.mat";
load(DataFile)
UserVar=[]; 
CtrlVar=CtrlVarInRestartFile;

%%
FindOrCreateFigure("MESH") ; PlotMuaMesh(CtrlVar,MUA)


%%  centre line profile, 1/2 channel width
iProfile=abs(F.y) < 1 ; 

FindOrCreateFigure("dJ/dC profile") ; plot(F.x(iProfile),InvFinalValues.dJdC(iProfile),"or") ; title("dJ/dC along centre line") ; xlabel("x (km)") ; ylabel("y (km)")
FindOrCreateFigure("dJ/dA profile") ; plot(F.x(iProfile),InvFinalValues.dJdAGlen(iProfile),"or")  ; title("dA/dC along centre line") ; xlabel("x (km)") ; ylabel("y (km)")


FindOrCreateFigure("A centre-line profile") ; 
plot(F.x(iProfile)/1000,InvFinalValues.AGlen(iProfile),"or",DisplayName="Retrieved A")  ; 
hold on 
plot(F.x(iProfile)/1000,Priors.TrueAGlen(iProfile),"xk",DisplayName="true A")  ; 
title("A along centre line") ; subtitle(DataFile)
legend
xlabel("x (km)") ; ylabel("y (km)")


FindOrCreateFigure("C centre-line profile") ; 
plot(F.x(iProfile)/1000,InvFinalValues.C(iProfile),"or",DisplayName="Retrieved C")  ; 
hold on 
plot(F.x(iProfile)/1000,Priors.TrueC(iProfile),"xk",DisplayName="true C")  ; 
title("C along centre line") ; subtitle(DataFile)
legend
xlabel("x (km)") ; ylabel("y (km)")

%% 25km profile, 1/4 channel width
iProfile=abs(F.y-25000) < 1 ; 
FindOrCreateFigure("A 25km profile") ; 
plot(F.x(iProfile)/1000,InvFinalValues.AGlen(iProfile),"or",DisplayName="Retrieved A")  ; 
hold on 
plot(F.x(iProfile)/1000,Priors.TrueAGlen(iProfile),"xk",DisplayName="true A")  ; 
title("A mid-distance betwee centre and side") ; subtitle(DataFile)
legend
xlabel("x (km)") ; ylabel("y (km)")

FindOrCreateFigure("C 25km profile") ; 
plot(F.x(iProfile)/1000,InvFinalValues.C(iProfile),"or",DisplayName="Retrieved C")  ; 
hold on 
plot(F.x(iProfile)/1000,Priors.TrueC(iProfile),"xk",DisplayName="true C")  ; 
title("C mid-distance between centre and side")
subtitle(DataFile)
legend
xlabel("x (km)") ; ylabel("y (km)")

%%  50m profile, along the channel boundary
iProfile=abs(F.y-50000) < 1 ; 
FindOrCreateFigure("A 50km profile") ; 
plot(F.x(iProfile)/1000,InvFinalValues.AGlen(iProfile),"or",DisplayName="Retrieved A")  ; 
hold on 
plot(F.x(iProfile)/1000,Priors.TrueAGlen(iProfile),"xk",DisplayName="true A")  ; 
title("A along channel wall") ; subtitle(DataFile)
legend
xlabel("x (km)") ; ylabel("y (km)")

FindOrCreateFigure("C 50km profile") ; 
plot(F.x(iProfile)/1000,InvFinalValues.C(iProfile),"or",DisplayName="Retrieved C")  ; 
hold on 
plot(F.x(iProfile)/1000,Priors.TrueC(iProfile),"xk",DisplayName="true C")  ; 
title("C along channel wall line")
subtitle(DataFile)
legend
xlabel("x (km)") ; ylabel("y (km)")


%%
[~,dhdt]=dhdtExplicit(UserVar,CtrlVar,MUA,F,BCs);  

FindOrCreateFigure("dh/dt profile at y=0")
iProfile=abs(F.y) < 1 ; 
plot(F.x(iProfile)/1000,dhdt(iProfile),"or",DisplayName="Retrieved C")  ; 
title("dh/dt at y=0$")



FindOrCreateFigure("dh/dt profile at y=25km")
iProfile=abs(F.y-25000) < 1 ; 
plot(F.x(iProfile)/1000,dhdt(iProfile),"or",DisplayName="Retrieved C")  ; 
title("dh/dt at y=25km")



%%

