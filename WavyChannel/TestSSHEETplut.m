 UaHomeDirectory=getenv('UaHomeDirectory');
addpath([UaHomeDirectory,'/SuiteSparse/CHOLMOD/MATLAB'],'-begin')
%%
load Ua2d_Restartfile
CtrlVar=CtrlVarInRestartFile;

[txzb,tyzb]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,GF,s,b,ub,vb);
[udPlus,vdPlus]=uvSSHEETplus(CtrlVar,MUA,BCs,AGlen,n,h,txzb,tyzb);

[ud,vd]=uvSSHEET(CtrlVar,MUA,BCs,AGlen,n,rho,g,s,h);



x=MUA.coordinates(:,1);
figure ; 
subplot(3,1,1)
plot(x/1000,txzb); title('txzb')
subplot(3,1,2)
plot(x/1000,udPlus,'b'); title('ud plus')
hold on
plot(x/1000,ud,'r'); title('ud')
legend('ud Plus','ud')
subplot(3,1,3)
plot(x/1000,h) ; title('h')