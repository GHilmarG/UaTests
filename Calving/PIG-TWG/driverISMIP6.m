


function driverISMIP6(RunString)

% Driver for repeated inversions over time. This is done to reduce initial transients
%

if nargin==0 | isempty(RunString)
   
   RunString="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
   RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

   RunString="ES30km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

end


%% Some additional control variables
UserVar.InverseRestartFile="create the name of inverse restart file from User.RunType";
UserVar.GeometryInterpolant="create the name of inverse restart file from User.RunType";

UserVar.RunStartYear=2015;     
UserVar.Assimilation.Period=5;   % (years) 
UserVar.Inverse.Iterations=2;

UserVar.Assimilation.tStart=UserVar.RunStartYear+0;
UserVar.Assimilation.tEnd=UserVar.RunStartYear+UserVar.Assimilation.Period;  % 
UserVar.ForwardRunDuration=10 ;   %  This is the number of years of forward run following the assimilation/relaxation phase
                                  %  This forward run will start at time=UserVar.Assimilation.tEnd; 
InverseRunAtStart=true ; 
%%

if contains(RunString,"-MRIM6")  % this implies the use of ISMIP6 forcing
    UserVar.Assimilation.tStart=UserVar.Assimilation.tStart;
    UserVar.Assimilation.tEnd=UserVar.Assimilation.tEnd; 
end

%% 1) Initial inverse run

if InverseRunAtStart 
    %% First INVERSE run,

    UserVar.RunType="-IR-"+RunString ;
    CtrlVar.Restart=0;  % Here forcing this NOT to be an inverse run. I need this if I have changed data sets such as Bedmachine,
    CtrlVar.Restart=1;  % Only use the inverse restart option if geometry has not been changed
    % if this change is not reflected in the name of the restart file

    Ua(UserVar,CtrlVar) ;

end

%% 2) Relaxation phase
% Loop over repeated forward and then inverse runs, each forward run is for 1 year, and uses the previous inversion data for A and C
for itime=UserVar.Assimilation.tStart:UserVar.Assimilation.tEnd-1

    from=itime;
    to=itime+1;

    %% 2a) This is the first transient run, uses geometry from previous inverse run (this will be Bedmachine if from=0)
    % A and C interpolants are created from a inverse restart file, unless existing FA and FC files are found that are newer than the
    % inverse restart file
    UserVar.RunType=sprintf("-FR%ito%i-",from,to)+RunString ;
    
    Ua(UserVar) ;       % This FORWARD run will go t=from to t=to,

    %CtrlVar.Restart=1; CtrlVar.ForwardTimeIntegration="-uv-h-" ; Ua(UserVar,CtrlVar) ; % if want to force restart
    

    %% 2b) This is an INVERSE run using geometry based on the previous forward run that ended at time=to, ie the previous forward run

    UserVar.RunType=sprintf("-IR%ito%i-",from,to)+RunString ;
    Ua(UserVar)
    close all 

end

%% 3) Forward run

from=UserVar.Assimilation.tEnd ; 
to=UserVar.Assimilation.tEnd + UserVar.ForwardRunDuration ; 

UserVar.RunType=sprintf("-FR%ito%i-",from,to)+RunString ;

Ua(UserVar) ;       % This FORWARD run will go t=from to t=to,





end