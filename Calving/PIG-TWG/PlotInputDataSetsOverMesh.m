
%%
CtrlVar= Ua2D_DefaultParameters;
UserVar=FileDirectories([]);

load(UserVar.MeshFileDirectory+"MeshFile5km-PIG-TWG.mat","MUA") ;
load(UserVar.Interpolants+"BedMachineAntarctica-v3-GriddedInterpolants.mat","Fs","FB","Fb","Frho")  

%%
F=UaFields();
F.x=MUA.coordinates(:,1); 
F.y=MUA.coordinates(:,2); 

F.s=Fs(F.x,F.y) ;
F.b=Fb(F.x,F.y) ;
F.B=FB(F.x,F.y) ;
F.rho=Frho(F.x,F.y) ;
F.rhow=1030;
F.h=F.s-F.b;
F.S=F.s*0 ; 

 [F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow);

%%

cbar=UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="B");
CM=cmocean('-balanced',25,'pivot',0) ; colormap(CM);
title("Bedrock")
subtitle("")
title(cbar,"(m a.s.l.)")

cbar=UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="b");


title("Lower ice surface")
subtitle("")
title(cbar,"(m a.s.l.)")
hold on ; PlotCalvingFronts([],"ITS-LIVE",[],"b");

cbar=UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s");
CM=cmocean('-balanced',25,'pivot',0) ; colormap(CM);
title("Upper ice surface")
subtitle("")
title(cbar,"(m a.s.l.)")
hold on ; PlotCalvingFronts([],"ITS-LIVE",[],"b");



%%

Line=[-1587315.52795031         -483507.453416149 ; ...
    -1304771.42857143         -325331.055900621 ] ;

Line=Line/1000;

FindOrCreateFigure("B")
hold on ; 
plot([Line(1,1) Line(2,1)],[Line(1,2) Line(2,2)],LineStyle="-",Color="k",LineWidth=3)

Vector=[Line(2,1)-Line(1,1)  Line(2,2)-Line(1,2)];
Vector=Vector/norm(Vector);

Along=Vector;
Normal=[Vector(2) -Vector(1)] ;

Width=50e3 ;
Length=200e3;

Origin=[-1587315.52795031         -483507.453416149] ;

p1=Origin-Width*Normal; 
p2=Origin+Width*Normal; 
p3=Origin+Length*Vector+Width*Normal; 
p4=Origin+Length*Vector-Width*Normal; 

Square=[p1 ; p2 ; p3 ; p4 ; p1];

hold on ;
plot(p1(1)/1000,p1(2)/1000,"ok")
plot(p2(1)/1000,p2(2)/1000,"ok")
plot(p3(1)/1000,p3(2)/1000,"ok")
plot(p4(1)/1000,p4(2)/1000,"ok")

plot(Square(:,1)/1000,Square(:,2)/1000,color="k",LineStyle="--",LineWidth=2)



%%


%%