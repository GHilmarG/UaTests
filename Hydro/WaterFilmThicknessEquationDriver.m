function WaterFilmThicknessEquationDriver



ReadData=1;
CalcFluxes=1;
isRestart=0;  ResetTime=0;

%%
%
% Solving for:
%
%  "-phi-"  : Traditional goundwater theory
%
% $$\frac{S_w}{\rho_w g} \partial_t \phi - \nabla \cdot ( \nabla \phi ) = a_w $$
%
%
% "-hw-AD-Phi-" : Solving for $h_w$ using advection diffusion approach and a given potental $\Phi$
%
% $$\partial_t h_w  + \nabla \cdot ( k h_w \nabla \Phi) - \nabla ( \kappa h_w \nabla h_w) = a_w $$
%
% "-hw-D-Phi-" : Solving for $h_w$ for a give potental $\Phi$ as a pure diffusion problem
%
% $$\partial_t h_w  - \nabla \cdot ( h_w k \nabla \Phi + \kappa h_w \nabla h_w) = a_w $$
%
% "-hw-A-"  : Solving for $h_w$ as a pure advection problem for a given velocity $\mathbf{v}_w$
%
% $$\partial_t h_w  + \nabla \cdot ( h_w \mathbf{v}_w) = a_w $$
%
%%

CtrlVar=Ua2D_DefaultParameters();
FluxGate=[]; xGL=[] ; yGL=[] ;


UserVar.Example="-Dome-Phi-" ;
UserVar.Example="-Dome-hw-" ;
UserVar.Example="-Island-hw-" ;
UserVar.Example="-Island-Retrograde-hw-" ;
UserVar.Example="-Island-Retrograde-Peaks-hw-" ;
% UserVar.Example="-Antarctica-" ;  CtrlVar.WaterFilm.Assembly="-D-";  UserVar.HelmholtzSmoothingLengthScale=0.1e3;


%%
nTimeSteps=10000;
nRestartSaveIntervale=1000;
maxTime=1e8;
CtrlVar.dt=100;
qw1x=0 ; qw1y=0 ;


CtrlVar.InfoLevelBackTrack=0;  CtrlVar.InfoLevelNonLinIt=10 ;  CtrlVar.doplots=1 ;

CtrlVar.WaterFilm.ThickMin=0.001 ;  % can be small, but not zero
CtrlVar.WaterFilm.qwAfloatMultiplier=10;

CtrlVar.lsqUa.gTol=1e-5;

CtrlVar.WaterFilm.MaxActiveSetIterations=10;
CtrlVar.WaterFilm.Potential="-bs-" ;
CtrlVar.lsqUa.ItMax=20;
CtrlVar.WaterFilm.useActiveSetMethod=true;
CtrlVar.WaterFilm.Barrier=0 ;
CtrlVar.WaterFilm.Penalty=0 ;





ActiveSet=[]; lambda=[];

PlotWaterFilmFlux=false;

nPlotStep=1;

