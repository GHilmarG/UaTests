
function [UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar)



%% Summary

%{

When prescribing start A and C equal to true A and C, the true A and C is returned.  Only one iteration is performed and
iteration stagnates at first step. This is of course expected, but nevertheless and important test.


When using 6-node elements, the matlab optimisation gradient-based approach sometimes takes step at the beginning of an
iteration that result in very large C value (e.g. 10^42), and same can happen with the A values. This, understandably, causes
numerical issues in the uv solve.  Manually setting Cmax and Amax to reasonable value, solves this. Not sure why this
happens, and not sure why this happens for 6-node elements when the same problem with 3-node elements is working fine.


Just using dh/dt does not produce good results, stagnates early with retrieved A and C fields clearly being affected by the
mesh and element sizes. This has now been sorted, and now looks really good!

Testing the adjoint gradient calculation shows the directional derivative to be very accurate. This is true for all
measurement cases: -uv-, -dhdt-, and -uv-dhd- , and for A and C derivatives.

Inversion using -uv- as well as -uv-dhdt-  results in next-to-perfect retrieval of C, but A retrieval at center-line has a
freq. doubling, while elsewhere it looks good

DirectAdjoint Hessian estimate can be done using both uv and dhdt measurements and works fine. With the Ua optimisation
toolbox the reduction is typically greater per iteration, but using the MATLAB optimisation toolbox with
-trust-region-reflective works fine.

The DirectAdjoint approach is remarkably effective, reducing the cost-function by 10 to 15 order of magnitudes in 2 to 3
iterations when used with the Ua optimization toolbox!  This is possibly a problem dependent and may not be equally effective
for different cases, as currently only some of the Hessian terms are included.

%}

%% UserVar

UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToTrueA-MS10km-Tri3-";
UserVar.RunType="IR-CstartSetToTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri10-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri6-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-";


% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS5km-Tri3-";
% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS5km-Tri6-";

UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS25km-Tri3-MatGrad-";
% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS25km-Tri3-UaHess-";

% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaHess-BI-logA-logC-EI-";
% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-MatGrad-BI-logA-logC-EI-";


UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS5km-Tri3-MatGrad-logA-logC-uv-dhdt-";
% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS25km-Tri3-MatGrad-logA-logC-uv-dhdt-";

UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS5km-Tri3-UaHess-logA-logC-uv-dhdt-"; % running
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logA-logC-uv-";
%UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logA-logC-uv-";
%UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS5km-Tri3-UaDirectAdjointHessian-logA-logC-uv-";

UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logC-uv-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logA-uv-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logA-logC-uv-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-MatGrad-logA-logC-uv-";

UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logA-logC-uv-";

UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logA-logC-uv-dhdt-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logA-logC-uv-";
UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-UaDirectAdjointHessian-logC-uv-";

% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-MatlabDirectAdjointHessian-logA-logC-uv-dhdt-";
% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-MatlabHessianVectorProduct-logA-logC-uv-dhdt-";

% UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-MatlabHessianFiniteDifferences-logA-logC-uv-dhdt-";


CtrlVar.Inverse.Iterations=5;
CtrlVar.Restart=0;  %



UserVar.ampl_eta=0.1;
UserVar.nxA = 3; UserVar.nyA = 0;
UserVar.AGlen0 = 5e-5;

UserVar.ampl_c=0.1;
UserVar.nxC = 3; UserVar.nyC = 0;
% units are kg, m, kPa
rho=917 ; h=1000 ; alpha=0.05 ; g=9.81/1000 ; ub=1e4;
taud=rho*g*sin(alpha)*h ; m=1;
UserVar.C0 = ub/taud^m;  %i.e. c=22.24 this is equivalent to c0=100 in the dimensionless example

UserVar.NoiseAmplitude=0.00001;

%%

CtrlVar.alpha=0.05;   % slope of the coordinate system

