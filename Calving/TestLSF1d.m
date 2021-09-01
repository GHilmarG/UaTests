
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
%   27 June, 2021: -NR iteration now good, found some obvious mistakes and corrected. Also, found that BCs were not fulfilled if the
%                   initial guess for LSF did not (not a feasable point) and no update was made if not convergent in initial step.
%                  -It appears that the LSF has to be reasonably close to the minimum of the P term for it to converge to the
%                   right solution.
%                  -In the initialisation step, set theta=1, otherwise the mean value (f0+f1)/2 is the solution , not f1.
function TestLSF1d

clearvars
clear FindOrCreateFigure


Restart=false ;
ReadMUA=false ;

if ~Restart
    
    
    if ReadMUA
        load("LSFtest","BCs","CtrlVar","F0","F1","MUA","UserVar","RunInfo")
        
    else
        %% Generate mesh and MUA.
        UserVar=[];
        CtrlVar=Ua2D_DefaultParameters(); %
        
        CtrlVar.DevelopmentVersion=true;
        CtrlVar.LevelSetMethod=true; CtrlVar.LevelSetAssembly="consistent" ;
        
        
        CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
        MeshSize=2.5e3;
        CtrlVar.MeshSizeMax=MeshSize;
        CtrlVar.MeshSizeMin=MeshSize;
        CtrlVar.MeshSize=MeshSize;
        
        MeshBoundaryCoordinates=[0 -10e3 ; 800e3 -10e3 ; 800e3 10e3 ; 0  10e3 ] ;
        CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
        CtrlVar.TriNodes=3 ;  % Possible values are 3, 6, 10 node (linear/quadradic/cubic)
        CtrlVar.MUA.DecomposeMassMatrix=true;
        [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
        CtrlVar.PlotNodes=1;
        FindOrCreateFigure("Mesh"); PlotMuaMesh(CtrlVar,MUA); drawnow
        F0=UaFields;
        F1=UaFields;
        BCs=BoundaryConditions;
        RunInfo=UaRunInfo;
    end
    
    RunStepStart=1 ;
    ReinitialisationStepsStart=1;
    F0.x=MUA.coordinates(:,1) ; F0.y=MUA.coordinates(:,2) ;
    F1.x=MUA.coordinates(:,1) ; F1.y=MUA.coordinates(:,2) ;

    
    %% Parameters
    nRunSteps=20; nReinitialisationSteps=5; 
    CtrlVar.dt=0.1;   xc=90e3;   
    CtrlVar.LevelSetTestString="" ; %-xc sign-"  ; % "-xc/yc nodes-" ; 
    CtrlVar.LevelSetFABmu.Value=0.1 ; % 0.32
    CtrlVar.LevelSetFABmu.Value=0.01 ; % 0.032
    CtrlVar.LevelSetFABmu.Value=0.001 ; % 0.027
    CtrlVar.LevelSetFABmu.Value=1 ; % 0.027

    
    CtrlVar.LevelSetFABmu.Scale="ucl"; CtrlVar.LevelSetFABCostFunction="p2q2" ; %"p2q2";
    CtrlVar.LevelSetInfoLevel=1;
    AddedStringToFileName="" ;
    %%
    
    
    ResultsFile=sprintf("TestLSFresults-Iceshelf-%s-%s-muScale%s-muValue%i-dt%3.2f-%i-%i-xc%i-%s-l%i-N%i",...
        AddedStringToFileName,...
        CtrlVar.LevelSetFABCostFunction,CtrlVar.LevelSetFABmu.Scale,CtrlVar.LevelSetFABmu.Value,...
        CtrlVar.dt,nRunSteps,nReinitialisationSteps,xc,CtrlVar.LevelSetTestString,CtrlVar.MeshSize,CtrlVar.TriNodes);
    
    ResultsFile=replace(ResultsFile,".","k") ;
    ResultsFile=replace(ResultsFile,"--","-") ;
    CtrlVar.VelocityField="Analytical" ; % "Linear" ; % "Analytical" ; % "Constant" ;  % prescribed velocity, see below in nested function"Analytical"
    
    
        
    % I find that while mu can not be either too small or too large,
    % it can have a wide range of acceptable values 1e6 to 1e9 at least
    
    
    
    CtrlVar.LevelSetEpsilon=0;
    
   
    UserVar.xc=xc;
    BCs.LSFFixedNode=[]; BCs.LSFFixedValue=[];
    
    
    % Initial LSF
    F0.LSF=1*(xc-MUA.coordinates(:,1)) ;
    F1.LSF=1*(xc-MUA.coordinates(:,1)) ;
    F0.LSFqx=zeros(MUA.Nnodes,1) ; F0.LSFqy=zeros(MUA.Nnodes,1) ;
    F1.LSFqx=zeros(MUA.Nnodes,1) ; F1.LSFqy=zeros(MUA.Nnodes,1) ;
    % for I=1:21
    % P(I)=CalcLevelSetPertubationFunctional(CtrlVar,MUA,0.1*(I-1)*(xc-MUA.coordinates(:,1)));
    % end
    
    
    xcAnalytical=NaN(2*nRunSteps,1) ; tVector=NaN(2*nRunSteps,1) ;
    xcNumerical=NaN(2*nRunSteps,1) ;  xcLSFNumerical=NaN(2*nRunSteps,1) ;
    iV=1;  xcAnalytical(iV)=xc ; tVector(iV)=CtrlVar.time;  xcLSFNumerical(iV)=xc ;
    
    [u,c]=ucAnalytical(F1.x) ; % this is a nested function, so it sees all local variables
    
    
    F1.ub=u+zeros(MUA.Nnodes,1) ;   F0.ub=F1.ub ;  F1.vb=F1.ub*0  ;   F0.vb=F0.ub*0 ;
    F1.c=c ; F0.c=c;
    
    
    
    CtrlVar.LevelSetPhase="Initialisation" ;
    CtrlVar.LevelSetSolutionMethod="Newton Raphson";
    
    CtrlVar.LevelSetEpsilon=0;
    fprintf('\n \n Initialisation Phase. \n ')
    
    
    % Testing initialisation
    % BCs.LSFFixedNode=[] ; BCs.LSFFixedValue=[] ;
    
    % xBreak=600e3 ;
    % F0.LSF=0.9*(xc-F0.x) ;  I=F0.x>xBreak ; F0.LSF(I)=0.1*(xc-F0.x(I));
    % F1.LSF=0.9*(xc-F1.x) ;  I=F1.x>xBreak ; F1.LSF(I)=0.1*(xc-F1.x(I));
    
    
    
    
    [UserVar,RunInfo,LSF,Mask,lambda,LSFqx,LSFqy]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);
    
    
    % Perturbation term: J=1/(pq) int ( norm(nabla phi)^q-1)^p d|
    
    if CtrlVar.LevelSetInfoLevel>=5
        
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
    end
    %%
    
    F1.LSF = LSF ; F0.LSF = F1.LSF ; F0.LSFqx=LSFqx ; F0.LSFqy=LSFqy; 
    if CtrlVar.LevelSetInfoLevel>=10
        TestLevelSetPlots(CtrlVar,UserVar,MUA,F1);
    end
    
    
    
    BCs.LSFFixedNode=[]; BCs.LSFFixedValue=[];
    
