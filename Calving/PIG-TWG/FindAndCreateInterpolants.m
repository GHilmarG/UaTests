


function [CtrlVar,UserVar]=FindAndCreateInterpolants(CtrlVar,UserVar)



if CtrlVar.InverseRun

    % inverse run using forward run results from t=1. This implies using the geometry from t=1 instead of Bedmachine2  geometry.
    % UserVar.RunType="-IRt1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";



    

    if UserVar.to == 0

        % This is the initial inverse run. It will use the Bedmachine geometry

        % If no corresponding inverse restart file exists, I might consider creating FA and FC interpolants from a similar previous
        % inverse run here.

    else

       % This is a "transient" inverse run, that is the inverse run should use geometry from a previous forward transient run

        % The previous forward run results file, containing the sbB information for this inverse run
        FileName=sprintf('%s%07i-%s.mat',...
            UserVar.ResultsFileDirectory,...
            round(100*UserVar.to),CtrlVar.Experiment);
        FileName=replace(FileName,".mat","");
        FileName=replace(FileName,"--","-");
        FileName=replace(FileName,".","k");

        FileName=replace(FileName,"-IR","-FR");
        FileName=FileName+".mat" ;


        isInverseRestartFile=isfile(UserVar.InverseRestartFile);

     

        if isfile(FileName)

            fprintf("An output file with results from a forward transient run at t=%i is found: \n",UserVar.to)
            fprintf("%s\n",FileName)
            fprintf("This output file will be used to define the new geometry (sbSB) of this inverse run.\n ")
            fprintf("This output file will be also be used to define new FA and FC interpolants.\n ")


            % If no corresponding inverse restart file exists, FA and FC interpolants are created from transient run at t=to

            load(FileName,"F")

            FC=scatteredInterpolant(F.x,F.y,F.C);
            FA=scatteredInterpolant(F.x,F.y,F.AGlen);

            fprintf("Saving FA interpolant in: %s \n",UserVar.FAFile)
            fprintf("Saving FC interpolant in: %s \n",UserVar.FCFile)

            save(UserVar.FAFile,"FA")
            save(UserVar.FCFile,"FC")




            fprintf("Creating new geometrical interpolants for this inverse run from %s \n",FileName)
            FB=scatteredInterpolant(F.x,F.y,F.B);
            Fh=scatteredInterpolant(F.x,F.y,F.h);
            Fs=scatteredInterpolant(F.x,F.y,F.s);
            Fb=scatteredInterpolant(F.x,F.y,F.b);
            
            Frho=scatteredInterpolant(F.x,F.y,F.rho);
            rhow=F.rhow;
            fprintf("Saving new geometrical interpolants for this inverse run in %s \n",UserVar.GeometryInterpolant)
            save(UserVar.GeometryInterpolant,'FB','Fh','Frho','Fs','Fb','rhow')



        else

            error(" No previous forward run file found.\n")
        end


        if isInverseRestartFile  %

            fprintf("Inverse restart file is found. \n ")

            % Have to consider the possibility that after this inverse restart file was generated a further transient run was
            % conduced and the geometry should therefore be updated based on the results of this more recent transient run. So I
            % load the inverse restart file and replace F.s, F.n , F.B F.S and F.h in that file with (possibly) the more recent
            % results from a transient run for the time at which this restart run should start from

            load(UserVar.InverseRestartFile,...
                'CtrlVarInRestartFile','UserVarInRestartFile','MUA','BCs','F','GF','l','RunInfo',...
                'InvStartValues','Priors','Meas','BCsAdjoint','InvFinalValues');

            
            F.h=Fh(F.x,F.y);
            F.B=FB(F.x,F.y);
            F.rho=Frho(F.x,F.y) ;
            
            [F.b,F.s,F.h,GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow);
            
            fprintf("Saving an updated restart file for inverse restart run with new geometry based on previous forward transient run. \n")
            save(UserVar.InverseRestartFile,...
                'CtrlVarInRestartFile','UserVarInRestartFile','MUA','BCs','F','GF','l','RunInfo',...
                'InvStartValues','Priors','Meas','BCsAdjoint','InvFinalValues');


        end

    end

elseif CtrlVar.TimeDependentRun


    % The FA and FC interpolants must be based on previous restart run
    FAdir=dir(UserVar.FAFile);
    FCdir=dir(UserVar.FCFile);
    IRdir=dir(UserVar.InverseRestartFile);

    if  isempty(FAdir) || isempty(FCdir) || (datetime(IRdir.date) > datetime(FAdir.date)) || (datetime(IRdir.date) > datetime(FCdir.date))


        fprintf("FindAndCreateInterpolants: Loading inverse restart file: \n")
        fprintf("%s \n \t",UserVar.InverseRestartFile)
        load(UserVar.InverseRestartFile,"F")
        FC=scatteredInterpolant(F.x,F.y,F.C);
        FA=scatteredInterpolant(F.x,F.y,F.AGlen);

        fprintf("FindAndCreateInterpolants: New FA and FC interpolants created and saved.\n")
        fprintf("FA interpolant: %s \n",UserVar.FAFile)
        fprintf("FC interpolant: %s \n",UserVar.FCFile)

        save(UserVar.FAFile,"FA")
        save(UserVar.FCFile,"FC")

    else

        fprintf("FindAndCreateInterpolants: Existing files with A and C interpolants found:")
        fprintf("FA: %s ",UserVar.FAFile)
        fprintf("FC: %s ",UserVar.FCFile)

    end


    if UserVar.from ~= 0

        % Since this is a forward run, following an inverse run, the geometrical interpolants should already exist.

        if ~isfile(UserVar.GeometryInterpolant)

           fprintf("Was expecing to find the geometry interpolant file: \n")
           fprintf("%s \n",UserVar.GeometryInterpolant)
           error("A required input file not found")

        end
     


    end

end