

%%

Directory="D:\Runs\Calving\PIG-TWG\InversionFiles\";

Afile="InvA-Weertman-ITS120-Ca1-Cs100000-Aa1-As100000-5km-Alim-Clim-.mat";
Cfile="InvC-Weertman-ITS120-Ca1-Cs100000-Aa1-As100000-5km-Alim-Clim-.mat";

Afile=Directory+Afile;
Cfile=Directory+Cfile;


FCfile=replace(Cfile,"InvC","FC") ;
FAfile=replace(Afile,"InvA","FA") ;



fprintf("loading %s \n",Cfile)
load(Cfile);
FC=scatteredInterpolant(xC,yC,C);

if isfile(FCfile)
    fprintf("Overwrite %s? \n",FCfile)
    txt=input("y/n :");
    if txt=="y"
        fprintf("saving %s \n",FCfile)
        save(FCfile,"FC")
    end
else
    fprintf("saving %s \n",FCfile)
    save(FCfile,"FC")
end

fprintf("loading %s \n",Afile)
load(Afile);
FA=scatteredInterpolant(xA,yA,AGlen);


if isfile(FAfile)
    fprintf("Overwrite %s? \n",FAfile)
    txt=input("y/n :");
    if txt=="y"
        fprintf("saving %s \n",FAfile)
        save(FAfile,"FA")
    end
else
    fprintf("saving %s \n",FAfile)
    save(FAfile,"FA")
end


%%