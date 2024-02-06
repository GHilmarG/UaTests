

%%



UserVar.RunType="-FT-from0to1-30km-Tri3-SlidCornford-Duvh-MR4-P-kH10000-ThickMin0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-ITS120-GeoBed2-" ;



%%
UserVar=FileDirectories(UserVar) ;
[CtrlVar,UserVar]=ParseRunTypeString(CtrlVar,UserVar) ; 

FCFile=UserVar.FCFile;
FAFile=UserVar.FAFile;

CFile=UserVar.CFile;
AFile=UserVar.AFile;


fprintf("\n loading %s \n",CFile)
load(CFile);
FC=scatteredInterpolant(xC,yC,C);

if isfile(FCFile)

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
load(AFile);
FA=scatteredInterpolant(xA,yA,AGlen);


if isfile(FAFile)
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