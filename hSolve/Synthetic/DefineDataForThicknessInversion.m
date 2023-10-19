



function [UserVar,CtrlVar,MUA,F,BCs,Priors,Meas,htrue,kIso,kAlong,kCross,Method]=DefineDataForThicknessInversion(CtrlVar)



fprintf("Defining synthetic data based on the MismipPlus geometry, using previous run results...")


Method="(h-hmeas) P (h-hmeas) / 2 + (h-hprior) Q (h-hprior) / 2 +  (K h - b) M (K h - b) / 2" ; 

UserVar=[];


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
Meas.h=zeros(MUA.Nnodes,1);
Meas.hCov=1e10+zeros(MUA.Nnodes,1);  % very high errors



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
isError=true;

if isError  % add some error the surface mass balance

    F.as=F.as+0.01*0.3*rand(numel(F.x),1);  % 1% error

end


% constrain h over all floating areas

%% Define parameters entering the precision matrices

CtrlVar.hEq.gha=0;
CtrlVar.hEq.ghs=0;
CtrlVar.hEq.gFa=1;


%%

% Using cross diffusion is very effective as "smoothing" the solution and results insensitive to the exact diffusion coefficient value

CtrlVar.SUPG.beta0=0;

kIso=F.x*0+0*1e2;
kAlong=F.x*0+0.01*1e4;
kCross=F.x*0+0.1*1e4;

F.as=F.as-F.dhdt;



fprintf("done. \n")

end