if ReadData  &&~isRestart

    if contains(UserVar.Example,"-Antarctica-")



        load("..\Calving\PIG-TWG\MeshFile20km-PIG-TWG.mat","MUA")
        % load("AntarcticaMUAwith54kElements.mat","MUA") ;

        CtrlVar.TriNodes=3;  MUA=UpdateMUA(CtrlVar,MUA);
        F=UaFields;
        F.x=MUA.coordinates(:,1) ; F.y=MUA.coordinates(:,2) ;

        FieldsToBeDefined="";
        [UserVar,F.s,F.b,F.S,F.B,F.rho,F.rhow,F.g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined);
        [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);

        UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="B") ;
        UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="b") ;
        UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s") ;

        aw=zeros(MUA.Nnodes,1);
        F.aw=aw;
        F.hw=zeros(MUA.Nnodes,1)+0.1;    % Initial water film thickness

        k=zeros(MUA.Nnodes,1)+1e10;
        eta=zeros(MUA.Nnodes,1)+1e2;

        CtrlVar.dt=1e10;
        CtrlVar.lsqUa.gTol=20;
        CtrlVar.WaterFilm.qwAfloatMultiplier=100;

        FluxGate=[-1550 -388 ; -1500 -543]*1000;  Npoints=300 ; FluxGate=interparc(Npoints,FluxGate(:,1),FluxGate(:,2),'linear');
        hold on ;
        plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,"o-") ; axis equal


    elseif contains(UserVar.Example,"-Island-")


        CtrlVar.PlotXYscale=1000;
        l=100e3 ;
        UserVar.l=l;
        dl=l/5;
        dl=l/10;
        % dl=l/20;
        dl=l/30;
        dl=l/40;
        % dl=l/60;
        % dl=l/80;
        % dl=l/100;
        % dl=2000;
        % dl=500;
        dl=4e3 ;
        dl=6000 ;
        dl=7000 ;
        dl=8000 ;
        dl=7500 ;
        dl=7250 ;
        dl=7100 ;
        dl=4500 ;
        dl=15000 ;
        dl=2500 ;
        dl=5000 ;
        dl=1000;

        CtrlVar.MeshSize=dl;

        CtrlVar.MeshSizeMin=CtrlVar.MeshSize/2 ;
        CtrlVar.MeshSizeMax=CtrlVar.MeshSize*2 ;
        MeshBoundaryCoordinates=[-l -l ; l -l ; l l ; -l l ];
        CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
        [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
        CtrlVar.TriNodes=3;  MUA=UpdateMUA(CtrlVar,MUA);
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




        UserVar.aw=10;
        UserVar.RadiusWaterAdded=30e3 ;
        UserVar.RadiusWaterAdded=nan ;  % in nan, water added everywhere
        UserVar.RadiusFluxGate=40e3;


   



        k=zeros(MUA.Nnodes,1)+1e2;     % works fine in all cases with A/D/AD
        k=zeros(MUA.Nnodes,1)+1e10;    % For "-A-" had to reduce min thick from 0.001 to 1e-5. Then a very good agreement was found
        % Further reduction in CtrlVar.WaterFilm.ThickMin had no effect and was not needed.
        % "-D-" ran into numerical issues
        % "-AD-" works as "-A-",
        % With very sharp peaks, solution appear not to be mass conserving unless sufficient diffusion flux is included
        %
        eta=zeros(MUA.Nnodes,1)+1e5;
        % eta=zeros(MUA.Nnodes,1)+1e12; % testing the importance of the linear diffusion term
        eta=10*k; 

      
        eta(~F.GF.NodesUpstreamOfGroundingLines)=eta(1)*1000;

        CtrlVar.WaterFilm.Assembly="-A-" ;     % excellent 
        CtrlVar.WaterFilm.Assembly="-AD-" ;    % excellent
        %  CtrlVar.WaterFilm.Assembly="-D-" ;  % excellent

        CtrlVar.Tracer.SUPG.Use=1;
        CtrlVar.WaterFilm.Barrier=0;
        CtrlVar.WaterFilm.Penalty=1 ;
        CtrlVar.WaterFilm.Potential="-bs-" ;
        CtrlVar.WaterFilm.qwAfloatMultiplier=1000; 
        CtrlVar.lsqUa.gTol=1;
        CtrlVar.WaterFilm.MaxActiveSetIterations=2;

        CtrlVar.dt=10e3/k(1) ;
        CtrlVar.WaterFilm.ThickMin=10e3/k(1);
        F.hw=zeros(MUA.Nnodes,1)+10*CtrlVar.WaterFilm.ThickMin   ;

        maxTime=5000;

        [cbar,xGL,yGL]=UaPlots(CtrlVar,MUA,F,F.s) ;
        % Npoints=300 ; FluxGate=interparc(Npoints,FluxGate(:,1),FluxGate(:,2),'linear');

        % FluxGate=[xGL(:) yGL(:)];
        angle=linspace(0,2*pi,500); angle=angle(:);

        FluxGate=UserVar.RadiusFluxGate*[sin(-angle) cos(-angle) ];

        hold on ;

        plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,"o-") ; axis equal

        %%
    else
        error("case not found")
    end


    icount=0;

