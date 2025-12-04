

%% loads two results files and plots various quantities, in particular those related to the inversion products.




UserVar=FileDirectories() ;


Files="-inverse-" ;

if Files=="-forward-"
    %% Loading forward run files


    FileA="0201800-FR2017to2018-10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
    FileB="0201800-FR2017to2018-10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-Rgl50-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";


    FileA="0202050-FR2020to2500-10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
    FileB="0202050-FR2020to2500-10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-Rgl50-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";


    VarsA=load(UserVar.ResultsFileDirectory+FileA);
    VarsB=load(UserVar.ResultsFileDirectory+FileB);

elseif Files=="-inverse-"
    %% loading inverse restart files

    FileA="IR-at2020-10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-Rgl50-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";
    FileB="IR-at2020-10km-uvh-Tri3-SlidWeertman-Duvh-MRlASE3-abMask0A-IOR-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-";


    VarsA=load(UserVar.InverseRestartFileDirectory+FileA);
    VarsB=load(UserVar.InverseRestartFileDirectory+FileB);

    VarsA.CtrlVar=VarsA.CtrlVarInRestartFile;
    VarsB.CtrlVar=VarsB.CtrlVarInRestartFile;
else
    error("case not found")
end
%%




%%
UaPlots(VarsA.CtrlVar,VarsA.MUA,VarsA.F,VarsA.F.C,FigureTitle="C FileA",logColorbar=true,GetRidOfValuesDownStreamOfCalvingFronts=false)
UaPlots(VarsB.CtrlVar,VarsB.MUA,VarsB.F,VarsB.F.C,FigureTitle="C FileB",logColorbar=true,GetRidOfValuesDownStreamOfCalvingFronts=false)


UaPlots(VarsB.CtrlVar,VarsB.MUA,VarsB.F,VarsA.F.C-VarsB.F.C,FigureTitle="C: File A - File B",logColorbar=false,GetRidOfValuesDownStreamOfCalvingFronts=false)

UaPlots(VarsB.CtrlVar,VarsB.MUA,VarsB.F,abs(VarsA.F.C-VarsB.F.C),FigureTitle="abs(C): File A - File B",logColorbar=true,GetRidOfValuesDownStreamOfCalvingFronts=false)


UaPlots(VarsA.CtrlVar,VarsA.MUA,VarsA.F,"-uv-",FigureTitle="uv FileA",GetRidOfValuesDownStreamOfCalvingFronts=false)
UaPlots(VarsB.CtrlVar,VarsB.MUA,VarsB.F,"-uv-",FigureTitle="uv FileB",GetRidOfValuesDownStreamOfCalvingFronts=false)

du=VarsB.F.ub-VarsA.F.ub; dv=VarsB.F.vb-VarsA.F.vb;
UaPlots(VarsB.CtrlVar,VarsB.MUA,VarsB.F,[du dv],FigureTitle="Delta uv ",GetRidOfValuesDownStreamOfCalvingFronts=false)


UaPlots(VarsA.CtrlVar,VarsA.MUA,VarsA.F,VarsA.F.dhdt,FigureTitle="dh/dt FileA",GetRidOfValuesDownStreamOfCalvingFronts=false) ; clim([-10 10]) ; title("dh/dt File A") ; CM=cmocean('balanced',25,'pivot',0) ; colormap(CM);
UaPlots(VarsB.CtrlVar,VarsB.MUA,VarsB.F,VarsB.F.dhdt,FigureTitle="dh/dt FileB",GetRidOfValuesDownStreamOfCalvingFronts=false) ; clim([-10 10]) ; title("dh/dt File B")  ; CM=cmocean('balanced',25,'pivot',0) ; colormap(CM);


if Files=="-inverse-"

    um=VarsA.Meas.us;
    vm=VarsA.Meas.vs;
    UaPlots(VarsA.CtrlVar,VarsA.MUA,VarsA.F,[um vm],FigureTitle="measured velocities",GetRidOfValuesDownStreamOfCalvingFronts=false) ; title("Measured velocities")

    uErrA=sqrt(full(diag(VarsA.Meas.usCov)));
    vErrA=sqrt(full(diag(VarsA.Meas.vsCov)));
    um=(VarsA.F.ub-VarsA.Meas.us)./uErrA;
    vm=(VarsA.F.vb-VarsA.Meas.vs)./vErrA;
    UaPlots(VarsA.CtrlVar,VarsA.MUA,VarsA.F,[um vm],FigureTitle="File A: modelled - measured velocities",GetRidOfValuesDownStreamOfCalvingFronts=false) ; title("File A: Modelled - Measured velocities")

    uErrB=sqrt(full(diag(VarsB.Meas.usCov)));
    vErrB=sqrt(full(diag(VarsB.Meas.vsCov)));
    um=(VarsB.F.ub-VarsB.Meas.us)./uErrB;
    vm=(VarsB.F.vb-VarsB.Meas.vs)./vErrB;
    UaPlots(VarsA.CtrlVar,VarsA.MUA,VarsA.F,[um vm],FigureTitle="FileB ;modelled - measured velocities",GetRidOfValuesDownStreamOfCalvingFronts=false) ; title("File B: Modelled - Measured velocities")


end

%%