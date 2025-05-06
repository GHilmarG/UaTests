

%% Inverse
CurDir=pwd;
cd("D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\InverseRestartFiles")

load("IR-at2020-2k5km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-")
cd(CurDir)
CtrlVar=CtrlVarInRestartFile;
UserVar=UserVarInRestartFile;
%% Inverse figures



UaPlots(CtrlVar,MUA,F,[Meas.us Meas.vs],FigureTitle="uv measured")
PlotLatLonGrid(); 
title("Measured surface velocities",fontsize=16,interpreter="latex") ; subtitle("")
drawnow
fig=gcf ; fig.Position=[2600 360 1000 850] ;
f = gcf; exportgraphics(f,'VelocitesMeasured.png') ;

CtrlVar.QuiverSameVelocityScalingsAsBefore=true;
%Ifloat=GF.node<0.5; F.ub(Ifloat)=nan; F.vb(Ifloat)=nan;
UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="uv modeled")
PlotLatLonGrid(); 
title("Modelled surface velocities",fontsize=16,interpreter="latex") ; subtitle("")
drawnow
fig=gcf ; fig.Position=[2800 360 1000 850] ;


UaPlots(CtrlVar,MUA,F,F.C,FigureTitle="C") ; set(gca,'ColorScale','log') ; clim([1e-3 1]) ; 
PlotLatLonGrid(); 
title("Inverted basal slipperiness ($C$)",fontsize=16,interpreter="latex") ; subtitle("")
drawnow
fig=gcf ; fig.Position=[3000 360 1000 850] ;
f = gcf; exportgraphics(f,'C.png') ;
%%

CurDir=pwd;

cd("D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\RestartFiles")

load("FR2020to2500-2k5km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat")
%load("FR2020to2500-10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat")
cd(CurDir)


CtrlVar=CtrlVarInRestartFile;
UserVar=UserVarInRestartFile;


MUA=UpdateMUA(CtrlVar,MUA);

CtrlVar.Development.Pre2025uvhAssembly=false;
%%

UaPlots(CtrlVar,MUA,F,"-uv-")
hold on ; PlotLatLonGrid();
title("Modelled Velocities",fontsize=16)
subtitle("")
f = gcf; exportgraphics(f,'Velocities.pdf') ; 
 


UaPlots(CtrlVar,MUA,F,F.AGlen) ; set(gca,'ColorScale','log') ; clim([1e-10 1e-5])  



%%

figD=FindOrCreateFigure("MUA domains") ; clf(figD)

Color=othercolor("YlGnBu8",16) ;  % See othercolor.m for more options
Color=othercolor("Mtemperaturemap",16);
%Color=["r","b","c","g","m","y","k","r","b","c","g","m","y","k","r","b","c","g","m","y","k"];

for I=1:16

 PlotMuaMesh(CtrlVar,MUAnew,MUAnew.workers{I}.Partition,Color(I,:)) 
 hold on

end

axis tight equal
PlotLatLonGrid();
title("SPMD Finite Element Assembly",fontsize=16)
f = gcf; exportgraphics(f,'SPMD_Assembly.pdf')
f = gcf; exportgraphics(f,'SPMD_Assembly.png')
%%

CtrlVar.Parallel.uvhAssembly.spmd.isOn=true;
CtrlVar.Parallel.uvAssembly.spmd.isOn=true;
CtrlVar.Parallel.Distribute=false;

[UserVar,RunInfo,F,l,BCs,dt]=uvhSolveCompareSequencialAndParallelPerformance(UserVar,RunInfo,CtrlVar,MUA,F,F,l,BCs);

%%

CtrlVar.Parallel.isTest=false;
 [UserVar,RunInfo,F,l,BCs,dt]=uvh(UserVar,RunInfo,CtrlVar,MUA,F,F,l,l,BCs);

%%