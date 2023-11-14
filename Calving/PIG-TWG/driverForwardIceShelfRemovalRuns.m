

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
%
%
%%
%
% DO= Dell Office
% HPO= HP Office
% HPH= HP Home
%
% Cornford-5km TM001&Duvh    TM001~Duvh    TM1        for MR4
% TWIS           x             400        124         *Duvh-TWISC0-*TM001-Cornford-5km*.mat / ls -t *P-TWIS-MR4-SM-TM001-Cornford*5km*.mat | head     /  ls -lt *P-TWIS-MR4-SM-Cornford*5km*.mat  | head
% TWISC0         x             400        327                                               / ls -lt *P-TWIS-MR4-SM-TM001-Cornford*5km*.mat  | head /  ls -lt *P-TWIS-MR4-SM-Cornford*5km*.mat  | head   
% TWISC2         200             x          x          *Duvh-TWISC2-*TM001-Cornford-5km*.mat
% PIGC0          x             353          x                                                / ls -t *P-PIGC0-MR4-SM-TM001-Cornford-5km*.mat | head  /
%
% 
% Cornford-5km TM001&Duvh    TM001~Duvh    TM1         for MR0:                             
%  TWIS            x           400           x                                             /  ls -lt *P-TWIS-MR0-SM-TM001-Cornford*5km*.mat  | head      /
%  TWISC0          x           375           x                                             /  ls -lt *P-TWISC0-MR0-SM-TM001-Cornford*5km*.mat  | head  /
%  PIGC0           x           400           x                                             /  ls -t  *P-PIGC0-MR0-SM-TM001-Cornford-5km*.mat | head  /
%
% Weertman-5km TM001&Duvh    TM001~Duvh    TM1         for MR4
% TWIS           369             x         361         ls -lt *P-Duvh-TWIS-MR4-SM-TM001-Weertman-5km*.mat | head     /  *P-TWIS-MR4*TM001-Weertman*5km*.mat  / ls -lt *P-TWIS-MR4-SM-5km-Alim*.mat |head
% TWISC0         400             x         303         ls -lt *P-Duvh-TWISC0-MR4-SM-TM001-Weertman-5km*.mat  | head  /                                           / ls -lt *P-TWISC0-MR4-SM-5km*.mat  | head
% TWISC2          x              x          x           
% PIGC0           x            227          x                                                                        /   ls -lt *P-PIGC0-MR4-SM-TM001-Weertman*5km*.mat  | head                     /
%
% Weertman-5km TM001&Duvh    TM001~Duvh    TM1         for MR0
% TWIS              x          219           x                                             / ls -lt *P-TWIS-MR0-SM-TM001-Weertman*5km*.mat  | head /
% TWISC0            x          156           x                                            / ls -lt *P-TWISC0-MR0-SM-TM001-Weertman*5km*.mat  | head /
% PIGC0             x          217           x                                            / ls -lt *P-PIGC0-MR0-SM-TM001-Weertman*5km*.mat  | head /
%
%
% Weertman-10km TM001&Duvh    TM001~Duvh    TM1         for MR4
% TWIS           200           x             100         *Duvh-TWIS-*TM001-Weertman*.mat  /  *-TWIS-*SM-10km*.mat
% TWISC0         177/HPO       x             100         *Duvh-TWISC0-*TM001-Weertman*.mat
% TWISC2         200           x              x
%
%
%
% Cornford-10km TM001&Duvh    TM001~Duvh    TM1        for MR4
% TWIS           359           302         100       /    ls -lt *Duvh-TWIS-*TM001-Cornford*5km*.mat | head     / ls -lt *P-TWIS-*TM001-Cornford*10km*.mat | head 
% TWISC0         224           232         100       
% TWISC2         200           x            x
%
%
%
% Cornford-20km TM001&Duvh    TM001~Duvh    TM1
% TWIS            x           200
% TWISC0          x           200      
% TWISC2          x             x            x
%
% SUPG: 20km, TWIS
%  tau1-01  tau2-02 taut-01    taus-01 taus-0.1  taus-0.0   taus-2.0 
%   252      283      241       200     400        400       193 
%
%%

