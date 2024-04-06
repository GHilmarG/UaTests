function WaterFilmThicknessEquationDriver(UserVar)



ReadData=1;
CalcFluxes=1;
isRestart=1;  ResetTime=0; maxTime=200000; nPlotStep=10;

%%
%
% Solving for:
%
%  "-phi-"  : Traditional groundwater theory
%
% $$\frac{S_w}{\rho_w g} \partial_t \phi - \nabla \cdot ( \nabla \phi ) = a_w $$
%
%
% "-hw-AD-Phi-" : Solving for $h_w$ using advection diffusion approach and a given potental $\Phi$
%
% $$\partial_t h_w  + \nabla \cdot ( k h_w \nabla \Phi) - \nabla ( \kappa h_w \nabla h_w) = a_w $$
%
% "-hw-D-Phi-" : Solving for $h_w$ for a give potential $\Phi$ as a pure diffusion problem
%
% $$\partial_t h_w  - \nabla \cdot ( h_w k \nabla \Phi + \kappa h_w \nabla h_w) = a_w $$
%
% "-hw-A-"  : Solving for $h_w$ as a pure advection problem for a given velocity $\mathbf{v}_w$
%
% $$\partial_t h_w  + \nabla \cdot ( h_w \mathbf{v}_w) = a_w $$
%
%%

CtrlVar=Ua2D_DefaultParameters();

% Default SUPG parameters:
% CtrlVar.Tracer.SUPG.Use=1;
% CtrlVar.Tracer.SUPG.tau="tau2" ;
% CtrlVar.SUPG.beta0=1 ;
% tau1 : often recommended in textbooks for linear diffusion equations with
%        spatially constant non-zero advection velocity
% taut : dt/2,  'temporal' definition, independent of velocity
% taus : l/(2u) 'spatial definition', independent of time step
% tau2 : 1./(1./taut+1./taus), an 'inverse' average of taus and taut
% my local modifications to the SUPG parameters
% CtrlVar.Tracer.SUPG.Use=1; CtrlVar.Tracer.SUPG.tau="taus" ; CtrlVar.SUPG.beta0=1 ; % hw looks good, qw not
% CtrlVar.Tracer.SUPG.Use=1; CtrlVar.Tracer.SUPG.tau="tau2" ; CtrlVar.SUPG.beta0=1 ; %



if nargin==0
    UserVar.Example="-Island-hw-" ;
    UserVar.Example="-Island-Retrograde-hw-" ;
    UserVar.Example="-Island-Retrograde-Peaks-hw-" ;
    UserVar.Example="-Island-Retrograde-Peaks-" ;  
    UserVar.Example="-Island-" ;   % This is supposed to be a simple test for a simple geometry.
    UserVar.Example="-WAIS-aw0-" ;  
    UserVar.Example="-Plane-" ;    % used this to test volume conservation, which was found to be conserved to almost machine precision .

end
%CtrlVar.WaterFilm.Assembly=["-A-"|"-AD-"|"-D-"]

if contains(UserVar.Example,"-Island-") || contains(UserVar.Example,"-Plane-")


    %% Island

    CtrlVar.MeshSize=10e3 ;
    CtrlVar.TriNodes=3 ; 
    


elseif contains(UserVar.Example,"-WAIS-")
    %% WAIS

    CtrlVar.MeshSize=10e3 ;   clear CreateMeshAndMua.m

end



%%
nTimeSteps=10000;
nRestartSaveInterval=100;
CtrlVar.dt=10; dtOutput=CtrlVar.dt*100;  tOutput=0; 
qwxLast=[];
qwyLast=[];
UserVar.HelmholtzSmoothingLengthScale=nan;  

CtrlVar.InfoLevelBackTrack=0;  CtrlVar.InfoLevelNonLinIt=1 ;  CtrlVar.doplots=1 ;



%% Water-film equation parameters
k=100; k0=k ; kmin=k0/1e10 ; kActiveSet=k ;
CtrlVar.WaterFilm.ThickMin=1e-6; 

