

%%
%
% "inverts" for the ice thickness, h, by solving 
%
% $$ d (u h)/dx + d (v h)/dy - \nabla \cdot (\kappa \nabla h) = a$$
%
% for a, u and v given.
%
%
%%



Method="Fh +  <l , hMeas>";   % Here we solve directly for Fh(h)=0 subject to  h=hMeas, 
                            % Thust both the model, Fh, and the measurments, hMeas, are hard constraints


Method="(h-hmeas) P (h-hmeas) / 2 +  <l , Fh>" ;








%% Synthetic data
% load("ForwardResults10km.mat","CtrlVar","F","MUA","UserVar") ;
%load("ForwardResults1km10yr.mat","CtrlVar","F","MUA","UserVar") ;
load("ForwardResults1km100yr.mat","CtrlVar","F","MUA","UserVar") ;


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

%load("C:\Users\Hilmar Gudmundsson\OneDrive - Northumbria University - Production Azure AD\Runs\MISMIPplus\RestartIce0-rCW-N0-Implicit-kH100-nod3.mat","F","MUA","UserVarInRestartFile","BCs")
load(OneDriveFolder+P+filename,"F","MUA","UserVarInRestartFile","BCs")

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
% 
if ~exist("BCs","var")
    BCs=BoundaryConditions ;
end

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
[UserVar,hest,lambda]=hEquation(UserVar,CtrlVar,MUA,F,BCs,kIso,kAlong,kCross,Method,Priors,Meas);




%% Results

FigTitle=sprintf("kIso=%5.1f kAlong=%5.1f kAcross=%5.1f",mean(kIso),mean(kAlong),mean(kCross));



UaPlots(CtrlVar,MUA,F,hest,FigureTitle="hest") ; 
title("h estimated")
axis tight

%nexttile ; 
% 
UaPlots(CtrlVar,MUA,F,htrue,FigureTitle="h true") ; title(FigTitle)
axis tight


%nexttile ;
% h1=histogram(hest-htrue); h1.Normalization="probability";

FindOrCreateFigure("compare")
yyaxis left
plot(htrue,hest,'.')
hold on
plot(xlim,xlim);
ylim(xlim)
ylabel("h estimated")
yyaxis right
plot(htrue,hest-htrue,'.')
ylabel("hest-htrue")

lm=fitlm(hest,htrue);
title(sprintf("R2=%f",lm.Rsquared.Ordinary));
xlabel("h true")  ;

%UaPlots(CtrlVar,MUA,F,"speed") ; % title("")
%axis tight

% nexttile ; 

UaPlots(CtrlVar,MUA,F,hest-htrue,FigureTitle="hest-htrue") ;  title("hest-htrue")

if ~isempty(Priors.h)
    UaPlots(CtrlVar,MUA,F,Priors.h,FigureTitle="hprior") ;  title("h prior")
end

if ~isempty(Meas.h)
    UaPlots(CtrlVar,MUA,F,Meas.h,FigureTitle="hmeas") ;  title("h measurements")
end
































