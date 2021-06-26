
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
%
function TestLSF

clearvars
clear FindOrCreateFigure

load("LSFtest","BCs","CtrlVar","F0","F1","MUA","UserVar","RunInfo")

nRunSteps=50; nReinitialisationSteps=5 ; CtrlVar.dt=1;
CtrlVar.VelocityField="Linear" ; % "Analytical" ; % "Constant" ;  % prescribed velocity, see below in nested function"Analytical"
CtrlVar.LevelSetFABmu=1e6 ;

% I find that while mu can not be either too small or too large,
% it can have a wide range of acceptable values 1e6 to 1e9 at least


CtrlVar.LevelSetInfoLevel=1;
CtrlVar.LevelSetEpsilon=0;

xc=600e3;  % this is the initial calving front
UserVar.xc=xc;
BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs) ;

% Initial LSF
F0.LSF=1*(xc-MUA.coordinates(:,1)) ;
F1.LSF=1*(xc-MUA.coordinates(:,1)) ;



xcAnalytical=NaN(2*nRunSteps,1) ; tVector=NaN(2*nRunSteps,1) ;
xcNumerical=NaN(2*nRunSteps,1) ;  xcLSFNumerical=NaN(2*nRunSteps,1) ;
iV=1;  xcAnalytical(iV)=xc ; tVector(iV)=CtrlVar.time;

[u,c]=ucAnalytical(F1.x) ; % this is a nested function, so it sees all local variables


F1.ub=u+zeros(MUA.Nnodes,1) ;   F0.ub=F1.ub ;  F1.vb=F1.ub*0  ;   F0.vb=F0.ub*0 ;
F1.c=c ; F0.c=c;



CtrlVar.LevelSetPhase="Initialisation" ;
CtrlVar.LevelSetSolutionMethod="Newton Raphson";
CtrlVar.LevelSetFABCostFunction="p2q1";

CtrlVar.LevelSetTheta=0.5;
fprintf('\n \n Initialisation Phase. \n ')
CtrlVar.LevelSetInfoLevel=10 ; CtrlVar.doplots=1  ;

% Testing initialisation 
% BCs.LSFFixedNode=[] ; BCs.LSFFixedValue=[] ;
x=MUA.coordinates(:,1) ; 
F0.LSF=100*sin(x/100e3) ; 
F1.LSF=F0.LSF ; 
F0.LSF(BCs.LSFFixedNode)=BCs.LSFFixedValue;
CtrlVar.LevelSetFABmu=1 ;
CtrlVar.dt=1e-5;
[UserVar,RunInfo,LSF,Mask,lambda]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);


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


%%
F1.LSF = LSF ;
TestLevelSetPlots(CtrlVar,UserVar,MUA,F1);


F0.LSF = F1.LSF ;



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
    Mask=CalcMeshMask(CtrlVar,MUA,F1.LSF,0);
    BCsReinitialisation=BCs;  % Here I'm exploring the option of defining bespoke BCs for the reinitialisation step.
    BCsReinitialisation.LSFFixedNode=find(Mask.NodesOn);  % fix the LSF field for all nodes of elements around the level.
    BCsReinitialisation.LSFFixedValue=F1.LSF(Mask.NodesOn);
    FindOrCreateFigure("LSF BCs Initialisation")
    PlotBoundaryConditions(CtrlVar,MUA,BCsReinitialisation) ;
    hold on ; [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F1,'b','LineWidth',2) ;
      
    CtrlVar.LevelSetPhase="Initialisation" ;
    fprintf("time=%f \t %s \n",CtrlVar.time,CtrlVar.LevelSetPhase)
    CtrlVar.LevelSetInfoLevel=10 ; CtrlVar.doplots=1  ;
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
    
    F0.LSF=LSF ; F1.LSF=LSF ;
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