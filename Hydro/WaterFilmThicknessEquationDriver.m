

ReadData=1;
CalcFluxes=1;
isRestart=1; 

UserVar.Example="-Antarctica-" ;
UserVar.Example="-Dome-Phi-" ;
% UserVar.Example="-Hat-Phi-" ;
CtrlVar=Ua2D_DefaultParameters();
%%

if ReadData  &&~isRestart

    switch UserVar.Example


        case "-Antarctica-"
            UserVar.GeometryInterpolant='../../Interpolants/BedMachineGriddedInterpolants.mat';
            UserVar.SurfaceVelocityInterpolant='../../Interpolants/SurfVelMeasures990mInterpolants.mat';
            UserVar.MeshBoundaryCoordinatesFile='../../Interpolants/MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine';
            fprintf('DefineGeometry: loading file: %-s ',UserVar.GeometryInterpolant)
            load(UserVar.GeometryInterpolant,'FB','Fb','Fs','Frho')
            fprintf(' done \n')
            %load("MeshFile20km-PIG-TWG.mat","MUA")
            load("AntarcticaMUAwith54kElements.mat","MUA") ;

            CtrlVar.TriNodes=6;  MUA=UpdateMUA(CtrlVar,MUA);
            F=UaFields;
            F.x=MUA.coordinates(:,1) ; F.y=MUA.coordinates(:,2) ;
            F.s=Fs(F.x,F.y);
            F.B=FB(F.x,F.y);
            F.b=Fb(F.x,F.y);
            F.rho=920; F.rhow=1030; F.g=9.81/1000;
            F.S=F.s*0 ;
            [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);

            LL=10e3 ;  % Smoothing length scale
            LL=100e3 ;  % Smoothing length scale
            [UserVar,F.s]=HelmholtzEquation([],CtrlVar,MUA,1,LL^2,F.s,0);
            UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s smoothed") ;
            [UserVar,F.b]=HelmholtzEquation([],CtrlVar,MUA,1,LL^2,F.b,0);
            [UserVar,F.B]=HelmholtzEquation([],CtrlVar,MUA,1,LL^2,F.B,0);

            [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);

        case {"-Dome-N-","-Dome-Phi-"}

            %%
            CtrlVar.PlotXYscale=1000;
            DomainSize=100e3 ;
            CtrlVar.MeshSize=DomainSize/20;
            CtrlVar.MeshSizeMin=CtrlVar.MeshSize/2 ;
            CtrlVar.MeshSizeMax=CtrlVar.MeshSize*2 ;
            MeshBoundaryCoordinates=[-DomainSize -DomainSize ; DomainSize -DomainSize ; DomainSize DomainSize ; -DomainSize DomainSize ];
            CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
            [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
            CtrlVar.TriNodes=3;  MUA=UpdateMUA(CtrlVar,MUA);
            FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA); drawnow

            F=UaFields  ; F.x=MUA.coordinates(:,1) ; F.y=MUA.coordinates(:,2) ;
            F.B=zeros(MUA.Nnodes,1) ; F.b=zeros(MUA.Nnodes,1) ; F.S=zeros(MUA.Nnodes,1)-1000 ; F.rho=920; F.rhow=1030; F.g=9.81/1000;
            r=vecnorm([F.x F.y],2,2)  ;
            s0=1000; F.s=s0*(1-sqrt(r/(1.2*DomainSize))) ; F.s(F.s<0)=0;
            [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);
            UaPlots(CtrlVar,MUA,F,F.s) ;


        case {"-Hat-Phi-"}

            %%
            CtrlVar.PlotXYscale=1000;
            DomainSize=100e3 ;
            CtrlVar.MeshSize=DomainSize/20;
            CtrlVar.MeshSizeMin=CtrlVar.MeshSize/2 ;
            CtrlVar.MeshSizeMax=CtrlVar.MeshSize*2 ;
            MeshBoundaryCoordinates=[-DomainSize -DomainSize ; DomainSize -DomainSize ; DomainSize DomainSize ; -DomainSize DomainSize ];
            CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
            [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
            CtrlVar.TriNodes=6;  MUA=UpdateMUA(CtrlVar,MUA);
            FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA); drawnow

            F=UaFields  ; F.x=MUA.coordinates(:,1) ; F.y=MUA.coordinates(:,2) ;
            F.S=zeros(MUA.Nnodes,1) ; F.rho=920; F.rhow=1030; F.g=9.81/1000;
            r=vecnorm([F.x F.y],2,2)  ;

            s0=1000; F.s=s0*(1-sqrt(r/(1.2*DomainSize))) ; F.s(F.s<0)=0;
            b0=500; F.b=b0*(1-sqrt(r/(1.2*DomainSize))).*sin(2*pi*F.x/DomainSize) ; F.b(F.b<0)=0;
            F.B=F.b;

            [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);
            UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s") ;
            UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="b") ;






            %%
    end