else
    RS="RestartFile-TestLSFresults-Iceshelf-mu1-dt1k000000e-01-10-10.mat" ;
    load(RS,"CtrlVar","F0","F1","BCs","MUA","xcAnalytical","xcNumerical","xcLSFNumerical","nRunSteps","tVector","UserVar","iRunStep","iReInitialisationStep","nReinitialisationSteps","RunInfo","iV","ResultsFile")
    nReinitialisationSteps=nReinitialisationSteps+1000 ; nRunSteps=10 ; % possibly change/increase
    RunStepStart=1 ; ReinitialisationStepsStart=iReInitialisationStep;
    F1.s=NaN(MUA.Nnodes,1) ; F1.b=NaN(MUA.Nnodes,1) ; F1.B=NaN(MUA.Nnodes,1) ; F1.S=NaN(MUA.Nnodes,1) ;
  
    
end





for iReInitialisationStep=ReinitialisationStepsStart:nReinitialisationSteps
    
    fprintf('\n \n Propagation Phase. \n ')
    for iRunStep=RunStepStart:nRunSteps
        
        CtrlVar.LevelSetPhase="Propagation and FAB" ;
        fprintf("time=%f \t %s \n",CtrlVar.time,CtrlVar.LevelSetPhase)
        
        F0=F1 ;
        [UserVar,RunInfo,F1.LSF,Mask,lambda,F1.LSFqx,F1.LSFqy]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);
        
        if CtrlVar.LevelSetInfoLevel>=10
            TestLevelSetPlots(CtrlVar,UserVar,MUA,F1);
        end
        
        CtrlVar.time=CtrlVar.time+CtrlVar.dt ;
        F1.time=CtrlVar.time ;
        
        
        [u,c]=ucAnalytical(xcAnalytical(iV)) ;
        xcAnalytical(iV+1)=(u-c)*CtrlVar.dt+xcAnalytical(iV) ;
        
        tVector(iV+1)=CtrlVar.time ;
        [Value,Index]=min(abs(F1.LSF)) ; xcNumerical(iV+1)=F1.x(Index) ;
        
        CtrlVar.PlotGLs=0 ;
        [xC,yC]=PlotCalvingFronts(CtrlVar,MUA,F1,'r') ;
        CtrlVar.PlotGLs=1 ;
        xcLSFNumerical(iV+1)=mean(xC) ;
        
        iV=iV+1;
        
        if CtrlVar.LevelSetInfoLevel>=5
            FindOrCreateFigure(CtrlVar.LevelSetPhase)
            hold off
            F.x=MUA.coordinates(:,1) ;
            plot(F.x/1000,F1.LSF/1000,'.g')
            title(sprintf("Level Set at t=%4.2f",CtrlVar.time))

        end
        
        
        
        
    end
    
    
    fprintf('\n \n Re-initialisation Phase. \n ')
    CtrlVar.LevelSetPhase="Initialisation" ;
    fprintf("time=%f \t %s \n",CtrlVar.time,CtrlVar.LevelSetPhase)
    F0=F1; 
    [UserVar,RunInfo,LSF,Mask,lambda,LSFqx,LSFqy]=LevelSetEquation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1);
    
    if CtrlVar.LevelSetInfoLevel>=5
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
        legend("slope before","slope after")
    end
    
    F0.LSF=LSF ; F1.LSF=LSF ;  % after a re-initialisation
    F0.LSFqx=LSFqx ; F0.LSFqy=LSFqy; 
    
    if CtrlVar.LevelSetInfoLevel>=10
        TestLevelSetPlots(CtrlVar,UserVar,MUA,F0);
        LevelSetInfoLevelPlots(CtrlVar,MUA,BCs,F0,F1);
    end
    
    % save a restart once in a while
