
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)

%% Summary
%
% When prescribing start A and C equal to true A and C, the true A and C is returned.  Only one iteration is performed and
% iteration stagnates at first step. This is of course expected, but nevertheless and important test.
%
%
% When using 6-node elements, the matlab optimisation gradient-based approach sometimes takes step at the beginning of an
% iteration that result in very large C value (e.g. 10^42), and same can happen with the A values. This, understandably,
% causes numerical issues in the uv solve.  Manually setting Cmax and Amax to reasonable value, solves this. Not sure why
% this happens, and not sure why this happens for 6-node elements when the same problem with 3-node elements is working fine.
%
%
% Just using dh/dt does not produce good results, stagnates early with retrieved A and C fields clearly being affected by the
% mesh and element sizes.
%
%
% Testing the ajoint gradient calculation shows the gradient to be very accurate. This is true for all measurement cases:
% -uv-, -dhdt-, and -uv-dhd- , and for A and C gradients.
%
%


%% UserVar

UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToTrueA-MS10km-Tri3-";
UserVar.RunType="IR-CstartSetToTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri10-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri6-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-";


% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS5km-Tri3-";
% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS5km-Tri6-";


CtrlVar.Inverse.Iterations=2;  
CtrlVar.Restart=0;  % Set to 1 after the first run so that it reads in restart file   



UserVar.ampl_eta=0.1; 
UserVar.nxA = 3; UserVar.nyA = 0;
UserVar.AGlen0 = 5e-5;

UserVar.ampl_c=0.1; 
UserVar.nxC = 3; UserVar.nyC = 0;
% units are kg, m, kPa
rho=917 ; h=1000 ; alpha=0.05 ; g=9.81/1000 ; ub=1e4; 
taud=rho*g*sin(alpha)*h ; m=1;
UserVar.C0 = ub/taud^m;  %i.e. c=22.24 this is equivalent to c0=100 in the dimensionless example


%%

CtrlVar.alpha=0.05;   % slope of the coordinate system

%% Mesh

xd=500e3; xu=-500e3 ; yl=50e3 ; yr=-50e3;

CtrlVar.MeshGenerator="UaSquareMesh"; 

CtrlVar.UaSquareMesh.xmin=xu;  
CtrlVar.UaSquareMesh.xmax=xd;
CtrlVar.UaSquareMesh.ymin=yr;
CtrlVar.UaSquareMesh.ymax=yl ; 
CtrlVar.UaSquareMesh.Refine=true;

MeshBoundaryCoordinates=flipud([xu yr ; xd yr ; xd yl ; xu yl]);
CtrlVar.OnlyMeshDomainAndThenStop=0;

CtrlVar.TriNodes=str2double(extractBetween(UserVar.RunType,"Tri","-")) ;


CtrlVar.MeshSize=str2double(extractBetween(UserVar.RunType,"-MS","km-"))*1000;

CtrlVar.UaSquareMesh.nx=round((CtrlVar.UaSquareMesh.xmax-CtrlVar.UaSquareMesh.xmin)/CtrlVar.MeshSize) ; 
CtrlVar.UaSquareMesh.ny=round((CtrlVar.UaSquareMesh.ymax-CtrlVar.UaSquareMesh.ymin)/CtrlVar.MeshSize) ; 


CtrlVar.MeshSizeMin=0.01*CtrlVar.MeshSize;
CtrlVar.MeshSizeMax=CtrlVar.MeshSize;

%%
CtrlVar.ThicknessConstraints=0;
%%

CtrlVar.doplots=1;
CtrlVar.PlotXYscale=1000;     % used to scale x and y axis of some of the figures, only used for plotting purposes
CtrlVar.PlotLabels=0 ; CtrlVar.PlotMesh=1; CtrlVar.PlotBCs=1;CtrlVar.PlotNodes=1;



%%

CtrlVar.InfoLevelNonLinIt=1;
CtrlVar.AdaptMesh=0;  



