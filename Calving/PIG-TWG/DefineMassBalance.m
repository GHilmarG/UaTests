





function [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)

persistent Fdh2000to2018 dhdtMeasured CurrentRunStepNumber Fas FOceanNodes0 gamma0 Fdeltbasin Ftf OceanNodes0FileSaved

% as=zeros(MUA.Nnodes,1) ;
ab=zeros(MUA.Nnodes,1) ;
dasdh=zeros(MUA.Nnodes,1) ;
dabdh=zeros(MUA.Nnodes,1) ;

if isempty(OceanNodes0FileSaved)
    OceanNodes0FileSaved=false;
end

%% Surface mass balance

if isempty(Fdh2000to2018)

    FdhdtDataFile="FdhdtMeasuredRatesOfElevationChanges2000to2018.mat";
    fprintf("Loading data on rate of thickness changes: %s \n",FdhdtDataFile)
    load(FdhdtDataFile,"Fdh2000to2018")
    dhdtMeasured=Fdh2000to2018(F.x,F.y) ;  % I can do this here because in this run the mesh does not change
    CurrentRunStepNumber=0 ;
end


%% ISMIP6:  Are we using the ISMIP6 forcing?
if contains(UserVar.RunType,"-MRIM6")

    F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);

    if isempty(Fas)
        % Read in the surface forcing interpolant, Fas
       % load('ISMIP6-Melt\FasRACMO.mat','Fas'); % Change path if necessary
        load(UserVar.ISMIP6Directory+"ISMIP6-Melt\FasRACMO.mat","Fas"); % Change path if necessary
        % Read in interpolants for deltaT_basin and thermal forcing, Fdeltbasin
        % and Ftf. Also the value of gamma0.
        load(UserVar.ISMIP6Directory+"ISMIP6-Melt\ocean_local_median_new.mat","gamma0","Fdeltbasin","Ftf"); % Change path if necessary


    end

    
    dasdh=zeros(MUA.Nnodes,1) ;
    dabdh=zeros(MUA.Nnodes,1) ;
    as0=Fas(MUA.coordinates);

    rhoi_SI=917.0; % ice density (kg/m^3)
    rhosw_SI=1027.0; % sea water density
    Lf_SI=3.34e5; % fusion latent heat of Ice (J/kg)
    cpw_SI=3974.0; % specific heat of sea water (J/kg/K)
    deltaT_basin=Fdeltbasin(MUA.coordinates);

    if ~contains(UserVar.RunType,"-MRIM6Control-")
        % Here we load chosen forcing, if not using Control
        year_anom=floor(F.time); % Define year for input files
        %anomfile=[UserVar.SMBfilename,num2str(year_anom),'.mat'];
        anomfile=UserVar.SMBfilename+num2str(year_anom)+".mat";
        
        for iLoadTry=1:10
            try
                fprintf("\t\t\t DefineMassBalance: loading %s \n",anomfile)
                load(anomfile,"smb_anomaly");
                break
            catch
                fprintf("could not load %s\n",anomfile)
                fprintf("Attempt nr %i , pausing for 10 sec. \n",iLoadTry)
                pause(10)
            end
        end
        %%
        as_anom=smb_anomaly(MUA.coordinates).*3600*24*365/917; % changing units from kg m^-2 s^-1 to m/year

        anomfile=UserVar.TFfilename+num2str(year_anom)+".mat";
        for iLoadTry=1:10
            try
                fprintf("\t\t\t DefineMassBalance: loading %s \n","tf_anomaly"); 
                load(anomfile,"tf_anomaly");
                %load(UserVar.TFfilename+num2str(year_anom)+".mat","tf_anomaly");
                break
            catch
                fprintf("could not load %s\n",anomfile)
                fprintf("Attempt nr %i , pausing for 10 sec. \n",iLoadTry)
                pause(10) % attempts 
            end
        end

        tf_anom=tf_anomaly([MUA.coordinates F.b]);
    else
        % Just use control forcing
        tf_anom=Ftf([MUA.coordinates F.b]);
        as_anom=0;
    
    end

    as=as0+as_anom; % Add model SMB anomalies to control.
    thermal_forcing=tf_anom; % Control+anomalies are included in files from Sainan. Don't need to add again!
    ab=-gamma0.*(rhosw_SI.*cpw_SI./rhoi_SI./Lf_SI).^2.*(max(thermal_forcing+deltaT_basin,0.0)).^2; % mass balance needs the negative sign
    ab(F.GF.node>0.5)=0;

    OceanBoundaryNodes=[];
    NodesDownstreamOfGroundingLines="Relaxed" ;
    LakeNodes = LakeOrOcean3(CtrlVar,MUA,F.GF,OceanBoundaryNodes,NodesDownstreamOfGroundingLines);
    ab(LakeNodes)=0;
    ab(isnan(ab))=0;