eta=0; 
CtrlVar.WaterFilm.Potential="-bs-" ;
CtrlVar.WaterFilm.qwAfloatMultiplier=1;
CtrlVar.WaterFilm.Assembly="-D-" ; 
UserVar.VelocityFieldPrescribed=false;
CtrlVar.WaterFilm.Barrier=0 ;
CtrlVar.WaterFilm.Penalty=0 ;
CtrlVar.WaterFilm.AdvectionFlag=1;
CtrlVar.WaterFilm.DiffusionFlag=1;
%% Solver variables
CtrlVar.lsqUa.Algorithm="LevenbergMarquardt";
CtrlVar.lsqUa.Algorithm="DogLeg";
CtrlVar.lsqUa.ItMax=5; 
CtrlVar.lsqUa.gTol=1e-5;
CtrlVar.lsqUa.dR2Tol=1e-3; 
CtrlVar.lsqUa.dxTol=1e-120;
CtrlVar.lsqUa.isLSQ=true; 
CtrlVar.lsqUa.SaveIterate=false; 
CtrlVar.lsqUa.CostMeasure="r2" ;
CtrlVar.WaterFilm.useActiveSetMethod=true;
CtrlVar.WaterFilm.MaxActiveSetIterations=5;
  ActiveSet=[]; lambda=[];
%%
RestartFileName="RF"+UserVar.Example+"MS"+num2str(CtrlVar.MeshSize/1000)+"km"+CtrlVar.WaterFilm.Assembly+"hwmin"+num2str(CtrlVar.WaterFilm.ThickMin);
RestartFileName=replace(RestartFileName,".","k");

