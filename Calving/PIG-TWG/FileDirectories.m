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

    UserVar.ResultsFileDirectory="D:\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="D:\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="D:\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="D:\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="D:\Runs\Calving\PIG-TWG\RestartFiles\";
    UserVar.Interpolants="C:\cygwin64\home\Hilmar\Ua\Interpolants\" ; 
                      

elseif contains(hostname,"C23000099")   % home

    UserVar.ResultsFileDirectory="E:\Runs\Calving\PIG-TWG\ResultsFiles\";
    UserVar.InverseRestartFileDirectory="E:\Runs\Calving\PIG-TWG\InverseRestartFiles\";
    UserVar.InversionFileDirectory="E:\Runs\Calving\PIG-TWG\InversionFiles\";
    UserVar.MeshFileDirectory="E:\Runs\Calving\PIG-TWG\MeshFiles\";
    UserVar.ForwardRestartFileDirectory="E:\Runs\Calving\PIG-TWG\RestartFiles\";

    UserVar.Interpolants="C:\cygwin64\home\Hilmar\Ua\Interpolants\" ; 

else
    UserVar.ResultsFileDirectory=pwd+"\ResultsFiles\";
end


end
