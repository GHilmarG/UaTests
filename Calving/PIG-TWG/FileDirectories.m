function UserVar=FileDirectories(UserVar)


% Set output files directory depending on which machine the code is running


[~,hostname]=system('hostname') ;

if contains(hostname,"DESKTOP-G5TCRTD")  % office Dell

    UserVar.ResultsFileDirectory="F:\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="F:\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="F:\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="F:\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="F:\Runs\Calving\PIG-TWG\RestartFiles\";

elseif contains(hostname,"DESKTOP-BU2IHIR")   % home

    % UserVar.ResultsFileDirectory="D:\Runs\Calving\PIG-TWG\ResultsFiles\";
    % UserVar.InverseRestartFileDirectory="D:\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    % UserVar.InversionFileDirectory="D:\Runs\Calving\PIG-TWG\InversionFiles\";
    % UserVar.MeshFileDirectory="D:\Runs\Calving\PIG-TWG\MeshFiles\";
    % UserVar.ForwardRestartFileDirectory="D:\Runs\Calving\PIG-TWG\RestartFiles\";
    
    UserVar.ResultsFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="D:\GoogleDriveStreamingHomeHP\My Drive\Runs\Calving\PIG-TWG\RestartFiles\";

    
    
    UserVar.Interpolants="C:\cygwin64\home\Hilmar\Ua\Interpolants\" ; 
                      

elseif contains(hostname,"C23000099")   % home

    % E drive is one of the local drives (Fast Store)
    % F is the "external" NAS drive
    % 
    % UserVar.ResultsFileDirectory="F:\Runs\Calving\PIG-TWG\ResultsFiles\";
    % UserVar.InverseRestartFileDirectory="F:\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    % UserVar.InversionFileDirectory="F:\Runs\Calving\PIG-TWG\InversionFiles\";
    % UserVar.MeshFileDirectory="F:\Runs\Calving\PIG-TWG\MeshFiles\";
    % UserVar.ForwardRestartFileDirectory="F:\Runs\Calving\PIG-TWG\RestartFiles\";


    UserVar.ResultsFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="E:\GoogleDriveStreamingOfficeHP\My Drive\Runs\Calving\PIG-TWG\RestartFiles\";

   


    UserVar.Interpolants="C:\cygwin64\home\pcnj6\Ua\Interpolants\";

else
    UserVar.ResultsFileDirectory=pwd+"\ResultsFiles\";
end


end