%%
CtrlVar.BCsRowSubsetSelection=true;

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


    CtrlVar.Inverse.InvertFor="";
    if contains(UserVar.RunType,"-logA-")
        CtrlVar.Inverse.InvertFor= CtrlVar.Inverse.InvertFor+"-logA-";
    end
    if contains(UserVar.RunType,"-logC-")
        CtrlVar.Inverse.InvertFor= CtrlVar.Inverse.InvertFor+"-logC-";
    end
    CtrlVar.Inverse.InvertFor=replace(CtrlVar.Inverse.InvertFor,"--","-");


    CtrlVar.Inverse.Regularize.Field=CtrlVar.Inverse.InvertFor;
    CtrlVar.Inverse.DataMisfit.GradientCalculation="-adjoint-" ;

    CtrlVar.Inverse.Measurements="";
    if contains(UserVar.RunType,"-uv-")
        CtrlVar.Inverse.Measurements= CtrlVar.Inverse.Measurements+"-uv-";
    end
    if contains(UserVar.RunType,"-dhdt-")
        CtrlVar.Inverse.Measurements= CtrlVar.Inverse.Measurements+"-dhdt-";
    end
    CtrlVar.Inverse.Measurements=replace(CtrlVar.Inverse.Measurements,"--","-");


    if contains(UserVar.RunType,"-UaHess-")

        CtrlVar.Inverse.MinimisationMethod="-Ua-BruteForceHessian-";
        CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=0.01;

    elseif contains(UserVar.RunType,"-UaDirectAdjointHessian-")

        CtrlVar.Inverse.MinimisationMethod="-Ua-DirectAdjointHessian-";

    elseif contains(UserVar.RunType,"-MatGrad-")

        CtrlVar.Inverse.MinimisationMethod="-MatlabOptimization-GradientBased-";

    elseif contains(UserVar.RunType,"-MatlabDirectAdjointHessian-")

        CtrlVar.Inverse.MinimisationMethod="-MatlabOptimization-DirectAdjointHessian-";

    elseif contains(UserVar.RunType,"-MatlabHessianVectorProduct-")

        CtrlVar.Inverse.MinimisationMethod="-MatlabOptimization-HessianVectorProduct-";

    elseif contains(UserVar.RunType,"-MatlabHessianFiniteDifferences-")

        CtrlVar.Inverse.MinimisationMethod="-MatlabOptimization-HessianFiniteDifferences-";

    else
        error("What inversion approach? ")
    end



    %%
    CtrlVar.Inverse.Methodology="-Tikhonov-" ; % either "-Tikhonov-" or "-Matern-"

    % Tikhonov regularization parameters:
    CtrlVar.Inverse.Regularize.logC.ga=0.1;%1;%1;
    CtrlVar.Inverse.Regularize.logC.gs=1000;%1e6;%1e4;
    CtrlVar.Inverse.Regularize.logAGlen.ga=0.1;%1;%1;
    CtrlVar.Inverse.Regularize.logAGlen.gs=1000;%1e6;%1e4 ;


    CtrlVar.Inverse.Regularize.logC.ga=1; %1;%1;
    CtrlVar.Inverse.Regularize.logC.gs=1e6 ;%1e4;
    CtrlVar.Inverse.Regularize.logAGlen.ga=1;%1;%1;
    CtrlVar.Inverse.Regularize.logAGlen.gs=1e6;%1e4 ;


    %$ Matern covariance parameters:
    %CtrlVar.Inverse.Methodology="-Matern-" ;
    Area=(xd-xu)*(yl-yr) ;


    % [alphaMatern,tauMatern,kappaMatern,sigma2Matern,rhoMatern]=Tikhonov2MaternParameters(CtrlVar.Inverse.Regularize.logAGlen.ga, CtrlVar.Inverse.Regularize.logAGlen.gs,Area);


    CtrlVar.Inverse.Matern.logAGlen.alpha=2;
    CtrlVar.Inverse.Matern.logAGlen.kappa=1/100;
    CtrlVar.Inverse.Matern.logAGlen.tau=100;

    % [alphaMatern,tauMatern,kappaMatern,sigma2Matern,rhoMatern]=Tikhonov2MaternParameters(CtrlVar.Inverse.Regularize.logC.ga, CtrlVar.Inverse.Regularize.logC.gs,Area);

    % [rhoMatern,sigmaMatern,nuMatern]=Matern_alpha_kappa_tau(CtrlVar.Inverse.Matern.logAGlen.alpha, CtrlVar.Inverse.Matern.logAGlen.kappa, CtrlVar.Inverse.Matern.logAGlen.tau);
    % r=linspace(0,5*rhoMatern,30); DoPlots=true; CreateRealisations=true;
    % sigma2Matern=sigmaMatern^2;
    % [C,nu,kappa,sigma2,tau,Cov,Realisation,coords]=Matern(sigma2Matern,CtrlVar.Inverse.Matern.logAGlen.alpha,rhoMatern,r,DoPlots,CreateRealisations);



    CtrlVar.Inverse.Matern.logC.alpha=2;
    CtrlVar.Inverse.Matern.logC.kappa=1/100;
    CtrlVar.Inverse.Matern.logC.tau=100;

    CtrlVar.Inverse.Matern.B.alpha=[];
    CtrlVar.Inverse.Matern.B.kappa=[];
    CtrlVar.Inverse.Matern.B.tau=[];
    %%

    CtrlVar.Cmax=1e20;
    CtrlVar.Cmin=1e-7;

    CtrlVar.AGlenmax=1e20;
    CtrlVar.AGlenmin=1e-7;


    % [----------- Testing adjoint gradients
    CtrlVar.Inverse.TestAdjoint.isTrue=false; % If true then perform a brute force calculation
    % of the directional derivative of the objective function.
    CtrlVar.TestAdjointFiniteDifferenceType="central-second-order" ;

    CtrlVar.Inverse.TestAdjoint.iRange=[1:500] ;  % range of nodes/elements over which brute force gradient is to be calculated.
    % if left empty, values are calculated for every node/element within the mesh.
    % If set to for example [1,10,45] values are calculated for these three
    % nodes/elements.
    % ----------------------- ]end, testing adjoint parameters.

    % remember that when testing adjoint gradient, the pre-multiplier must the I (i.e. identity matrix)
    if  CtrlVar.Inverse.TestAdjoint.isTrue
        CtrlVar.Inverse.AdjointGradientPreMultiplier="I";
        CtrlVar.Inverse.TestAdjoint.FiniteDifferenceStepSize=0.01 ;
    else
        CtrlVar.Inverse.AdjointGradientPreMultiplier="L2";
    end

    if CtrlVar.Inverse.MinimisationMethod=="-Ua-BruteForceHessian-"  || CtrlVar.Inverse.MinimisationMethod=="-Ua-DirectAdjointHessian-"
        CtrlVar.Inverse.AdjointGradientPreMultiplier="I";
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
%% MATLAB optimisation toolboox

