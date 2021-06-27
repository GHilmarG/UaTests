
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
%                   initial guess for LSF did not (not a feasable point) and no update was made if not convergent.
%                  -It appears that the LSF has to be reasonably close to the minimum of the P term for it to converge to the 
%                   right solution.                
%                  -In the initialisation step, set theta=1, otherwise the mean value (f0+f1)/2 is the solution , not f1.
function TestLSF

clearvars
clear FindOrCreateFigure

load("LSFtest","BCs","CtrlVar","F0","F1","MUA","UserVar","RunInfo")

F0.x=MUA.coordinates(:,1) ; F0.y=MUA.coordinates(:,2) ; 
F1.x=MUA.coordinates(:,1) ; F1.y=MUA.coordinates(:,2) ; 
CtrlVar.LSFslope=1; 
nRunSteps=50; nReinitialisationSteps=5 ; CtrlVar.dt=1;
CtrlVar.VelocityField="Linear" ; % "Analytical" ; % "Constant" ;  % prescribed velocity, see below in nested function"Analytical"
CtrlVar.LevelSetFABmu=1e6 ;

CtrlVar.LSFMinimisationQuantity="Work Residuals";
CtrlVar.LevelSetSolverMaxIterations=100;
CtrlVar.LSFDesiredWorkAndForceTolerances=[1e-10 1];  % just use the work tolerance
CtrlVar.LSFDesiredWorkOrForceTolerances=[1e-12 1];
CtrlVar.LSFExitBackTrackingStepLength=1e-4;
CtrlVar.LSFAcceptableWorkAndForceTolerances=[inf 1e-2];
CtrlVar.LSFAcceptableWorkOrForceTolerances=[100 1e-2];

% I find that while mu can not be either too small or too large,
% it can have a wide range of acceptable values 1e6 to 1e9 at least


CtrlVar.LevelSetInfoLevel=100;
CtrlVar.LevelSetEpsilon=0;

xc=600e3;  % this is the initial calving front
UserVar.xc=xc;
BCs.LSFFixedNode=[]; BCs.LSFFixedValue=[];
BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs) ;

% Initial LSF
F0.LSF=1*(xc-MUA.coordinates(:,1)) ;
F1.LSF=1*(xc-MUA.coordinates(:,1)) ;

% for I=1:21
% P(I)=CalcLevelSetPertubationFunctional(CtrlVar,MUA,0.1*(I-1)*(xc-MUA.coordinates(:,1)));
% end


xcAnalytical=NaN(2*nRunSteps,1) ; tVector=NaN(2*nRunSteps,1) ;
xcNumerical=NaN(2*nRunSteps,1) ;  xcLSFNumerical=NaN(2*nRunSteps,1) ;
iV=1;  xcAnalytical(iV)=xc ; tVector(iV)=CtrlVar.time;

[u,c]=ucAnalytical(F1.x) ; % this is a nested function, so it sees all local variables


F1.ub=u+zeros(MUA.Nnodes,1) ;   F0.ub=F1.ub ;  F1.vb=F1.ub*0  ;   F0.vb=F0.ub*0 ;
F1.c=c ; F0.c=c;



CtrlVar.LevelSetPhase="Initialisation" ; 
CtrlVar.LevelSetSolutionMethod="Newton Raphson";
CtrlVar.LevelSetFABCostFunction="p2q1";
CtrlVar.LevelSetEpsilon=0;
fprintf('\n \n Initialisation Phase. \n ')


% Testing initialisation
% BCs.LSFFixedNode=[] ; BCs.LSFFixedValue=[] ;

F0.LSF=0.9*(xc-F0.x) ;
F1.LSF=0.9*(xc-F1.x) ;


CtrlVar.LevelSetFABmu=1 ;

[UserVar,RunInfo,LSF,Mask,lambda]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);


% Perturbation term: J=1/(pq) int ( norm(nabla phi)^q-1)^p d|

FindOrCreateFigure("Re-initialisation step")
hold off
yyaxis left
F.x=MUA.coordinates(:,1) ;
plot(F.x/1000,F1.LSF/1000,'.g')
hold on
plot(F.x/1000,LSF/1000,'.b')
yyaxis right
plot(F.x/1000,(F1.LSF-LSF)/1000,'or')
legend('Before','after','change')

[Pbefore,Nbefore]=CalcLevelSetPertubationFunctional(CtrlVar,MUA,F1.LSF) ;
[Pafter,Nafter]=CalcLevelSetPertubationFunctional(CtrlVar,MUA,LSF);

