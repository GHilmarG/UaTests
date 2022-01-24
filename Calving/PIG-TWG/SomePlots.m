


CurDir=pwd ;


if ~contains(CurDir,"ResultsFiles")
    [~,hostname]=system('hostname') ;
    if contains(hostname,"DESKTOP-G5TCRTD")
        UserVar.ResultsFileDirectory="F:\Runs\Calving\PIG-TWG\ResultsFiles\";
    elseif contains(hostname,"DESKTOP-BU2IHIR")
        UserVar.ResultsFileDirectory="D:\Runs\Calving\PIG-TWG\ResultsFiles\";
    else
        error("case not implemented")
    end
    cd(UserVar.ResultsFileDirectory)
end

% "0001530-Nodes5190-Ele10116-Tri3-kH1000-ucl-muValue1-Ini1-PDist1-CliffHeight-Crawford-GL0-cExtrapolation0-PIG-MeshFile10km"


% ReadPlotSequenceOfResultFiles("FileNameSubstring","cExtrapolation0-PIG-MeshFile10km","PlotTimestep",0.1)
% ReadPlotSequenceOfResultFiles("FileNameSubstring","cExtrapolation0-PIG-MeshFile5km","PlotTimestep",0.1)
% ReadPlotSequenceOfResultFiles("FileNameSubstring","cExtrapolation0-PIG-MeshFile2k5km","PlotTimestep",0.1)

%ReadPlotSequenceOfResultFiles("FileNameSubstring","-PTS-FPtol100-FPIt100-cExtrapolation0-PIG-MeshFile2k5km","PlotTimestep",0.1)
% ReadPlotSequenceOfResultFiles("FileNameSubstring","-PTS-FPtol100-FPIt100-cExtrapolation0-PIG-MeshFile1k25km","PlotTimestep",0.1)
% ReadPlotSequenceOfResultFiles("FileNameSubstring","-PTS-FPtol100-FPIt100-cExtrapolation0-PIG-MeshFile5km","PlotTimestep",0.1)
% ReadPlotSequenceOfResultFiles("FileNameSubstring","-muValue1000-Ini1-PDist1-CliffHeight-Crawford-GL0-PTS-FPtol100-FPIt100-cExtrapolation0-PIG-MeshFile10km","PlotTimestep",0.1)



% ReadPlotSequenceOfResultFiles("FileNameSubstring","ScalesWithNormalVelocity1-BedMachineCalvingFronts-PTS-FPtol100-FPIt100-cExtrapolation0-cDist10000-cOutMax5000-cOutMin1000-cMax5000-PIG-TWG-MeshFile30km-PIG-TWG","PlotTimestep",0.1)


SubString="Tri3-kH1000-Forward-Transient-ucl-muValue1-Ini1-PDist1-CliffHeight-Crawford-GL0-PTS-FPtol100-FPIt100-cExtrapolation0-cDist10000-cOutMax5000-cOutMin1000-cMax5000-PIG-MeshFile5km";
SubString="Tri3-kH1000-Forward-Transient-ucl-muValue1-IniInf-PDist1-ScalesWithNormalVelocity1-BedMachineCalvingFronts-PTS-FPtol100-FPIt100-cExtrapolation0-cDist10000-cOutMax5000-cOutMin1000-cMax5000-PIG-TWG-MeshFile30km-PIG-TWG";

SubString="muValue1-IniInf-PDist1-ScalesWithNormalVelocity+1k2-BedMachineCalvingFronts-PTS-FPtol100-FPIt100-cExtrapolation0-cDist10000-cOutMax5000-cOutMin1000-cMax5000-PIG-TWG-MeshFile30km-PIG-TWG";

SubString="T-C-I-ucl-mu1-IniInf-PDist1-NV-1-BMCF-PIG-TWG-MeshFile30km-PIG-TWG";
SubString="T-C-I-P-DTW-u-cl-mu0k1-Ini-geo-Inf-Strip1-SW=100km-NV-1k5-BMCF-int-PIG-TWG-MeshFile30km-PIG-TWG";

SubString="T-C-I-u-cl-mu0k1-Ini-geo-Inf-Strip1-SW=100km-AD=1-NV-1k5-BMCF-int-PIG-TWG-MeshFile10km-PIG-TWG";
%SubString="T-C-I-u-cl-mu0k1-Ini-geo-Inf-Strip1-SW=100km-AD=1-NV-1k5-BMCF-int-PIG-TWG-MeshFile20km-PIG-TWG";


SubString="T-C-I-u-cl-mu0k1-Ini-geo-Inf-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile30km-PIG-TWG";
SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-Inf-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile30km-PIG-TWG";

SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile30km-PIG-TWG";
% SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile20km-PIG-TWG";
% SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile10km-PIG-TWG";
% SubString="T-C-MR4-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NV-1k5-BMCF-int-PIG-TWG-MeshFile5km-PIG-TWG";


ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString,PlotTimestep=0.25) ; % ,VideoFileName="Video-NV-1k5-PIG-TWG-30km")

cd(CurDir)