UserVar.RunType="IR-CstartSetToMeanOfTrueC-AstartSetToMeanOfTrueA-MS10km-Tri3-MatlabHessianVectorProduct-logA-logC-uv-dhdt-";

if contains(UserVar.RunType,"HessianVectorProduct")


    CtrlVar.Inverse.MatlabOptimisationHessianParameters = optimoptions('fmincon',...
        'Algorithm','trust-region-reflective',...
        'ConstraintTolerance',1e-10,...
        'HonorBounds',true,...
        'Diagnostics','on',...
        'DiffMaxChange',Inf,...
        'DiffMinChange',0,...
        'Display','iter-detailed',...
        'FunValCheck','off',...
        'MaxFunctionEvaluations',1e6,...
        'MaxIterations',CtrlVar.Inverse.Iterations,...,...
        'OptimalityTolerance',CtrlVar.Inverse.OptimalityTolerance,...
        'OutputFcn',@fminuncOutfun,...
        'PlotFcn',{@optimplotlogfval,@optimplotstepsize},...
        'StepTolerance',CtrlVar.Inverse.StepTolerance,...
        'FunctionTolerance',CtrlVar.Inverse.FunctionTolerance,...
        'UseParallel',true,...
        'HessianFcn',[],...     % I suspect this is not needed for the trust-region-reflective
        'HessianMultiplyFcn',@HessianVectorProduct,...
        'InitBarrierParam',1e-7,...           % On a restart this might have to be reduced if objective function starts to increase
        'ScaleProblem','none',...
        'InitTrustRegionRadius',1,...         % set to smaller value if the forward problem is not converging
        'SpecifyConstraintGradient',false,...
        'SpecifyObjectiveGradient',true,...
        'SubproblemAlgorithm','cg');  % here the options are 'gc' and 'factorization', unclear which is better.

