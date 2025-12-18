

function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)


%%



            UserVar.RunType="0202000-FR2019to2020-5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat   " ; 
CtrlVar.Inverse.NameOfRestartInputFile="IR-at2019-5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat";

UserVar.RunType="Amod5km"; 
CtrlVar.Inverse.NameOfRestartInputFile="Amod-IR-at2019-5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat";

 UserVar.RunType="Cmod5km"; 
 CtrlVar.Inverse.NameOfRestartInputFile="Cmod-IR-at2019-5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat";
%%

UserVar=FileDirectories(UserVar) ;

UserVar.Region="PIG-TWG" ; "PIG" ; % "PIG-TWG" ;
UserVar.DefineOutputs="-ubvb-LSF-h-dhdt-speed-save-AC-";
CtrlVar.LimitRangeInUpdateFtimeDerivatives=true ;


%% Parallel options
CtrlVar.Parallel.uvhAssembly.spmd.isOn=true;
CtrlVar.Parallel.uvAssembly.spmd.isOn=true;
CtrlVar.Parallel.Distribute=false;
CtrlVar.Parallel.isTest=false;
%% Data input files
% This run requires some additional input files. They are too big to be kept on Github so you
% will have to get those separately.
%
% You can get these files on OneDrive using the link:
%
%   https://livenorthumbriaac-my.sharepoint.co
% m/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwB1hgKNnRMscUitVpBrghjRg?e=yMZEOs
%
% Put the OneDrive folder `Interpolants' into you directory so that it can be reached as ../Interpolants with respect to you rundirectory.
%


UserVar.MeshBoundaryCoordinatesFile="../../Interpolants/BedMachineAntarctica-v3-MeshBoundaryCoordinates.mat";
load(UserVar.MeshBoundaryCoordinatesFile,"Boundary") ; UserVar.BedMachineBoundary=Boundary;
UserVar.DistanceBetweenPointsAlongBoundary=5e3 ;

UserVar.GeometryInterpolant="../../Interpolants/BedMachineAntarctica-v3-GriddedInterpolants.mat" ; 
UserVar.SurfaceVelocityInterpolant="../../Interpolants/ITS-LIVE-ANT-G0120-0000-VelocityGriddedInterpolants-nStride2.mat"; 

if ~isfile(UserVar.GeometryInterpolant) || ~isfile(UserVar.SurfaceVelocityInterpolant)

    fprintf('\n This run requires the additional input files: \n %s \n %s  \n \n',UserVar.GeometryInterpolant,UserVar.SurfaceVelocityInterpolant)
    fprintf('You can download these file from : https://livenorthumbriaac-my.sharepoint.com/:f:/g/personal/hilmar_gudmundsson_northumbria_ac_uk/EgrEImnkQuJNmf1GEB80VbwBF0SQnJdXtucDHKtPnv7G9Q?e=5aLX7T \n')
end







%% Times, time steps, output interval

% time and TotalTime already extracted from UserVar.RunType
CtrlVar.DefineOutputsDt=0.1;
CtrlVar.dt=1e-3;
CtrlVar.ATSdtMax=0.1;
CtrlVar.ATSdtMin=1e-5;
CtrlVar.ATSTargetIterations=6;



CtrlVar.ExplicitEstimationMethod="-no extrapolation-";



%% Plotting
CtrlVar.doplots=1;
CtrlVar.PlotMesh=0;
CtrlVar.PlotBCs=0 ;
CtrlVar.PlotXYscale=1000;
CtrlVar.doAdaptMeshPlots=5;
CtrlVar.PlotsXaxisLabel="xps (km)";
CtrlVar.PlotsYaxisLabel="yps (km)";

MeshBoundaryCoordinates=[]; 


%% Inverse
CtrlVar.InverseRun=true;    
CtrlVar.Restart=true;     
CtrlVar.Inverse.Iterations=5000; 



CtrlVar.Inverse.Regularize.logAGlen.ga=0.1;
CtrlVar.Inverse.Regularize.logAGlen.gs=0.1 ;
CtrlVar.Inverse.Regularize.logC.ga=0.1;
CtrlVar.Inverse.Regularize.logC.gs=0.1 ; 



CtrlVar.Inverse.NameOfRestartOutputFile=CtrlVar.Inverse.NameOfRestartInputFile; 

%%  Run files, names of run files etc.

CtrlVar.SaveInitialMeshFileName=[] ; % Do not create a new initial mesh file each time



CtrlVar.ReadInitialMeshFileName=replace(CtrlVar.ReadInitialMeshFileName,".","k");
if ~isempty(CtrlVar.SaveInitialMeshFileName)
    CtrlVar.SaveInitialMeshFileName=replace(CtrlVar.SaveInitialMeshFileName,".","k");
end



end