else

    %%


    if isempty(Fas)
        fprintf("Loading surface mass balance interpolant: %s ",UserVar.FasFile)
        load(UserVar.FasFile,"Fas")
        fprintf("...done.\n")
    end

    year=2000+zeros(MUA.Nnodes,1);
    as=Fas(F.x,F.y,year);  % units kg/m^2/yr

    as=as./F.rho ; % units kg/m^2/yr

    % UaPlots(CtrlVar,MUA,F,as,GetRidOfValuesDownStreamOfCalvingFronts=false)

    % Most of the melt-rate parameterisations below are based on that old Favier 2014 paper:
    % Favier, L., Durand, G., Cornford, S. L., Gudmundsson, G. H., Gagliardini, O.,
    % Gillet-Chaulet, F., Zwinger, T., Payne, A. J., & Le Brocq, a. M. (2014).
    % Retreat of Pine Island Glacier controlled by marine ice-sheet instability.
    % Nature Climate Change, 4(2), 117121. https://doi.org/10.1038/nclimate2094


    %
    % When calculating dabdh from ab(b) for floating ice shelves:
    % b=S-F.rho h /F.rhow
    % h=F.rhow (S-b)/F.rho
    % ab(b)=ab(S-F.rho h/F.rhow)
    % dab/dh= -(F.rho/F.rhow) dab/db
    % or:
    % dab/dh = dab/db  db/dh = dab/db (-F.rho/F.rhow)= -(F.rho/F.rhow) dab/db

    if contains(UserVar.RunType,"-I-")  % This is a 'dynamical' initialization, use with care!

        if isempty(F.dhdt)
            as=zeros(MUA.Nnodes,1) ;
        else

            if F.time < 0  ...  % only for neg times
                    && CtrlVar.CurrentRunStepNumber>1 ... % only once a uvh solve has been done
                    && CurrentRunStepNumber~=CtrlVar.CurrentRunStepNumber % not if already applied to the current run step

                dhdtMeasured=Fdh2000to2018(F.x,F.y) ;
                da=dhdtMeasured-F.dhdt ;
                fprintf("DefineMassBalance: norm(dhdtMeasured-F.dhdt)=%f \n ",norm(da))
                CurrentRunStepNumber=CtrlVar.CurrentRunStepNumber ;
            else
                da=0;
            end

            as=F.as+da ;


        end
    elseif contains(UserVar.RunType,"-MRZERO")


        ab=zeros(MUA.Nnodes,1) ;
        dasdh=zeros(MUA.Nnodes,1) ;
        dabdh=zeros(MUA.Nnodes,1) ;

    elseif contains(UserVar.RunType,"-MR")

        MRP=extractBetween(UserVar.RunType,"-MR","-");
        % MRP="l"+MRP;
        [ab,dabdh]=DraftDependentMeltParameterisations(UserVar,CtrlVar,F,MRP) ;



    elseif contains(UserVar.RunType,"-DMR")

        dsdt=F.x*0 ; dhdt=F.x*0;

        pat="DMR"+("+"|"-")+digitsPattern ;
        mathSymbols = asManyOfPattern(digitsPattern | characterListPattern("+-*/="),1) ;
        SubString=extract(extract(UserVar.RunType,pat),mathSymbols);


        if ~isempty(SubString)
            dhdtValue=str2double(SubString);
            if isnumeric(dhdtValue)
                dhdt=F.x*0+dhdtValue;
            end
        end



        if ~isempty(F.ub)
            ab=CalcIceShelfMeltRates(CtrlVar,MUA,F.ub,F.vb,F.s,F.b,F.S,F.B,F.rho,F.rhow,dsdt,F.as,dhdt) ;

            ab(F.LSF<0.5)=0 ;
            ab(ab>0)=0;
        end
    end

end


%% Now the general mass balance forcing have been defined. However, I might still want to add melt do to frictional heating,
% and I might want to use the initial GF mask during the initialisation/relaxation phase 
%
%