%%
if ReadData  &&~isRestart

    if contains(UserVar.Example,"-Antarctica-") || contains(UserVar.Example,"-WAIS-")

        UserVar.QnTheoretical=nan;
        UserVar.VelocityFieldPrescribed=false;
        


        CtrlVar.MeshSizeMin=CtrlVar.MeshSize/2;
        CtrlVar.MeshSizeMax=2*CtrlVar.MeshSize;
    

        % CtrlVar.MeshSize=10e3 ; 
        [UserVar,MUA]=CreateMeshAndMua(UserVar,CtrlVar); 

        % load("..\Calving\PIG-TWG\MeshFile20km-PIG-TWG.mat","MUA")
        % load("AntarcticaMUAwith54kElements.mat","MUA") ;

        F=UaFields;
        F.x=MUA.coordinates(:,1) ; F.y=MUA.coordinates(:,2) ;

        FieldsToBeDefined="";
        [UserVar,F.s,F.b,F.S,F.B,F.rho,F.rhow,F.g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined);
        [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);
        F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);

        UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="B") ;
        UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="b") ;
        UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s") ;
  
        
        UserVar.awSource="-Box-" ; 
        UserVar.awSource="-BasalFriction-" ; 

        
        CtrlVar.Tracer.SUPG.Use=1;
        CtrlVar.WaterFilm.Barrier=0;
        CtrlVar.WaterFilm.Penalty=0 ;
        CtrlVar.WaterFilm.Potential="-bs-" ;
        CtrlVar.WaterFilm.qwAfloatMultiplier=0; % optional (negative) mass balance over floating areas
        CtrlVar.lsqUa.gTol=1;
        CtrlVar.WaterFilm.MaxActiveSetIterations=2;
        
       
        
        F.hw=zeros(MUA.Nnodes,1)+2*CtrlVar.WaterFilm.ThickMin   ;
      

        
        

        FluxGate=[-1550 -388 ; -1500 -543]*1000; Npoints=300 ; FluxGate=interparc(Npoints,FluxGate(:,1),FluxGate(:,2),'linear');
        FluxGate=[-1500 -388 ; -1450 -543]*1000; Npoints=300 ; FluxGate=interparc(Npoints,FluxGate(:,1),FluxGate(:,2),'linear');

        hold on ;
        plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,"o-") ; axis equal

     

    elseif contains(UserVar.Example,"-Island-") || contains(UserVar.Example,"-Plane-")


        CtrlVar.PlotXYscale=1000;
        l=100e3 ;
        UserVar.l=l;
  


        CtrlVar.MeshSizeMin=CtrlVar.MeshSize/2 ;
        CtrlVar.MeshSizeMax=CtrlVar.MeshSize*2 ;
        MeshBoundaryCoordinates=[-l -l ; l -l ; l l ; -l l ];
        CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
        [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
        
        MUA=UpdateMUA(CtrlVar,MUA);
        FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA); drawnow

        F=UaFields  ; F.x=MUA.coordinates(:,1) ; F.y=MUA.coordinates(:,2) ;

        FieldsToBeDefined="";
        [UserVar,F.s,F.b,F.S,F.B,F.rho,F.rhow,F.g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined);
        [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);
        F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
        
        UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="B") ;
        UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="b") ;
        UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s") ;


        figsbBnew=FindOrCreateFigure("sbB new") ; clf(figsbBnew)
        Plot_sbB(CtrlVar,MUA,F.s,F.b,F.B) ;
        % Initial water film thickness

        if contains(UserVar.Example,"-aw0-")
            UserVar.aw=0;
        else
            UserVar.aw=10;
        end
        UserVar.RadiusWaterAdded=30e3 ;  % Make sure that this radius is smaller than the flux-gate radius
        UserVar.RadiusFluxGate=40e3;

       

        % k=zeros(MUA.Nnodes,1)+1e2;     % works fine in all cases with A/D/AD
        % k=zeros(MUA.Nnodes,1)+1e10;    % For "-A-" had to reduce min thick from 0.001 to 1e-5. Then a very good agreement was found
        % Further reduction in CtrlVar.WaterFilm.ThickMin had no effect and was not needed.
        % "-D-" ran into numerical issues
        % "-AD-" works as "-A-",
        % With very sharp peaks, solution appear not to be mass conserving unless sufficient diffusion flux is included
        %
        % eta=zeros(MUA.Nnodes,1)+1e5;
        % eta=zeros(MUA.Nnodes,1)+1e12; % testing the importance of the linear diffusion term
         
        F.hw=zeros(MUA.Nnodes,1)+10*CtrlVar.WaterFilm.ThickMin   ;

        
        [cbar,xGL,yGL]=UaPlots(CtrlVar,MUA,F,F.s) ;
        % Npoints=300 ; FluxGate=interparc(Npoints,FluxGate(:,1),FluxGate(:,2),'linear');

        % FluxGate=[xGL(:) yGL(:)];
        N=max(10*2*pi*UserVar.RadiusFluxGate/CtrlVar.MeshSize,500) ;
        angle=linspace(0,2*pi,N); angle=angle(:);

        FluxGate=UserVar.RadiusFluxGate*[sin(-angle) cos(-angle) ];

        hold on ;

        plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,"o-") ; axis equal

        %%
    else
        error("case not found")
    end

    % Phi=PhiPotential(CtrlVar,MUA,F);
    % hw=-Phi./(F.g.*(F.rhow-F.rho));
    % hw=hw-min(hw) ;
    % F.hw=hw; 
    

    icount=0;
  
end


% CtrlVar.GWE.Variable="-phi-" ;
% CtrlVar.GWE.Variable="-N-" ;
% CtrlVar.GWE.Variable="-hw-" ;


