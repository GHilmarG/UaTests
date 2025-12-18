

%%
% The meaning/purpose of various sub-strings can found in ParseRunTypeString

RunString="ES30km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";


%% Possible transient initialization 

% driverForwardAssimilation(RunString)

%%



RunString="-FR5to6-C-DP-CF0isBMCF-"+RunString;
RunString=replace(RunString,"-P-","-") ;  % "-P-" implies Prescribed level set, so I want to get rid of that if it was included
RunString=replace(RunString,"--","-") ;
UserVar.RunType=RunString;


CtrlVar.Restart=0;  % Here I might not want to start a forward restart run, but I need to have A and C files from a previous inversion corresponding to the start time of this transient run.
% A and C interpolants are then automatically created from a inverse restart file, unless existing FA and FC files are found that
% are newer than the inverse restart file
UserVar.InverseRestartFile="IR-at5-30km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
UserVar.GeometryInterpolant="FsbB-at5-30km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
  


Ua(UserVar)
%% UserVar.CalvingFront0="-BMCF-";