%
% if ~isfield(UserVar,"IceSheetIceShelves") || UserVar.IceSheetIceShelves
%     % only apply basal melt strictly below/outside of grounding lines
%     F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
%     ab(~F.GF.NodesDownstreamOfGroundingLines)=0;
%     dabdh(~F.GF.NodesDownstreamOfGroundingLines)=0;
%     % figure ; plot(F.b(F.GF.NodesDownstreamOfGroundingLines),F.ab(F.GF.NodesDownstreamOfGroundingLines),'.')
% end



%% During the "transient initialisation" phase, optionally, apply melt using the initial GF mask at t=0;

if contains(UserVar.RunType,"-abMask0") 

    % abMask0    :  apply melt over nodes either currently or initially afloat, within the assimilation/relaxation period
    %
    % abMask0M   :  apply ADDITIONAL high melt over nodes that initially were afloat, but now have become grounded, ONLY within the assimilation/relaxation period
    %
    % abMask0A   :  apply ADDITIONAL high melt over nodes that initially were afloat, but now have become grounded, ALWAYS (ie
    %               throughout the run period)
    % 
    %               
    %

    % creating, and later reading in, file with the initial ocean nodes
    FileNameOceanNodes0="OceanNodes0"+extractBetween(UserVar.RunType,"-"+digitsPattern,"km-",Boundaries="inclusive")+".mat";

    if F.time==UserVar.Assimilation.tStart && ~OceanNodes0FileSaved

        if contains(UserVar.RunType,"-IOR-")
            [~,OceanNodes0] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Relaxed") ;
        else
            [~,OceanNodes0] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Strict") ;
        end

        % The OceanNodes0 mask is only dependent on the mesh and the initial GF at t=0.
        FOceanNodes0=scatteredInterpolant(F.x,F.y,double(OceanNodes0));
        save(UserVar.ResultsFileDirectory+FileNameOceanNodes0,"OceanNodes0","FOceanNodes0")
        OceanNodes0FileSaved=true;

    end

    if isempty(FOceanNodes0)

        % this in principle should hardly happen, but since the transient initialization involves several forward runs, it is
        % possible that the current forward run did not start at t=0. But even so, if the matlab session has not been interrupted and
        % the m-file not changed, the OceanNodes0 created at t=0 in a previous run, should still be available.

        load(UserVar.ResultsFileDirectory+FileNameOceanNodes0,"FOceanNodes0")

    end



    % also apply melt over all nodes that initially were grounded

    OceanNodes0Double=FOceanNodes0(F.x,F.y) ; % this is a double
    OceanNodes0=OceanNodes0Double>0.5 ;       % presumably not needed, but interpolation might create values between 0 and 1

    if contains(UserVar.RunType,"-IOR-")
        [~,OceanNodes] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Relaxed") ;
    else
        [~,OceanNodes] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Strict") ;
    end


    InitialOceanNodesThatNowAreGrounded=OceanNodes0 & ~OceanNodes;


    % Above I have defined ab over ALL nodes. And below I then set ab to zero over ~OceanNodes
    %
    %



    if contains(UserVar.RunType,"-abMask0A")

        OceanNodesAndOceanNodes0=true;
        ApplyAdditionalMeltToNodes0=true;

    elseif F.time <= UserVar.Assimilation.tEnd

        if contains(UserVar.RunType,"-abMask0-")
            OceanNodesAndOceanNodes0=true;
            ApplyAdditionalMeltToNodes0=false;

        elseif contains(UserVar.RunType,"-abMask0M-")

            OceanNodesAndOceanNodes0=true;
            ApplyAdditionalMeltToNodes0=true;
        end
    else

        % Since this is within the if statement "if (contains(UserVar.RunType,"-abMask0") " this case should not happen
        OceanNodesAndOceanNodes0=false;
        ApplyAdditionalMeltToNodes0=false;
        %error(" confusion with if-then-else ")

    end

    if OceanNodesAndOceanNodes0


        %  1) currently are ocean nodes based on the current GF mask, or
        %  2) or were ocean nodes at the start of the run.


        % So melt will be applied over any ocean nodes, and also over all ocean nodes at the start of the run, even if they have by
        % now become grounded.

        % Alternative idea:  Find nodes that were afloat, but no longer are, and then add melt over those nodes which is a function
        % of how close to flotation they are, ie h-hf, for example apply high melt were (h+dh)-hf > 0 , where dh is a desired
        % min thickness below flotation at those locations.
        %
        % NOTE:  Because "OceanNodes" are here based on the "strict" definition, a node that is a afloat might not be included in
        % Ocean-nodes if it is attached to some other nodes that are not afloat.  And a node initially included in OceaNodes might
        % be deleted from the array if nodes that it is attached to become grounded. This implies that one can have the situation where
        % a node that is afloat enters, or leaves, the OceanNodes array depending on whether its neighboring nodes go afloat or not.
        %
        %

        % apply high melt rate over any nodes that have become grounded as compared to start of run

        OceanNodes=OceanNodes | OceanNodes0 ; % here "OceanNodes" are nodes that either:


        if ApplyAdditionalMeltToNodes0

            if any(InitialOceanNodesThatNowAreGrounded)

                fprintf("nodes initially afloat, now have become grounded\n")

                hf=F.rhow.*(F.S-F.B)./F.rho ;

                ThicknessAboveFloation=F.h(InitialOceanNodesThatNowAreGrounded)-hf(InitialOceanNodesThatNowAreGrounded) ;

                dh=ThicknessAboveFloation+20;
                dh(dh<0)=0 ;

                if any(dh>0)
                    ab(InitialOceanNodesThatNowAreGrounded)=ab(InitialOceanNodesThatNowAreGrounded)-100*dh;
                    dabdh(InitialOceanNodesThatNowAreGrounded)=dabdh(InitialOceanNodesThatNowAreGrounded)-100;
                end

            end
        end

    end

