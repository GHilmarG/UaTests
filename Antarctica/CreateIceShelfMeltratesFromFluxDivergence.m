%%


load('ForwardRestart.mat','CtrlVarInRestartFile','MUA','F'); 

%%

CtrlVar=CtrlVarInRestartFile;
dsdt=[];
dhdt=F.s*0 ; % here setting dh/dt to zero because I dont know what it is.
[ab,qx,qy,dqxdx,dqxdy,dqydx,dqydy]=CalcIceShelfMeltRates(CtrlVar,MUA,F.ub,F.vb,F.s,F.b,F.S,F.B,F.rho,F.rhow,dsdt,F.as,dhdt) ;


FindOrCreateFigure('Calculated basal melt'); 

[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,ab);
title(' Basal melt rates')
title(cbar,'(m/yr)')


abMax=-100;
abMin=0;

ab(ab>abMin)=abMin;
ab(ab<abMax)=abMax;

FindOrCreateFigure('Calculated basal melt (modified)'); 
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,ab);
title(' Basal melt rates (modified)')
title(cbar,'(m/yr)')


