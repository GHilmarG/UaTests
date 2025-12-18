%% 
warning('off','MATLAB:triangulation:PtsNotInTriWarnId')
warning('off','MATLAB:decomposition:SaveNotSupported')
warning('off','MATLAB:decomposition:genericError')
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:SaveNotSupported');


load Restart-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-GLrange-LSDRlin-kH10-Alim-Clim-Ca1-Cs100000-Aa1-As100000-.mat


% CtrlVar=CtrlVarInRestartFile;

PlotRunInfo(RunInfo," int 2 ")




%%

 load Restart-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-GLrange-LSDRlin-kH10-Alim-Clim-Ca1-Cs100000-Aa1-As100000-Old.mat


 % CtrlVar=CtrlVarInRestartFile;

 PlotRunInfo(RunInfo," int 1 ")


 %%
 load Restart-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-GLrange-uvh-LSDRlin-uvhGroup-uvGroup-kH10-Alim-Clim-Ca1-Cs100000-Aa1-As100000-.mat

 PlotRunInfo(RunInfo," group 1 ")