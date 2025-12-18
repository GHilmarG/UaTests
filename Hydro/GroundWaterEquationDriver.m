

ReadData=1;
CalcFluxes=1;
UserVar.Example="-Antarctica-" ;
UserVar.Example="-Dome-Phi-" ;
% UserVar.Example="-Hat-Phi-" ;
CtrlVar=Ua2D_DefaultParameters();
%%

if ReadData

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

    hw=1 ; k=1 ;

    [dsdx,dsdy]=gradUa(CtrlVar,MUA,F.s) ;
    [dbdx,dbdy]=gradUa(CtrlVar,MUA,F.b) ;

    cx=k.*hw.*(F.rhow-F.rho).*F.g.*dbdx - F.rho*F.g*dsdx;
    cy=k.*hw.*(F.rhow-F.rho).*F.g.*dbdy - F.rho*F.g*dsdy;


  


    figc=FindOrCreateFigure("grad phi0") ;
    CtrlVar.RelativeVelArrowSize=1;
    [cbar,QuiverHandel,Par]=QuiverColorGHG(F.x,F.y,cx,cy,CtrlVar) ;
    hold on
%    plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')

    PlotMuaBoundary(CtrlVar,MUA) ;

end

%%
nTimeSteps=200;   CtrlVar.dt=1e-2;

NVector=nan(nTimeSteps,1);
phiVector=nan(nTimeSteps,1);
tVector=nan(nTimeSteps,1);
icount=1;


CtrlVar.GWE.Variable="-phi-" ; 
% CtrlVar.GWE.Variable="-N-" ; 

