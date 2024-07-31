



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
    RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";


    RunString="ES30km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
    RunString="ES20km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
    RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";


    RunString="ES30km-Tri3-SlidWeertman-Duvh-MRlASE2-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";


    RunString="ES10km-Tri3-SlidWeertman-Duvh-MRlASE2-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % Dell office
    RunString="ES10km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % Dell office

    RunString="ES10km-Tri3-SlidWeertman-Duvh-MRlASE1-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
    RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE2-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
    RunString="ES30km-Tri3-SlidWeertman-Duvh-MRlASE2-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";



    RunString="ES30km-Tri3-SlidWeertman-Duvh-MRlASE2-abMask0-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
    RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE2-abMask0-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % HP Office
    RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE1-abMask0-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % HP Office
    RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";  % HP Office

    % RunString="ES10km-Tri3-SlidWeertman-Duvh-MRlASE1-abMask0-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % Dell office
    % RunString="ES10km-Tri3-SlidWeertman-Duvh-MRlASE2-abMask0-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; % Dell office


    RunString="ES5km-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; %



end

UserVar.Assimilation.tStart=0 ; %
UserVar.Assimilation.tEnd=10   ; %  Actually the end is at tEnd+1 once the final forward transient run is done


if UserVar.Assimilation.tStart==0  % Generally I would start with an inverse run, except if possible I like to continue a previous initialisation at some tStart>0
    %% First INVERSE run,
    UserVar.RunType="-IR-"+RunString ;
    CtrlVar.Restart=0;  % Here forcing this NOT to be an inverse run. I need this if I have changed data sets such as Bedmachine,
    CtrlVar.Restart=1;  % Only use the inverse restart option of geometry has not been changed
    % if this change is not reflected in the name of the restart file

    Ua(UserVar,CtrlVar) ;

end

%% Loop over repeated forward and then inverse runs, each forward run is for 1 year, and uses the previous inversion data for A and C
for itime=UserVar.Assimilation.tStart:UserVar.Assimilation.tEnd-1

    from=itime;
    to=itime+1;

    %% This is the first transient run, uses geometry from previous inverse run (this will be Bedmachine if from=0)
    % A and C interpolants are created from a inverse restart file, unless existing FA and FC files are found that are newer than the
    % inverse restart file
    UserVar.RunType=sprintf("-FR%ito%i-",from,to)+RunString ;
    CtrlVar.Restart=0;  % Here I might not want to start a forward restart run, for example if the inversion has been done anew.
    Ua(UserVar,CtrlVar) ;       % This FORWARD run will go t=from to t=to,

    %% This is an INVERSE run using geometry based on the previous forward run that ended at time=to, ie the previous forward run


    UserVar.RunType=sprintf("-IR%ito%i-",from,to)+RunString ;
    CtrlVar.Restart=1;  % Always try to start an inverse restart run when conducting an inversion
    Ua(UserVar,CtrlVar)

end




end