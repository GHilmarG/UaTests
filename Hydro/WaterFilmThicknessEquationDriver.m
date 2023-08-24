function WaterFilmThicknessEquationDriver

ReadData=1;
CalcFluxes=1;
isRestart=0;

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

FluxGate=[]; xGL=[] ; yGL=[] ;

UserVar.Example="-Antarctica-" ;
UserVar.Example="-Dome-Phi-" ;
UserVar.Example="-Dome-hw-A-" ;
UserVar.Example="-Island-hw-A-" ;
% UserVar.Example="-Hat-Phi-" ;
CtrlVar=Ua2D_DefaultParameters();
%%
nTimeSteps=20000;
maxTime=5000;
CtrlVar.dt=100;
qw1x=0 ; qw1y=0 ;


CtrlVar.InfoLevelBackTrack=0;  CtrlVar.InfoLevelNonLinIt=10 ;  CtrlVar.doplots=1 ;

CtrlVar.WaterFilm.ThickMin=0.01 ;  % can be small, but not zero
CtrlVar.WaterFilm.qwAfloatMultiplier=10;
CtrlVar.WaterFilm.qwAfloatTreshold=100 ; % b-B distance above which melt-feedback is applied
CtrlVar.lsqUa.gTol=1e-6;

CtrlVar.WaterFilm.MaxActiveSetIterations=10;
CtrlVar.WaterFilm.PotentialExtended=true;
CtrlVar.lsqUa.ItMax=20;
CtrlVar.WaterFilm.useActiveSetMethod=true;
CtrlVar.WaterFilm.Barrier=0 ;
CtrlVar.WaterFilm.Penalty=0 ;



QnTheoretical=nan;
PlotWaterFilmFlux=false;

nPlotStep=1;

