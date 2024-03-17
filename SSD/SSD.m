





function [UserVar,D,ActiveSet,lambda,output]=SSD(UserVar,CtrlVar,MUA,F0,F1,eta,DNye,ActiveSet,lambda)


%% Sainan-Sun Damage Evolution Equation
%
% Solves:
%
% $$\partial_t \mathcal{D} +  \alpha \, \nabla \cdot ( \mathbf{v} \mathcal{D} )  - \nabla \cdot (\eta  \nabla \mathcal{D} ) = \gamma (\mathcal{D}_{\mathrm{Nye}}-\mathcal{D}) + a_{\mathcal{D}} $$ 
%
% where
%
% $$\mathcal{D}_{\mathrm{Nye}}=\tau_1/ (\rho g h) $$
%
%
% Optionally, one can add a barrier and penalty terms as 
%
% $$\partial_t \mathcal{D} +  \alpha \, \nabla \cdot ( \mathbf{v} \mathcal{D} )  - \nabla \cdot (\eta  \nabla \mathcal{D} ) + \beta  \,\mathcal{D} \; \mathcal{H}(\mathcal{-D}) - \alpha \, \mathcal{D}^{-1} \, \mathcal{H}(\mathcal{D}) = a_{\mathcal{D}} $$ 
%
% where
%
% $$\mathcal{H} $$
%
% is the Heaviside step function.
%
%%



narginchk(9,9)
nargoutchk(4,5)



nlambda=numel(lambda);
nActiveSet=numel(ActiveSet);
nBCsUser=nlambda-nActiveSet; 
lambdaActiveSet=lambda(nlambda-nActiveSet+1:nlambda) ;
lambdaUser=lambda(1:nBCsUser) ; 

BCs=BoundaryConditions ;
[UserVar,BCs]=GetBoundaryConditions(UserVar,CtrlVar,MUA,BCs,F1) ;
BCsUser=BCs;

LastAdded=[];
LastDeleted=[];
nActiveSetDeletions=nan ;
nActiveSetAdditions=nan ;


if nBCsUser~=numel(BCsUser.hFixedNode)  % These are the number of BCs defined by the user
    nBCsUser=numel(BCsUser.hFixedNode) ;   % I don't have the information about last BCs defined by the user, (this could be added to the call in the future)
    % So if the #BCs defined by the user has changed, all I can do is to reset the lambdas
    lambdaUser=zeros(nBCsUser,1) ;

end

nActiveSetIterations=CtrlVar.SSD.MaxActiveSetIterations;
useActiveSetMethod=CtrlVar.SSD.useActiveSetMethod;

if ~useActiveSetMethod
    nActiveSetIterations=1;

else

    if ~isempty(ActiveSet)

        % Take out of active set any nodes that are part of the user-defined BCs.

        [ActiveSet,ia]=setdiff(ActiveSet,BCsUser.hFixedNode) ;
        lambdaActiveSet=lambdaActiveSet(ia) ; 

        BCs.hFixedNode=[BCsUser.hFixedNode;ActiveSet];
        BCs.hFixedValue=[BCsUser.hFixedValue;ActiveSet*0+CtrlVar.SSD.Dmin];
        lambda=[lambdaUser;lambdaActiveSet] ;

    end

end


for I=1:nActiveSetIterations

    MLC=BCs2MLC(CtrlVar,MUA,BCs);  LL=MLC.hL ; cc=MLC.hRhs ;

    if ~isempty(LL)
        BCsRes=LL*F1.D-cc ;
        if norm(BCsRes) > 1e-6
            F1.D(BCs.hFixedNode)= BCs.hFixedValue;
            F0.D(BCs.hFixedNode)= BCs.hFixedValue;
            %        F1.D=LL\cc;   % make feasable
        end
        if numel(lambda) ~= numel(BCs.hFixedNode)
            lambda=cc*0;
        end
    end


    

    x=F1.D;
    fun =@(x) lsqUaFuncSSD(x,UserVar,CtrlVar,MUA,F0,F1,eta,DNye) ;

    CtrlVar.lsqUa.CostMeasure="r2";
    CtrlVar.lsqUa.isLSQ=false ;
    [D,lambda,~,~,~,~,~,~,~,~,output] = lsqUa(CtrlVar,fun,x,lambda,LL,cc) ;
    F1.D=D ;
    lambdaActiveSet=lambda(nBCsUser+1:end) ; 

    if useActiveSetMethod

        if mod(I,2)==1 % add constraints
            %
            % Constraints are always added based on violatons of the applied constraints. This addition does not require knowing the
            % lagrange parameters.
            %
            ActiveSetAdditionsLogical=F1.D<CtrlVar.SSD.Dmin ;
            ActiveSetAdditionsNodes=find(ActiveSetAdditionsLogical) ;
            nActiveSetAdditions=numel(ActiveSetAdditionsNodes) ;

            if nActiveSetAdditions>0
                BCs.hFixedNode=[BCs.hFixedNode;ActiveSetAdditionsNodes];
                BCs.hFixedValue=[BCs.hFixedValue;ActiveSetAdditionsNodes*0+CtrlVar.SSD.Dmin];
                lambda=[lambda;ActiveSetAdditionsNodes*0] ;
                LastAdded=ActiveSetAdditionsNodes;
            else
                LastAdded=[];
            end



            fprintf("Active Set iteration: #%i \t Added=%i  \n",I,nActiveSetAdditions)

        else  % delete contraints

            % Constraints are deleted based on the sign of the lagrange parameters in the active set
            % So I must have solved the system once in order to be able to select nodes for deltion from the active set. 
            %
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

        if nActiveSetDeletions==0 && nActiveSetAdditions==0 &&   all(F1.D>=CtrlVar.SSD.Dmin)
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


