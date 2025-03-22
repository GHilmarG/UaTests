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

clear PFFPlots

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

% Make initial phi feasible
BCsphi=BoundaryConditions;
CtrlVar.BCs="-phi-" ;
[UserVar,BCsphi]=GetBoundaryConditions(UserVar,CtrlVar,MUA,BCsphi,F) ;

F.phi(BCsphi.hFixedNode)=BCsphi.hFixedValue;


nMeshRefinements=CtrlVar.PhaseFieldFracture.MaxMeshRefinements;
nphiUpdates=CtrlVar.PhaseFieldFracture.MaxUpdates ;

iphiUpdate=0; 
Dphi=nan(100,1); DphiCount=0;
EleSizeMin=CtrlVar.MeshSizeMin;

b0=F.b ; % The 'undamaged' lower surface, possible better here to work with the undamaged ice thickness


CtrlVar.PhaseFieldFracture.iphiUpdate=0;
CtrlVar.PhaseFieldFracture.MeshRefinement=0;

PlotTitle="initial configuration" ;
[F.Psi,e,eInt]=StrainRateEnergy(CtrlVar,MUA,F,F.AGlen0) ; % Update Psi
PFFPlots(UserVar,CtrlVar,MUA,F,BCs,BCsphi,F.phi,F.Psi,e,PlotTitle) ;

while true % phi "evolution" loop, ie here the driving term Psi is updated
   
    iMeshRefinements=0 ;
    iphiUpdate= iphiUpdate + 1;

    


    while true   % mesh refinement loop, here Psi is not updated following a uv and phi solve.
        %

        PlotTitle=sprintf("phi loop %i, mesh refinement %i",iphiUpdate,iMeshRefinements) ;

        CtrlVar.BCs="-uv-" ; 
        % BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs) ;
        [UserVar,BCs]= GetBoundaryConditions(UserVar,CtrlVar,MUA,BCs,F); 
        lm=UaLagrangeVariables ;

        
        %% Solve uv problem: this depends only on phi from the (previous) phase-field solution
        %
        %
        [F.AGlen,F.rho]=ArhoPFF(CtrlVar,F.phi,F.rho0,F.rhow,F.AGlen0,n) ;
        [F.s,F.h]=sPFF(CtrlVar,F.S,b0,F.rho0,F.rhow,F.phi);  % redefine upper surface s, to reflect changes in effective density
        [UserVar,RunInfo,F,lm]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,lm) ;
        %%
        
        %% Solve phase-field problem: This depends only on the previous uv solution, and not on previous phi or Psi
        %  phi field

        BCsphi=BoundaryConditions;
        CtrlVar.BCs="-phi-" ; 
        %[UserVar,BCsphi]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCsphi) ;
        [UserVar,BCsphi]= GetBoundaryConditions(UserVar,CtrlVar,MUA,BCsphi,F); 

        [F.Psi,e,eInt]=StrainRateEnergy(CtrlVar,MUA,F,F.AGlen0) ; % Update Psi

        phiLast=F.phi;
        [UserVar,F.phi]=PFFequation(UserVar,CtrlVar,MUA,BCsphi,Gc,l,F.Psi);

        if ~isfield(CtrlVar.PhaseFieldFracture,"UpdateRatio")
            CtrlVar.PhaseFieldFracture.UpdateRatio=1;
        end
        
        
        dphi=F.phi-phiLast;
        dphiNorm=(dphi'*MUA.M* dphi)/MUA.Area; 
        fprintf("|dphi|=%g \n",dphiNorm)
        DphiCount=DphiCount+1; 
        Dphi(DphiCount)=dphiNorm;

        F.phi= CtrlVar.PhaseFieldFracture.UpdateRatio*F.phi+(1- CtrlVar.PhaseFieldFracture.UpdateRatio)*phiLast;
        
        PFFPlots(UserVar,CtrlVar,MUA,F,BCs,BCsphi,F.phi,F.Psi,e,PlotTitle) ;


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
        % Do I really need to map anything except the velocities?
        %[RunInfo,Fnew.ub,Fnew.vb,Fnew.phi,Fnew.Psi,Fnew.AGlen0,Fnew.rho0]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,F.ub,F.vb,F.phi,F.Psi,F.AGlen0,F.rho0);
        [RunInfo,Fnew.ub,Fnew.vb,Fnew.phi]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,RunInfo,MUAold,MUAnew,OutsideValues,F.ub,F.vb,F.phi);
        F=Fnew;
        b0=F.b; % incorporate into F later

    end


   

    CtrlVar.PhaseFieldFracture.iphiUpdate=iphiUpdate ;  
    

    if iphiUpdate > nphiUpdates
        break
    end

   PlotTitle=sprintf("phi loop %i, mesh refinement %i",iphiUpdate,iMeshRefinements) ;
   [F.Psi,e,eInt]=StrainRateEnergy(CtrlVar,MUA,F,F.AGlen0) ; % Update Psi
   PFFPlots(UserVar,CtrlVar,MUA,F,BCs,BCsphi,F.phi,F.Psi,e,PlotTitle) ;

    drawnow

end



FindOrCreateFigure("Dphi"); 
semilogy(Dphi,'o-r') ; 
xlabel("iterations")
ylabel("$\|\Delta \phi\|$",interpreter="latex")
title("Change in phase field with iteration")


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







