IceShelf="Thwaites" ; % send
Melt="-MR4-" ;                  % BasalMeltRateParameterisation=
UserVar.InvMeshResolution=[];
GLrange="";
uvh="" ;  % uvh="-uv-h-" implies semi-implicit
UserVar.LevelSetDownstreamRheology="";
UserVar.GroupAssembly="";
UserVar.kH="" ;  % defaults to kH=10 

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

CtrlVar.uvh.SUPG.tauMultiplier=1 ;  CtrlVar.uvh.SUPG.tau="taus" ; 
Resolution="-5km-" ;  CtrlVar.SlidingLaw="Weertman"; C="" ;     Duvh="Duvh" ;   % send
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Weertman"; C="C0" ;   Duvh="Duvh" ;   % sent
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;       % sent
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;   Duvh="" ;       % done

Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR4-" ;   IceShelf="PIG" ; % Deleting PIG Ice Shelf, using Melt MR4

Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-MR0-" ;  IceShelf="Thwaites" ; % Reference run for Melt="-MR0-"
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR0-" ;  IceShelf="PIG" ;    % PIG ice shelf removal run for Melt="-MR0-"
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR0-" ;  IceShelf="Thwaites" ; % Thwaites ice shelf removal run for Melt="-MR0-"

Resolution="-20km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ; % Reference run (for both Thwaites and PIG
Resolution="-20km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ; % Thwaites removal

Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;      Duvh="" ;  Melt="-MR4-" ;  IceShelf="PIG" ;  % PIG removal
% Resolution="-20km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="PIG" ; % PIG removal

%%
% Home Office HP, now Dell Office
Resolution="-5km-" ;  CtrlVar.SlidingLaw="Weertman"; C="C0" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="PIG" ; % PIG removal / Weertman  /MR4
Resolution="-5km-" ;  CtrlVar.SlidingLaw="Weertman"; C="C0" ;     Duvh="" ;  Melt="-MR0-" ;  IceShelf="PIG" ; % PIG removal / Weertman  /MR0
Resolution="-5km-" ;  CtrlVar.SlidingLaw="Weertman"; C="C0" ;     Duvh="" ;  Melt="-MR0-" ;  IceShelf="Thwaites" ; % TWIS removal / Weertman  /MR0
Resolution="-5km-" ;  CtrlVar.SlidingLaw="Weertman"; C="" ;     Duvh="" ;  Melt="-MR0-" ;  IceShelf="Thwaites" ; % TWIS removal / Weertman  /MR0

%C17777347
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;       Duvh="" ;  Melt="-MR0-" ;  IceShelf="Thwaites" ; 
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR0-" ;  IceShelf="Thwaites" ; 
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="PIG" ; 
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR0-" ;  IceShelf="PIG" ; 

% Dell Office
% 10km
% Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;       Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ; % done
% Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ; 
% Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="PIG" ; 
% C17777347
% 20km
% Resolution="-20km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;       Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ; % done
% Resolution="-20km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ; % done
% Resolution="-20km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C0" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="PIG" ; % done


% To do: continue the MR4 run:  Duvh-TWISC2-*TM001-Cornford-5km*.mat run and add one without Duvh
Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C2" ;     Duvh="Duvh" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ; 
Resolution="-5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="C2" ;     Duvh=""     ;  Melt="-MR4-" ;  IceShelf="Thwaites" ; 

Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-DMR-2-" ;  IceShelf="Thwaites" ; % testing dynamical melt rates
Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-DMR-10-" ;  IceShelf="Thwaites" ; % testing dynamical melt rates
Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-DMR-100-" ;  IceShelf="Thwaites" ; % testing dynamical melt rates

