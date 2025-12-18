

function Create_AC_ScatteredInterpolants(CtrlVar,UserVar)

%%

if nargin==0 || isempty(CtrlVar)

    CtrlVar=Ua2D_DefaultParameters();
end

if nargin<2

    UserVar.RunType="-FT-from0to1-30km-Tri3-SlidCornford-Duvh-MR4-P-kH10000-ThickMin0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-" ;
    UserVar.RunType="-FT-from0to1-30km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-ThickMin0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-SMB_RACHMO2k3_2km-" ;
    UserVar.RunType="-FT-from0to1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-ThickMin0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-Velyr1-GeoBed2-SMB_RACHMO2k3_2km-" ;

end

%%
UserVar=FileDirectories(UserVar) ;

[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ; 

FCFile=UserVar.FCFile;
FAFile=UserVar.FAFile;

CFile=UserVar.CFile;
AFile=UserVar.AFile;


fprintf("\n loading %s \n",CFile)

%if contains(CFile,"InvC")  % this implies that the file was generated through an inverse run
    load(CFile,"xC","yC","C");
% catch
%     load(CFile,"F");
%     xC=F.x;
%     yC=F.y;
%     C=F.C;
% end

FC=scatteredInterpolant(xC,yC,C);

if isfile(FCFile+".mat")

    list=dir(FCFile) ;

    fprintf("Overwrite %s from %s? \n",FCFile,list.date)
    txt=input("y/n :","s");
    if txt=="y"
        fprintf("saving %s \n",FCFile)
        save(FCFile,"FC")
    end
else
    fprintf("saving %s \n",FCFile)
    save(FCFile,"FC")
end

fprintf("\n loading %s \n",AFile)
load(AFile,"xA","yA","AGlen");
FA=scatteredInterpolant(xA,yA,AGlen);


if isfile(FAFile+".mat")
    list=dir(FAFile) ;
    fprintf("Overwrite %s from %s? \n",FAFile,list.date)
    txt=input("y/n :","s");
    if txt=="y"
        fprintf("saving %s \n",FAFile)
        save(FAFile,"FA")
    end
else
    fprintf("saving %s \n",FAFile)
    save(FAFile,"FA")
end


%%