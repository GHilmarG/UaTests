
Resolution="-5km-" ; 
Resolution="-10km-" ; % Inverse files still running (2022-07-04)
% Resolution="-20km-" ; 


UserVar.RunType="-FT-P-TWISC0-MR4-SM"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 0km away
UserVar.RunType="-FT-P-TWIS-MR4-SM"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;  % not calved off

% UserVar.RunType="-FT-P-TWIS-MR4-SM"+Resolution+"Alim-Ca1-Cs1000000-Aa1-As1000000-" ;  % not calved off, have not run this regularisation for either Weertman or Conford


CreateAndSaveACInterpolants=true;  % But still created if the files with the interpolants do not exist, 
                                    % but the data files with A and C do.

RunJob=true; 
BatchJob=false;


CtrlVar.TotalTime=500;
CtrlVar.Inverse.Regularize.logC.ga=str2double(extract(extract(UserVar.RunType,"-Ca"+digitsPattern+"-"),digitsPattern)) ; 
CtrlVar.Inverse.Regularize.logC.gs=str2double(extract(extract(UserVar.RunType,"-Cs"+digitsPattern+"-"),digitsPattern)) ; 
CtrlVar.Inverse.Regularize.logAGlen.ga=str2double(extract(extract(UserVar.RunType,"-Aa"+digitsPattern+"-"),digitsPattern)) ;
CtrlVar.Inverse.Regularize.logAGlen.gs=str2double(extract(extract(UserVar.RunType,"-As"+digitsPattern+"-"),digitsPattern)) ; 

CtrlVar.SlidingLaw="Weertman";
CtrlVar.SlidingLaw="Cornford";

CtrlVar.LevelSetDownstreamAGlen=AGlenVersusTemp(0);     


%%

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

UserVar.AFile="FA-"+InvFile+".mat";
UserVar.CFile="FC-"+InvFile+".mat";

AdataFile="InvA-"+InvFile+".mat";
CdataFile="InvC-"+InvFile+".mat";


if CreateAndSaveACInterpolants ||  (~isfile(UserVar.AFile)  || ~isfile(UserVar.CFile) )

    
    % Either 1) always create new interpolants from inverse files, even if the interpolants already
    %           exist (ie update interpolants),
    %     or 2) always create  interpolants from inverse files.

    if isfile(AdataFile) && isfile(CdataFile)

        fprintf("Createing FA and FC interpolants.\n")
        fprintf("FA in %s.\n",UserVar.AFile)
        fprintf("FC in %s.\n",UserVar.CFile)

        % Create and save interpolants
        load(AdataFile,"AGlen","xA","yA") ;
        FA=scatteredInterpolant(xA,yA,AGlen);
        save(UserVar.AFile,"FA");

        load(CdataFile,"C","xC","yC")
        FC=scatteredInterpolant(xC,yC,C);
        save(UserVar.CFile,"FC")

    else

        warning("cant create interpolants as A & C data files do not exist")
        return

    end


end

if RunJob
    if BatchJob
        job1=batch(@Ua,0,{UserVar,CtrlVar},Pool=2) ;
    else
        Ua(UserVar,CtrlVar)
    end
end

