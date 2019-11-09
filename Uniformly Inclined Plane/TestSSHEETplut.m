
%%
load Ua2d_Restartfile
CtrlVar=CtrlVarInRestartFile;

[txzb,tyzb]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,GF,s,b,ub,vb);
[udPlus,vdPlus]=uvSSHEETplus(CtrlVar,MUA,AGlen,n,h,txzb,tyzb);

[ud,vd]=uvSSHEET(CtrlVar,MUA,AGlen,n,rho,g,s,h);


x=MUA.coordinates(:,1);
figure ; plot(x/1000,txzb); title('txzb')
figure
plot(x/1000,udPlus,'b'); title('ud plus')
hold on
plot(x/1000,ud,'r'); title('ud')
legend('ud Plus','ud')
