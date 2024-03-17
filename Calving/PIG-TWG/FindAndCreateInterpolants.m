


function [CtrlVar,UserVar]=FindAndCreateInterpolants(CtrlVar,UserVar)



if CtrlVar.InverseRun

    % inverse run using forward run results from t=1. This implies using the geometry from t=1 instead of Bedmachine2  geometry.
    % UserVar.RunType="-IRt1-ES20km-Tri3-SlidWeertman-Duvh-MR4-P-kH10000-TM0k1-Alim-Clim-Ca1-Cs100000-Aa1-As100000-VelITS120-GeoBed2-SMB_RACHMO2k3_2km-";



    % if this is not start run,

    if UserVar.to == 0

        % This is the initial inverse run

        % If no corresponding inverse restart file exists, I might consider creating FA and FC interpolants from a similar previous
        % inverse run here.

    else

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

        if isInverseRestartFile

            fprintf("Inverse restart file is found. \n ")

            % consider here to updated the FA and FC interpolants

        elseif isfile(FileName)

            fprintf("An output file with results from a forward transient run at t=%i is found: \n",UserVar.to)
            fprintf("%s\n",FileName)
            fprintf("This output file will be used to define the geometry (sbSB) of this inverse run.\n ")
            fprintf("This output file will be also be used to define the FA and FC interpolants.\n ")


            % If no corresponding inverse restart file exists, FA and FC interpolants are created from transient run at t=to

            load(FileName,"F")

            FC=scatteredInterpolant(F.x,F.y,F.C);
            FA=scatteredInterpolant(F.x,F.y,F.AGlen);

            fprintf("Saving FA interpolant in: %s \n",UserVar.FAFile)
            fprintf("Saving FC interpolant in: %s \n",UserVar.FCFile)

            save(UserVar.FAFile,"FA")
            save(UserVar.FCFile,"FC")



            if isfile(UserVar.GeometryInterpolant)


                fprintf("Geometrical interpolants based on a previous forward run, and to be used in this inverse run, are already found in:  \n")
                fprintf(" %s \n",UserVar.GeometryInterpolant)


            else

                fprintf("Creating new geometrical interpolants for this inverse run from %s \n",FileName)
                FB=scatteredInterpolant(F.x,F.y,F.B);
                Fs=scatteredInterpolant(F.x,F.y,F.s);
                Fb=scatteredInterpolant(F.x,F.y,F.b);
                Frho=scatteredInterpolant(F.x,F.y,F.rho);
                fprintf("Saving new geometrical interpolants for this inverse run in %s \n",UserVar.GeometryInterpolant)
                save(UserVar.GeometryInterpolant,'FB','Fb','Fs','Frho')

            end

        else

            error(" No inverse restart file found, and no previous forward run file either.\n")
        end




    end

elseif CtrlVar.TimeDependentRun


    % The FA and FC interpolants must be based on previous restart run
    FAdir=dir(UserVar.FAFile);
    FCdir=dir(UserVar.FCFile);
    IRdir=dir(UserVar.InverseRestartFile);

    if  isempty(FAdir) || isempty(FCdir) || (datetime(IRdir.date) > datetime(FAdir.date)) || (datetime(IRdir.date) > datetime(FCdir.date))


        fprintf("Loading inverse restart file: \n")
        fprintf("%s \n",UserVar.InverseRestartFile)
        load(UserVar.InverseRestartFile,"F")
        FC=scatteredInterpolant(F.x,F.y,F.C);
        FA=scatteredInterpolant(F.x,F.y,F.AGlen);

        fprintf("New FA and FC interpolants created and saved.\n")
        fprintf("FA interpolant: %s \n",UserVar.FAFile)
        fprintf("FC interpolant: %s \n",UserVar.FCFile)

        save(UserVar.FAFile,"FA")
        save(UserVar.FCFile,"FC")

    else

        fprintf("Existing files with A and C interpolants found:")
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