end

%%
nTimeSteps=2000;   CtrlVar.dt=10;
nPlotStep=10; 
hwMaxVector=nan(nTimeSteps,1);
hwMinVector=nan(nTimeSteps,1);
tVector=nan(nTimeSteps,1);
icount=1;


% CtrlVar.GWE.Variable="-phi-" ;
% CtrlVar.GWE.Variable="-N-" ;
CtrlVar.GWE.Variable="-hw-" ;


if CalcFluxes


    dN=zeros(MUA.Nnodes,1);  dlambda=[];
    CtrlVar.time=0;  F.time=0;

    if isRestart
        load("RestartWaterFilmThicknessEquationDriver","UserVar","CtrlVar","MUA","F0","F1","k")
    else

        aw=zeros(MUA.Nnodes,1)+0.1 ;
        hmin=300;
        II=F.h<hmin;
        aw(II)=0 ; % set water input to zero where the region is ice free.
        F.aw=aw;

        F.hw=zeros(MUA.Nnodes,1)+1 ;    % Initial water film thickness
        k=zeros(MUA.Nnodes,1)+1e2;

        F0=F ; F1=F ;
    end

   
    for Isteps=1:nTimeSteps

        F0.hw=F1.hw;

        [UserVar,hw1,Phi1,uw1,vw1,RR,KK]=WaterFilmThicknessEquation(UserVar,CtrlVar,MUA,F0,F1,k);

        % speed=sqrt(uw1.*uw1+vw1.*vw1) ;
        % l=sqrt(2*MUA.EleAreas);
        % dtcritical=min(l)./max(speed+eps);
        % 
        % fprintf("CFL dt=%f \n",dtcritical)

        F1.hw=hw1;
        F1.time=F1.time+CtrlVar.dt ;
        CtrlVar.time=F1.time ;

        Phi1=F1.g.* ( (F1.rhow-F1.rho).*F1.B + F1.rho.*F1.s) ;
        
        phi1=Phi1+F1.g.*(F1.rhow-F1.rho).*F1.hw ;


        [dphi1dx,dphi1dy]=gradUa(CtrlVar,MUA,phi1) ;
        qwx1=-F1.hw.*k.*dphi1dx;  qwy1=-F1.hw.*k.*dphi1dy;  % Achtung, this implies a boundary condition, compare with the integration points


        hwMaxVector(icount)=max(F1.hw) ;
        hwMinVector(icount)=min(F1.hw) ;
        tVector(icount)=F1.time;
        icount=icount+1;

        %% figures
        if mod(Isteps,nPlotStep)==0
            [~,xGL,yGL]=UaPlots(CtrlVar,MUA,F1,F1.hw,FigureTitle="hw",CreateNewFigure=true) ;
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
            QuiverColorGHG(F1.x,F1.y,uw1,vw1,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            title(sprintf("$\\mathbf{v}_w$ time=%g",CtrlVar.time),Interpreter="latex")
            hold off

            figqw=FindOrCreateFigure("(qwx,qwy)") ; clf(figqw) ;
            QuiverColorGHG(F1.x,F1.y,qwx1,qwy1,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            title(sprintf("$\\mathbf{q}_w$ time=%g",CtrlVar.time),Interpreter="latex")
            hold off

            BoundaryNodes=MUA.Boundary.EdgeCornerNodes ;
            BoundaryNodes=[BoundaryNodes;BoundaryNodes(1)] ;
            BoundaryNodes=flipud(BoundaryNodes) ;

            Int=FEintegrate2D(CtrlVar,MUA,F1.aw) ;
            QInt=sum(Int) ;
            [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,F1.x(BoundaryNodes),F1.y(BoundaryNodes),qwx1(BoundaryNodes),qwy1(BoundaryNodes));
            figNP=FindOrCreateFigure("Boundary fluxes") ; clf(figNP);

            qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
            [cbar,QuiverHandel,Par]=QuiverColorGHG(xc,yc,qnx,qny,CtrlVar) ;
            hold on
            plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
            PlotMuaBoundary(CtrlVar,MUA) ;
            title(sprintf("Qn=%g  \t QInt=%g \t time=%g",Qn,QInt,CtrlVar.time))
            hold off
        end

        %%


    end

  

end
