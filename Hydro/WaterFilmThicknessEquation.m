





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




BCs=BoundaryConditions ;
[UserVar,BCs]=GetBoundaryConditions(UserVar,CtrlVar,MUA,BCs,F1) ;
BCsUser=BCs;

LastAdded=[];
LastDeleted=[];
nActiveSetDeletions=nan ;
nActiveSetAdditions=nan ;


nBCsUser=numel(BCsUser.hFixedNode) ; % These are the number of BCs defined by the user



nActiveSetIterations=CtrlVar.WaterFilm.MaxActiveSetIterations;
useActiveSetMethod=CtrlVar.WaterFilm.useActiveSetMethod;

if ~useActiveSetMethod
    nActiveSetIterations=1;

else

    if ~isempty(ActiveSet)

        BCs.hFixedNode=[BCsUser.hFixedNode;ActiveSet];
        BCs.hFixedValue=[BCsUser.hFixedNode;ActiveSet*0+CtrlVar.WaterFilm.ThickMin];

    end

end


for I=1:nActiveSetIterations

    MLC=BCs2MLC(CtrlVar,MUA,BCs);  LL=MLC.hL ; cc=MLC.hRhs ;

    if ~isempty(LL)
        BCsRes=LL*F1.hw-cc ;
        if norm(BCsRes) > 1e-6
            F1.hw(BCs.hFixedNode)= BCs.hFixedValue;
            F0.hw(BCs.hFixedNode)= BCs.hFixedValue;
            %        F1.hw=LL\cc;   % make feasable
        end
        if numel(lambda) ~= numel(BCs.hFixedNode)
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
    [hw1,lambda]= lsqUa(CtrlVar,fun,x,lambda,LL,cc) ;
    F1.hw=hw1 ;

    if useActiveSetMethod

        if mod(I,2)==1 % add constraints

            ActiveSetAdditionsLogical=F1.hw<CtrlVar.WaterFilm.ThickMin ;
            ActiveSetAdditionsNodes=find(ActiveSetAdditionsLogical) ;
            nActiveSetAdditions=numel(ActiveSetAdditionsNodes) ;

            if nActiveSetAdditions>0
                BCs.hFixedNode=[BCs.hFixedNode;ActiveSetAdditionsNodes];
                BCs.hFixedValue=[BCs.hFixedValue;ActiveSetAdditionsNodes*0+CtrlVar.WaterFilm.ThickMin];
                lambda=[lambda;ActiveSetAdditionsNodes*0] ;
                LastAdded=ActiveSetAdditionsNodes;
            else
                LastAdded=[];
            end



            fprintf("Active Set iteration: #%i \t Added=%i  \n",I,nActiveSetAdditions)

        else  % delete contraints

            if ~isempty(lambda)

                % Here I must know the original number of BCs as defined by the user.
                % The rest is the current active set
                %
                nBCs=numel(BCs.hFixedNode) ;
                nBCsActiveConstraints=nBCs-nBCsUser;

                if nBCsActiveConstraints>0

                    ActiveSetLogical=logical([zeros(nBCsUser,1);ones(nBCsActiveConstraints,1)]) ;
                    ActiveSetDeletionsLogical=lambda>0 & ActiveSetLogical ;
                    nActiveSetDeletions=numel(find(ActiveSetDeletionsLogical));

                    if nActiveSetDeletions>0

                        DeleteCandidates=BCs.hFixedNode(ActiveSetDeletionsLogical);

                        Delete=setdiff(DeleteCandidates,LastAdded) ;
                        [C2,ia,ib]=intersect(BCs.hFixedNode,Delete) ;

                        BCs.hFixedNode(ia)=[];
                        BCs.hFixedValue(ia)=[];
                        lambda(ia)=[];

                        LastDeleted=Delete;
                        nActiveSetDeletions=numel(Delete);
                    else
                        LastDeleted=[];
                        nActiveSetDeletions=0;
                    end

                    fprintf("Active Set iteration: #%i \t Deleted=%i  \n",I,nActiveSetDeletions)


                    AddedThenDeleted=intersect(LastAdded,LastDeleted);
                    if ~isempty(AddedThenDeleted)
                        fprintf("nodes deleted that were previously added: \n")
                        AddedThenDeleted'
                    end


                end
            else
                LastDeleted=[];
                nActiveSetDeletions=0;
            end

        end

        nBCs=numel(BCs.hFixedNode) ;
        nBCsActiveConstraints=nBCs-nBCsUser;

        if nBCsActiveConstraints>0
            nBCsUser=numel(BCsUser.hFixedNode) ; % These are the number of BCs defined by the user
            ActiveSet=BCs.hFixedNode(nBCsUser+1:end);
        else
            ActiveSetLogical=[];
            ActiveSet=[];
        end

        if nActiveSetDeletions==0 && nActiveSetAdditions==0 &&   all(F1.hw>=CtrlVar.WaterFilm.ThickMin)
            fprintf(" Breaking out of active set iteration #%i. All constraints fulfilled. \n",I)
            break
        end

        % sort(LastAdded')

        % sort(LastDeleted')

      
        ActiveSetUpdate=setxor(LastAdded,LastDeleted);

        if isempty(ActiveSetUpdate)
            fprintf(" Active set is cyclical. \n")
        end

    end



end



end


