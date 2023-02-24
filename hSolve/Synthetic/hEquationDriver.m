

BCs=BoundaryConditions ;

%% Synthetic data
% load("ForwardResults10km.mat","CtrlVar","F","MUA","UserVar") ;  
%load("ForwardResults1km10yr.mat","CtrlVar","F","MUA","UserVar") ;  
load("ForwardResults1km100yr.mat","CtrlVar","F","MUA","UserVar") ;  


load("C:\Users\Hilmar Gudmundsson\OneDrive - Northumbria University - Production Azure AD\Runs\MISMIPplus\RestartIce0-rCW-N0-Implicit-kH100-nod3.mat","F","MUA","UserVarInRestartFile","BCs")

if isempty(F.x)  % if the result file is old...
    F.x=MUA.coordinates(:,1);
    F.y=MUA.coordinates(:,2);
end

htrue=F.h ;


%% Define BCs for h-problem

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

isError=true;

if isError  % add some error the surface mass balance

F.as=F.as+0.01*0.3*rand(numel(F.x),1);  % 1% error 

end


% constrain h over all floating areas



%%

% Using cross diffusion is very effective as "smoothing" the solution and results insensitive to the exact diffusion coefficient value 

 CtrlVar.SUPG.beta0=0;

kIso=F.x*0+0*1e2; 
kAlong=F.x*0+0.01*1e4; 
kCross=F.x*0+0.1*1e4; 

F.as=F.as-F.dhdt; 
[UserVar,hest,lambda]=hEquation(UserVar,CtrlVar,MUA,F,BCs,kIso,kAlong,kCross);




%% Results

FigTitle=sprintf("h est: kIso=%5.1f kAlong=%5.1f kAcross=%5.1f",mean(kIso),mean(kAlong),mean(kCross)); 

FindOrCreateFigure(FigTitle);
Tile=tiledlayout(2,2) ;

nexttile
UaPlots(CtrlVar,MUA,F,hest) ; title("h estimated")
axis tight

nexttile ; UaPlots(CtrlVar,MUA,F,htrue) ; title("h true")
axis tight


nexttile ; 
% h1=histogram(hest-htrue); h1.Normalization="probability";
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

nexttile ; UaPlots(CtrlVar,MUA,F,hest-htrue) ;  title("hest-htrue")
Tile.Padding="compact";
Tile.TileSpacing="compact";