FindOrCreateFigure("LSF slope") ;
hold off;
plot(F.x/1000,Nbefore,'.r') ; hold on  ; plot(F.x/1000,Nafter,'.b')
legend("before","after")
%%
F1.LSF = LSF ; F0.LSF = F1.LSF ;
TestLevelSetPlots(CtrlVar,UserVar,MUA,F1);




BCs.LSFFixedNode=[]; BCs.LSFFixedValue=[];

for iReInitialisationStep=1:nReinitialisationSteps
    
    fprintf('\n \n Propagation Phase. \n ')
    for iRunStep=1:nRunSteps
        
        CtrlVar.LevelSetPhase="Propagation and FAB" ;
        fprintf("time=%f \t %s \n",CtrlVar.time,CtrlVar.LevelSetPhase)
        
        F0=F1 ;
        [UserVar,RunInfo,F1.LSF,Mask,lambda]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);
        
        TestLevelSetPlots(CtrlVar,UserVar,MUA,F1);
        
        CtrlVar.time=CtrlVar.time+CtrlVar.dt ;
        F1.time=CtrlVar.time ;
        
        
        [u,c]=ucAnalytical(xcAnalytical(iV)) ;
        xcAnalytical(iV+1)=(u+c)*CtrlVar.dt+xcAnalytical(iV) ;
        tVector(iV+1)=CtrlVar.time ;
        [Value,Index]=min(abs(F1.LSF)) ; xcNumerical(iV+1)=F1.x(Index) ;
        
        CtrlVar.PlotGLs=0 ;
        [xC,yC]=PlotCalvingFronts(CtrlVar,MUA,F1,'r') ;
        CtrlVar.PlotGLs=1 ;
        xcLSFNumerical(iV+1)=mean(xC) ;
        
        iV=iV+1;
        
        
    end
    
    fprintf('\n \n Re-initialisation Phase. \n ')
        CtrlVar.LevelSetPhase="Initialisation" ;
    fprintf("time=%f \t %s \n",CtrlVar.time,CtrlVar.LevelSetPhase)
    
    [UserVar,RunInfo,LSF,Mask]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCsReinitialisation,F0,F1);
    
    FindOrCreateFigure("Re-initialisation step")
    hold off
    yyaxis left
    F.x=MUA.coordinates(:,1) ; 
    plot(F.x/1000,F1.LSF/1000,'.g')
    hold on
    plot(F.x/1000,LSF/1000,'.b')
    yyaxis right
    plot(F.x/1000,(F1.LSF-LSF)/1000,'or')
    legend('Before','after','change')
    
    F0.LSF=LSF ; F1.LSF=LSF ;  % after a re-initialisation
    TestLevelSetPlots(CtrlVar,UserVar,MUA,F0);
    LevelSetInfoLevelPlots(CtrlVar,MUA,BCs,F0,F1);
end

% Plot comparision
fig=FindOrCreateFigure("xc comparision") ;
plot(tVector,xcAnalytical/1000) ;
hold on ;
plot(tVector,xcLSFNumerical/1000,'*m')
plot(tVector,xcNumerical/1000,'or')
xlabel("$t \; \mathrm{(yr)}$","Interpreter","latex")
ylabel("$x_c\;\mathrm{(km)}$","Interpreter","latex")
legend("$\varphi$ analytical","$\varphi$ numerical","Nearest node to $x_c$",...
    "interpreter","latex","location","northwest")


%% nested functions

    function [u,c]=ucAnalytical(x)
        % This is a nested function
        
        switch CtrlVar.VelocityField
            
            case "Analytical"
                
                [s,b,u]=AnalyticalOneDimentionalIceShelf([],x) ;
                
                % c=-5*u+zeros(size(x),'like',x);
                
                h=s-b;
                q=-2;
                % k=86322275.9814533 ;
                k=86320694.4400036;
                c=-k*h.^q;
                
            case "Linear"
                 
                ugl=0;
                cgl=0;
                dudx=1000/600e3;
                dcdx=-2*dudx;
                
                u=ugl+dudx*x;
                c=cgl+dcdx*x;
                
                
                
            case "Constant"
                
                
                u=1000+zeros(size(x),'like',x);
                c=-1*u ;
                
                
            otherwise
                
                error("adfa")
                
        end
        
    end

end