function SSDdriver



isRestart=0;


CtrlVar=Ua2D_DefaultParameters();
RestartFileName="RestartFile.mat" ;

UserVar.Example="-Antarctica-" ;
UserVar.Example="-PIG-" ;

CtrlVar.SSD.Dmin=0.0; CtrlVar.SSD.Dmax=0.99;

UserVar.SSD.D=true ;  % evolve damage (D)
UserVar.SSD.uv=true ; % evolve velocities (uv)

%%
warning('off','MATLAB:decomposition:genericError')
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:genericError');
parfevalOnAll(gcp(), @warning, 0, 'off','MATLAB:decomposition:SaveNotSupported');

%%
nTimeSteps=1000;

maxTime=50;
CtrlVar.dt=0.1;


CtrlVar.InfoLevelBackTrack=0;  CtrlVar.InfoLevelNonLinIt=1 ;  CtrlVar.doplots=1 ;


CtrlVar.lsqUa.gTol=1e-5;
CtrlVar.SSD.MaxActiveSetIterations=10;
CtrlVar.lsqUa.ItMax=20;
CtrlVar.SSD.useActiveSetMethod=false;
CtrlVar.SSD.Barrier=0 ;
CtrlVar.SSD.Penalty=0 ;
CtrlVar.SSD.gamma=0.01; 


RunInfo=UaRunInfo;

ActiveSet=[]; lambdaD=[]; l=UaLagrangeVariables; 


if ~isRestart

    if contains(UserVar.Example,"-PIG-")


        CtrlVar.MeshSize=2.5e3 ;
        CtrlVar.MeshSizeMin=0.1*CtrlVar.MeshSize ;
        CtrlVar.MeshSizeMax=10*CtrlVar.MeshSize ;
        [UserVar,MUA]=CreateMeshAndMua(UserVar,CtrlVar);



        F=UaFields;
        F.x=MUA.coordinates(:,1) ; F.y=MUA.coordinates(:,2) ;

        FieldsToBeDefined="";
        [UserVar,F.s,F.b,F.S,F.B,F.rho,F.rhow,F.g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined);
        [F.b,F.h,F.GF]=Calc_bh_From_sBS(CtrlVar,MUA,F.s,F.B,F.S,F.rho,F.rhow);
        F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);

        UaPlots(CtrlVar,MUA,F,F.B,FigureTitle="B") ;
        UaPlots(CtrlVar,MUA,F,F.b,FigureTitle="b") ;
        UaPlots(CtrlVar,MUA,F,F.s,FigureTitle="s",PlotUnderMesh=true) ; clim([0 150]) ;


        [F.ub,F.vb]=DefineVelocities(UserVar,CtrlVar,MUA,F);

        if UserVar.SSD.uv

            uvBCs=BoundaryConditions ;
            UserVar.BCs="-uv-" ;
            [UserVar,uvBCs]=GetBoundaryConditions(UserVar,CtrlVar,MUA,uvBCs,F) ;
            UserVar.BCs="-D-" ;

            [UserVar,F.AGlen,F.n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F) ;
            [UserVar,F.C,F.m]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F);

            UaPlots(CtrlVar,MUA,F,log10(F.C),FigureTitle=" log10(C)")
            UaPlots(CtrlVar,MUA,F,log10(F.AGlen),FigureTitle=" log10(A)")

            [UserVar,RunInfo,F,l]= uv(UserVar,RunInfo,CtrlVar,MUA,uvBCs,F,l) ;


        else
            [F.ub,F.vb]=DefineVelocities(UserVar,CtrlVar,MUA,F);
        end

        UaPlots(CtrlVar,MUA,F,"-uv-")

        eta=zeros(MUA.Nnodes,1) ;
        F.D=zeros(MUA.Nnodes,1) ;

        % inBox=IsInBox([-1600e3 -1580e3 -260e3 -240e3],F.x,F.y) ;  F.D(inBox)=1;
        
        cbar=UaPlots(CtrlVar,MUA,F,F.D,FigureTitle=" Damage ") ; title(sprintf("Damage at t=%g",CtrlVar.dt),Interpreter="latex")
        title(cbar,"$\mathcal{D}$",Interpreter="latex")


        F.aD=zeros(MUA.Nnodes,1) ;





        CtrlVar.Tracer.SUPG.Use=1;



    else

        error(" case not found ")

    end

