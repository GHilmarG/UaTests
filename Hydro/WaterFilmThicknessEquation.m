





function [UserVar,hw1,ActiveSet,lambda]=WaterFilmThicknessEquation(UserVar,CtrlVar,MUA,F0,F1,k,eta,ActiveSet,lambda)

narginchk(9,9)
nargoutchk(4,4)

%% Water film thickness equation
%
%
% $$\partial_t h_w -  \nabla \cdot ( k h_w \nabla \Phi )  - \nabla \cdot (\kappa h_w \nabla h_w) = a_w $$
%
% where
%
% $$\Phi = (\rho_w-\rho) g \nabla B - \rho g \nabla s  $$
%
% $$N=0 $$
%
%%


if  CtrlVar.WaterFilm.Assembly=="-A-"
    CtrlVar.WaterFilm.AdvectionFlag=1;
    CtrlVar.WaterFilm.DiffusionFlag=0;
elseif CtrlVar.WaterFilm.Assembly=="-AD-"
    CtrlVar.WaterFilm.AdvectionFlag=1;
    CtrlVar.WaterFilm.DiffusionFlag=1;
end



ActiveSetUpdated=ActiveSet; 
nActiveSetDeactivations=nan ; 

BCs=BoundaryConditions ;
[UserVar,BCs]=GetBoundaryConditions(UserVar,CtrlVar,MUA,BCs,F1) ;
MLC=BCs2MLC(CtrlVar,MUA,BCs);
LL=MLC.hL ; cc=MLC.hRhs ;
BCsUser=BCs;


nActiveSetIterations=CtrlVar.WaterFilm.MaxActiveSetIterations;
useActiveSetMethod=CtrlVar.WaterFilm.useActiveSetMethod;

if ~useActiveSetMethod
    nActiveSetIterations=1;
end


for I=1:nActiveSetIterations

    if useActiveSetMethod
        ActiveSetAdditions=find(F1.hw<CtrlVar.WaterFilm.ThickMin) ;
        nActiveSetAdditions=numel(ActiveSetAdditions) ;

        fprintf("Active Set iteration: #%i \t Added=%i \t Removed=%i \n",I,nActiveSetAdditions,nActiveSetDeactivations)

        lambda=[lambda;ActiveSetAdditions*0] ;
        ActiveSet=union(ActiveSetAdditions,ActiveSetUpdated);
        nActiveSet=numel(ActiveSet); 
        if nActiveSetAdditions==0 && nActiveSetDeactivations==0
            fprintf(" Breaking out of active set iteration #%i, with %i active constraints, because number of new activated and deactivated constraints is %i and %i, respectivily. \n",I,nActiveSet,nActiveSetAdditions,nActiveSetDeactivations)
            break
        end

      

        ActiveSet=setdiff(ActiveSet,BCsUser.hFixedNode) ;       % Don't add a node to the active set if it already has a user-defined BCs.

        if ~isempty(ActiveSet)

            BCs.hFixedNode=[BCsUser.hFixedNode;ActiveSet];
            BCs.hFixedValue=[BCsUser.hFixedValue;ActiveSet*0+CtrlVar.WaterFilm.ThickMin];

        end

        MLC=BCs2MLC(CtrlVar,MUA,BCs);
        LL=MLC.hL ; cc=MLC.hRhs ;

    end

    if ~isempty(LL)
        BCsRes=LL*F1.hw-cc ;
        if norm(BCsRes) > 1e-6
            F1.hw(BCs.hFixedNode)= BCs.hFixedValue;
            F0.hw(BCs.hFixedNode)= BCs.hFixedValue;
            %        F1.hw=LL\cc;   % make feasable
        end
        if numel(lambda)~=numel(cc)
            lambda=cc*0;
        end
    end


    % if CtrlVar.WaterFilm.Assembly=="-AD-"    || CtrlVar.WaterFilm.Assembly=="-A-"   
    %     [UserVar,RR,KK]=WaterFilmThicknessEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k,eta,uw0,vw0,uw1,vw1);
    % elseif CtrlVar.WaterFilm.Assembly=="-D-"   % "-AD-"   either diffusive only (D) or advective/diffusive "-AD-"
    %     [UserVar,RR,KK]=WaterFilmThicknessDiffusionEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k,eta,uw0,vw0,uw1,vw1);
    % else
    %     error("case not found")
    % end

    x=F1.hw;
    fun =@(x) lsqUaFunc(x,UserVar,CtrlVar,MUA,F0,F1,k,eta)  ;

    CtrlVar.lsqUa.CostMeasure="r2";
    CtrlVar.lsqUa.isLSQ=false ;
    [hw1,lambda,R2,r2]= lsqUa(CtrlVar,fun,x,lambda,LL,cc) ;
    F1.hw=hw1 ;

    if useActiveSetMethod
        if ~isempty(lambda)

            lambdaActiveSet=lambda(1+numel(lambda)-numel(ActiveSet):end) ;

            II=lambdaActiveSet<0 ;
            ActiveSetUpdated=ActiveSet(II) ;
            lambda=lambda(II);
            % If this set difference is empty, then no constraints were deactivated
            DeactivatedConstraints=setxor(ActiveSet,ActiveSetUpdated)         ;
            nActiveSetDeactivations=numel(DeactivatedConstraints);
        else
            nActiveSetDeactivations=0;
        end
    end

end



end


