%%

%load  SteadyState_Restartfile_NoBasalMelt.mat
load Ua2D_Restartfile.mat
Fs=scatteredInterpolant(F.x,F.y,F.s);

Fb=scatteredInterpolant(F.x,F.y,F.b);


save("SteadyStateInterpolantsThuleNS.mat","Fb","Fs") 

