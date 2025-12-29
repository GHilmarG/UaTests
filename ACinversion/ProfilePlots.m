


function  ProfilePlots(UserVar,CtrlVar,RunInfo,MUA,BCs,F,l,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint)



if nargin==0

    DataFile="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS5km-Tri3-.mat";
    DataFile="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS5km-Tri6-.mat";
    load(DataFile)
    UserVar=[];
    CtrlVar=CtrlVarInRestartFile;
else
    DataFile="";
end

%% FindOrCreateFigure("MESH") ; PlotMuaMesh(CtrlVar,MUA)


%%  centre line profile, 1/2 channel width
iProfile=abs(F.y) < 1 ;

if ~isempty(InvFinalValues.dJdC)
    FindOrCreateFigure("dJ/dC profile") ; plot(F.x(iProfile),InvFinalValues.dJdC(iProfile),"or") ; title("dJ/dC along centre line") ; xlabel("x (km)") ; ylabel("y (km)")
end

if ~isempty(InvFinalValues.dJdAGlen)
    FindOrCreateFigure("dJ/dA profile") ; plot(F.x(iProfile),InvFinalValues.dJdAGlen(iProfile),"or")  ; title("dA/dC along centre line") ; xlabel("x (km)") ; ylabel("y (km)")
end


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



Fig0=FindOrCreateFigure("dh/dt profile at y=0") ; clf(Fig0)
iProfile=abs(F.y) < 1 ; 
plot(F.x(iProfile)/1000,dhdt(iProfile),"or",DisplayName="Retrieved C")  ; 
title("dh/dt at y=0$")



Fig25=FindOrCreateFigure("dh/dt profile at y=25km") ; clf(Fig25) 
iProfile=abs(F.y-25000) < 1 ; 
plot(F.x(iProfile)/1000,dhdt(iProfile),"or",DisplayName="Retrieved C")  ; 
title("dh/dt at y=25km")

Fig27=FindOrCreateFigure("dh/dt profile at y=27.5km") ; clf(Fig27) 
iProfile=abs(F.y-27500) < 1 ; 
plot(F.x(iProfile)/1000,dhdt(iProfile),"or",DisplayName="dhdt")  ; 
legend



end

%%

