function [MUA,BCs,BCsphi,F]=PhaseFieldFractureSolver(UserVar,RunInfo,CtrlVar,MUA,F,BCs)


%%
%
% Solves a phase-field fracture problem. 
%
%  
%  Outer solve:   
%
%       Inner solve:
%
%           For Psi0=Psi, refine mesh by repeatedly solving: 
%                  
%           uv=uv(phi)  
%           phi=phi(Psi0)
%
%       end 
%
%       update Psi:
%       Psi=Psi(uv)
%
% end 
%
%%

% currently only spatially constant intact A (ie F.AGlen0), and rhoi allowed



n=F.n(1) ;


Gc=CtrlVar.PhaseFieldFracture.Gc ;
l=CtrlVar.PhaseFieldFracture.l ;


if isempty(F.Psi) 
    F.Psi=zeros(MUA.Nnodes,1) ;
end

if isempty(F.phi) 
    F.phi=zeros(MUA.Nnodes,1) ;  % phi=0, undamaged,
end

% phi=1, fully damaged


nMeshRefinements=CtrlVar.PhaseFieldFracture.MaxMeshRefinements;
nphiUpdates=CtrlVar.PhaseFieldFracture.MaxUpdates ; 

iphiUpdate=0; 

EleSizeMin=CtrlVar.MeshSizeMin;


while true % phi "evolution" loop, ie here the driving term Psi is updated


   
    iMeshRefinements=0 ;

    PlotTitle=sprintf("update %i",iphiUpdate) ;
   

    while true   % mesh refinement loop, here Psi is not updated following a uv and phi solve.
        %

      
        CtrlVar.BCs="-uv-" ; 
        BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs) ;
        lm=UaLagrangeVariables ;


        [F.AGlen,F.rho]=ArhoPFF(CtrlVar,F.phi,F.rho0,F.rhow,F.AGlen0,n) ;
        [F.s,F.h]=sPFF(CtrlVar,F.S,F.b,F.rho0,F.rhow,F.phi);  % redefine upper surface s, to reflect changes in effective density



        [UserVar,RunInfo,F,lm,Kuv,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;

        

        %  phi field

        BCsphi=BoundaryConditions;
        CtrlVar.BCs="-phi-" ; 
        BCsphi=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCsphi) ;


      

        % Psi=zeros(MUA.Nnodes,1) ;  % If I set Psi to zero, the damage field (\phi) does not evolve

        phiLast=F.phi;

        [UserVar,F.phi,lambda,HEmatrix,HErhs]=PFFequation(UserVar,CtrlVar,MUA,BCsphi,Gc,l,F.Psi);

       % PFFdeltaPlots(UserVar,CtrlVar,MUA,F,PlotTitle,F.phi,phiLast) ;



        % Iphi=phi<phiLast;
        % phi(Iphi)=phiLast(Iphi) ; % ir-reversibility

        % [PsiPlot,e,eInt]=StrainRateEnergy(CtrlVar,MUA,F,F.AGlen0) ; % just here for plotting purposes
        % PFFPlots(UserVar,CtrlVar,MUA,F,BCs,BCsphi,F.phi,PsiPlot,e) ;


        iMeshRefinements=iMeshRefinements+1;

        if iMeshRefinements > nMeshRefinements
            fprintf("Exiting element refinement loop. Max number of refinement iterations reached. \n")
            break
        end

        MUAold=MUA;
        phiEle=Nodes2EleMean(MUAold.connectivity,F.phi) ;
        
        Tarea=TriAreaFE(MUA.coordinates,MUA.connectivity);
        EleSize=sqrt(Tarea);

        ElementsToBeRefined   = ( phiEle > 0.5 )  &  ( EleSize > EleSizeMin ) ;
        ElementsToBeCoarsened = ( phiEle < 0.5 )  ; 


        nEleRefine=numel(find(ElementsToBeRefined)) ; 


        fprintf("number of elements refined %i \n",nEleRefine)

        if nEleRefine==0

            fprintf("Exiting element refinement loop. No elements to be refined. \n")
            break

        end

        CtrlVar.MeshRefinementMethod='explicit:local:newest vertex bisection' ; CtrlVar.InfoLevelAdaptiveMeshing=1;
        [MUAnew,RunInfo]=LocalMeshRefinement(CtrlVar,RunInfo,MUAold,ElementsToBeRefined,ElementsToBeCoarsened) ;
        MUA=MUAnew;
        Fnew=DefineF(UserVar,CtrlVar,MUAnew) ;
        OutsideValues=[] ;
        [RunInfo,Fnew.ub,Fnew.vb,Fnew.phi,Fnew.Psi,Fnew.AGlen0,Fnew.rho0]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,F.ub,F.vb,F.phi,F.Psi,F.AGlen0,F.rho0);
        F=Fnew;

    end


    iphiUpdate= iphiUpdate + 1;

    CtrlVar.PhaseFieldFracture.iphiUpdate=iphiUpdate ;  
    

    if iphiUpdate > nphiUpdates
        break
    end

   [F.Psi,e,eInt]=StrainRateEnergy(CtrlVar,MUA,F,F.AGlen0) ; % Update Psi
   PFFPlots(UserVar,CtrlVar,MUA,F,BCs,BCsphi,F.phi,F.Psi,e,PlotTitle) ;

    drawnow

end







end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







