Resolution="-5km-" ;  CtrlVar.SlidingLaw="Weertman"; C="" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ; % TWIS kept / Weertman  /MR4
% Resolution="-5km-" ;  CtrlVar.SlidingLaw="Weertman"; C="C0" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ; % TWIS removal / Weertman  /MR4




Resolution="-10km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];  GLrange="-GLrange-";
Resolution="-5km-"  ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];  GLrange="-GLrange-";




Resolution="-5km-"   ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];    GLrange="";
Resolution="-2.5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=5000;  GLrange="";  



Resolution="-10km-"   ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh=""     ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];    GLrange="";
Resolution="-5km-"    ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh=""     ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];    GLrange="";   % has hit boundary of computational domain
Resolution="-2.5km-"  ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh=""     ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=5000;    GLrange=""; 

Resolution="-20km-"  ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="Duvh" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];      GLrange="";
Resolution="-10km-"  ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="Duvh" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];      GLrange="";
Resolution="-5km-"   ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="Duvh" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];      GLrange="";
Resolution="-2.5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="Duvh" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=5000;    GLrange=""; 



CtrlVar.InfoLevelNonLinIt=5;  CtrlVar.doplots=1;   % testing
CtrlVar.LocateAndDeleteDetachedIslandsAndRegionsConnectedByOneNodeOnly=true;
CtrlVar.ExplicitEstimationMethod="-no extrapolation-" ;

% setting GLrange="-GLrange-"  implies further refinement around grounding-line 

% Resolution="-20km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];  GLrange="-GLrange-";


% Resolution="-20km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];  
%                        GLrange="-GLrange-";  UserVar.LevelSetDownstreamRheology="-LSDRlin-" ;  UserVar.kH="-kH10-" ; Duvh="-Duvh-" ; 
%                        uvh="-uvh-"  ; UserVar.GroupAssembly="-uvhGroup-uvGroup-" ; 
                  

% Note: Setting Duvh="-Duvh-" gives automated element deactivation based on the level-set                    

% Resolution="-2.5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=5000; GLrange="" ; 
%                        GLrange="-GLrange-";  UserVar.LevelSetDownstreamRheology="-LSDRlin-" ;  

% Resolution="-2.5km-" ;  CtrlVar.SlidingLaw="Cornford"; C="" ;     Duvh="" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=5000; GLrange="" ; 
%                        GLrange="-GLrange-";  UserVar.LevelSetDownstreamRheology="-LSDRlin-" ;  
%                        uvh="-uvh-"  ; UserVar.GroupAssembly="-uvhGroup-uvGroup-" ;  UserVar.kH="-kH10-" ; 





% CtrlVar.ExplicitEstimationMethod="-no extrapolation-";


%% Testing new SPMD option in uv, using parallel loop over integration points
% CtrlVar.Parallel.isTest=true; 
% CtrlVar.Parallel.uvAssembly.spmdInt.isOn=true;

%%

if uvh=="-uvh-"   % this means implicit with respect to uvh as opposed to "-uv-h-" which is semi-implicit
    uvh="";  % keep the old default
end

CreateAndSaveACInterpolants=false;  % But still created if the files with the interpolants do not exist, 
                                    % but the data files with A and C do.

RunJob=true; 
BatchJob=false;



UserVar.RunType="-FT-P-"+Duvh+"-TWIS"+C+Melt+"SM-TM001-"+CtrlVar.SlidingLaw+Resolution+GLrange+uvh+ UserVar.LevelSetDownstreamRheology+UserVar.GroupAssembly+UserVar.kH+"Alim-Clim-Ca1-Cs100000-Aa1-As100000-";  

if CtrlVar.uvh.SUPG.tauMultiplier~=1  ||  CtrlVar.uvh.SUPG.tau~="taus"
    UserVar.RunType=UserVar.RunType+"-"+CtrlVar.uvh.SUPG.tau+"-SUPGm"+num2str(CtrlVar.uvh.SUPG.tauMultiplier) ;
    % taus with multy >= 5 does not converge
