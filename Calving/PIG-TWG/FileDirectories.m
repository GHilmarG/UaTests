function UserVar=FileDirectories(UserVar)


% Set output files directory depending on which machine the code is running


[~,hostname]=system('hostname') ;

if contains(hostname,"DESKTOP-G5TCRTD")  % office Dell

 

    UserVar.ResultsFileDirectory="F:\GoogleDriveStreamingOfficeDell\My Drive\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="F:\GoogleDriveStreamingOfficeDell\My Drive\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="F:\GoogleDriveStreamingOfficeDell\My Drive\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="F:\GoogleDriveStreamingOfficeDell\My Drive\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="F:\GoogleDriveStreamingOfficeDell\My Drive\Runs\Calving\PIG-TWG\RestartFiles\";
    UserVar.VideoFileDirectory="F:\GoogleDriveStreamingOfficeDell\My Drive\Runs\Calving\PIG-TWG\Videos\";
    UserVar.Interpolants="F:\GoogleDriveStreamingOfficeDell\My Drive\Interpolants\";

    UserVar.ISMIP6Directory="F:\GoogleDriveStreamingOfficeDell\My Drive\ISMIP6-Forcings\";

elseif contains(hostname,"DESKTOP-BU2IHIR")   % home

  
    
    UserVar.ResultsFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\RestartFiles\";
    UserVar.VideoFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\Videos\";
    UserVar.Interpolants="D:\GoogleDriveStreamingHomeHP\My Drive\Interpolants\";
    
    UserVar.ISMIP6Directory="D:\GoogleDriveStreamingHomeHP\My Drive\ISMIP6-Forcings\";




elseif contains(hostname,"C23000099")   

  


    UserVar.ResultsFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\RestartFiles\";
    UserVar.VideoFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\Videos\";
    UserVar.Interpolants="C:\cygwin64\home\pcnj6\Ua\Interpolants\";

   UserVar.ISMIP6Directory="E:\GoogleDriveStreamingOfficeHP\My Drive\ISMIP6-Forcings\";

elseif contains(hostname,"DESKTOP-014ILS5")   % HP laptop

  % G:\My Drive\Runs\Calving\PIG-TWG
    
    UserVar.ResultsFileDirectory="G:\My Drive\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="G:\My Drive\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="G:\My Drive\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="G:\My Drive\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="G:\My Drive\Runs\Calving\PIG-TWG\RestartFiles\";
    UserVar.VideoFileDirectory="G:\My Drive\Runs\Calving\PIG-TWG\Videos\";
    UserVar.Interpolants="G:\My Drive\Interpolants\";
    
    UserVar.ISMIP6Directory="G:\My Drive\ISMIP6-Forcings\";

else
    UserVar.ResultsFileDirectory=pwd+"\ResultsFiles\";
end


end
