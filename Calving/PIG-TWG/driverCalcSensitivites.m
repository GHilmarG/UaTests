

%%




UserVar.RunType="ES2k5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % get rid of BCVel since I need to recreate BCs
UserVar=FileDirectories(UserVar);

File="0203000-FR2020to2500-2k5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat";
File="0203000-FR2020to2500-30km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat";
File="0203000-FR2020to2500-20km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat";
File="0203000-FR2020to2300-10km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat";
File="0203000-FR2020to2500-5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat";  % out of memory


DataFile=UserVar.ResultsFileDirectory+File;

load(DataFile,"UserVar","CtrlVar","MUA","F")


[cbar,xGL,yGL,xCF,yCF,CtrlVar,lg]=UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="uv") ;


BCs=BoundaryConditions();


UserVar.RunType="";

[UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs);
figure(100); PlotBoundaryConditions(CtrlVar,MUA,BCs);


%% Here calculating for single nodes at a time

CtrlVar.CalcMUA_Derivatives=true;
CtrlVar.MUA.MassMatrix=true;
MUA=UpdateMUA(CtrlVar,MUA);

CtrlVar.Development.Pre2025uvAssembly=false;


xPIG=-1620e3 ; yPIG=-320e3 ;

x=xThwaites ; y=yThwaites;
% x=xPIG ; y=yPIG;

d2=(F.x-x).^2+(F.y-y).^2;
[d2min,Node]=min(d2) ;


tic
[dudA,dvdA]=duvdAFunc(CtrlVar,MUA,F,BCs,Node);  % takes about 65 sec for 10km with 19,522 nodes
toc

%%



dudANode=dudA;
dvdANode=dvdA;


CtrlVar.MaxPlottedSpeed=inf;
CtrlVar.MinPlottedSpeed=0;
CtrlVar.QuiverColorSpeedLimits=[0 1e10];
CtrlVar.VelPlotIntervalSpacing='log10';

CtrlVar.VelPlotIntervalSpacing='lin';
CtrlVar.RelativeVelArrowSize=1;
CtrlVar.QuiverColorPowRange=2;

UaPlots(CtrlVar,MUA,F,dudANode,FigureTitle="du/dA",GetRidOfValuesDownStreamOfCalvingFronts=false)
hold on ; plot(F.x(Node)/1000,F.y(Node)/1000,"or",MarkerFaceColor="m")

UaPlots(CtrlVar,MUA,F,dvdANode,FigureTitle="dv/dA",GetRidOfValuesDownStreamOfCalvingFronts=false)
hold on ; plot(F.x(Node)/1000,F.y(Node)/1000,"or",MarkerFaceColor="m")

UaPlots(CtrlVar,MUA,F,[dudANode dvdANode],FigureTitle="A velocity response",GetRidOfValuesDownStreamOfCalvingFronts=false)
hold on ; plot(F.x(Node)/1000,F.y(Node)/1000,"or",MarkerFaceColor="m")




%% Now calculate the gradient

CtrlVar.MinPlottedSpeed=0;
CtrlVar.QuiverColorSpeedLimits=[];
CtrlVar.VelPlotIntervalSpacing='log10';

CtrlVar.VelPlotIntervalSpacing='lin';
CtrlVar.RelativeVelArrowSize=1;
CtrlVar.QuiverColorPowRange=2;

graduA=MUA.M\dudA;  gradvA=MUA.M\dvdA;   
UaPlots(CtrlVar,MUA,F,[graduA gradvA],FigureTitle="grad")

%%