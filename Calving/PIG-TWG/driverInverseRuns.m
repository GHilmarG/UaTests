%%
close all

SubmitBathJobs=false;
IRCase="AandC" ;
more off


 UserVar.kH="" ; 
 UserVar.GroupAssembly="";

 

UserVar.RunType='Inverse-MatOpt';
UserVar.RunType='Inverse-MatOpt-Alim-';

UserVar.RunType='Inverse-MatOpt-Alim-Cornford-';
UserVar.RunType='Inverse-MatOpt-Alim-Weertman-';

UserVar.RunType='Inverse-MatOpt-Alim-Clim-Cornford-';
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Weertman-';


UserVar.MeshResolution=5e3; IRange=3:6 ; JRange=3:6 ;
UserVar.MeshResolution=20e3; IRange=0:7 ; JRange=0:7 ;
UserVar.MeshResolution=10e3; IRange=5 ; JRange=5 ;

UserVar.MeshResolution=2.5e3; IRange=5:5 ; JRange=5:5 ;

UserVar.RunType='Inverse-MatOpt-Alim-Clim-Umbi-';  UserVar.MeshResolution=20e3; IRange=5:5 ; JRange=5:5 ;
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Umbi-';  UserVar.MeshResolution=10e3; IRange=5:5 ; JRange=5:5 ;
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Weertman-';  UserVar.MeshResolution=2.5e3; IRange=5:5 ; JRange=5:5 ;  % done about 4000 iterations need to continue 25/03/2023
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Cornford-';  UserVar.MeshResolution=2.5e3; IRange=5:5 ; JRange=5:5 ;  % done about 7000 iterations, need to continue 26/03/2023

UserVar.RunType='Inverse-MatOpt-Alim-Clim-Umbi-';  UserVar.MeshResolution=5e3; IRange=5:5 ; JRange=5:5 ;




UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Umbi-';  UserVar.MeshResolution=20e3; IRange=5:5 ; JRange=5:5 ;

UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Cornford-';  UserVar.MeshResolution=2.5e3; IRange=5:5 ; JRange=5:5 ;


UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Cornford-';  UserVar.MeshResolution=20e3; IRange=5:5 ; JRange=5:5 ;

UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Umbi-';  UserVar.MeshResolution=10e3; IRange=5:5 ; JRange=5:5 ;
UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Cornford-';  UserVar.MeshResolution=5e3; IRange=5:5 ; JRange=5:5 ;

UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Umbi-';  UserVar.MeshResolution=5e3; IRange=5:5 ; JRange=5:5 ;
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Umbi-';  UserVar.MeshResolution=2.5e3; IRange=5:5 ; JRange=5:5 ;  % done about 2500 iterations

UserVar.RunType='Inverse-MatOpt-Alim-Clim-Cornford-';  UserVar.MeshResolution=20e3; IRange=5:5 ; JRange=5:5 ;  


UserVar.RunType='Inverse-MatOpt-Alim-Clim-Cornford-uvGroup-';  UserVar.MeshResolution=30e3; IRange=5:5 ; JRange=5:5 ;  
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Cornford-uvGroup-';  UserVar.MeshResolution=20e3; IRange=5:5 ; JRange=5:5 ;  
% UserVar.RunType='Inverse-MatOpt-Alim-Clim-Cornford-uvGroup-';  UserVar.MeshResolution=10e3; IRange=5:5 ; JRange=5:5 ;  
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Cornford-uvGroup-';  UserVar.MeshResolution=5e3; IRange=5:5 ; JRange=5:5 ;  
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Cornford-uvGroup-';  UserVar.MeshResolution=2.5e3; IRange=5:5 ; JRange=5:5 ;  

UserVar.RunType='Inverse-MatOpt-Alim-Clim-Weertman-';  UserVar.MeshResolution=5e3; IRange=5:5 ; JRange=5:5 ;  %


UserVar.RunType='Inverse-MatOpt-Alim-Clim-Cornford-';  UserVar.MeshResolution=30e3; IRange=5:5 ; JRange=5:5 ;  %  presumably fine


UserVar.RunType='Inverse-MatOpt-Alim-Clim-Joughin-';  UserVar.MeshResolution=20e3; IRange=5:5 ; JRange=5:5 ;  %  11000 it
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Joughin-';  UserVar.MeshResolution=30e3; IRange=5:5 ; JRange=5:5 ;  %  12000 it
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Joughin-';  UserVar.MeshResolution=10e3; IRange=5:5 ; JRange=5:5 ;  %  28000 it
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Joughin-';  UserVar.MeshResolution=5e3;  IRange=5:5 ; JRange=5:5 ;  %  17,500 it, 


UserVar.RunType='Inverse-MatOpt-Alim-Clim-Weertman-';  UserVar.MeshResolution=30e3; IRange=5:5 ; JRange=5:5 ;  %  10,000 it, presumably OK
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Weertman-';  UserVar.MeshResolution=10e3; IRange=5:5 ; JRange=5:5 ;  %  20,000 it, presumably OK
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Weertman-';  UserVar.MeshResolution=20e3; IRange=5:5 ; JRange=5:5 ;  %  15,000 it, presumably OK
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Weertman-';  UserVar.MeshResolution=5e3; IRange=5:5 ; JRange=5:5 ;   %  18,500 it, looking good
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Weertman-ITS120-';  UserVar.MeshResolution=5e3;  IRange=5:5 ; JRange=5:5 ;  % 2000 it, starting from ~ITS120


