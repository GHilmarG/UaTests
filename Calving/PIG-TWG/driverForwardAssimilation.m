

%%


[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ; 


% extracts from:
%
%   UserVar.RunType
%
% various model options and set CrtlVar fields accordingly 
%

% UserVar.RunType="-FT-from0to1-30km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-ThickMin0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-" ;


pat="-"+digitsPattern+"km-";  MR=str2double(extract(extract(UserVar.RunType,pat),digitsPattern));

UserVar.MeshResolution=MR*1000;   % MESH RESOLUTION
CtrlVar.MeshSize=UserVar.MeshResolution ;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize ;




if contains(UserVar.RunType,"-FT-")
    CtrlVar.InverseRun=0;
    CtrlVar.TimeDependentRun=1;
elseif contains(UserVar.RunType,"-IR-")
    CtrlVar.TimeDependentRun=0;
    CtrlVar.InverseRun=1;
end

pat="-from"+digitsPattern+"to";    TimeStart=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;
pat="to"+digitsPattern+"-";      TimeEnd=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;

CtrlVar.time=TimeStart ; CtrlVar.TotalTime=TimeEnd ;

pat="-Tri"+digitsPattern+"-";    CtrlVar.TriNodes=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ;


CtrlVar.SlidingLaw=extractBetween(UserVar.RunType,"Slid","-");

CtrlVar.kH=str2double(extractBetween(UserVar.RunType,"-kH","-"));

if contains(UserVar.RunType,"-P-")

    CtrlVar.LevelSetEvolution="-Prescribed-"   ; % "-prescribed-",
    CtrlVar.LevelSetMethod=1;
    UserVar.CalvingFront0="-BMCF-"; "-BedMachineCalvingFronts-"  ;  % "-GL0-" ; % "-BedMachineCalvingFronts-"  ;

else

    error("not implemented")

end

pat="-ThickMin"+digitsPattern+"k"+digitsPattern+"-" ; TM=str2double(extract(extract(UserVar.RunType,pat),digitsPattern)) ; CtrlVar.ThickMin=TM(1)+TM(2)/10 ; 
CtrlVar.LevelSetMinIceThickness=CtrlVar.ThickMin;  

CtrlVar.Inverse.Regularize.logC.ga=str2double(extractBetween(UserVar.RunType,"Ca","-"));
CtrlVar.Inverse.Regularize.logC.gs=str2double(extractBetween(UserVar.RunType,"Cs","-"));
CtrlVar.Inverse.Regularize.logAGlen.ga=str2double(extractBetween(UserVar.RunType,"Aa","-"));
CtrlVar.Inverse.Regularize.logAGlen.gs=str2double(extractBetween(UserVar.RunType,"As","-"));


CtrlVar