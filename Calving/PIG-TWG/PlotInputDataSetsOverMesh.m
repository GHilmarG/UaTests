
%%
CtrlVar= Ua2D_DefaultParameters;
UserVar=FileDirectories([]);

load(UserVar.MeshFileDirectory+"MeshFile5km-PIG-TWG.mat","MUA") ;
load(UserVar.Interpolants+"BedMachineAntarctica-v3-GriddedInterpolants.mat","Fs","FB","Fb","Frho")  

load("ase_basin_masks.mat","x_crosson_dotson","y_crosson_dotson","x_thwaites","y_thwaites","x_pig","y_pig") 

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
hold on ; 
PlotCalvingFronts([],"ITS-LIVE",[],"b");
plot(x_thwaites/1000,y_thwaites/1000,".r")
plot(x_pig/1000,y_pig/1000,".r")
plot(x_crosson_dotson/1000,y_crosson_dotson/1000,".r")


cbar=UaPlots(CtrlVar,MUA,F,F.b-F.B,FigureTitle="b-B");
CM=cmocean('-balanced',25,'pivot',0) ; colormap(CM);
title("Lower ice surface - Ocean floor")
subtitle("")
title(cbar,"(m)")
hold on ; PlotCalvingFronts([],"ITS-LIVE",[],"b");
clim([0 1000]) 
axis([-1730 -1400 -725 -200])



%%




%%