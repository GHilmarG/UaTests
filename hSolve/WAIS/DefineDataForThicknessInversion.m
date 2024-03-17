



function [UserVar,CtrlVar,MUA,F,BCs,Priors,Meas,htrue]=DefineDataForThicknessInversion(UserVar,CtrlVar)

narginchk(2,2)
nargoutchk(8,8)

%%

fprintf("Defining data for thickness inversion")


Method="(h-hmeas) P (h-hmeas) / 2 + (h-hprior) Q (h-hprior) / 2 +  (K h - b) M (K h - b) / 2" ; 

UserVar=[];

F=UaFields;


Meas=Measurements ;

[UserVar,MUA]=CreateMeshAndMua(UserVar,CtrlVar) ; 


[MUA.Dxx,MUA.Dyy]=StiffnessMatrix2D1dof(MUA);

if isempty(F.x)  % if the result file is old...
    F.x=MUA.coordinates(:,1);
    F.y=MUA.coordinates(:,2);
end

htrue=nan;


%% Define Priors

Priors=PriorProbabilityDistribution;
Priors.h=zeros(MUA.Nnodes,1); 


%% Get ice thickness measurements
% I load this from a compilation of radar measurements that I've created as a part of DynaMap
%
%
DataFile="GriddedIceThicknessInterpolant-ds10000-N5" ;
Folder="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Work\DynaMap\";

load(Folder+DataFile,"Fh","FhErrors")


Meas.h=Fh(F.x,F.y);
MeasErrors=FhErrors(F.x,F.y) ;
Meas.hCov=MeasErrors.^2 ;


%% Get surface accumulation
load("Fas_SMB_RACMO2k3_1979_2011.mat","Fas")
F.as=Fas(F.x,F.y) ;


%% Get surface elevation changes
load("FdhdtMeasuredRatesOfElevationChanges2000to2018.mat","Fdh2000to2018")
F.dsdt=Fdh2000to2018(F.x,F.y) ;  % I can do this here because in this run the mesh does not change


%% Get surface velocities


fprintf("Loading interpolants for surface velocity data")
load("SurfVelMeasures990mInterpolants.mat","FuMeas","FvMeas","FerrMeas")
fprintf(' done.\n')

F.ub=FuMeas(F.x,F.y) ;
F.vb=FvMeas(F.x,F.y) ;

% These interpolants have nan where there are no velocity data
I=isnan(F.ub) | isnan(F.vb);
F.ub(I)=0 ; F.vb(I)=0 ; 


%% Define BCs for h-problem
% only needed if measurements introduced as hard contraints
% i.e. only if using  <l , hMeas>

BCs=BoundaryConditions ;




fprintf("done. \n")






















end