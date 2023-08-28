 
%%

Bold=F1.B; 
bold=F1.b;
sold=F1.s;

UserVar.HelmholtzSmoothingLengthScale=10e3; 
UserVar.HelmholtzSmoothingLengthScale=9e3;
UserVar.HelmholtzSmoothingLengthScale=8e3;
UserVar.HelmholtzSmoothingLengthScale=7e3;
UserVar.HelmholtzSmoothingLengthScale=6e3;
UserVar.HelmholtzSmoothingLengthScale=5e3;
UserVar.HelmholtzSmoothingLengthScale=4e3;
UserVar.HelmholtzSmoothingLengthScale=1e3;

FieldsToBeDefined="";
[UserVar,F1.s,F1.b,F1.S,F1.B,F1.rho,F1.rhow,F1.g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F1,FieldsToBeDefined);
[F1.b,F1.h,F1.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F1.s,F1.B,F1.S,F1.rho,F1.rhow);

F0.b=F1.b ; F0.B=F1.B ; F0.h=F1.h ; F0.S=F1.S ; 

[F0.uw,F0.vw]=WaterFilmVelocities(CtrlVar,UserVar,MUA,F0,k) ; 
[F1.uw,F1.vw]=WaterFilmVelocities(CtrlVar,UserVar,MUA,F1,k) ; 


UaPlots(CtrlVar,MUA,F1,F1.B,FigureTitle="B smoothed") ;
UaPlots(CtrlVar,MUA,F1,F1.b,FigureTitle="b smoothed") ;
UaPlots(CtrlVar,MUA,F1,F1.s,FigureTitle="s smoothed") ;


UaPlots(CtrlVar,MUA,F1,F1.B-Bold,FigureTitle="Delta B ") ;
UaPlots(CtrlVar,MUA,F1,F1.b-bold,FigureTitle="Delta b ") ;
UaPlots(CtrlVar,MUA,F1,F1.s-sold,FigureTitle="Delta s ") ;


%%