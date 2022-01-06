


CurDir=pwd ;


if ~contains(CurDir,"ResultsFiles")
    [~,hostname]=system('hostname') ;
    if contains(hostname,"DESKTOP-G5TCRTD")
        UserVar.ResultsFileDirectory="F:\Runs\Calving\Circular\ResultsFiles\";
    elseif contains(hostname,"DESKTOP-BU2IHIR")
        UserVar.ResultsFileDirectory="D:\Runs\Calving\Circular\ResultsFiles\";
    else
        error("case not implemented")
    end
    cd(UserVar.ResultsFileDirectory)
end


SubString="muValue1-IniInf-PDist1-NV-=+0k0-wavy-int-cExtrapolation0dt=10-IceShelf-";
SubString="muValue1-IniInf-PDist1-NV-=+0k0-wavy-int-cExtrapolation0dt=1-IceShelf-";
SubString="muValue1-IniInf-PDist1-NV-=+0k0-wavy-int-cExtrapolation0dt=5-IceShelf-";
SubString="muValue1-IniInf-PDist1-NV-=+0k0-wavy-int-cExtrapolation0dt=1-IceShelf-";

SubString="muValue1-IniInf-PDist1-NV-=+0k0-wavy-int-cExtrapolation0dt=1Ele5km-IceShelf-";
SubString="muValue0k1-IniInf-PDist1-NV-=+0k0-wavy-int-cExtrapolation0dt=1Ele5km-IceShelf-";
SubString="muValue0k01-IniInf-PDist1-NV-=+0k0-wavy-int-cExtrapolation0dt=1Ele5km-IceShelf-";
SubString="muValue0-IniInf-PDist1-AutoDeactivate1-NV-=+0k0-wavy-int-cExtrapolation0dt=1Ele5kmT6-IceShelf-";
SubString="muValue0k01-IniInf-PDist1-AutoDeactivate0-NV-=+0k0-wavy-int-cExtrapolation0dt=1Ele5kmT3-IceShelf-";

SubString="mu0k01-IniInf-PDist1-AD0Strip1SW=150000-NV-=+2k0-wavy-int-dt=1Ele5kmT3-IceShelf-"; 
SubString="mu0k01-IniInf-PDist1-AD0Strip1SW=150000-NV-=+1k0-wavy-int-dt=1Ele5kmT3-IceShelf-"; 
SubString="mu0k01-IniInf-PDist1-AD0Strip1SW=150000-NV-=+0k0-wavy-int-dt=1Ele5kmT3-IceShelf-"; 

VideoFileName="Video-Circular"+SubString ; 
ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString,PlotTimestep=10,VideoFileName="Video-Circular")

cd(CurDir)