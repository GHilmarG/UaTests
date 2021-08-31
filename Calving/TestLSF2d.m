
%%
%
%
%  Testing LSF implementation by prescribing velocity, ie not using Ua to calculate those.
%
% Initialize solving the suitable norm of the eikonal equation with BCs
%
% Evolve with FAB without Dirichlet BCs
%
%
% Issues:
%
%   25 June, 2021. The NR with analytical ice-shelf velocities does not appear to get into second-order convergence.
%
%   27 June, 2021: -NR interation now good, found some obvious mistakes and corrected. Also, found that BCs were not fulfilled if the
%                   initial guess for LSF did not (not a feasable point) and no update was made if not convergent in initial step.
%                  -It appears that the LSF has to be reasonably close to the minimum of the P term for it to converge to the
%                   right solution.
%                  -In the initialisation step, set theta=1, otherwise the mean value (f0+f1)/2 is the solution , not f1.
function TestLSF2d



%% Generate mesh and MUA.
UserVar=[];
CtrlVar=Ua2D_DefaultParameters(); %
CtrlVar.DevelopmentTestingQuadRules=true; CtrlVar.DevelopmentVersion=true; 
CtrlVar.LevelSetMethod=true; CtrlVar.LevelSetAssembly="consistent" ;
CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
MeshSize=5e3;
CtrlVar.MeshSizeMax=MeshSize;
CtrlVar.MeshSizeMin=MeshSize;
CtrlVar.MeshSize=MeshSize;

CtrlVar.PlotXYscale=1000;  
CtrlVar.PlotsXaxisLabel='x (km)' ; CtrlVar.PlotsYaxisLabel='y (km)' ; %

