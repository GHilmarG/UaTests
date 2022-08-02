

%%
%
% 2022-07-04: I think the long With-Ice-Shelf run stopped at t=363.1. Apparantly some issues with saving files...
% 2022-07-04: Sending of 5km resolution run with Cornford at 100000 regularisation, for As and Cs with Thwaites Ice Shelf
%
% 2022-08-01: Consider sending off 10km runs for Weertman, TWIS, TWISC0 and TWISC2
%                                                                                                   2022-07-27        2022-07-28: 2022-08-01
% Job70: FT-P-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-                     t=94.7 dt=0.01    *TWIS99.73/117
% Job71: FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-                t=102  dt=0.01    116/131
% Job72: FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-                  t=186 dt=0.02      200.6/212
% Job74: FT-P-TWIS-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-                              t=73.9 dt=0.1      91.29/95.95
% Job75: FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-                            t=17 dt=0.003 (resubmitted on 27 July)
% Job77: FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000                 t=200, done
% Job78: FT-P-Duvh-TWISC0MGL-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-             t=142.4 dt=0.014    159.74         169  200(done)
% Job79: 
% job81: -ThickMin0k01-FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-                                t=20.77 dt=0.014 23.8

%%


Resolution="-10km-" ; 
CtrlVar.SlidingLaw="Cornford";
CtrlVar.SlidingLaw="Weertman";
C="C0" ;


CreateAndSaveACInterpolants=true;  % But still created if the files with the interpolants do not exist, 
                                    % but the data files with A and C do.

RunJob=true; 
BatchJob=false;


%%%%%%%%%%%%%%

% Resolution="-10km-" ; % Inverse files still running (2022-07-04)
% Resolution="-20km-" ; % I think this inversion product for Cornford might not be the latest or fully converged



% UserVar.RunType="-FT-P-TWISC0-MR4-SM"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 0km away
% UserVar.RunType="-FT-P-TWIS-MR4-SM"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;  % not calved off


% UserVar.RunType="-FT-P-TWIS-MR4-SM-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;    % not calved off, initially submitted 2022-07-02
% UserVar.RunType="-FT-P-TWISC0-MR4-SM-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;  % calved off, initially submitted 2022-07-02

% UserVar.RunType="-FT-P-TWIS-MR4-SM"+Resolution+"Alim-Ca1-Cs1000000-Aa1-As1000000-" ;  % not calved off, have not run this regularisation for either Weertman or Conford

%% current runs: for 5 and 10km (but thickmin 0.01 and deactivation have yet to be submitted for 5km)
% To do: Consider running the 20km runs on Office DESKTOP-G5TCRTD
UserVar.RunType="-FT-P-TWIS-MR4-SM-TM001-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;      % not calved off with smaller ThickMin initially submitted 2022-07-10
UserVar.RunType="-FT-P-TWISC0-MR4-SM-TM001-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;    % calved off with smaller ThickMin initially submitted 2022-07-10

UserVar.RunType="-FT-P-Duvh-TWIS"+C+"-MR4-SM-TM001-"+CtrlVar.SlidingLaw+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;    % calved off with smaller ThickMin initially submitted 2022-07-10

% UserVar.RunType="-FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;    % calved off with smaller ThickMin and automated LSF ele deactivation, 
                                                                                                            %  initially submitted 2022-07-10 for 10km
                                                                                                            %  then for 5km on  2022-07-27 on DESKTOP-G5TCRTD

% UserVar.RunType="-FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;    % calved off with smaller ThickMin and automated LSF ele deactivation, 

% UserVar.RunType="-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;    % NOT calved off with smaller ThickMin and automated LSF ele deactivation, 
                                                                                                          % initially submitted 2022-07-14 for 10km
                                                                                                          %  then for 5km on  2022-07-27 on DESKTOP-G5TCRTD

% UserVar.RunType="-FT-P-TWIS-MR4-SM-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;    % not calved off, initially submitted 2022-07-02
% UserVar.RunType="-FT-P-TWISC0-MR4-SM-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;  % calved off, initially submitted 2022-07-02
                    
% UserVar.RunType="-FT-P-Duvh-TWISC0MGL-MR4-SM-TM001-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ; %submitted 18 July 2022 for 10km res
% UserVar.RunType="-FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;     % submitted 18 July 2022


% UserVar.RunType="-FT-P-TWIS-MR4-SM-TM001-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;    % NOT calved off with smaller ThickMin, 
                                                                                                     % send off with 20km on 2022-07-27 on DESKTOP-G5TCRTD

% UserVar.RunType="-FT-P-TWISC0-MR4-SM-TM001-Cornford"+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;  % calved off with smaller ThickMin, 
                                                                                                     % send off with 20km on 2022-07-27 on DESKTOP-G5TCRTD
                                                                                                     
%%


 

CtrlVar.TotalTime=200;

CtrlVar.Inverse.Regularize.logC.ga=str2double(extract(extract(UserVar.RunType,"-Ca"+digitsPattern+"-"),digitsPattern)) ; 
CtrlVar.Inverse.Regularize.logC.gs=str2double(extract(extract(UserVar.RunType,"-Cs"+digitsPattern+"-"),digitsPattern)) ; 
CtrlVar.Inverse.Regularize.logAGlen.ga=str2double(extract(extract(UserVar.RunType,"-Aa"+digitsPattern+"-"),digitsPattern)) ;
CtrlVar.Inverse.Regularize.logAGlen.gs=str2double(extract(extract(UserVar.RunType,"-As"+digitsPattern+"-"),digitsPattern)) ; 


if contains(UserVar.RunType,"Cornford")
    CtrlVar.SlidingLaw="Cornford";
else
    CtrlVar.SlidingLaw="Weertman";
end

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

        fprintf("Creating FA and FC interpolants.\n")
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

        warning("Can not create interpolants as A & C data files do not exist")
        fprintf("A data file: %s.\n",AdataFile)
        fprintf("C data file: %s.\n",CdataFile)
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