if CalcFluxes



    if isRestart

        
        fprintf("loading restart file: %s \n",RestartFileName)
        load(RestartFileName,"UserVar","CtrlVar","MUA","F0","F1","k","eta","tVector","hwMaxVector","qwVector","hwMinVector","hwMaxGroundedVector","hwMaxAfloatVector","hwVolumeVector","FluxGate","ActiveSet","lambda") ;
        
        hwVolumeVector=nan(nTimeSteps,1);
        %FluxGate=[-1550 -388 ; -1500 -543]*1000;   Npoints=300 ; FluxGate=interparc(Npoints,FluxGate(:,1),FluxGate(:,2),'linear');
        %qwVector=tVector*0+nan;

        if ResetTime
            CtrlVar.time=0 ;
            F1.time=0;
            F0.time=0;
          
            icount=0;
            nTimeSteps=10000;

            hwMaxGroundedVector=nan(nTimeSteps,1);
            hwMaxAfloatVector=nan(nTimeSteps,1);
            hwMaxVector=nan(nTimeSteps,1);
            hwMinVector=nan(nTimeSteps,1);
            qwVector=nan(nTimeSteps,1);
            tVector=nan(nTimeSteps,1);

        else
            [~,icount]=max(tVector);
            
            
     
        end

    else


        F.time=0; F.dt=CtrlVar.dt ; 
        F0=F ; F1=F ;
        hwMaxGroundedVector=nan(nTimeSteps,1);
        hwMaxAfloatVector=nan(nTimeSteps,1);
        hwMaxVector=nan(nTimeSteps,1);
        hwMinVector=nan(nTimeSteps,1);
        qwVector=nan(nTimeSteps,1);
        tVector=nan(nTimeSteps,1);
        hwVolumeVector=nan(nTimeSteps,1);

    end
   

    %% Initialize (uw,vw)

    if  CtrlVar.WaterFilm.Assembly=="-D-"
        F0.uw=nan; F0.vw=nan ;
        F1.uw=nan; F1.vw=nan ;

    else
        
        [F0.uw,F0.vw]=WaterFilmVelocities(CtrlVar,UserVar,MUA,F0,k) ;
        [F1.uw,F1.vw]=WaterFilmVelocities(CtrlVar,UserVar,MUA,F1,k) ;
        % dtcritical=CalcCFLdt2D(UserVar,RunInfo,CtrlVar,MUA,F1,F1.uw,F1.vw) ;

    end

    RunInfo=UaRunInfo();
    



    for Isteps=1:nTimeSteps


        [UserVar,~,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,F1) ;

        F0.aw=ab ;
        F1.aw=ab ;

        F0.hw=F1.hw ;
        F1.aw=F1.aw ;

        



        [UserVar,hw1,ActiveSet,lambda,output]=WaterFilmThicknessEquation(UserVar,CtrlVar,MUA,F0,F1,k,eta,ActiveSet,lambda*0) ;


        k=k0+zeros(MUA.Nnodes,1) ;
        
        % AG=MuaElementsContainingGivenNodes(CtrlVar,MUA,ActiveSet) & F1.GF.ElementsUpstreamOfGroundingLines ;
        % NodesOfElementsContainingActiveNodes=unique(MUA.connectivity(AG,:)) ;
        % k(NodesOfElementsContainingActiveNodes)=kmin;

        kActiveSet=max(kActiveSet/2,kmin); 
        k(ActiveSet)=kActiveSet; 

        xint=output.fun.xint ;  yint=output.fun.yint ;  qwxint=output.fun.qx1int ; qwyint=output.fun.qy1int ;

        [qwx,qwy]=ProjectFintOntoNodes(MUA,qwxint,qwyint) ;

        [qwxPhi,qwyPhi]=ProjectFintOntoNodes(MUA,output.fun.qx1Phiint,output.fun.qy1Phiint);
        [qwxY,qwyY]=ProjectFintOntoNodes(MUA,output.fun.qx1Yint,output.fun.qy1Yint);

        xint=xint(:) ; yint=yint(:) ; qwxint=qwxint(:); qwyint=qwyint(:);
        Nstride=1 ; xint=xint(1:Nstride:end) ;  yint=yint(1:Nstride:end) ;  qwxint=qwxint(1:Nstride:end) ; qwyint=qwyint(1:Nstride:end) ;


        F1.hw=hw1;
        F1.dt=CtrlVar.dt; 
        F1.time=F1.time+CtrlVar.dt ;
        CtrlVar.time=F1.time ;


        
       fprintf("===================== \n      t=%g \t dt=%g \n ===================== \n",F1.time,F1.dt)

        % [UserVar,qw1x,qw1y,qUpsilonx,qUpsilony,qPhix,qPhiy]=WaterFilmFlux(UserVar,CtrlVar,MUA,F0,F1,k);



        icount=icount+1;

        if icount > numel(hwMaxVector)

            hwMinVector=[hwMinVector;hwMinVector+nan];
            hwMaxVector=[hwMaxVector;hwMaxVector+nan];
            hwMaxGroundedVector=[hwMaxGroundedVector;hwMaxGroundedVector+nan];
            hwMaxAfloatVector=[hwMaxAfloatVector;hwMaxAfloatVector+nan];
            qwVector=[qwVector;qwVector+nan];
            tVector=[tVector;tVector+nan];
            hwVolumeVector=[tVector;hwVolumeVector+nan];

        end


        hwMaxVector(icount)=max(F1.hw) ;
        hwMinVector(icount)=min(F1.hw) ;

        temp=max(F1.hw(F1.GF.node>0.5)) ;
        if ~isempty(temp)
            hwMaxGroundedVector(icount)=temp;
        end

        temp=max(F1.hw(F1.GF.node<0.5)) ;
        if~isempty(temp)
            hwMaxAfloatVector(icount)=max(F1.hw(F1.GF.node<0.5)) ;
        end

        hwVolumeVector(icount)=sum(FEintegrate2D(CtrlVar,MUA,F1.hw));
        tVector(icount)=F1.time;


        if F1.time> tOutput

            tOutput=tOutput+dtOutput ;
            OutputFileName=sprintf("./ResultsFiles/%10.10i-%s",F1.time,RestartFileName);
            fprintf("Saving output file: %s \n",OutputFileName)
            save(OutputFileName,"UserVar","CtrlVar","MUA","F0","F1","k","eta","qwx","qwy","ActiveSet","lambda") ;

        end

        % Restart file
        if mod(Isteps,nRestartSaveInterval)==0
            fprintf("Saving Restart File: %s \n",RestartFileName)
            save(RestartFileName,"UserVar","CtrlVar","MUA","F0","F1","k","eta","tVector","hwMaxVector","qwVector","hwMinVector","hwMaxGroundedVector","hwMaxAfloatVector","hwVolumeVector","FluxGate","ActiveSet","lambda") ;
        end

        %% figures



        if mod(Isteps-1,nPlotStep)==0 || abs(CtrlVar.time-maxTime)<0.1

            [~,xGL,yGL]=UaPlots(CtrlVar,MUA,F1,F1.hw,FigureTitle="hw",CreateNewFigure=true) ;
            ihmin=F1.hw <= CtrlVar.WaterFilm.ThickMin ;
            hold on ; plot(F1.x(ihmin)/CtrlVar.PlotXYscale,F1.y(ihmin)/CtrlVar.PlotXYscale,'.k',MarkerSize=0.1)
            title(sprintf("$h_w$ time=%g",CtrlVar.time),Interpreter="latex")

            [~,xGL,yGL]=UaPlots(CtrlVar,MUA,F1,F1.hw-F0.hw,FigureTitle="Delta hw",CreateNewFigure=true) ;
            title(sprintf("$\\Delta h_w$ time=%g",CtrlVar.time),Interpreter="latex")

            figNp=FindOrCreateFigure("max(hw)(t)")  ; clf(figNp) ;
            plot(tVector,hwMaxVector,"-ok")
            hold on
            plot(tVector,hwMinVector,"-*r")
            plot(tVector,hwMaxGroundedVector,"-*g")
            plot(tVector,hwMaxAfloatVector,"-*b")
            %yline(0,"--")
            title(sprintf("$h_w$"),Interpreter="latex")
            legend("hw max","hw min","hw max grounded","hw max afloat",Location="best")

            if  CtrlVar.WaterFilm.Assembly~="-D-"
                figP=FindOrCreateFigure("(uw,vw)") ; clf(figP) ;
                CtrlVar.VelColorBarTitle="($\mathrm{m \, yr^{-1}}$)" ;
                QuiverColorGHG(F1.x,F1.y,F1.uw,F1.vw,CtrlVar) ;
                hold on
                plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
                PlotMuaBoundary(CtrlVar,MUA) ;
                title(sprintf("$\\mathbf{v}_w$ time=%g",CtrlVar.time),Interpreter="latex")
                hold off
            end

            figqw=FindOrCreateFigure("(qwx,qwy)") ; clf(figqw) ;
            CtrlVar.VelColorBarTitle="($\mathrm{km^2 \, yr^{-1}}$)" ;
            QuiverColorGHG(F1.x,F1.y,qwx,qwy,CtrlVar);
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
      
            hold on ; plot(F1.x(ActiveSet)/CtrlVar.PlotXYscale,F1.y(ActiveSet)/CtrlVar.PlotXYscale,'*k',MarkerSize=3)
            if ~isempty(FluxGate)
                plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,Color="k",LineWidth=2) ;
            end
            xlabel("$x\,(\mathrm{km})$",interpreter="latex")
            ylabel("$y\,(\mathrm{km})$",interpreter="latex")
            title(sprintf("$\\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
            hold off

            % Phi fluxes
            figqPhi=FindOrCreateFigure("(qwxPhi,qwyPhi)") ; clf(figqPhi) ;
            CtrlVar.VelColorBarTitle="($\mathrm{km^2 \, yr^{-1}}$)" ;
            QuiverColorGHG(F1.x,F1.y,qwxPhi,qwyPhi,CtrlVar);
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            hold on ; plot(F1.x(ActiveSet)/CtrlVar.PlotXYscale,F1.y(ActiveSet)/CtrlVar.PlotXYscale,'*k',MarkerSize=3)
            if ~isempty(FluxGate)
                plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,Color="k",LineWidth=2) ;
            end
            xlabel("$x\,(\mathrm{km})$",interpreter="latex")
            ylabel("$y\,(\mathrm{km})$",interpreter="latex")
            title(sprintf("$\\Phi \\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
            hold off

            % Y fluxes
            figqY=FindOrCreateFigure("(qwxY,qwyY)") ; clf(figqY) ;
            CtrlVar.VelColorBarTitle="($\mathrm{km^2 \, yr^{-1}}$)" ;
            QuiverColorGHG(F1.x,F1.y,qwxY,qwyY,CtrlVar);
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            hold on ; plot(F1.x(ActiveSet)/CtrlVar.PlotXYscale,F1.y(ActiveSet)/CtrlVar.PlotXYscale,'*k',MarkerSize=3)
            if ~isempty(FluxGate)
                plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,Color="k",LineWidth=2) ;
            end
            xlabel("$x\,(\mathrm{km})$",interpreter="latex")
            ylabel("$y\,(\mathrm{km})$",interpreter="latex")
            title(sprintf("$\\Upsilon \\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
            hold off






            if ~isempty(qwxLast)
                figqw=FindOrCreateFigure("Delta(qwx,qwy)") ; clf(figqw) ;
                QuiverColorGHG(F1.x,F1.y,(qwx-qwxLast)/1e6,(qwy-qwyLast)/1e6,CtrlVar) ;
                hold on
                plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
                PlotMuaBoundary(CtrlVar,MUA) ;
                title(sprintf("$\\Delta \\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
                hold off
            end

            qwxLast=qwx ;
            qwyLast=qwy ;


            BoundaryNodes=MUA.Boundary.EdgeCornerNodes ;
            BoundaryNodes=[BoundaryNodes;BoundaryNodes(1)] ;
            BoundaryNodes=flipud(BoundaryNodes) ;

            if contains(UserVar.Example,"-Island-")
                aw=F1.aw;
                r=vecnorm([F.x F.y],2,2)  ;
                aw(r>UserVar.RadiusWaterAdded)=0;
                aw(F.x<0) =0 ;
                Int=FEintegrate2D(CtrlVar,MUA,aw) ;
                QIntNum=sum(Int) ;
            else
                QIntNum=nan;
            end


            if contains(UserVar.Example,"-Plane-")

                % testing volume and mass conservation
                % Here I add constant aw with time, so the change in volume must be equL
                % F1.aw/F1.dt

                R=diff(hwVolumeVector)./sum(FEintegrate2D(CtrlVar,MUA,F1.aw))/CtrlVar.dt ;
                % This ratio should be equal to unity if the gain in volume is alwasy equal to the added volume

                FindOrCreateFigure("dVolume/(dMassBalance*dt)")
    
                plot(tVector(2:end),R,"or-")
                xlabel("time")
                ylabel("ratio")
                title("ratio between change in volume and added mass balance")
                subtitle("(should be close to unity if mass is conserved)")

            end

            if ~isempty(FluxGate)


                % II=r>RadiusWaterAdded;
                % aw=F1.aw;
                % aw(II)=0;
                % Int=FEintegrate2D(CtrlVar,MUA,aw) ;
                % QInt=sum(Int) ;

             
                % Fqwx=scatteredInterpolant(F1.x,F1.y,qw1x);
                % Fqwy=scatteredInterpolant(F1.x,F1.y,qw1y);

                Fqwx=scatteredInterpolant(xint,yint,qwxint);
                Fqwy=scatteredInterpolant(xint,yint,qwyint);
                


                [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,FluxGate(:,1),FluxGate(:,2),Fqwx,Fqwy);

                qwVector(icount)=Qn ;

                figFG=FindOrCreateFigure("Flux Gate") ; clf(figFG);
                qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
                [cbar,QuiverHandel,Par]=QuiverColorGHG(xc,yc,qnx,qny,CtrlVar) ;
                hold on
                plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,"k--") ; axis equal
                plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')

                PlotMuaBoundary(CtrlVar,MUA) ;
                title(sprintf("$Q_n$=%g $Q_{\\mathrm{int}}$=%g  $\\tilde{Q}_{\\mathrm{int}}$=%g $t$=%g",Qn/1e9,UserVar.QnTheoretical/1e9,QIntNum/1e9,CtrlVar.time),Interpreter="latex")
                hold off

                figFGt=FindOrCreateFigure("Flux Gate(t)") ; clf(figFGt);
                %semilogy(tVector,qwVector/1e9,"ob")
                plot(tVector,qwVector/1e9,"ob")
                title(sprintf("$Q_n$=%g $(\\mathrm{km}^3/\\mathrm{yr})$ $Q_{\\mathrm{int}}$=%g $(\\mathrm{km}^3/\\mathrm{yr})$ $\\tilde{Q}_{\\mathrm{int}}$=%g $(\\mathrm{km}^3/\\mathrm{yr})$ $t$=%g $(\\mathrm{yr})$",...
                    Qn/1e9,UserVar.QnTheoretical/1e9,QIntNum/1e9,CtrlVar.time),Interpreter="latex")
                yline(UserVar.QnTheoretical/1e9,"--")
                xlabel("time, $t$ $(\mathrm{yr})$",Interpreter="latex")
                ylabel("Water flux, $Q$ $(\mathrm{km}^3/\mathrm{yr})$",Interpreter="latex")


            end

            drawnow
        end

        %%

        if CtrlVar.time>=maxTime
            break
        end

    end

    
    fprintf("Saving Restart File: %s \n",RestartFileName)
    MUA.dM=[];
    save(RestartFileName,"UserVar","CtrlVar","MUA","F0","F1","k","eta","tVector","hwMaxVector","qwVector","hwMinVector","hwMaxGroundedVector","hwMaxAfloatVector","hwVolumeVector","FluxGate","ActiveSet","lambda") ;

end

