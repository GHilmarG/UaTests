%%
load Ua2D_Restartfile_PIGtransient_uvh_int.mat

PlotRunInfo(RunInfo,"-int-")

%%


load FR-Forward-Transient-group-.mat


PlotRunInfo(RunInfo,"-group-")

%%


load FR-Forward-Transient-dt0k1-.mat  ;         PlotRunInfo(RunInfo,"-int-dt0k1-")

load FR-Forward-Transient-group-dt0k1-.mat  ;   PlotRunInfo(RunInfo,"-group-dt0k1-")
 
load FR-Forward-Transient-uv-h.mat  ;           PlotRunInfo(RunInfo,"-uv-h-")

load FR-Forward-Transient-uv-h-group-.mat ;     PlotRunInfo(RunInfo,"-uv-h-group-")
%%

