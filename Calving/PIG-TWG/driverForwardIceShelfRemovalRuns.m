

UserVar.RunType="-FT-P-TWISC0-MR4-SM-5km-Alim" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 0km away


UserVar.RunType="-FT-P-TWISC0-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 0km away
UserVar.RunType="-FT-P-TWIS-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-" ;  % not calved off


CreateAndSaveACInterpolants=false;
BatchJob=true;

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

