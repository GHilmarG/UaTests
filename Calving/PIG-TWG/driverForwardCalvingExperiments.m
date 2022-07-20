
% 30km = 14km
% 20km = 9.3km
% 10km = 4.6km
%  5km = 2.3km
% 2.5km = 1.16km

%% 5km runs which actually are 2.4 km runs:

UserVar.RunType="-FT-C-DP-MR4-Ini5-BMGL-5km-Alim-Ca1-Cs100000-Aa1-As100000-" ; 
% UserVar.RunType="-FT-C-AC-MR4-Ini1-BMGL-5km-Alim-Ca1-Cs100000-Aa1-As100000-" ; 
% UserVar.RunType="-FT-C-AC-T5-MR4-Ini1-BMGL-5km-Alim-Ca1-Cs100000-Aa1-As100000-" ; 


%%
%% 20km runs which actually are 9.4 km runs:

% Here I need: FC-Weertman-Ca1-Cs100000-Aa1-As100000-20km-Alim- 

% UserVar.RunType="-FT-C-DP-MR4-Ini5-BMGL-20km-Alim-Ca1-Cs100000-Aa1-As100000-" ; 
% UserVar.RunType="-FT-C-AC-MR4-Ini1-BMGL-20km-Alim-Ca1-Cs100000-Aa1-As100000-" ; 
 UserVar.RunType="-FT-C-AC-T5-MR4-Ini1-BMGL-10km-Alim-Ca1-Cs100000-Aa1-As100000-" ; % possibly this was related to a convergence test

%% UserVar.RunType="-FT-AM-C-AC-MR4-Ini1-BMGL-5km-Alim-Ca1-Cs100000-Aa1-As100000-" ; 

%  AM  : Adaptive Meshing global 
%  AC

%%

CreateAndSaveACInterpolants=false;
BatchJob=false;

CtrlVar.TotalTime=200;
CtrlVar.Inverse.Regularize.logC.ga=str2double(extract(extract(UserVar.RunType,"-Ca"+digitsPattern+"-"),digitsPattern)) ; 
CtrlVar.Inverse.Regularize.logC.gs=str2double(extract(extract(UserVar.RunType,"-Cs"+digitsPattern+"-"),digitsPattern)) ; 
CtrlVar.Inverse.Regularize.logAGlen.ga=str2double(extract(extract(UserVar.RunType,"-Aa"+digitsPattern+"-"),digitsPattern)) ;
CtrlVar.Inverse.Regularize.logAGlen.gs=str2double(extract(extract(UserVar.RunType,"-As"+digitsPattern+"-"),digitsPattern)) ; 

CtrlVar.SlidingLaw="Weertman";

CtrlVar.LevelSetDownstreamAGlen=AGlenVersusTemp(0);  

pat="-"+digitsPattern+"km";
MR=str2double(extract(extract(UserVar.RunType,pat),digitsPattern));
UserVar.MeshResolution=MR*1000;   % MESH RESOLUTION

% Now set UserVar

InvFile=CtrlVar.SlidingLaw...
    +"-Ca"+num2str(CtrlVar.Inverse.Regularize.logC.ga)...
    +"-Cs"+num2str(CtrlVar.Inverse.Regularize.logC.gs)...
    +"-Aa"+num2str(CtrlVar.Inverse.Regularize.logAGlen.ga)...
    +"-As"+num2str(CtrlVar.Inverse.Regularize.logAGlen.gs)...
    +"-"+num2str(UserVar.MeshResolution/1000)+"km";

if contains(UserVar.RunType,"-Alim-")
    InvFile=InvFile+"-Alim-";
end
InvFile=replace(InvFile,".","k");

UserVar.AFile="FA-"+InvFile;
UserVar.CFile="FC-"+InvFile;


if CreateAndSaveACInterpolants
    % Create and save interpolants
    load("InvA-"+InvFile,"AGlen","xA","yA") ;
    % load("InvA-Weertman-Ca1-Cs100000-Aa1-As100000-10km","AGlen,"xA,"yA") ;
    FA=scatteredInterpolant(xA,yA,AGlen);
    save(UserVar.AFile,"FA");

    load("InvC-"+InvFile,"C","xC","yC")
    FC=scatteredInterpolant(xC,yC,C);
    save(UserVar.CFile,"FC")
end

if BatchJob
    job2=batch(@Ua,0,{UserVar,CtrlVar},Pool=1) ;
else
    Ua(UserVar,CtrlVar)
end