MeshBoundaryCoordinates=[-100e3 -100e3 ; 100e3 -100e3 ; 100e3 100e3 ; -100e3  100e3 ] ;
CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
CtrlVar.TriNodes=3 ;  % Possible values are 3, 6, 10 node (linear/quadradic/cubic)
CtrlVar.MUA.DecomposeMassMatrix=true;
[UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
CtrlVar.PlotNodes=1;
FindOrCreateFigure("Mesh"); PlotMuaMesh(CtrlVar,MUA); drawnow
F0=UaFields;
F1=UaFields;
F0.x=MUA.coordinates(:,1) ; F0.y=MUA.coordinates(:,2) ;
F1.x=MUA.coordinates(:,1) ; F1.y=MUA.coordinates(:,2) ;
F1.time=CtrlVar.time ;
F0.time=CtrlVar.time ;

BCs=BoundaryConditions;
RunInfo=UaRunInfo;


RunStepStart=1 ;
ReinitialisationStepsStart=1;
R0=sqrt(F0.x.^2+F0.y.^2);
R1=sqrt(F1.x.^2+F1.y.^2);



%% Parameters
nRunSteps=200; nReinitialisationSteps=10; CtrlVar.dt=0.1;   Rc=50e3;
 CtrlVar.LevelSetTestString="" ; %-xc sign-"  ; % "-xc/yc nodes-" ;
% CtrlVar.LevelSetTestString="-limit c-" ; 
CtrlVar.LevelSetFABmu.Value=1e4 ; CtrlVar.LevelSetFABmu.Scale="constant"; 
CtrlVar.LevelSetFABmu.Value=0.1; CtrlVar.LevelSetFABmu.Scale="ucl"; % 0.1 possible too small,
CtrlVar.LevelSetFABCostFunction="p2q2" ; % "Li2010" ; % "p2q1" ; %"p2q2";
AddedStringToFileName="" ;
CtrlVar.LevelSetInfoLevel=1 ; CtrlVar.doplots=1 ; 
%%

CtrlVar.LSFslope=1;
Threshold=0 ; 
ResultsFile=sprintf("TestLSF2d-%s-%s-muScale%s-muValue%i-dt%3.2f-%i-%i-xc%i-%s-l%i-N%i",...
    AddedStringToFileName,...
    CtrlVar.LevelSetFABCostFunction,CtrlVar.LevelSetFABmu.Scale,CtrlVar.LevelSetFABmu.Value,...
    CtrlVar.dt,nRunSteps,nReinitialisationSteps,Rc,CtrlVar.LevelSetTestString,CtrlVar.MeshSize,CtrlVar.TriNodes);

ResultsFile=replace(ResultsFile,".","k") ;
ResultsFile=replace(ResultsFile,"--","-") ;
CtrlVar.VelocityField="Stable Point" ; % "Linear2D" ; % "Linear" ; % "Analytical" ; % "Constant" ;  % prescribed velocity, see below in nested function"Analytical"



% I find that while mu can not be either too small or too large,
% it can have a wide range of acceptable values 1e6 to 1e9 at least




UserVar.Rc=Rc;
BCs.LSFFixedNode=[]; BCs.LSFFixedValue=[];


% Initial LSF
F0.LSF=1*(Rc-R0);
F1.LSF=1*(Rc-R1);



RcAnalytical=NaN(2*nRunSteps,1) ; tVector=NaN(2*nRunSteps,1) ;
RcNumerical=NaN(2*nRunSteps,1) ;  xcLSFNumerical=NaN(2*nRunSteps,1) ;
iV=1;  RcAnalytical(iV)=Rc ; tVector(iV)=CtrlVar.time;  xcLSFNumerical(iV)=Rc ;

[speedAnalytical,c]=ucAnalytical(R1) ;

theta=atan2(F1.y,F1.x);
F1.ub=speedAnalytical.*cos(theta) ;   F0.ub=F1.ub ;
F1.vb=speedAnalytical.*sin(theta) ;   F0.vb=F1.vb ;
F1.c=c ; F0.c=c;



CtrlVar.LevelSetPhase="Initialisation" ;
CtrlVar.LevelSetSolutionMethod="Newton Raphson";

CtrlVar.LevelSetEpsilon=0;
fprintf('\n \n Initialisation Phase. \n ')



%% Here I'm testing the initialisation/reset procedure.
% Can is correct distorted level-set fields for a given level set? 
% Can it create a signed distance function with slope norm of unity?


F0.LSF=1*(Rc-R0);
F1.LSF=1*(Rc-R1);
F0.LSFqx=zeros(MUA.Nnodes,1) ; F0.LSFqy=zeros(MUA.Nnodes,1) ;
F1.LSFqx=zeros(MUA.Nnodes,1) ; F1.LSFqy=zeros(MUA.Nnodes,1) ;


% defining evenn plataus
% I=F0.LSF> 10e3 ; F0.LSF(I)=10e3; 
% I=F0.LSF< -20e3 ; F0.LSF(I)=-20e3; 

% increasing slope

% I=F0.LSF< -20e3 ; F0.LSF(I)=0.5*(Rc-R0(I));
% I=F0.LSF>  10e3 ; F0.LSF(I)=10e3 ;
% I=F0.LSF< -20e3 & F1.x>10e3 ;  F0.LSF(I)=-10e3 ;
% I=F0.LSF< -10e3 & F1.x>0  & abs(F1.y)<50e3 ;   F0.LSF(I)=-50e3; 


[UserVar,RunInfo,LSF,Mask,lambda,LSFqx,LSFqy]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);

% sqrt((F1.LSF'*MUA.Dxx*F1.LSF+F1.LSF'*MUA.Dyy*F1.LSF)/MUA.Area)
% Some aditional 1D plots




%%



F1.LSF = LSF ; F0.LSF = F1.LSF ; F0.LSFqx=LSFqx ; F0.LSFqy=LSFqy; 

BCs.LSFFixedNode=[]; BCs.LSFFixedValue=[];


for iReInitialisationStep=ReinitialisationStepsStart:nReinitialisationSteps
    
    fprintf('\n \n Propagation Phase. \n ')
    for iRunStep=RunStepStart:nRunSteps
        
        CtrlVar.LevelSetPhase="Propagation and FAB" ;
        fprintf("time=%f \t %s \n",CtrlVar.time,CtrlVar.LevelSetPhase)

        
        F0=F1 ;  F0.time=CtrlVar.time ; 
        [UserVar,RunInfo,F1.LSF,Mask,lambda,F1.LSFqx,F1.LSFqy]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,lambda);
              
        CtrlVar.time=CtrlVar.time+CtrlVar.dt ;
        F1.time=CtrlVar.time ;
        
        % This only works if we have 1d radial symmetrical velocity field
        [speedAnalytical,c]=ucAnalytical(RcAnalytical(iV)) ;
        
      
        
        RcAnalytical(iV+1)=(speedAnalytical-c)*CtrlVar.dt+RcAnalytical(iV) ;
        
        CtrlVar.LineUpGLs=false ; [xC,yC]=CalcMuaFieldsContourLine(CtrlVar,MUA,F1.LSF,Threshold);  Rc=sqrt(xC.^2+yC.^2) ;
        
        tVector(iV+1)=CtrlVar.time ;
        RcNumerical(iV+1)=mean(Rc) ;
        
        
        iV=iV+1;
        
        
    end
    
    
    fprintf('\n \n Re-initialisation Phase. \n ')
    CtrlVar.LevelSetPhase="Initialisation" ;
    fprintf("time=%f \t %s \n",CtrlVar.time,CtrlVar.LevelSetPhase)
    [UserVar,RunInfo,LSF,Mask,l,LSFqx,LSFqy]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);
    
    
    F0.LSF=LSF ; F1.LSF=LSF ;  % after a re-initialisation
    F0.LSFqx=LSFqx ; F0.LSFqy=LSFqy; 
    
    % save a restart once in a while
    if mod(iReInitialisationStep,20)==0
        MUA.dM=[];
        save(ResultsFile,"tVector","RcAnalytical","xcLSFNumerical","RcNumerical","MUA","F0","F1","CtrlVar","UserVar","RunInfo")
        close all
        save("RestartFile-"+ResultsFile)
    end
