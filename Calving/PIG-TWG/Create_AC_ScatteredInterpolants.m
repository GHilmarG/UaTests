

%%

Directory="D:\Runs\Calving\PIG-TWG\InversionFiles\";



Afile="InvA-Joughin-Ca1-Cs100000-Aa1-As100000-5km-Alim-Clim-.mat";
Cfile="InvC-Joughin-Ca1-Cs100000-Aa1-As100000-5km-Alim-Clim-.mat";

Afile="InvA-Weertman-ITS120-Ca1-Cs100000-Aa1-As100000-5km-Alim-Clim-.mat";
Cfile="InvC-Weertman-ITS120-Ca1-Cs100000-Aa1-As100000-5km-Alim-Clim-.mat";

Afile="InvA-Cornford-ITS120-Ca1-Cs100000-Aa1-As100000-5km-Alim-Clim-.mat";
Cfile="InvC-Cornford-ITS120-Ca1-Cs100000-Aa1-As100000-5km-Alim-Clim-.mat";

Afile=Directory+Afile;
Cfile=Directory+Cfile;


FCfile=replace(Cfile,"InvC","FC") ;
FAfile=replace(Afile,"InvA","FA") ;



fprintf("\n loading %s \n",Cfile)
load(Cfile);
FC=scatteredInterpolant(xC,yC,C);

if isfile(FCfile)

    list=dir(FCfile) ;

    fprintf("Overwrite %s from %s? \n",FCfile,list.date)
    txt=input("y/n :","s");
    if txt=="y"
        fprintf("saving %s \n",FCfile)
        save(FCfile,"FC")
    end
else
    fprintf("saving %s \n",FCfile)
    save(FCfile,"FC")
end

fprintf("\n loading %s \n",Afile)
load(Afile);
FA=scatteredInterpolant(xA,yA,AGlen);


if isfile(FAfile)
    list=dir(FAfile) ;
    fprintf("Overwrite %s from %s? \n",FAfile,list.date)
    txt=input("y/n :","s");
    if txt=="y"
        fprintf("saving %s \n",FAfile)
        save(FAfile,"FA")
    end
else
    fprintf("saving %s \n",FAfile)
    save(FAfile,"FA")
end


%%