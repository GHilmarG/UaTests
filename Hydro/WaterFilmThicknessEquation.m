





function [UserVar,hw1,ActiveSet,lambda,output]=WaterFilmThicknessEquation(UserVar,CtrlVar,MUA,F0,F1,k,eta,ActiveSet,lambda)

narginchk(9,9)
nargoutchk(5,5)


%% Water film thickness equation
%
% See:
%
%   WaterFilmThicknessEquationAssembly.m
%
% for detailed information.
%
% Solves:
%
% $$ \partial_t h_w + A  \nabla \cdot (  h_w \mathbf{v}_w )  - D \nabla \cdot (\kappa h_w \nabla h_w) -\nabla \cdot (\eta \nabla h_w )= a_w $$
%
% where $A$ and $D$ are advection and diffusion flags.
%
% Further barrier and penalty terms can be added
%
% $$ \partial_t h_w + A  \nabla \cdot (  h_w \mathbf{v}_w )  - D \nabla \cdot (\kappa h_w \nabla h_w) -\nabla \cdot (\eta \nabla h_w )= a_w + B (h_w>0) /h_w  + P (h_w<0) h_w $$
%
% where $B$ is a barrier-flag, and $P$ a penalty flag, and $h_w>0$  and $h_w<0$ are (logical) masks.  
%
% The (static) water velocity (F.uw,F,vw) needs to be defined ahead of the call, and is here an input field.
%
% The (static) water velocity can, for example, be calculated as
%
% $$ \mathbf{v}_w= - k \nabla \Phi$$
%
% where, for example,
%
% $$\Phi = (\rho_w-\rho) g \nabla B - \rho g \nabla s  $$
%
% using
%
%   [F0.uw,F0.vw]=WaterFilmVelocities(CtrlVar,UserVar,MUA,F0,k) ;
%
%
% The code calls
%
%   DefineBoundaryConditions.m
%
% and uses the active-set method to enforce
%
%  $$h_w>$$ CtrlVar.WaterFilm.ThickMin
%
% Some further inputs variables are:
%
%   A=CtrlVar.WaterFilm.AdvectionFlag;
%
%   D=CtrlVar.WaterFilm.DiffusionFlag;
%
%   B=CtrlVar.WaterFilm.Barrier ;
%
%   P=CtrlVar.WaterFilm.Penalty ;
%
%   eta : linear viscosity (here just for numerical tests, generally set eta=0)
%
%   k : hydraulic conductivity
%
% |ActiveSet| and |lambda| can be empty on initial call.
%
%%

% 
% if  CtrlVar.WaterFilm.Assembly=="-A-"
%     CtrlVar.WaterFilm.AdvectionFlag=1;
%     CtrlVar.WaterFilm.DiffusionFlag=0;
% elseif CtrlVar.WaterFilm.Assembly=="-AD-"
%     CtrlVar.WaterFilm.AdvectionFlag=1;
%     CtrlVar.WaterFilm.DiffusionFlag=1;
% end

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

nActiveSetIterations=CtrlVar.WaterFilm.MaxActiveSetIterations;
useActiveSetMethod=CtrlVar.WaterFilm.useActiveSetMethod;

if ~useActiveSetMethod
    nActiveSetIterations=1;

else

    if ~isempty(ActiveSet)

        % Take out of active set any nodes that are part of the user-defined BCs.

        [ActiveSet,ia]=setdiff(ActiveSet,BCsUser.hFixedNode) ;
        lambdaActiveSet=lambdaActiveSet(ia) ; 

        BCs.hFixedNode=[BCsUser.hFixedNode;ActiveSet];
        BCs.hFixedValue=[BCsUser.hFixedValue;ActiveSet*0+CtrlVar.WaterFilm.ThickMin];
        lambda=[lambdaUser;lambdaActiveSet] ;

    end

end


for I=1:nActiveSetIterations

    MLC=BCs2MLC(CtrlVar,MUA,BCs);  LL=MLC.hL ; cc=MLC.hRhs ;

    if ~isempty(LL)
        BCsRes=LL*F1.hw-cc ;
        if norm(BCsRes) > 1e-6
            F1.hw(BCs.hFixedNode)= BCs.hFixedValue;
            F0.hw(BCs.hFixedNode)= BCs.hFixedValue;
            %        F1.hw=LL\cc;   % make feasible
        end
        if numel(lambda) ~= numel(BCs.hFixedNode)
            lambda=cc*0;
        end
    end


    

    x=F1.hw;
    fun =@(x) lsqUaFunc(x,UserVar,CtrlVar,MUA,F0,F1,k,eta)  ;

    CtrlVar.lsqUa.CostMeasure="r2";
    CtrlVar.lsqUa.isLSQ=false ;
    [hw1,lambda,~,~,~,~,~,~,~,~,output] = lsqUa(CtrlVar,fun,x,lambda,LL,cc) ;
    F1.hw=hw1 ;
    lambdaActiveSet=lambda(nBCsUser+1:end) ; 

    if useActiveSetMethod

        if mod(I,2)==1 % add constraints
            %
            % Constraints are always added based on violations of the applied constraints. This addition does not require knowing the
            % Lagrange parameters.
            %
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

        else  % delete constraints

            % Constraints are deleted based on the sign of the Lagrange parameters in the active set
            % So I must have solved the system once in order to be able to select nodes for deletion from the active set. 
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


