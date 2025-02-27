
%%

load Amod-IR-at2019-5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat
% load Cmod-IR-at2019-5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat

UserVar=UserVarInRestartFile;
CtrlVar=CtrlVarInRestartFile;
%%




UaPlots(CtrlVar,MUA,F,Priors.TrueAGlen,FigureTitle="A true") ; set(gca,'ColorScale','log') ; title("$A$ true",Interpreter="latex")
cbarA=clim;
UaPlots(CtrlVar,MUA,F,Priors.TrueC,FigureTitle="C true") ; set(gca,'ColorScale','log') ; title("$C$ true",Interpreter="latex")
cbarC=clim;

UaPlots(CtrlVar,MUA,F,F.AGlen,FigureTitle="A retrieved") ; set(gca,'ColorScale','log') ; title("$A$ retrieved",Interpreter="latex")
clim(cbarA) 
UaPlots(CtrlVar,MUA,F,F.C,FigureTitle="C retrived") ; set(gca,'ColorScale','log') ; title("$C$ retrieved",Interpreter="latex")
clim(cbarC)

UaPlots(CtrlVar,MUA,F,"-uv-"); title("modelled velocities")

UaPlots(CtrlVar,MUA,F,"-e-"); set(gca,'ColorScale','log') ; CM=cmocean('balanced',25) ; colormap(CM); clim([0.0001 0.1])

%%

PlotResultsFromInversion(UserVar,CtrlVar,MUA,BCs,F,l,F.GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);


%%