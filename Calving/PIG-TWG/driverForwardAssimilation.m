



% This is the initial inversion at the start of the experiment, uses Bedmachine geometry
RunString="ES30km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";
RunString="ES10km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";



UserVar.RunType="-IR-"+RunString ;    CtrlVar.Restart=1;
Ua(UserVar,CtrlVar) ;

for itime=0:4

    from=itime;
    to=itime+1;

    % This is the first transient run, uses geometry from previous inverse run (this will be Bedmachine if from=0)
    
    UserVar.RunType=sprintf("-FR%ito%i-",from,to)+RunString ;
    CtrlVar.Restart=0;  % Here I might not want to start a restart run, for example if the inversion has been done anew. 
    Ua(UserVar) ;

    % This is an inversion using geometry based on forward run that ended at time=to, ie the previous forward run
    UserVar.RunType=sprintf("-IR%ito%i-",from,to)+RunString ;
    CtrlVar.Restart=1;  % Always try to start a restart run when conducting an inversion 
    Ua(UserVar)

end