end

%% Plot comparision
fig=FindOrCreateFigure("xc comparision") ;
hold off
yyaxis left
plot(tVector,RcAnalytical/1000,'k',LineWidth=2) ;
hold on ;
plot(tVector,RcNumerical/1000,'ob')
xlabel("$t \; \mathrm{(yr)}$","Interpreter","latex")
ylabel("$x_c\;\mathrm{(km)}$","Interpreter","latex")

yyaxis right
plot(tVector,(RcAnalytical-RcNumerical)/1000,'.r')
ylabel("$\Delta x_c$ (Analytical-Numerical) $\;\mathrm{(km)}$","Interpreter","latex")

%legend("$x_c$ analytical","$x_c$ numerical","Nearest node to $x_c$","$\Delta x_c$ (Analytical-Numerical)",...
%    "interpreter","latex","location","northwest")
%%

legend("$x_c$ analytical","$x_c$ numerical","$\Delta x_c$ (Analytical-Numerical)",...
    "interpreter","latex","location","northeast")
title(sprintf("std %f (km)",std((RcAnalytical-RcNumerical)/1000,'omitnan')))

fprintf('Saving results in %s \n',ResultsFile)

% exportgraphics(gca,ResultsFile+"-t"+num2str(round(CtrlVar.time))+".pdf") ;


I=RunInfo.LevelSet.Phase=="Propagation and FAB";
FindOrCreateFigure("Propagation and FAB")
plot(RunInfo.LevelSet.time(I),RunInfo.LevelSet.Iterations(I),'ro')
title("Propagation and FAB")
xlabel("time")
ylabel("#NR iterations")

I=RunInfo.LevelSet.Phase=="Initialisation";
FindOrCreateFigure("Initialisation")
plot(RunInfo.LevelSet.time(I),RunInfo.LevelSet.Iterations(I),'b*')
title("Initialisation")
xlabel("time")
ylabel("#NR iterations")

MUA.dM=[] ; 
save(ResultsFile,"tVector","RcAnalytical","RcNumerical","MUA","F0","F1","CtrlVar","UserVar","RunInfo")
%% nested functions

function [speed,c]=ucAnalytical(r)
% This is a nested function

switch CtrlVar.VelocityField
    
    case "Analytical"
        
        [s,b,speed]=AnalyticalOneDimentionalIceShelf([],r) ;
        
        % c=-5*u+zeros(size(x),'like',x);
        
        h=s-b;
        q=-2;
        % k=86322275.9814533 ;
        k=86320694.4400036;
        c=k*h.^q;
        
    case "Linear"
        
        ugl=0;
        cgl=0;
        dudx=1000/600e3;
        dcdx=2*dudx;
        
        speed=ugl+dudx*x;
        c=cgl+dcdx*x;
        
        
    case "Linear2D"
        
        u0=0;
        dudr=1000/100e3;
        speed=u0+dudr*r;
        c=2*speed;
                  
    case "Stable Point"
        
        xcS=40e3 ;
        speed=100 ;
        c=speed + (r-xcS)/100;
        
    case "Constant"
        
        
        speed=1000+zeros(size(r),'like',r);
        c=speed ;
        
        
    case "Constant2D"
        
      
        speed=1000+zeros(size(r),'like',r);
        c=speed ;
        
    otherwise
        
        error("adfa")
        
end

end

end