end


% CtrlVar.GWE.Variable="-phi-" ;
% CtrlVar.GWE.Variable="-N-" ;
CtrlVar.GWE.Variable="-hw-" ;


if CalcFluxes



    if isRestart

        
        load("RestartWaterFilmThicknessEquationDriver","UserVar","CtrlVar","MUA","F0","F1","k","eta","tVector","hwMaxVector","qwVector","hwMinVector","hwMaxGroundedVector","hwMaxAfloatVector","FluxGate","ActiveSet","lambda") ;

        %FluxGate=[-1550 -388 ; -1500 -543]*1000;   Npoints=300 ; FluxGate=interparc(Npoints,FluxGate(:,1),FluxGate(:,2),'linear');
        %qwVector=tVector*0+nan;

        if ResetTime
            CtrlVar.time=0 ;
            F1.time=0;
            F0.time=0;
            CtrlVar.dt=10;
            icount=0;
            nTimeSteps=10000;

            hwMaxGroundedVector=nan(nTimeSteps,1);
            hwMaxAfloatVector=nan(nTimeSteps,1);
            hwMaxVector=nan(nTimeSteps,1);
            hwMinVector=nan(nTimeSteps,1);
            qwVector=nan(nTimeSteps,1);
            tVector=nan(nTimeSteps,1);

        else
            icount=numel(tVector) ;
            
            hwMinVector=[hwMinVector;hwMinVector+nan];
            hwMaxVector=[hwMaxVector;hwMaxVector+nan];
            hwMaxGroundedVector=[hwMaxGroundedVector;hwMaxGroundedVector+nan];
            hwMaxAfloatVector=[hwMaxAloatVector;hwMaxAfloatVector+nan];
            qwVector=[qwVector;qwVector+nan];
            tVector=[tVector;tVector+nan];
        end

    else


        F.time=0;
        F0=F ; F1=F ;
        hwMaxGroundedVector=nan(nTimeSteps,1);
        hwMaxAfloatVector=nan(nTimeSteps,1);
        hwMaxVector=nan(nTimeSteps,1);
        hwMinVector=nan(nTimeSteps,1);
        qwVector=nan(nTimeSteps,1);
        tVector=nan(nTimeSteps,1);
    end

    dN=zeros(MUA.Nnodes,1);  dlambda=[];

    %% Initialize (uw,vw)

    [F0.uw,F0.vw]=WaterFilmVelocities(CtrlVar,UserVar,MUA,F0,k) ;
    [F1.uw,F1.vw]=WaterFilmVelocities(CtrlVar,UserVar,MUA,F1,k) ;

        

    for Isteps=1:nTimeSteps


        [UserVar,~,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,F1) ;

        F0.aw=ab ;
        F1.aw=ab ;

        F0.hw=F1.hw ;
        F1.aw=F1.aw ;

        qw0x=qw1x ; qw0y=qw1y ;



        [UserVar,hw1,ActiveSet,lambda]=WaterFilmThicknessEquation(UserVar,CtrlVar,MUA,F0,F1,k,eta,ActiveSet,lambda*0) ;



        F1.hw=hw1;
        F1.time=F1.time+CtrlVar.dt ;
        CtrlVar.time=F1.time ;



        [UserVar,qw1x,qw1y,qUpsilonx,qUpsilony,qPhix,qPhiy]=WaterFilmFlux(UserVar,CtrlVar,MUA,F0,F1,k);


        if PlotWaterFilmFlux

            figqw=FindOrCreateFigure("(qw1x,qw1y) New") ; clf(figqw) ;
            CtrlVar.VelColorBarTitle="($\mathrm{m^2 \, yr^{-1}}$)" ;
            cbar=QuiverColorGHG(F1.x,F1.y,qw1x,qw1y,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            title(sprintf("$\\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
            hold off


            figqPhi=FindOrCreateFigure("(qPhix,qPhiy)") ; clf(figqPhi) ;
            CtrlVar.VelColorBarTitle="($\mathrm{m^2 \, yr^{-1}}$)" ;
            QuiverColorGHG(F1.x,F1.y,qPhix,qPhiy,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            title(sprintf("$\\mathbf{q}_{\\Phi}  \\, \\Phi$ time=%g",CtrlVar.time),Interpreter="latex")
            hold off



            figqphi=FindOrCreateFigure("(qphix,qphiy)") ; clf(figqphi) ;
            CtrlVar.VelColorBarTitle="($\mathrm{m^2 \, yr^{-1}}$)" ;
            QuiverColorGHG(F1.x,F1.y,qUpsilonx,qUpsilony,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            title(sprintf("$\\mathbf{q}_{\\Upsilon} $ $\\Upsilon$ flux time=%g",CtrlVar.time),Interpreter="latex")
            hold off

        end
        %%

        icount=icount+1;
        hwMaxVector(icount)=max(F1.hw) ;
        hwMinVector(icount)=min(F1.hw) ;
        hwMaxGroundedVector(icount)=max(F1.hw(F1.GF.node>0.5)) ;
        hwMaxAfloatVector(icount)=max(F1.hw(F1.GF.node<0.5)) ;
        tVector(icount)=F1.time;

        % Restart file
        if mod(Isteps,nRestartSaveIntervale)==0
            fprintf("Saving Restart File. \n")
            
            save("RestartWaterFilmThicknessEquationDriver","UserVar","CtrlVar","MUA","F0","F1","k","eta","tVector","hwMaxVector","qwVector","hwMinVector","hwMaxGroundedVector","hwMaxAfloatVector","FluxGate","ActiveSet","lambda") ;
        end

        %% figures



        if mod(Isteps-1,nPlotStep)==0 || abs(CtrlVar.time-maxTime)<0.1

            [~,xGL,yGL]=UaPlots(CtrlVar,MUA,F1,F1.hw,FigureTitle="hw",CreateNewFigure=true) ;
            % IhwNeg=F1.hw<0 ; hold on ; plot(F1.x(IhwNeg)/CtrlVar.PlotXYscale,F1.y(IhwNeg)/CtrlVar.PlotXYscale,'or')
            title(sprintf("$h_w$ time=%g",CtrlVar.time),Interpreter="latex")

            [~,xGL,yGL]=UaPlots(CtrlVar,MUA,F1,F1.hw-F0.hw,FigureTitle="Delta hw",CreateNewFigure=true) ;
            title(sprintf("$\\Delta h_w$ time=%g",CtrlVar.time),Interpreter="latex")

            figNp=FindOrCreateFigure("max(hw)(t)")  ; clf(figNp) ;
            plot(tVector,hwMaxVector,"-ok")
            hold on
            plot(tVector,hwMinVector,"-*r")
            plot(tVector,hwMaxGroundedVector,"-*g")
            plot(tVector,hwMaxAfloatVector,"-*b")
            yline(0,"--")
            title(sprintf("$h_w$"),Interpreter="latex")

            figP=FindOrCreateFigure("(uw,vw)") ; clf(figP) ;
            CtrlVar.VelColorBarTitle="($\mathrm{m \, yr^{-1}}$)" ;
            QuiverColorGHG(F1.x,F1.y,F1.uw,F1.vw,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            title(sprintf("$\\mathbf{v}_w$ time=%g",CtrlVar.time),Interpreter="latex")
            hold off

            figqw=FindOrCreateFigure("(qwx,qwy)") ; clf(figqw) ;
            CtrlVar.VelColorBarTitle="($\mathrm{km^2 \, yr^{-1}}$)" ;
            QuiverColorGHG(F1.x,F1.y,qw1x/1e6,qw1y/1e6,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            if ~isempty(FluxGate)
                plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,Color="k",LineWidth=2) ;
            end
            xlabel("$x\,(\mathrm{km})$",interpreter="latex")
            ylabel("$y\,(\mathrm{km})$",interpreter="latex")
            title(sprintf("$\\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
            hold off


            figqw=FindOrCreateFigure("Delta(qwx,qwy)") ; clf(figqw) ;
            QuiverColorGHG(F1.x,F1.y,(qw1x-qw0x)/1e6,(qw1y-qw0y)/1e6,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            title(sprintf("$\\Delta \\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
            hold off



            BoundaryNodes=MUA.Boundary.EdgeCornerNodes ;
            BoundaryNodes=[BoundaryNodes;BoundaryNodes(1)] ;
            BoundaryNodes=flipud(BoundaryNodes) ;

            Int=FEintegrate2D(CtrlVar,MUA,F1.aw) ;
            QInt=sum(Int) ;

            % [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,F1.x(BoundaryNodes),F1.y(BoundaryNodes),qw1x(BoundaryNodes),qw1y(BoundaryNodes));
            % figNP=FindOrCreateFigure("Boundary fluxes") ; clf(figNP);
            % qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
            % [cbar,QuiverHandel,Par]=QuiverColorGHG(xc,yc,qnx,qny,CtrlVar) ;
            % hold on
            % plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            % PlotMuaBoundary(CtrlVar,MUA) ;
            % title(sprintf("Qn=%g  \t QInt=%g \t time=%g",Qn,QInt,CtrlVar.time))
            % hold off


            [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,F1.x(BoundaryNodes),F1.y(BoundaryNodes),qw1x(BoundaryNodes),qw1y(BoundaryNodes));

            % figNP=FindOrCreateFigure("Boundary fluxes") ; clf(figNP);
            % qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
            % [cbar,QuiverHandel,Par]=QuiverColorGHG(xc,yc,qnx,qny,CtrlVar) ;
            % hold on
            % plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            % PlotMuaBoundary(CtrlVar,MUA) ;
            % title(sprintf("Qn=%g  \t QInt=%g \t time=%g",Qn,QInt,CtrlVar.time))
            % hold off

            if ~isempty(FluxGate)


                % II=r>RadiusWaterAdded;
                % aw=F1.aw;
                % aw(II)=0;
                % Int=FEintegrate2D(CtrlVar,MUA,aw) ;
                % QInt=sum(Int) ;


                Fqwx=scatteredInterpolant(F1.x,F1.y,qw1x);
                Fqwy=scatteredInterpolant(F1.x,F1.y,qw1y);
                [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,FluxGate(:,1),FluxGate(:,2),Fqwx,Fqwy);

                qwVector(icount)=Qn ;

                figFG=FindOrCreateFigure("Flux Gate") ; clf(figFG);
                qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
                [cbar,QuiverHandel,Par]=QuiverColorGHG(xc,yc,qnx,qny,CtrlVar) ;
                hold on
                plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,"k--") ; axis equal
                plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')

                PlotMuaBoundary(CtrlVar,MUA) ;
                title(sprintf("$Q_n$=%g $Q_{\\mathrm{int}}$=%g  $t$=%g",Qn,UserVar.QnTheoretical,CtrlVar.time),Interpreter="latex")
                hold off

                figFGt=FindOrCreateFigure("Flux Gate(t)") ; clf(figFGt);
                semilogy(tVector,qwVector/1e9,"ob")
                title(sprintf("$Q_n$=%g $(\\mathrm{km}^3/\\mathrm{yr})$ $Q_{\\mathrm{int}}$=%g $(\\mathrm{km}^3/\\mathrm{yr})$ $t$=%g $(\\mathrm{yr})$",Qn/1e9,UserVar.QnTheoretical/1e9,CtrlVar.time),Interpreter="latex")
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

    
    fprintf("Saving Restart File. \n")
    save("RestartWaterFilmThicknessEquationDriver","UserVar","CtrlVar","MUA","F0","F1","k","eta","tVector","hwMaxVector","qwVector","hwMinVector","hwMaxGroundedVector","hwMaxAfloatVector","FluxGate","ActiveSet","lambda") ;

end

