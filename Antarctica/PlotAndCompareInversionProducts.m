


%%

Directory="C:\Users\pcnj6\OneDrive - Northumbria University - Production Azure AD\Sandbox\InverseRestartFiles\" ;

IRfile=Directory+"IR-panAntarctic-m3-n3-Weertman-Nod3-Cga1-Cgs100000-Aga1-Ags100000-logC-logA-N111k-E218k-.mat";

load(IRfile)

%%

Directory="C:\Users\pcnj6\OneDrive - Northumbria University - Production Azure AD\Sandbox\InverseRestartFiles\" ;

IRfile=Directory+"InverseRestartFile-Weertman-Ca1-Cs100000-Aa1-As100000-2k5km-Alim-Clim-.mat"; 


load(IRfile)


%%

cbar=UaPlots(CtrlVarInRestartFile,MUA,F,log10(F.C),FigureTitle="log10(C)") ; 
title("$\log_{10}(C)$",interpreter="latex")
title(cbar, '($\mathrm{kPa^{-3}\, m \, a^{-1}}$)',interpreter="latex");
clim([-9 -2])

cbar=UaPlots(CtrlVarInRestartFile,MUA,F,log10(F.AGlen),FigureTitle="log10(A)") ; 
title("$\log_{10}(A)$",interpreter="latex")
title(cbar, '($\mathrm{kPa}^{-3}\,\mathrm{a}^{-1}$)',interpreter="latex");
colormap(othercolor("Mtemperaturemap",1028))
clim([-10 -7])

%%

 PlotResultsFromInversion(UserVarInRestartFile,CtrlVarInRestartFile,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);