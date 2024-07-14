



function driverForwardAssimilation(RunString)

% Driver for repeated inversions over time. This is done to reduce initial transients
%


UserVar.InverseRestartFile="create the name of inverse restart file from User.RunType";
UserVar.GeometryInterpolant="create the name of inverse restart file from User.RunType";

if nargin==0 | isempty(RunString)

    % The RunString defined here is then used in DefineInitialInputs to set various fields of CtrlVar. This is mostly done by
    % calling: [CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar).
    %
    %

    % This is the initial inversion at the start of the experiment, uses Bedmachine geometry
    RunString="ES30km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
    RunString="ES30km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
    % RunString="ES10km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";


end

%% First INVERSE run, do this as a restart run if a restart file is available
UserVar.RunType="-IR-"+RunString ;    CtrlVar.Restart=1;
Ua(UserVar,CtrlVar) ;


%% Loop over repeated forward and then inverse runs, each forward run is for 1 year, and uses the previous inversion data for A and C
for itime=0:4

    from=itime;
    to=itime+1;

    %% This is the first transient run, uses geometry from previous inverse run (this will be Bedmachine if from=0)
    % A and C interpolants are created from a inverse restart file, unless existing FA and FC files are found that are newer than the
    % inverse restart file
    UserVar.RunType=sprintf("-FR%ito%i-",from,to)+RunString ;
    CtrlVar.Restart=0;  % Here I might not want to start a restart run, for example if the inversion has been done anew.
    Ua(UserVar) ;       % This FORWARD run will go t=from to t=to,

    %% This is an INVERSE run using geometry based on the previous forward run that ended at time=to, ie the previous forward run

   
    UserVar.RunType=sprintf("-IR%ito%i-",from,to)+RunString ;
    CtrlVar.Restart=1;  % Always try to start a restart run when conducting an inversion
    Ua(UserVar)

end




end