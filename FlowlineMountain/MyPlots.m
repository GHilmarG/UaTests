
load Ua2D_Restartfile.mat ; 
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);


figure(10)
plot(x/1000,F.h,'.');
xlabel('x (km)')
ylabel('y (m)')
title(sprintf('Ice thickness at time=%f \n ',CtrlVarInRestartFile.time))
