


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

ReadPlotSequenceOfResultFiles("FileNameSubstring","-PTS-FPtol100-FPIt100-cExtrapolation0-PIG-MeshFile2k5km","PlotTimestep",0.1)


cd(CurDir)