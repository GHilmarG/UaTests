%%
Klear

SubmitBathJobs=false;
IRCase="AandC" ;
more off

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
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Weertman-';  UserVar.MeshResolution=2.5e3; IRange=5:5 ; JRange=5:5 ;
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Cornford-';  UserVar.MeshResolution=2.5e3; IRange=5:5 ; JRange=5:5 ;
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Umbi-';  UserVar.MeshResolution=2.5e3; IRange=5:5 ; JRange=5:5 ;
UserVar.RunType='Inverse-MatOpt-Alim-Clim-Umbi-';  UserVar.MeshResolution=5e3; IRange=5:5 ; JRange=5:5 ;




UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Umbi-';  UserVar.MeshResolution=20e3; IRange=5:5 ; JRange=5:5 ;

UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Cornford-';  UserVar.MeshResolution=2.5e3; IRange=5:5 ; JRange=5:5 ;


UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Cornford-';  UserVar.MeshResolution=20e3; IRange=5:5 ; JRange=5:5 ;

UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Umbi-';  UserVar.MeshResolution=10e3; IRange=5:5 ; JRange=5:5 ;
UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Cornford-';  UserVar.MeshResolution=5e3; IRange=5:5 ; JRange=5:5 ;

UserVar.RunType='Inverse-MatOpt-uvdhdt-Alim-Clim-Umbi-';  UserVar.MeshResolution=5e3; IRange=5:5 ; JRange=5:5 ;

CtrlVar.Inverse.Iterations=5;

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
   
    
 
 

    CtrlVar.Inverse.Iterations=2500;
    CtrlVar.Inverse.Regularize.logC.ga=1;
    CtrlVar.Inverse.Regularize.logC.gs=100000  ; % 100000000  ; % 10000000 (c); %   5000000 (c) ; %     1000000 (c) ;

    CtrlVar.Inverse.Regularize.logAGlen.ga=1;
    CtrlVar.Inverse.Regularize.logAGlen.gs=100000;

    Ua(UserVar,CtrlVar) ;
    %%
end

%%