end

if IceShelf~="Thwaites"

    UserVar.RunType=replace(UserVar.RunType,"TWIS","PIG");

end

pat="-"+digitsPattern+"km";
MR=str2double(extract(extract(UserVar.RunType,pat),digitsPattern));

if isempty(MR)

    pat="-"+digitsPattern+"."+digitsPattern+"km";
    MR=str2double(extractBetween(extract(UserVar.RunType,pat),"-","km")) ;

end

UserVar.MeshResolution=MR*1000;   % MESH RESOLUTION

if round(UserVar.MeshResolution)~=round(UserVar.InvMeshResolution)
    UserVar.RunType=UserVar.RunType+"InvMR"+num2str(UserVar.InvMeshResolution/1000);
end

                                                                                                     
%%

UserVar.RunType=replace(UserVar.RunType,"--","-");
UserVar.RunType=replace(UserVar.RunType,".","k");


CtrlVar.TotalTime=500;

CtrlVar.Inverse.Regularize.logC.ga=str2double(extract(extract(UserVar.RunType,"-Ca"+digitsPattern+"-"),digitsPattern)) ;
CtrlVar.Inverse.Regularize.logC.gs=str2double(extract(extract(UserVar.RunType,"-Cs"+digitsPattern+"-"),digitsPattern)) ;
CtrlVar.Inverse.Regularize.logAGlen.ga=str2double(extract(extract(UserVar.RunType,"-Aa"+digitsPattern+"-"),digitsPattern)) ;
CtrlVar.Inverse.Regularize.logAGlen.gs=str2double(extract(extract(UserVar.RunType,"-As"+digitsPattern+"-"),digitsPattern)) ;


if contains(UserVar.RunType,"Cornford")
    CtrlVar.SlidingLaw="Cornford";
else
    CtrlVar.SlidingLaw="Weertman";
end


CtrlVar.LevelSetDownstream_nGlen=1;
eta= 1e10  / (1000*365.25*24*60*60);
CtrlVar.LevelSetDownstreamAGlen=1/(2*eta);

%%




if isempty(UserVar.InvMeshResolution)
    UserVar.InvMeshResolution=UserVar.MeshResolution;
end

% Now set UserVar

InvFile=CtrlVar.SlidingLaw...
    +"-Ca"+num2str(CtrlVar.Inverse.Regularize.logC.ga)...
    +"-Cs"+num2str(CtrlVar.Inverse.Regularize.logC.gs)...
    +"-Aa"+num2str(CtrlVar.Inverse.Regularize.logAGlen.ga)...
    +"-As"+num2str(CtrlVar.Inverse.Regularize.logAGlen.gs)...
    +"-"+num2str(UserVar.InvMeshResolution/1000)+"km";

if contains(UserVar.RunType,"-Alim-")
    InvFile=InvFile+"-Alim-";
end

if contains(UserVar.RunType,"-Clim-")
    InvFile=InvFile+"-Clim-";
end

if contains(UserVar.RunType,"-uvdhdt-")
    InvFile=InvFile+"-uvdhdt-";
end

if contains(UserVar.RunType,"Group-")
    InvFile=InvFile+"-uvGroup-";
end


InvFile=replace(InvFile,".","k");
InvFile=replace(InvFile,"--","-");

UserVar.AFile="FA-"+InvFile+".mat";
UserVar.CFile="FC-"+InvFile+".mat";

AdataFile="InvA-"+InvFile+".mat";
CdataFile="InvC-"+InvFile+".mat";


if CreateAndSaveACInterpolants ||  (~isfile(UserVar.AFile)  || ~isfile(UserVar.CFile) )

    
    % Either 1) always create new interpolants from inverse files, even if the interpolants already
    %           exist (ie update interpolants),
    %     or 2) create  interpolants from inverse files if no interpolants exists (create for first time).

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

