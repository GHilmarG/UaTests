

%%
%
% 2022-07-04: I think the long With-Ice-Shelf run stopped at t=363.1. Apparantly some issues with saving files...
% 2022-07-04: Sending of 5km resolution run with Cornford at 100000 regularisation, for As and Cs with Thwaites Ice Shelf
%
% 2022-08-01: Consider sending off 10km runs for Weertman, TWIS, TWISC0 and TWISC2
%                                                                                                   2022-07-27        2022-07-28: 2022-08-01
% Job70: FT-P-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-                     t=94.7 dt=0.01    99.73/117/147
% Job71: FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-                t=102  dt=0.01    116/131/157
% Job72: FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-                  t=186 dt=0.02     200.6/212/252

% Job74: FT-P-TWIS-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-                              t=73.9 dt=0.1  91.29/95.95/109.97/110.4/115
% Job75: FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-                            t=17 dt=0.003    59.3/64.5

% Job77: FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000                 t=200, done
% Job78: FT-P-Duvh-TWISC0MGL-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-             t=142.4 dt=0.014    159.74         169  200(done)
% Job79: 
% job81: -ThickMin0k01-FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-                                t=20.77 dt=0.014 23.8
%
%
%  Runs missing: Cornford 5km TM001 TWIS (ie reference run for min ice thickness, for both Duvh and not)
%
%
%%
%
% DO= Dell Office
% HPO= HP Office
% HPH= HP Home
%
% Cornford-5km TM001&Duvh    TM001~Duvh    TM1
% TWIS           x             107        115         *Duvh-TWISC0-*TM001-Cornford-5km*.mat / *P-TWIS-*TM001-Cornford*5km*.mat
% TWISC0         x             283        250           
% TWISC2         200             x          x          *Duvh-TWISC2-*TM001-Cornford-5km*.mat
%
%
% Weertman-5km TM001&Duvh    TM001~Duvh    TM1
% TWIS           116/HPO         x         361        *Duvh-TWIS-MR4*TM001-Weertman*5km*.mat  / *P-TWIS-MR4-SM-5km-Alim*.mat
% TWISC0         126/HPO         x         303
% TWISC2          x              x          x                                              
%
%
%
% Weertman-10km TM001&Duvh    TM001~Duvh    TM1
% TWIS           200           x             100         *Duvh-TWIS-*TM001-Weertman*.mat  /  *-TWIS-*SM-10km*.mat
% TWISC0         177/HPO       x             100         *Duvh-TWISC0-*TM001-Weertman*.mat
% TWISC2         200           x              x
%
%
%
% Cornfod-10km TM001&Duvh    TM001~Duvh    TM1
% TWIS           359           161         100       
% TWISC0         224           232         100       
% TWISC2         200           x            x
%
%
%
% Cornfod-20km TM001&Duvh    TM001~Duvh    TM1
% TWIS            x           200
% TWISC0          x           200      
% TWISC2          x             x            x
%
% SUPG: 20km, TWIS
%  tau1-01  tau2-02 taut-01    taus-01 taus-0.1  taus-0.0   taus-2.0 
%   252      283      241       200     400        400       193 
%
%%

% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="-Duvh-" ;  % missing
Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  % submitted
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;   Duvh="-Duvh-" ;  % missing


Resolution="-10km-" ;  CtrlVar.SlidingLaw="Weertman"; C="C0" ;   Duvh="Duvh" ;  CtrlVar.TotalTime=200;  
Resolution="-5km-" ;  CtrlVar.SlidingLaw="Weertman"; C="" ;   Duvh="Duvh" ;  CtrlVar.TotalTime=200;  
Resolution="-5km-" ;  CtrlVar.SlidingLaw="Weertman"; C="C0" ;   Duvh="Duvh" ;  CtrlVar.TotalTime=200;  


Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  CtrlVar.uvh.SUPG.tauMultiplier=10 ; CtrlVar.uvh.SUPG.tau="tau1";  
% Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  CtrlVar.uvh.SUPG.tauMultiplier=0.1 ; CtrlVar.uvh.SUPG.tau="taus"; CtrlVar.dt=1e-6 ;  
% Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  CtrlVar.uvh.SUPG.tauMultiplier=0 ; CtrlVar.uvh.SUPG.tau="taus"; CtrlVar.dt=1e-6 ;    
% Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  CtrlVar.uvh.SUPG.tauMultiplier=1 ; CtrlVar.uvh.SUPG.tau="taus"; CtrlVar.dt=1e-6 ;    


CreateAndSaveACInterpolants=false;  % But still created if the files with the interpolants do not exist, 
                                    % but the data files with A and C do.

RunJob=true; 
BatchJob=true;


UserVar.RunType="-FT-P-"+Duvh+"-TWIS"+C+"-MR4-SM-TM001-"+CtrlVar.SlidingLaw+Resolution+"Alim-Ca1-Cs100000-Aa1-As100000-" ;  

if CtrlVar.uvh.SUPG.tauMultiplier~=1  ||  CtrlVar.uvh.SUPG.tau~="taus"
    UserVar.RunType=UserVar.RunType+"-"+CtrlVar.uvh.SUPG.tau+"-SUPGm"+num2str(CtrlVar.uvh.SUPG.tauMultiplier) ;
    % taus with multy >= 5 does not converge
end

                                                                                                     
                                                                                                     
%%

UserVar.RunType=replace(UserVar.RunType,"--","-");
UserVar.RunType=replace(UserVar.RunType,".","k");
 

CtrlVar.TotalTime=400;

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

