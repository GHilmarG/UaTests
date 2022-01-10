function [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)

persistent Fdh2000to2018 dhdtMeasured CurrentRunStepNumber

as=zeros(MUA.Nnodes,1) ;
ab=zeros(MUA.Nnodes,1) ;
dasdh=zeros(MUA.Nnodes,1) ;
dabdh=zeros(MUA.Nnodes,1) ;


%% Surface mass balance

if isempty(Fdh2000to2018)
    load("FdhdtMeasuredRatesOfElevationChanges2000to2018.mat","Fdh2000to2018")
    dhdtMeasured=Fdh2000to2018(F.x,F.y) ;  % I can do this here because in this run the mesh does not change
    CurrentRunStepNumber=0 ; 
end

if contains(UserVar.RunType,"-I-")

    if isempty(F.dhdt)
        as=zeros(MUA.Nnodes,1) ;
    else

        if F.time < 0  ...  % only for neg times
            && CtrlVar.CurrentRunStepNumber>1 ... % only once a uvh solve has been done
            && CurrentRunStepNumber~=CtrlVar.CurrentRunStepNumber % not if already applied to the current run step

            da=dhdtMeasured-F.dhdt ;
            fprintf("DefineMassBalance: norm(dhdtMeasured-F.dhdt)=%f \n ",norm(da))
            CurrentRunStepNumber=CtrlVar.CurrentRunStepNumber ;
        else
            da=0;
        end

        as=F.as+da ;

        
    end
    return

end








%
% When calculating dabdh from ab(b) for floating ice shelves:
% b=S-rho h /rhow
% h=rhow (S-b)/rho
% ab(b)=ab(S-rho h/rhow)
% dab/dh= -(rho/rhow) dab/db
% or:
% dab/dh = dab/db  db/dh = dab/db (-rho/rhow)= -(rho/rhow) dab/db

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


% Most of the melt-rate parameterisations below are based on that old Favier 2014 paper:
% Favier, L., Durand, G., Cornford, S. L., Gudmundsson, G. H., Gagliardini, O., 
% Gillet-Chaulet, F., Zwinger, T., Payne, A. J., & Le Brocq, a. M. (2014). 
% Retreat of Pine Island Glacier controlled by marine ice-sheet instability. 
% Nature Climate Change, 4(2), 117–121. https://doi.org/10.1038/nclimate2094

% Adds further fields to GF, listing elements and nodes upstream,
% downstream, and over grounding lines.
%
F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);

switch UserVar.BasalMeltRate
    
    case 'MeltRate0'
        % if time <10 or Meltrate0, use meltrate0
        
        
        fprintf(CtrlVar.fidlog,' MeltRate0 \n ');
        
        dabdh=zeros(MUA.Nnodes,1);
        
        I=F.b<-800 ; ab(I)=-100; dabdh(I)=0;
        I= F.b< -400 & F.b >= -800; ab(I)=100*(F.b(I)+400)/400; dabdh(I)=(-F.rho(I)/F.rhow)/4;
        I=F.b>-400 ; ab(I)=0; dabdh(I)=0;
        
    case 'MeltRate1'
        
        fprintf(CtrlVar.fidlog,' MeltRate1 \n ');
        
        dabdh=zeros(MUA.Nnodes,1);
        
        I=F.b<-800 ; ab(I)=-200; dabdh(I)=0;
        I= F.b< -400 & F.b>= -800; ab(I)=200*(b(I)+400)/400; dabdh(I)=(-rho(I)/rhow)/2;
        I=b>-400 ; ab(I)=0; dabdh(I)=0;
        %I=MUA.coordinates(:,2)>-264e3;
        %ab(I)=0; dabdh(I)=0;
        
    case 'MeltRate2'
        
        fprintf(CtrlVar.fidlog,' MeltRate2 \n ');
        
        dabdh=zeros(MUA.Nnodes,1);
        
        I= F.b<-800 ; ab(I)=-100;  dabdh(I)=0;
        I= F.b< -200 & F.b>= -800; ab(I)=100*(F.b(I)+200)/600; dabdh(I)=(-rho(I)/rhow)/6;
        I=b>-200 ; ab(I)=0; dabdh(I)=0;
        
    case 'MeltRate3'
        
        fprintf(CtrlVar.fidlog,' MeltRate3 \n ');
        
        dabdh=zeros(MUA.Nnodes,1);
        
        I=F.b<-800 ; ab(I)=-200; dabdh(I)=0;
        I= F.b< -200 & F.b>= -800;  ab(I)=200*(F.b(I)+200)/600;  dabdh(I)=(-rho(I)/rhow)/3;
        I=b>-200 ; ab(I)=0; dabdh(I)=0;
        
    case 'MeltRate5'
        
        fprintf(CtrlVar.fidlog,' MeltRate5 \n ');
        
        ab(F.b<-800)=-200;
        I= F.b< -200 & F.b>= -800; ab(I)=200*(F.b(I)+200)/600;
        ab(b>-200)=0;
        
        I=MUA.coordinates(:,2)>-264e3;
        ab(I)=0;
        
    case 'MeltRate6'
        
        fprintf(CtrlVar.fidlog,' MeltRate6 \n ');
        
        ab(F.b<-800)=-200;
        I= F.b< -200 & F.b>= -800; ab(I)=200*(F.b(I)+200)/600;
        ab(b>-200)=0;
        
        I=MUA.coordinates(:,2)>-200e3;
        ab(I)=0;
        
    case 'Jan De Rydt'
        
        fprintf(CtrlVar.fidlog,' Jan melt rate distribution \n ');
        
        ab(F.b<-1000)=-50 ;
        I=F.b> -1000 & F.b < -455 ; ab(I)=9e-4*F.b(I).^2+1.4*F.b(I)+450 ;
        ab(b>-455)=0;
        
end

ab(~F.GF.NodesDownstreamOfGroundingLines)=0;
dabdh(~F.GF.NodesDownstreamOfGroundingLines)=0;





end