elseif contains(UserVar.RunType,"MatlabDirectAdjointHessian")

    Hfunc=@(p,lambda) p+lambda ;  % just needs to defined here, this is then later replaced with a function that returns the Hessian estimation.
    CtrlVar.Inverse.MatlabOptimisationHessianParameters = optimoptions('fmincon',...
        'Algorithm','trust-region-reflective',...
        'ConstraintTolerance',1e-10,...
        'HonorBounds',true,...
        'Diagnostics','on',...
        'DiffMaxChange',Inf,...
        'DiffMinChange',0,...
        'Display','iter-detailed',...
        'FunValCheck','off',...
        'MaxFunctionEvaluations',1e6,...
        'MaxIterations',CtrlVar.Inverse.Iterations,...,...
        'OptimalityTolerance',CtrlVar.Inverse.OptimalityTolerance,...
        'OutputFcn',@fminuncOutfun,...
        'PlotFcn',{@optimplotlogfval,@optimplotstepsize},...
        'StepTolerance',CtrlVar.Inverse.StepTolerance,...
        'FunctionTolerance',CtrlVar.Inverse.FunctionTolerance,...
        'UseParallel',true,...
        'HessianFcn',Hfunc,...     % I suspect this is not needed for the trust-region-reflective
        'HessianMultiplyFcn',[],...
        'InitBarrierParam',1e-7,...           % On a restart this might have to be reduced if objective function starts to increase
        'ScaleProblem','none',...
        'InitTrustRegionRadius',1,...         % set to smaller value if the forward problem is not converging
        'SpecifyConstraintGradient',false,...
        'SpecifyObjectiveGradient',true,...
        'SubproblemAlgorithm','cg');  % here the options are 'gc' and 'factorization', unclear which is better.


elseif contains(UserVar.RunType,"MatlabHessianFiniteDifferences")

    CtrlVar.Inverse.MatlabOptimisationHessianParameters = optimoptions('fmincon',...
        'Algorithm','trust-region-reflective',...
        'CheckGradients',false,...
        'ConstraintTolerance',1e-10,...
        'HonorBounds',true,...
        'Diagnostics','on',...
        'DiffMaxChange',Inf,...
        'DiffMinChange',0,...
        'Display','iter-detailed',...
        'FunValCheck','off',...
        'MaxFunctionEvaluations',1e6,...
        'MaxIterations',CtrlVar.Inverse.Iterations,...,...
        'OptimalityTolerance',CtrlVar.Inverse.OptimalityTolerance,...
        'OutputFcn',@fminuncOutfun,...
        'PlotFcn',{@optimplotlogfval,@optimplotstepsize},...
        'StepTolerance',CtrlVar.Inverse.StepTolerance,...
        'FunctionTolerance',CtrlVar.Inverse.FunctionTolerance,...
        'UseParallel',true,...
        'HessianFcn',[],...     % uses finite differences, provided HessianMultiplyFcn is also empty
        'HessianMultiplyFcn',[],...
        'SpecifyConstraintGradient',false,...
        'SpecifyObjectiveGradient',true,...
        'InitBarrierParam',1e-7,...           % On a restart this might have to be reduced if objective function starts to increase
        'ScaleProblem','none',...
        'InitTrustRegionRadius',1,...         % set to smaller value if the forward problem is not converging
        'SubproblemAlgorithm','cg');  % here the options are 'gc' and 'factorization', unclear which is better.


end
%%


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