if CalcFluxes


    F.aw=zeros(MUA.Nnodes,1)+0.1 ;
    
    Phi=F.g.* ( (F.rhow-F.rho).*F.b + F.rho.*F.s) ;   % does not change, if s and b do not
    F.N=zeros(MUA.Nnodes,1)-Phi; 


    F.phi=zeros(MUA.Nnodes,1)+F.g*F.rhow.*F.b ; 

    K=zeros(MUA.Nnodes,1)+1e5;
    Sw=zeros(MUA.Nnodes,1)+0.1;  Sw=Sw./(F.g.*F.rhow) ;

    dN=zeros(MUA.Nnodes,1);  dlambda=[];
    
    CtrlVar.time=0;  F.time=0; 

    F0=F ; F1=F ;

    for Isteps=1:nTimeSteps

        F0.N=F1.N ; % update
        F0.phi=F1.phi; 


        [UserVar,phi1,Phi1,N1,RR,KK]=GroundWaterEquation(UserVar,CtrlVar,MUA,F0,F1,K,Sw) ;
        
        F1.N=N1;
        F1.phi=phi1 ; 
        F1.time=F1.time+CtrlVar.dt ; 
        CtrlVar.time=F1.time ; 

        % I = F.x < -2000e3 ; F1.N(I)=0 ;

        [~,xGL,yGL]=UaPlots(CtrlVar,MUA,F1,F1.phi,FigureTitle="phi",CreateNewFigure=true) ;
        title(sprintf("$\\phi$ time=%g",CtrlVar.time),Interpreter="latex")

        UaPlots(CtrlVar,MUA,F1,Phi1,FigureTitle="Phi",CreateNewFigure=true)
        title(sprintf("$\\Phi$ time=%g",CtrlVar.time),Interpreter="latex")

        UaPlots(CtrlVar,MUA,F1,F1.N,FigureTitle="F1.N",CreateNewFigure=true)
        title(sprintf("$N$ time=%g",CtrlVar.time),Interpreter="latex")




        DN=F1.N-F0.N;
        UaPlots(CtrlVar,MUA,F1,DN,FigureTitle="N1-N0",CreateNewFigure=true)
        hold on
        [DBmax,II]=maxk(abs(DN),10);
        plot(F1.x(II)/CtrlVar.PlotXYscale,F1.y(II)/CtrlVar.PlotXYscale,'or',MarkerFaceColor="r")
        title(sprintf("N1-N0 at time=%g",CtrlVar.time))


        % Flux based on Phi alone
        [dPhidx,dPhidy]=gradUa(CtrlVar,MUA,Phi1) ;
        qxPhi=-K.*dPhidx ; qyPhi=-K.*dPhidy ;
        figP=FindOrCreateFigure("Phi flux") ; clf(figP) ;
        [cbar,QuiverHandel,Par]=QuiverColorGHG(F1.x,F1.y,qxPhi,qyPhi,CtrlVar) ;
        hold on
        plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
        PlotMuaBoundary(CtrlVar,MUA) ;
        title(sprintf("$\\Phi$-flux time=%g",CtrlVar.time),Interpreter="latex")
        hold off

        % Flux based on N alone
        [dNdx,dNdy]=gradUa(CtrlVar,MUA,F1.N) ;
        qxN=-K.*dNdx ; qyN=-K.*dNdy ;
        figN=FindOrCreateFigure("N flux") ; clf(figN) ;
        [cbar,QuiverHandel,Par]=QuiverColorGHG(F1.x,F1.y,qxN,qyN,CtrlVar) ;
        hold on
        plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
        PlotMuaBoundary(CtrlVar,MUA) ;
        title(sprintf("$N$-flux time=%g",CtrlVar.time),Interpreter="latex")
        hold off

        % Flux based on phi
        figphiq=FindOrCreateFigure("Combined flux") ; clf(figphiq);
        [dphidx,dphidy]=gradUa(CtrlVar,MUA,F1.phi) ;
        qxphi=-K.*dphidx ; qyphi=-K.*dphidy ;
        [cbar,QuiverHandel,Par]=QuiverColorGHG(F1.x,F1.y,qxphi,qyphi,CtrlVar) ;
        hold on
        plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
        PlotMuaBoundary(CtrlVar,MUA) ;
        title(sprintf("$\\phi$-flux time=%g",CtrlVar.time),Interpreter="latex")
        hold off


        %  if  contains(UserVar.Example,"-Dome-")

        II=abs(F1.y)<1000;
        figNp=FindOrCreateFigure("N profile")  ; clf(figNp) ;
        plot(F1.x(II)/CtrlVar.PlotXYscale,F1.N(II),'.r')
        xlabel("x") ; ylabel("N")
        title(sprintf("time=%3.1f",CtrlVar.time))

       
        NVector(icount)=max(abs(F1.N)) ;
        phiVector(icount)=max(abs(F1.phi)) ;
        tVector(icount)=F1.time;
        icount=icount+1;

        figNp=FindOrCreateFigure("max(N)(t)")  ; clf(figNp) ;
        plot(tVector,NVector,"-or")
        title(sprintf("$N$"),Interpreter="latex") 
 
        figphit=FindOrCreateFigure("max(phi)(t)")  ; clf(figphit) ;
        plot(tVector,phiVector,"-or")
        title(sprintf("$\\phi$"),Interpreter="latex") 
        % end

        BoundaryNodes=MUA.Boundary.EdgeCornerNodes ;
        BoundaryNodes=[BoundaryNodes;BoundaryNodes(1)] ;
        BoundaryNodes=flipud(BoundaryNodes) ;

        Int=FEintegrate2D(CtrlVar,MUA,F1.aw) ;
        QInt=sum(Int) ;
        [Qn,Qt,qn,qt,xc,yc,normal]=PathIntegral(CtrlVar,F.x(BoundaryNodes),F.y(BoundaryNodes),qxphi(BoundaryNodes),qyphi(BoundaryNodes));
        figNP=FindOrCreateFigure("Boundary fluxes") ; clf(figNP);

        qnx=qn.*normal(:,1) ; qny=qn.*normal(:,2) ;
        [cbar,QuiverHandel,Par]=QuiverColorGHG(xc,yc,qnx,qny,CtrlVar) ;
        hold on
        plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
        PlotMuaBoundary(CtrlVar,MUA) ;
        title(sprintf("Qn=%g  \t QInt=%g \t time=%g",Qn,QInt,CtrlVar.time))
        hold off


        [min(F1.N-F0.N) max(F1.N-F0.N) median(abs(F1.N-F0.N))]
    end


UaPlots(CtrlVar,MUA,F1,phi1-F1.g*F1.rhow.*F1.b,FigureTitle="phi - g rhow b") 


end