% These are the A/C interpolants used to define start A/C fields in an inversion, and A/C fields in DefineSlipperiness
% If this is left empty, ie [],  these are set to run appropriate values in DefineInitialInputs.
% By defining this here, one can overwrite those values, good for restarting the inversion with interpolants from other
% inversions. To create this A/C interpolants, one can use driverForwardIceShelfRemovalRun
UserVar.AFile="FA-Weertman-Ca1-ITS120-Cs100000-Aa1-As100000-5km-Alim-Clim-.mat"; 
UserVar.CFile="FC-Weertman-Ca1-ITS120-Cs100000-Aa1-As100000-5km-Alim-Clim-.mat"; 




CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased";      % Hessian-based, Matlab toolbox
% CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased";     % gradient-based, Matlab toolbox
% CtrlVar.Inverse.MinimisationMethod="UaOptimization-GradientBased";         % gradient-based, Ua optimisation toolbox
% CtrlVar.Inverse.MinimisationMethod="UaOptimization-HessianBased";          % Hessian-based, Ua optimisation toolbox
% CtrlVar.Inverse.AdjointGradientPreMultiplier="M"; % {'I','M'}

if contains(UserVar.RunType,"-ITS120-")
    UserVar.VelDataSet="-ITS120-";
else
    UserVar.VelDataSet="";
end



CtrlVar.Inverse.Iterations=2;

CtrlVar.Parallel.uvAssembly.spmd.isOn=true;
CtrlVar.Parallel.uvAssembly.parfeval.isOn=false;
CtrlVar.Parallel.isTest=false; 

if SubmitBathJobs

    
    job=cell(100,1);

    switch IRCase


        case "AorC"  % varies Ags with Cgs fixed, and  Cgs with Ags fixed

            job=cell(100,1);

            

            CtrlVar.Inverse.Regularize.logC.ga=1 ; % 10;
            CtrlVar.Inverse.Regularize.logC.gs=1000 ;
            CtrlVar.Inverse.Regularize.logAGlen.ga=1 ; % 10;
            CtrlVar.Inverse.Regularize.logAGlen.gs=1000;


          
            c=1;
            % C
            J=1;
            for I=IRange   % anything above 7 does not appear to converge I think
                I

                CtrlVar.Inverse.Regularize.logC.gs=c*10^I;
                job{J}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ; J=J+1;
                %Ua(UserVar,CtrlVar) ;
                pause(30)

                CtrlVar.Inverse.Regularize.logC.gs=5*c*10^I;
                job{J}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ; J=J+1;
                pause(30)

            end

            CtrlVar.Inverse.Regularize.logC.ga=10;
            CtrlVar.Inverse.Regularize.logC.gs=1000 ;
            CtrlVar.Inverse.Regularize.logAGlen.ga=10;
            CtrlVar.Inverse.Regularize.logAGlen.gs=1000;

            % A
            for I=IRange % all done above 10^7
                I+10

                CtrlVar.Inverse.Regularize.logAGlen.gs=c*10^I ;
                %Ua(UserVar,CtrlVar) ;
                job{J}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ; J=J+1;
                pause(30)
                CtrlVar.Inverse.Regularize.logAGlen.gs=5*c*10^I ;
                %Ua(UserVar,CtrlVar) ;
                job{J}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ; J=J+1;
                pause(30)

            end

        case "AandC"  % varies Ags and Cgs over a 2D grid of Ags and Cgs points

            K=1; 
            for I=IRange   % anything above 7 does not appear to converge I think
                for J=JRange   % anything above 7 does not appear to converge I think

                    
                    fprintf("I=%i \t J=%i \t K=%i \n",I,J,K)

                    CtrlVar.Inverse.Regularize.logC.ga=1;
                    CtrlVar.Inverse.Regularize.logAGlen.ga=1;


                    CtrlVar.Inverse.Regularize.logC.gs=10^I;
                    CtrlVar.Inverse.Regularize.logAGlen.gs=10^J ;


                    
                   % Ua(UserVar,CtrlVar) ; close all 


                   job{K}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ; 
                   pause(10)
                   K=K+1;
                end
            end

        otherwise

            error("case not found")

    end


else

    %% Test Run


    CtrlVar.Inverse.Regularize.logC.ga=1;
    CtrlVar.Inverse.Regularize.logC.gs=100000  ; % 100000000  ; % 10000000 (c); %   5000000 (c) ; %     1000000 (c) ;

    CtrlVar.Inverse.Regularize.logAGlen.ga=1;
    CtrlVar.Inverse.Regularize.logAGlen.gs=100000;

    for KK=1:1
        
        close all
        Ua(UserVar,CtrlVar) ;
    end
    %%
end

%%