if ReadData  &&~isRestart

    switch UserVar.Example


        case "-Antarctica-"

            CtrlVar.WaterFilm.Assembly="-D-";

            UserVar.GeometryInterpolant='../../Interpolants/BedMachineGriddedInterpolants.mat';
            UserVar.SurfaceVelocityInterpolant='../../Interpolants/SurfVelMeasures990mInterpolants.mat';
            UserVar.MeshBoundaryCoordinatesFile='../../Interpolants/MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine';

            if ~exist("Fb","var")
                fprintf('DefineGeometry: loading file: %-s ',UserVar.GeometryInterpolant)
                load(UserVar.GeometryInterpolant,'FB','Fb','Fs','Frho')
                fprintf(' done \n')
            end

            load("..\Calving\PIG-TWG\MeshFile20km-PIG-TWG.mat","MUA")
            % load("AntarcticaMUAwith54kElements.mat","MUA") ;

            CtrlVar.TriNodes=3;  MUA=UpdateMUA(CtrlVar,MUA);
            F=UaFields;
            F.x=MUA.coordinates(:,1) ; F.y=MUA.coordinates(:,2) ;
            F.s=Fs(F.x,F.y);
            F.B=FB(F.x,F.y);
            F.b=Fb(F.x,F.y);
            F.rho=920; F.rhow=1030; F.g=9.81/1000;
            F.S=F.s*0 ;
            [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);

            % LL=10e3 ;  % Smoothing length scale
            % % LL=100e3 ;  % Smoothing length scale
            % [UserVar,F.s]=HelmholtzEquation(UserVar,CtrlVar,MUA,1,LL^2,F.s,0);
            %
            % [UserVar,F.b]=HelmholtzEquation(UserVar,CtrlVar,MUA,1,LL^2,F.b,0);
            % [UserVar,F.B]=HelmholtzEquation(UserVar,CtrlVar,MUA,1,LL^2,F.B,0);
            %
            % [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);
            %
            % UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="B smoothed") ;
            % UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="b smoothed") ;
            % UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s smoothed") ;

            aw=zeros(MUA.Nnodes,1);

            % Box=[-1600 -1500 -200 -100]*1000;
            % Box=[-1500 -1400 -500 -400]*1000;
            % In=IsInBox(Box,F.x,F.y) ;
            % aw(In)=100;
            UaPlots(CtrlVar,MUA,F,aw,FigureTitle="aw")


            F.aw=aw;
            F.hw=zeros(MUA.Nnodes,1)+0.01;    % Initial water film thickness
            k=zeros(MUA.Nnodes,1)+1e6;
            eta=zeros(MUA.Nnodes,1);
            CtrlVar.dt=0.001;



            FluxGate=[-1550 -388 ; -1500 -543]*1000;  Npoints=300 ; FluxGate=interparc(Npoints,FluxGate(:,1),FluxGate(:,2),'linear');
            hold on ;
            plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,"o-") ; axis equal


        case {"-Dome-N-","-Dome-Phi-","-Dome-hw-A-"}

            %%
            CtrlVar.PlotXYscale=1000;
            l=100e3 ;
            CtrlVar.MeshSize=l/10;
            CtrlVar.MeshSize=l/20;
            CtrlVar.MeshSize=l/40;

            CtrlVar.MeshSizeMin=CtrlVar.MeshSize/2 ;
            CtrlVar.MeshSizeMax=CtrlVar.MeshSize*2 ;
            MeshBoundaryCoordinates=[-l -l ; l -l ; l l ; -l l ];
            CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
            [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
            CtrlVar.TriNodes=3;  MUA=UpdateMUA(CtrlVar,MUA);
            FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA); drawnow

            F=UaFields  ; F.x=MUA.coordinates(:,1) ; F.y=MUA.coordinates(:,2) ;

            % Geometry
            F.B=zeros(MUA.Nnodes,1) ; F.b=zeros(MUA.Nnodes,1) ; F.S=zeros(MUA.Nnodes,1)-1000 ; F.rho=920; F.rhow=1030; F.g=9.81/1000;
            r=vecnorm([F.x F.y],2,2)  ;
            s0=1000; F.s=s0*(1-sqrt(r/(1.2*l))) ; F.s(F.s<0)=0;
            [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);
            UaPlots(CtrlVar,MUA,F,F.s) ;

            % Initial water film thickness
            F.hw=zeros(MUA.Nnodes,1)+10 ;    % Initial water film thickness

            % distributed water input/output
            F.aw=zeros(MUA.Nnodes,1)+0;
            II=r>75e3;
            F.aw(II)=-10 ; % get rid of all water, this could be done internally as a feedback

            %
            k=zeros(MUA.Nnodes,1)+1e2;
            eta=zeros(MUA.Nnodes,1)+1e2;

            CtrlVar.WaterFilm.Barrier=0;
            CtrlVar.WaterFilm.Penalty=1 ;



        case "-Island-hw-A-"

            CtrlVar.PlotXYscale=1000;
            l=100e3 ;
            dl=l/5;
            dl=l/10;
            % dl=l/20;
            dl=l/30;
             dl=l/40;
            % dl=l/60;
            % dl=l/80;
            % dl=l/100;
            dl=2000;
            dl=500;

            CtrlVar.MeshSize=dl;

            CtrlVar.MeshSizeMin=CtrlVar.MeshSize/2 ;
            CtrlVar.MeshSizeMax=CtrlVar.MeshSize*2 ;
            MeshBoundaryCoordinates=[-l -l ; l -l ; l l ; -l l ];
            CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
            [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
            CtrlVar.TriNodes=3;  MUA=UpdateMUA(CtrlVar,MUA);
            FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA); drawnow

            F=UaFields  ; F.x=MUA.coordinates(:,1) ; F.y=MUA.coordinates(:,2) ;

            % Geometry
            r=vecnorm([F.x F.y],2,2)  ;
            F.B=-2000*(r/l).^2 ;
            F.b=F.B;
            F.S=zeros(MUA.Nnodes,1);
            F.rho=920; F.rhow=1030; F.g=9.81/1000;

            lmax=sqrt(2)*l ;
            h0=1000; hmin=100; h=h0*(1-sqrt(r/lmax))+hmin ;% h(h<hmin)=0;
            F.h=h;

            [F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow) ;
            %[F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);



            figure ; Plot_sbB(CtrlVar,MUA,F.s,F.b,F.B) ;
            % Initial water film thickness
            
            F.hw=zeros(MUA.Nnodes,1)+10 ;    % Initial water film thickness

            % distributed water input/output
            aw=10;
            F.aw=zeros(MUA.Nnodes,1)+aw;
            
            
            RadiusWaterAdded=30e3 ;
            RadiusWaterAdded=nan ;
            RadiusFluxGate=35e3; 
            
            
            if ~isnan(RadiusWaterAdded)
                F.aw(r>RadiusWaterAdded)=0;
                QnTheoretical=pi*RadiusWaterAdded^2*aw ;
            else
                QnTheoretical=pi*RadiusFluxGate^2*aw ;
            end
            


            k=zeros(MUA.Nnodes,1)+1e2;
            eta=zeros(MUA.Nnodes,1)+1e3;

            CtrlVar.WaterFilm.Barrier=0;
            CtrlVar.WaterFilm.Penalty=1 ;


            [cbar,xGL,yGL]=UaPlots(CtrlVar,MUA,F,F.s) ;
            % Npoints=300 ; FluxGate=interparc(Npoints,FluxGate(:,1),FluxGate(:,2),'linear');

            % FluxGate=[xGL(:) yGL(:)];
            angle=linspace(0,2*pi,500); angle=angle(:);

            FluxGate=RadiusFluxGate*[sin(-angle) cos(-angle) ];

            hold on ;

            plot(FluxGate(:,1)/CtrlVar.PlotXYscale,FluxGate(:,2)/CtrlVar.PlotXYscale,"o-") ; axis equal

            %%
    end


    icount=0;

end


if  contains(UserVar.Example,"-A-")
    CtrlVar.WaterFilm.Assembly="-A-" ;
    CtrlVar.Tracer.SUPG.Use=1;
elseif contains(UserVar.Example,"-AD-")
    CtrlVar.WaterFilm.Assembly="-AD-";
else
    CtrlVar.WaterFilm.Assembly="-D-";
    CtrlVar.Tracer.SUPG.Use=0;
end




