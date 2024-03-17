



function [UserVar,CtrlVar,MUA,F,BCs,Priors,Meas,htrue]=DefineDataForThicknessInversion(UserVar,CtrlVar)



fprintf("Defining synthetic data based on the MismipPlus geometry, using previous run results...")



[~,hostname]=system('hostname') ;
if contains(hostname,"DESKTOP-G5TCRTD")

elseif contains(hostname,"DESKTOP-014ILS5")

    OneDriveFolder="C:\Users\lapnjc6\OneDrive - Northumbria University - Production Azure AD\";

elseif contains(hostname,"DESKTOP-BU2IHIR")

    OneDriveFolder="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\";

elseif contains(hostname,"C23000099")

    OneDriveFolder="C:\Users\pcnj6\OneDrive - Northumbria University - Production Azure AD\";

end


P="Runs\MISMIPplus\";
filename="RestartIce0-rCW-N0-Implicit-kH100-nod3.mat";


load(OneDriveFolder+P+filename,"F","MUA")

[MUA.Dxx,MUA.Dyy]=StiffnessMatrix2D1dof(MUA);

if isempty(F.x)  % if the result file is old...
    F.x=MUA.coordinates(:,1);
    F.y=MUA.coordinates(:,2);
end

htrue=F.h ; 


Priors=PriorProbabilityDistribution ;
Priors.h=F.h*0 ;


%% Define "soft" boundary conditions for the ice thickness h.
% These need to be defined over all of the nodes, both values and errors.
% The errors are uncorrelated and defined

Meas=Measurements;
Meas.h=F.h ;        % OK, here I am simply giving the nodal values as measurements, 
Meas.hCov=1e10+zeros(MUA.Nnodes,1);  % generally very high errors

I= F.x<10e3 ; Meas.hCov(I)=1e-5;        % but small errors around inflow boundary



%% Define BCs for h-problem
% only needed if measurements introduced as hard contraints
% i.e. only if using  <l , hMeas>

BCs=BoundaryConditions();

% add min thickness constraints
I=find(F.h<=CtrlVar.ThickMin); BCs.hFixedNode=I ;
BCs.hFixedValue=BCs.hFixedNode*0+CtrlVar.ThickMin;

BCs.hFixedNode=[BCs.hFixedNode ; MUA.Boundary.Nodes] ;
BCs.hFixedValue=[BCs.hFixedValue; F.h(MUA.Boundary.Nodes)] ;

% constrain all floating areas
I=find(F.GF.node<0.5) ;
BCs.hFixedNode=[BCs.hFixedNode ; I] ;
BCs.hFixedValue=[BCs.hFixedValue; F.h(I)] ;


isMeas=true;

if isMeas
    % add some "measurements"
    I=find(F.x <305e3 & F.x>295e3);   BCs.hFixedNode=[BCs.hFixedNode ; I] ;    BCs.hFixedValue=[BCs.hFixedValue; F.h(I)] ;
    I=find(F.x <105e3 & F.x>95e3);   BCs.hFixedNode=[BCs.hFixedNode ; I] ;    BCs.hFixedValue=[BCs.hFixedValue; F.h(I)] ;
end



%% add error to surface mass balance


F.as=F.as+UserVar.SurfaceMassBalanceErrorAmplitude*randn(MUA.Nnodes,1);
F.ub=F.ub+UserVar.VelocityErrorAmplitude*randn(MUA.Nnodes,1);
F.vb=F.vb+UserVar.VelocityErrorAmplitude*randn(MUA.Nnodes,1);



F.as=F.as-F.dhdt;



fprintf("done. \n")


%% Smooth data?

if  ~isnan(UserVar.VelocitySmoothingScale)  && UserVar.VelocitySmoothingScale>0

    fprintf("smoothing velocity field with the length scale %g \n",UserVar.VelocitySmoothingScale)
    L=UserVar.VelocitySmoothingScale ;  % Smoothing length scale
    [UserVar,F.ub]=HelmholtzEquation([],CtrlVar,MUA,1,L^2,F.ub,0);
    [UserVar,F.vb]=HelmholtzEquation([],CtrlVar,MUA,1,L^2,F.vb,0);

end
















end