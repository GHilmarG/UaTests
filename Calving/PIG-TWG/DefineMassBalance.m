function [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)

persistent Fdh2000to2018 dhdtMeasured CurrentRunStepNumber Fas FOceanNodes0

as=zeros(MUA.Nnodes,1) ;
ab=zeros(MUA.Nnodes,1) ;
dasdh=zeros(MUA.Nnodes,1) ;
dabdh=zeros(MUA.Nnodes,1) ;


%% Surface mass balance

if isempty(Fdh2000to2018)

    FdhdtDataFile="FdhdtMeasuredRatesOfElevationChanges2000to2018.mat";
    fprintf("Loading data on rate of thickness changes: %s \n",FdhdtDataFile)
    load(FdhdtDataFile,"Fdh2000to2018")
    dhdtMeasured=Fdh2000to2018(F.x,F.y) ;  % I can do this here because in this run the mesh does not change
    CurrentRunStepNumber=0 ;
end


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
        [ab,qx,qy,dqxdx,dqxdy,dqydx,dqydy]=CalcIceShelfMeltRates(CtrlVar,MUA,F.ub,F.vb,F.s,F.b,F.S,F.B,F.rho,F.rhow,dsdt,F.as,dhdt) ;

        ab(F.LSF<0.5)=0 ;
        ab(ab>0)=0;
    end
end

% if ~isfield(UserVar,"IceSheetIceShelves") || UserVar.IceSheetIceShelves
%     % only apply basal melt strictly below/outside of grounding lines
%     F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
%     ab(~F.GF.NodesDownstreamOfGroundingLines)=0;
%     dabdh(~F.GF.NodesDownstreamOfGroundingLines)=0;
%     % figure ; plot(F.b(F.GF.NodesDownstreamOfGroundingLines),F.ab(F.GF.NodesDownstreamOfGroundingLines),'.')
% end



%% During the "transient initialisation" phase, optionally, apply melt using the initial GF mask at t=0;

if contains(UserVar.RunType,"-abMask0-")  && F.time <= UserVar.Assimilation.tEnd  % the initialisation period is up to t=5

    FileNameOceanNodes0="OceanNodes0"+extractBetween(UserVar.RunType,"-"+digitsPattern,"km-",Boundaries="inclusive")+".mat";

    if F.time==0

        [LakeNodes0,OceanNodes0] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Strickt") ;

        % The OceanNodes0 mask is only dependent on the mesh and the initial GF at t=0.
        FOceanNodes0=scatteredInterpolant(F.x,F.y,double(OceanNodes0));
        save(FileNameOceanNodes0,"OceanNodes0","FOceanNodes0")

    end

    if isempty(FOceanNodes0)

        % this in principle should hardly happen, but since the transient initialisation involves several forward runs, it is
        % possible that the current forward run did not start at t=0. But even so, if the matlab session has not been interupted and
        % the m-file not changed, the OceanNodes0 created at t=0 in a previous run, should still be available.
      
        load(FileNameOceanNodes0,"FOceanNodes0")

    end

    OceanNodes0Double=FOceanNodes0(F.x,F.y) ; % this is a double
    OceanNodes0=OceanNodes0Double>0.5 ;       % presumably not needed, but interpolation might create values between 0 and 1
    [LakeNodes,OceanNodesCurrent] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Strickt") ;
    OceanNodes=OceanNodesCurrent | OceanNodes0 ; % here "OceanNodes" are nodes that either
                                                  %  1) currently are ocean nodes based on the current GF mask 2) or were ocean nodes at the start of the run.
                                                  % So melt will be applied over any ocean nodes, and also over all ocean nodes at the start of the run, even if they have by
                                                  % now become grounded.


else

    [LakeNodes,OceanNodes] = LakeOrOcean3(CtrlVar,MUA,F.GF,[],"Strickt") ;

end



% only apply basal melt strictly below/outside of grounding lines over nodes connected to the ocean

ab(~OceanNodes)=0;
dabdh(~OceanNodes)=0;



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