% CtrlVar.GWE.Variable="-phi-" ;
% CtrlVar.GWE.Variable="-N-" ;
CtrlVar.GWE.Variable="-hw-" ;

ActiveSet=[];
lambda=[];

if CalcFluxes



    if isRestart


        
        load("RestartWaterFilmThicknessEquationDriver","UserVar","CtrlVar","MUA","F0","F1","k","eta","tVector","hwMaxVector","qwVector","hwMinVector","FluxGate")
        %FluxGate=[-1550 -388 ; -1500 -543]*1000;   Npoints=300 ; FluxGate=interparc(Npoints,FluxGate(:,1),FluxGate(:,2),'linear');
        %qwVector=tVector*0+nan;

        icount=numel(tVector) ;
        hwMinVector=[hwMinVector;hwMinVector+nan];
        hwMaxVector=[hwMaxVector;hwMaxVector+nan];
        qwVector=[qwVector;qwVector+nan];
        tVector=[tVector;tVector+nan];
    else


        CtrlVar.time=0;  F.time=0;



        F0=F ; F1=F ;
        hwMaxVector=nan(nTimeSteps,1);
        hwMinVector=nan(nTimeSteps,1);
        qwVector=nan(nTimeSteps,1);
        tVector=nan(nTimeSteps,1);
    end

    dN=zeros(MUA.Nnodes,1);  dlambda=[];

%% Initialize (uw,vw)

[F0.uw,F0.vw]=WaterFilmVelocities(CtrlVar,MUA,F0,k) ; 
[F1.uw,F1.vw]=WaterFilmVelocities(CtrlVar,MUA,F1,k) ; 




    for Isteps=1:nTimeSteps

        F0.hw=F1.hw;
        qw0x=qw1x ; qw0y=qw1y ;

        [UserVar,hw1,ActiveSet,lambda]=WaterFilmThicknessEquation(UserVar,CtrlVar,MUA,F0,F1,k,eta,ActiveSet,lambda) ;



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
        tVector(icount)=F1.time;


        %% figures
        if mod(Isteps,nPlotStep)==0

            [~,xGL,yGL]=UaPlots(CtrlVar,MUA,F1,F1.hw,FigureTitle="hw",CreateNewFigure=true) ;
            % IhwNeg=F1.hw<0 ; hold on ; plot(F1.x(IhwNeg)/CtrlVar.PlotXYscale,F1.y(IhwNeg)/CtrlVar.PlotXYscale,'or')
            title(sprintf("$h_w$ time=%g",CtrlVar.time),Interpreter="latex")

            [~,xGL,yGL]=UaPlots(CtrlVar,MUA,F1,F1.hw-F0.hw,FigureTitle="Delta hw",CreateNewFigure=true) ;
            title(sprintf("$\\Delta h_w$ time=%g",CtrlVar.time),Interpreter="latex")

            figNp=FindOrCreateFigure("max(hw)(t)")  ; clf(figNp) ;
            plot(tVector,hwMaxVector,"-ob")
            hold on
            plot(tVector,hwMinVector,"-*r")
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
            QuiverColorGHG(F1.x,F1.y,qw1x-qw0x,qw1y-qw0y,CtrlVar) ;
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

            [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,F1.x(BoundaryNodes),F1.y(BoundaryNodes),qw1x(BoundaryNodes),qw1y(BoundaryNodes));
            figNP=FindOrCreateFigure("Boundary fluxes") ; clf(figNP);
            qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
            [cbar,QuiverHandel,Par]=QuiverColorGHG(xc,yc,qnx,qny,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            title(sprintf("Qn=%g  \t QInt=%g \t time=%g",Qn,QInt,CtrlVar.time))
            hold off


            [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,F1.x(BoundaryNodes),F1.y(BoundaryNodes),qw1x(BoundaryNodes),qw1y(BoundaryNodes));

            figNP=FindOrCreateFigure("Boundary fluxes") ; clf(figNP);
            qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
            [cbar,QuiverHandel,Par]=QuiverColorGHG(xc,yc,qnx,qny,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            title(sprintf("Qn=%g  \t QInt=%g \t time=%g",Qn,QInt,CtrlVar.time))
            hold off

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
                title(sprintf("$Q_n$=%g $Q_{\\mathrm{int}}$=%g  $t$=%g",Qn,QnTheoretical,CtrlVar.time),Interpreter="latex")
                hold off

                figFGt=FindOrCreateFigure("Flux Gate(t)") ; clf(figFGt);
                plot(tVector,qwVector/1e9,"ob")
                title(sprintf("$Q_n$=%g $(\\mathrm{km}^3/\\mathrm{yr})$ $Q_{\\mathrm{int}}$=%g $(\\mathrm{km}^3/\\mathrm{yr})$ $t$=%g $(\\mathrm{yr})$",Qn/1e9,QnTheoretical/1e9,CtrlVar.time),Interpreter="latex")
                yline(QnTheoretical/1e9,"--")
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

    save("RestartWaterFilmThicknessEquationDriver","UserVar","CtrlVar","MUA","F0","F1","k","eta","tVector","hwMaxVector","qwVector","hwMinVector","FluxGate","ActiveSet","lambda") ;

end