elseif isRestart


    load(RestartFileName)

end

%%

F.n=zeros(MUA.Nnodes,1)+3; F.AGlen=AGlenVersusTemp(-20)+zeros(MUA.Nnodes,1) ;
[d,DNye]=NyeCrevasse(UserVar,CtrlVar,MUA,F) ; 

cbar=UaPlots(CtrlVar,MUA,F,d,FigureTitle="Nye d")  ; title(cbar,"$(m)$",Interpreter="latex") ; title("Crevasse depth $d=\tau_1/(\rho g)$",Interpreter="latex")


cbar=UaPlots(CtrlVar,MUA,F,DNye,FigureTitle="Nye D")  ; title(cbar,"$\mathcal{D}_{\mathrm{Nye}}$",Interpreter="latex") ; title("Nye Damage $\mathcal{D}=\tau_1/(\rho g h)$",Interpreter="latex")

%%%%%
F0=F ; F1=F; 
A0=F.AGlen ;

for Isteps=1:nTimeSteps


    % [UserVar,~,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,F1) ;

    F0=F1;


    
    [UserVar,D1,ActiveSet,lambdaD]=SSD(UserVar,CtrlVar,MUA,F0,F1,eta,DNye,ActiveSet,lambdaD) ; 

    D1(D1<CtrlVar.SSD.Dmin)=CtrlVar.SSD.Dmin;
    D1(D1>CtrlVar.SSD.Dmax)=CtrlVar.SSD.Dmax;


    F1.D=D1;

    F1.AGlen=A0./ ((1-D1).^F.n) ;


    if UserVar.SSD.uv

        [UserVar,RunInfo,F1,l]= uv(UserVar,RunInfo,CtrlVar,MUA,uvBCs,F1,l) ; 

        UaPlots(CtrlVar,MUA,F1,"-uv-",FigureTitle=" velocities ") ; title(sprintf("velocities at t=%f",CtrlVar.time),Interpreter="latex")
        F0.ub=F1.ub-F0.ub; F0.vb=F1.vb-F0.vb; % just doing this here for plotting purposes, this will be overwritten when F0 is updated
        UaPlots(CtrlVar,MUA,F0,"-uv-",FigureTitle=" changes in velocities ") ; title(sprintf("velocity changes at t=%f",CtrlVar.time),Interpreter="latex")

    end
    



    CtrlVar.time=CtrlVar.time+CtrlVar.dt; 

    cbar=UaPlots(CtrlVar,MUA,F,D1,FigureTitle=" Damage ") ; title(sprintf("Damage at t=%g",CtrlVar.time),Interpreter="latex")
    title(cbar,"$\mathcal{D}$",Interpreter="latex")

    cbar=UaPlots(CtrlVar,MUA,F1,F1.D,FigureTitle=" Damage ") ; title(sprintf("Damage at t=%g",CtrlVar.time),Interpreter="latex") ; title(cbar,"$\mathcal{D}$",Interpreter="latex")
    cbar=UaPlots(CtrlVar,MUA,F1,F1.D-F0.D,FigureTitle=" Delta Damage Change") ; title(sprintf("Delta Damage at t=%g",CtrlVar.time),Interpreter="latex") ; title(cbar,"$\Delta \mathcal{D}$",Interpreter="latex")

    if CtrlVar.time>=maxTime
        break
    end

end


fprintf("Saving Restart File. \n")
save(RestartFileName)

end