%     if mod(iReInitialisationStep,20000)==0
%         
%         save(ResultsFile,"tVector","xcAnalytical","xcLSFNumerical","xcNumerical","MUA","F0","F1","CtrlVar","UserVar")
%         close all
%         save("RestartFile-"+ResultsFile)
%     end
end

% Plot comparision
fig=FindOrCreateFigure("xc comparision "+CtrlVar.LevelSetAssembly+" Nod="+string(num2str(CtrlVar.TriNodes))) ;
hold off
yyaxis left
plot(tVector,xcAnalytical/1000,'k') ;
hold on ;
%plot(tVector,xcLSFNumerical/1000,'.g')
plot(tVector,xcLSFNumerical/1000,'og')
xlabel("$t \; \mathrm{(yr)}$","Interpreter","latex")
ylabel("$x_c\;\mathrm{(km)}$","Interpreter","latex")

yyaxis right
plot(tVector,(xcAnalytical-xcLSFNumerical)/1000,'.r')
ylabel("$\Delta x_c$ (Analytical-Numerical) $\;\mathrm{(km)}$","Interpreter","latex")

%legend("$x_c$ analytical","$x_c$ numerical","Nearest node to $x_c$","$\Delta x_c$ (Analytical-Numerical)",...
%    "interpreter","latex","location","northwest")

legend("$x_c$ analytical","$x_c$ numerical","$\Delta x_c$ (Analytical-Numerical)",...
    "interpreter","latex","location","northeast")


dt=CtrlVar.dt ; T=max(tVector)-min(tVector) ;
RMSE=sqrt(sum((xcAnalytical-xcLSFNumerical).^2,'omitnan'))*dt/T ;

title(sprintf("RMSE %f ",RMSE))

 fprintf('Saving results in %s \n',ResultsFile) 
% exportgraphics(gca,ResultsFile+"-t"+num2str(round(CtrlVar.time))+".pdf") ; 
MUA.dM=[];
save(ResultsFile,"tVector","xcAnalytical","xcLSFNumerical","xcNumerical","MUA","F0","F1","CtrlVar","UserVar")


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
                c=k*h.^q;
                
            case "Linear"
                
                ugl=0;
                cgl=0;
                dudx=1000/600e3;
                dcdx=2*dudx;
                
                u=ugl+dudx*x;
                c=cgl+dcdx*x;
                
                
                
            case "Constant"
                
                
                u=1000+zeros(size(x),'like',x);
                c=u ;
                
                
            otherwise
                
                error("adfa")
                
        end
        
    end

end