if contains(UserVar.RunType,"IR-")

        
        CtrlVar.InverseRun=1;
        
        CtrlVar.Inverse.InfoLevel=1;
        CtrlVar.InfoLevel=0;
        
        UserVar.Slipperiness.ReadFromFile=0;
        UserVar.AGlen.ReadFromFile=0;
                
        CtrlVar.InfoLevelNonLinIt=0;
        
        CtrlVar.Inverse.InvertFor="-logA-logC-";
        CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
        CtrlVar.Inverse.DataMisfit.GradientCalculation="-adjoint-" ;
        CtrlVar.Inverse.Measurements="-dhdt-" ;  % {'-uv-,'-uv-dhdt-','-dhdt-'}
        %CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-HessianBased";  
        CtrlVar.Inverse.MinimisationMethod="MatlabOptimization-GradientBased";  % recommended 
        
      
        CtrlVar.Inverse.Regularize.logC.ga=0;%1;%1;
        CtrlVar.Inverse.Regularize.logC.gs=0;%1e6;%1e4;  
        CtrlVar.Inverse.Regularize.logAGlen.ga=0;%1;%1;
        CtrlVar.Inverse.Regularize.logAGlen.gs=0;%1e6;%1e4 ; 
        

        CtrlVar.Cmax=1e20;
        CtrlVar.Cmin=1e-7;

        CtrlVar.AGlenmax=1e20;
        CtrlVar.AGlenmin=1e-7;


        % [----------- Testing adjoint gradients
        CtrlVar.Inverse.TestAdjoint.isTrue=false; % If true then perform a brute force calculation
        % of the directional derivative of the objective function.
        CtrlVar.TestAdjointFiniteDifferenceType="central-second-order" ;
        CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=0.01 ;
        CtrlVar.Inverse.TestAdjoint.iRange=[1:500] ;  % range of nodes/elements over which brute force gradient is to be calculated.
        % if left empty, values are calculated for every node/element within the mesh.
        % If set to for example [1,10,45] values are calculated for these three
        % nodes/elements.
        % ----------------------- ]end, testing adjoint parameters.

        % remember that when testing adjoint gradient, the pre-multiplier must the I (i.e. identity matrix)
        if  CtrlVar.Inverse.TestAdjoint.isTrue
            CtrlVar.Inverse.AdjointGradientPreMultiplier="I"; 
        else
            CtrlVar.Inverse.AdjointGradientPreMultiplier="M"; 
        end



elseif contains(UserVar.RunType,"FT-")  % forward time dependent run

        
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=1;
        
        CtrlVar.time=0 ;
        CtrlVar.dt=0.1; 
        CtrlVar.AdaptiveTimeStepping=1;
        CtrlVar.ATSdtMax=0.1;  
        CtrlVar.TotalNumberOfForwardRunSteps=5;      
        CtrlVar.EndTime = CtrlVar.dt * CtrlVar.TotalNumberOfForwardRunSteps; %% new. Is this right?
          
elseif contains(UserVar.RunType,"FD-") % forward diagnostic run
  
        
        CtrlVar.InverseRun=0;
        CtrlVar.TimeDependentRun=0;
      
end



if CtrlVar.InverseRun
    CtrlVar.Experiment='LateralDrag-Inverse-'...
        +CtrlVar.Inverse.InvertFor...
        +CtrlVar.Inverse.MinimisationMethod...
        +"-"+CtrlVar.Inverse.AdjointGradientPreMultiplier...
        +CtrlVar.Inverse.DataMisfit.GradientCalculation...
        +CtrlVar.Inverse.Hessian...
        +"-"+CtrlVar.SlidingLaw...
        +"-"+num2str(CtrlVar.DevelopmentVersion);
else
    CtrlVar.Experiment="LateralDrag-Forward"...
        +CtrlVar.ReadInitialMeshFileName;
    
end

CtrlVar.Experiment=replace(CtrlVar.Experiment," ","-"); 
CtrlVar.Experiment=replace(CtrlVar.Experiment,".","k"); 


CtrlVar.NameOfRestartFiletoWrite=UserVar.RunType;
CtrlVar.NameOfRestartFiletoRead=CtrlVar.NameOfRestartFiletoWrite; %Set to be identical

CtrlVar.Inverse.NameOfRestartOutputFile=UserVar.RunType;
CtrlVar.Inverse.NameOfRestartInputFile=CtrlVar.Inverse.NameOfRestartOutputFile; 


end
