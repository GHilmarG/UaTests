
%%
ResultsFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\ResultsFiles"; 

Files=dir(ResultsFileDirectory+"/0202000-*-*km-uvh-*MRZERO-P-BCVel-*VelITS120-*.mat")


for I=1:numel(Files)

    copyfile(Files(I).folder+"/"+Files(I).name,Files(I).name)


end

%%

%%
ResultsFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\InverseRestartFiles";

Files=dir(ResultsFileDirectory+"/IR-at2019-*km-uvh-*-MRZERO-*BCVel-*VelITS120-*.mat")


for I=1:numel(Files)
   
    fprintf("file %s \n",Files(I).name)
    copyfile(Files(I).folder+"/"+Files(I).name,Files(I).name)


end

%%