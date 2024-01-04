%% Create scattered A and C interpolants


load('C-EstimateWeertman.mat');
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman.mat','FC')

load('AGlen-Estimate.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman.mat','FA')

%%

load('C-Estimate.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Umbi.mat','FC')

load('AGlen-Estimate.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Umbi.mat','FA')

%%
clearvars


load('InvEstimate-CWeertman-PIG-TWG10km.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman-PIG-TWG-10km.mat','FC')

load('InvEstimate-AWeertman-PIG-TWG10km.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman-PIG-TWG-10km.mat','FA')

      
load('InvEstimate-CWeertman-PIG-TWG20km.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman-PIG-TWG-20km.mat','FC')

load('InvEstimate-AWeertman-PIG-TWG20km.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman-PIG-TWG-20km.mat','FA')


load('InvEstimate-CWeertman-PIG-TWG30km.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman-PIG-TWG-30km.mat','FC')

load('InvEstimate-AWeertman-PIG-TWG30km.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman-PIG-TWG-30km.mat','FA')

load('InvEstimate-CWeertman-PIG-TWG5km.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC-Weertman-PIG-TWG-5km.mat','FC')

load('InvEstimate-AWeertman-PIG-TWG5km.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA-Weertman-PIG-TWG-5km.mat','FA')
%%



load("InvA-Weertman-Ca1-Cs100000-Aa1-As100000-10km") ;
FA=scatteredInterpolant(xA,yA,AGlen);  
save("FA-Weertman-Ca1-Cs100000-Aa1-As100000-10km.mat") ;



load("InvC-Weertman-Ca1-Cs100000-Aa1-As100000-10km") ;
FC=scatteredInterpolant(xC,yC,C);  
save("FC-Weertman-Ca1-Cs100000-Aa1-As100000-10km.mat") ;

%%




DataFile="InvA-Weertman-Ca1-Cs100000-Aa1-As100000-10km" ;
DataFile="InvA-Weertman-Ca1-Cs100000-Aa1-As100000-5km-Apwd" + ...
    "lim-";
%DataFile="InvA-Weertman-Ca10-Cs100000-Aa10-As100000-10km" ;

load(DataFile) ;



FindOrCreateFigure("A"+DataFile) ;

PlotMeshScalarVariable(CtrlVarInRestartFile,MUA,log10(AGlen));
hold on ; PlotGroundingLines(CtrlVarInRestartFile,"Bedmachine",[],[],[],[],"r");
hold on ; PlotMuaBoundary(CtrlVarInRestartFile,MUA) ;
hold on ; PlotMuaBoundary(CtrlVarInRestartFile,MUA) ;



Box=[ -1616.3      -1491.8      -530.00      -395.07]*1000;
F.x=MUA.coordinates(:,1); F.y=MUA.coordinates(:,2);

In=IsInBox(Box,F.x,F.y) ;
AminTWIS=AGlenVersusTemp(-30) ;
I= AGlen < AminTWIS & In ;
AGlen(I)=AminTWIS;
FindOrCreateFigure("A lim"+DataFile) ;


PlotMeshScalarVariable(CtrlVarInRestartFile,MUA,log10(AGlen));
hold on ; PlotGroundingLines(CtrlVarInRestartFile,"Bedmachine",[],[],[],[],"r");
hold on ; PlotMuaBoundary(CtrlVarInRestartFile,MUA) ;
hold on ; PlotMuaBoundary(CtrlVarInRestartFile,MUA) ;
plot(F.x(I)/1000,F.y(I)/1000,'.r')


%%

UserVar.InvMeshResolution=[];
uvh="" ;  % uvh="-uv-h-" implies semi-implicit
UserVar.LevelSetDownstreamRheology="";
UserVar.GroupAssembly="";
UserVar.kH="" ;  % defaults to kH=10 

Resolution="-30km-"  ;  CtrlVar.SlidingLaw="Weertman"; C="" ;     Duvh="Duvh" ;  Melt="-MR4-" ;  IceShelf="Thwaites" ;  UserVar.InvMeshResolution=[];      GLrange="";

UserVar.RunType="-FT-P-"+Duvh+"-TWIS"+C+Melt+"SM-TM001-"+CtrlVar.SlidingLaw+Resolution+GLrange+uvh+ UserVar.LevelSetDownstreamRheology+UserVar.GroupAssembly+UserVar.kH+"Alim-Clim-Ca1-Cs100000-Aa1-As100000-";  

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


if isempty(UserVar.InvMeshResolution)
    UserVar.InvMeshResolution=UserVar.MeshResolution;
end


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
