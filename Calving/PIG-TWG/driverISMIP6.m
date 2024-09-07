


function driverISMIP6(RunString)

% Driver for repeated inversions over time. This is done to reduce initial transients
%

if nargin==0 | isempty(RunString)
   
   RunString="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
   RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

   RunString="ES20km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

   RunString="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0M-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
   RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0M-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

   RunString="ES10km-uv-h-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 
   RunString="ES10km-uvh-Tri3-SlidWeertman-Duvh-MRIM6HadGEM2-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

   RunString="ES5km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 

   RunString="ES30km-uv-h-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-"; 


end


%% Some additional control variables
UserVar.InverseRestartFile="create the name of inverse restart file from User.RunType";
UserVar.GeometryInterpolant="create the name of inverse restart file from User.RunType";

%% Keep his
%
% Assimilation/relaxation: from t=UserVar.Assimilation.tStart to t=UserVar.Assimilation.tEnd
% 
% After assimilation/relaxation is when the actual run starts. So this run goes from        
%
%   t=UserVar.Assimilation.tEnd to t=UserVar.RunEndYear
%
% During the actual run, there are no 
%
%
UserVar.Assimilation.tStart=2015;                   % typically RunStartYear = Assimilation.tEnd
UserVar.Assimilation.tEnd=2020;

UserVar.RunStartYear=UserVar.Assimilation.tEnd ;    % I don't really need this RunStartYear variable, 
                                                    % and I always must make sure that the RunStartYear 
                                                    % is that of the end of the assimilation/period
UserVar.RunEndYear=2100;

UserVar.Assimilation.is=true ;       % This is a flag to bypass the assimilation/relaxation phase. 
                                      % This will only work if the assimilation/relaxation has already 
                                      % been performed previously and all the related files exists

UserVar.Inverse.Iterations=200;
InverseRunAtStart=true ;
%% -]
%%

% if contains(RunString,"-MRIM6")  % this implies the use of ISMIP6 forcing
%     UserVar.Assimilation.tStart=UserVar.Assimilation.tStart;
%     UserVar.Assimilation.tEnd=UserVar.Assimilation.tEnd;
% end
% 



if UserVar.Assimilation.is

    %% 1) Initial inverse run

    if InverseRunAtStart
        %% First INVERSE run,

        UserVar.RunType="-IR-"+RunString ;
        CtrlVar.Restart=0;  % Here forcing this NOT to be a restart inverse run. I need this if I have changed data sets such as Bedmachine,
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

end
%% 3) Forward run
% Generally, the forward run should continue from after the end of the assimilation/relaxation period.
%
% However, if RunStartYear is set to a value greater or equal to the end of the relaxation period, the run starts at
% the time of the RunStartYear. This assumes that the relaxation phase has already been done, and does not need to tbe done
% again. 

from=UserVar.RunStartYear  ; 
to=UserVar.RunEndYear;

if UserVar.RunStartYear~=UserVar.Assimilation.tEnd
    error("this is just here to remind me that RunStartYear must be the same as the Assimilation.tEnd ")
end


UserVar.RunType=sprintf("-FR%ito%i-",from,to)+RunString ;

Ua(UserVar) ;       % This FORWARD run will go t=from to t=to,






end