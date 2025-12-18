
%%

%
% Perturb A and/or C and calculate uv for the new perturbed distributions, and define uv as synthetic data for these "true"
% distributions.
%
% This results in new observations witch are the uv fields calculated using these new "true" states for A and C
%
% In the new restart file, F is same as in the initial input restart file. The only difference is that now the
% observations/Meas have been replaced with the uv results for the true A and C states, and those true states are
% in the F.AGlneTrue and F.CTrue
%

Pert="-A-";
Pert="-C-";



CtrlVar.Inverse.NameOfRestartInputFile="IR-at2019-5km-uvh-Tri3-SlidWeertman-Duvh-MRZERO-P-BCVel-kH10000-TM0k2-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-BM3-SMB_RACHMO2k3_2km-.mat";
                                        

load(CtrlVar.Inverse.NameOfRestartInputFile) 

CtrlVar=CtrlVarInRestartFile;
UserVar=UserVarInRestartFile; 

% if ( CtrlVar.Parallel.uvAssembly.spmd.isOn || CtrlVar.Parallel.uvhAssembly.spmd.isOn  )
% 
%     poolobj = gcp('nocreate');
%     CtrlVar.Parallel.uvhAssembly.spmd.nWorkers=poolobj.NumWorkers;
% 
% end

CtrlVar.Parallel.BuildWorkers=true;
MUA=UpdateMUA(CtrlVar,MUA); 

[UserVar,RunInfo,F,l,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l);


CtrlVar.PlotXYscale=1000;

UaPlots(CtrlVar,MUA,F,F.AGlen,FigureTitle="A original") ; set(gca,'ColorScale','log')
UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="uv original")

Fmodified=F ;

AGeo=[-1500 -500 ; -1300 -500 ; -1300 -300 ; -1500 -300 ; -1500 -500]*1e3;
CGeo=[-1650 -250 ; -1500 -250 ; -1500 -100 ; -1650 -100 ; -1650 -250]*1e3;

if contains(Pert,"-A-")

    [isInside,isOnBounday]=InsideOutside([F.x F.y],AGeo) ;
    Fmodified.AGlen(isInside)=1e-7 ;
end

if contains(Pert,"-C-")

    [isInside,isOnBounday]=InsideOutside([F.x F.y],CGeo) ;
    Fmodified.C(isInside)=0.01 ;

end



% new synthetic data
[UserVar,RunInfo,Fmodified,l,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,Fmodified,l);

% now define as measurements, the modeled velocities obtained using the modified A and C fields
Meas.us=Fmodified.ub;
Meas.vs=Fmodified.vb ;

Priors.TrueC=Fmodified.C ;
Priors.TrueAGlen=Fmodified.AGlen ;


UaPlots(CtrlVar,MUA,F,Fmodified.AGlen,FigureTitle="A modified") ; set(gca,'ColorScale','log')
hold on ; plot(AGeo(:,1)/1000,AGeo(:,2)/1000,"r") ; 

UaPlots(CtrlVar,MUA,F,Fmodified.C,FigureTitle="C modified") ; set(gca,'ColorScale','log')
hold on ; plot(CGeo(:,1)/1000,CGeo(:,2)/1000,"b")

UaPlots(CtrlVar,MUA,Fmodified,"-uv-",FigureTitle="uv modified")
hold on ; plot(AGeo(:,1)/1000,AGeo(:,2)/1000,"r") ; plot(CGeo(:,1)/1000,CGeo(:,2)/1000,"b")

du=Fmodified.ub-F.ub;  dv=Fmodified.vb-F.vb;
UaPlots(CtrlVar,MUA,F,[du dv],FigureTitle="duv")
hold on ; plot(AGeo(:,1)/1000,AGeo(:,2)/1000,"r") ; plot(CGeo(:,1)/1000,CGeo(:,2)/1000,"b")

CtrlVar.Inverse.NameOfRestartOutputFile=CtrlVar.Inverse.NameOfRestartInputFile;

if contains(Pert,"-A-")

    CtrlVar.Inverse.NameOfRestartOutputFile="Amod-"+CtrlVar.Inverse.NameOfRestartOutputFile;

end

if contains(Pert,"-C-")

    CtrlVar.Inverse.NameOfRestartOutputFile="Cmod-"+CtrlVar.Inverse.NameOfRestartOutputFile;

end


CtrlVar.Inverse.SaveSlipperinessEstimateInSeperateFile=false ;
CtrlVar.Inverse.SaveAGlenEstimateInSeperateFile=false ;
WriteAdjointRestartFile(UserVar,CtrlVar,MUA,BCs,F,F.GF,l,RunInfo,InvStartValues,Priors,Meas,BCsAdjoint,InvFinalValues);

%%