else

    if contains(UserVar.RunType,"-IOR-")

        [~,OceanNodes] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Relaxed") ;
    else

        [~,OceanNodes] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Strict") ;
    end

end

% only apply basal melt strictly below/outside of grounding lines over nodes connected to the ocean

ab(~OceanNodes)=0;
dabdh(~OceanNodes)=0;

dabdh=dabdh*0; % testing impact of uv-h convergence

%% Basal melting due to frictional heating


[tbx,tby] = CalcBasalTraction(CtrlVar,UserVar,MUA,F,CalcNodalValues=true,CalcIntegrationPointValues=false) ;


% cbar=UaPlots(CtrlVar,MUA,F,tb,FigureTitle="taub");
% title(cbar,"(kPa)",Interpreter="latex")
% clim([0 1000])


% Pa = J/m^3
%
%
L=334e3 ; % J/kg
rho=1000;

if isempty(tbx)  % it is possible that velocities have yet to be calculated
    aw=0;
else
    aw=1000*(F.ub.*tbx+F.vb.*tby)/(L*rho) ; % multiplying with 1000 to get Joules
end

ab=ab-aw ;



return


%save TestSave ; error('asdf')



%% [ --------------- Old code using and old version of the plume model
%if ~isempty(regexp(CtrlVar.Experiment,'J[123]-','once'))
%
%
%     %fprintf(' Jenkins \n ')
%     [Tw,Sw,tcDe]=TwSwtcDe(CtrlVar,time);
%
%
%     [dfdx,dfdy]=calcFEderivativesMUA(b,MUA,CtrlVar);
%     bGrad=sqrt(dfdx.*dfdx+dfdy.*dfdy);  % defined at integration points
%     bGrad=ProjectFintOntoNodes(MUA,bGrad);
%     minSlope=0.001;
%     bGrad(bGrad<minSlope)=minSlope;
%
%
%     % find for each node on an ice shelf the min distance to a grounded point that has
%     % a greater (more negative) draft than the point itself
%
%     I=GF.node<0.5 ;
%
%
%     % Both method give almost identical results for PIG+TWG, but scale differently with the size of the problem
%     %glDe=FindNearestGroundedPoint(CtrlVar,MUA,b,GF,I) ;My first method
%
%     [glDe,BGL,xGL,yGL,GLgeo]=DefineDraftAlongGroundingLineForTheUniversalPlume(CtrlVar,MUA,b,GF,I); %My second method
%
%
%     ab=b*0 ;
%
%
%
%     glfw=b(I)*0;
%
%     switch char(CtrlVar.MeltParameterisation)
%
%         case 'J2'
%
%             ab(I)=basal_melt(b(I),bGrad(I),glDe,Tw,Sw,tcDe);
%
%         case 'J3'
%
%             [~,~,ab(I)] = UPP_melt(b(I),bGrad(I),glDe,glfw,Tw,Sw,tcDe);
%     end
%
%     ab=-ab; % Jenkins defines pos as melting
%
%
%     % keep within limits
%     [ab,iU,iL] = kk_proj(ab,500,-500);
%
%
%
%

%     figure
%     PlotMeshScalarVariable(CtrlVar,MUA,-ab)
%     hold on
%     [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);
%     caxis([0 80])
%
%
%%






end