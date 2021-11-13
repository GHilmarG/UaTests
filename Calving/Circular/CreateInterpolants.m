%%

load  SteadyState_Restartfile_NoBasalMelt.mat

Fs=scatteredInterpolant(F.x,F.y,F.s);
Fb=scatteredInterpolant(F.x,F.y,F.b);


save("SteadyStateInterpolants.mat","Fb","Fs") 

