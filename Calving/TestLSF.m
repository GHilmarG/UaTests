
%%
%
% Initialize solving the suitable norm of the eikonal equation with BCs
%
% Evolve with FAB without Dirichlet BCs
%
%

function TestLSF

clearvars
close all
clear FindOrCreateFigure

load("LSFtest","BCs","CtrlVar","F0","F1","MUA","UserVar","RunInfo")

nRunSteps=5; nReinitialisationSteps=20 ; CtrlVar.dt=1;

CtrlVar.LevelSetFABmu=1e6 ; 

% I find that while mu can not be either too small or too large, 
% it can have a wide range of acceptable values 1e6 to 1e9 at least


CtrlVar.LevelSetInfoLevel=1;
CtrlVar.LevelSetEpsilon=0;

xc=600e3;  % this is the initial calving front
UserVar.xc=xc;
BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs) ;

% Testing
F0.LSF=0*(xc-MUA.coordinates(:,1)) ;
F1.LSF=1*(xc-MUA.coordinates(:,1)) ;


% Velocity

CtrlVar.VelocityField="Constant" ;

xcAnalytical=NaN(2*nRunSteps,1) ; tVector=NaN(2*nRunSteps,1) ; 
xcNumerical=NaN(2*nRunSteps,1) ;  xcLSFNumerical=NaN(2*nRunSteps,1) ;
iV=1;  xcAnalytical(iV)=xc ; tVector(iV)=CtrlVar.time;

[u,c]=ucAnalytical(F1.x) ;


F1.ub=u+zeros(MUA.Nnodes,1) ;   F0.ub=F1.ub ;  F1.vb=F1.ub*0  ;   F0.vb=F0.ub*0 ;
F1.c=c ; F0.c=c;


CtrlVar.LevelSetPhase="Initialisation" ;
CtrlVar.LevelSetSolutionMethod="Newton Raphson";
CtrlVar.LevelSetFABCostFunction="p2q1";

CtrlVar.LevelSetTheta=0.5;
fprintf('\n \n Initialisation Phase. \n ')
[UserVar,RunInfo,LSF,Mask,lambda]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);

F1.LSF = LSF ;
TestLevelSetPlots(CtrlVar,UserVar,MUA,F1);


F0.LSF = F1.LSF ;



BCs.LSFFixedNode=[]; BCs.LSFFixedValue=[];

for iReInitialisationStep=1:nReinitialisationSteps
    
     fprintf('\n \n Propagation Phase. \n ')
    for iRunStep=1:nRunSteps
        
        CtrlVar.LevelSetPhase="Propagation and FAB" ;

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
    BCsReinitialisation=BCs;
    BCsReinitialisation.LSFFixedNode=find(Mask.NodesOn);
    BCsReinitialisation.LSFFixedValue=F1.LSF(Mask.NodesOn);
    [UserVar,RunInfo,LSF,Mask]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCsReinitialisation,F0,F1);
    F0.LSF=LSF ; F1.LSF=LSF ; 
    TestLevelSetPlots(CtrlVar,UserVar,MUA,F0);
    
end

%% Plot comparision
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
                
                
            case "Constant"
                
                
                u=1000+zeros(size(x),'like',x);
                c=-1*u ;
                
                
            otherwise
                
                error("adfa")
                
        end
        
    end

end