



function [UserVar,RR,KK]=SSDAssembly(UserVar,CtrlVar,MUA,F0,F1,eta,DNye)


narginchk(6,7)
nargoutchk(3,3)

%% Sainan-Sun Damage Evolution equation
%
% Solves:
%
% $$\partial_t \mathcal{D} +  \alpha \, \nabla \cdot ( \mathbf{v} \mathcal{D} )  - \nabla \cdot (\eta  \nabla \mathcal{D} ) = \gamma (\mathcal{D}_{\mathrm{Nye}}-\mathcal{D}) + a_{\mathcal{D}} $$ 
%
% where
%
% $$\mathcal{D}_{\mathrm{Nye}}=\tau_1/ (\rho g h) $$
%
% Here
%
% $$\gamma$$
%
% is a model parameter, with the dimention inverse time  (ie 1/time).
%
% Optionally, one can add a barrier and penalty terms as 
%
% $$\partial_t \mathcal{D} +  \alpha \, \nabla \cdot ( \mathbf{v} \mathcal{D} )  - \nabla \cdot (\eta  \nabla \mathcal{D} ) + \beta  \,\mathcal{D} \; \mathcal{H}(\mathcal{-D}) - \alpha \, \mathcal{D}^{-1} \, \mathcal{H}(\mathcal{D}) =  \gamma (\mathcal{D}_{\mathrm{Nye}}-\mathcal{D}) + a_{\mathcal{D}} $$ 
%
% where
%
% $$\mathcal{H} $$
%
% is the Heaviside step function.
%
% The system to solve is 
% 
% $$ K \, \Delta \mathcal{D} = -R  $$
%
% Notice the sign on the right-hand side
% 
%
%%




dt=CtrlVar.dt ;
alpha=CtrlVar.SSD.Barrier ;
beta=CtrlVar.SSD.Penalty ;
gamma=CtrlVar.SSD.gamma ;

theta=CtrlVar.theta;

ndim=2; dof=1; neq=dof*MUA.Nnodes;


% If D was not already defined on input, calculate it here
if nargin< 7 || isempty(DNye)
    DNye=NyeCrevasse(UserVar,CtrlVar,MUA,F1) ;
end



etanod=reshape(eta(MUA.connectivity,1),MUA.Nele,MUA.nod);

DNyenod=reshape(DNye(MUA.connectivity,1),MUA.Nele,MUA.nod);


D0nod=reshape(F0.D(MUA.connectivity,1),MUA.Nele,MUA.nod);
D1nod=reshape(F1.D(MUA.connectivity,1),MUA.Nele,MUA.nod);

a0nod=reshape(F0.aD(MUA.connectivity,1),MUA.Nele,MUA.nod);
a1nod=reshape(F1.aD(MUA.connectivity,1),MUA.Nele,MUA.nod);

u0nod=reshape(F0.ub(MUA.connectivity,1),MUA.Nele,MUA.nod);
u1nod=reshape(F1.ub(MUA.connectivity,1),MUA.Nele,MUA.nod);

v0nod=reshape(F0.vb(MUA.connectivity,1),MUA.Nele,MUA.nod);
v1nod=reshape(F1.vb(MUA.connectivity,1),MUA.Nele,MUA.nod);


Kelements=zeros(MUA.Nele,MUA.nod,MUA.nod);
Relements=zeros(MUA.Nele,MUA.nod);

l=sqrt(2*MUA.EleAreas);


% vector over all elements for each integration point
for Iint=1:MUA.nip

    fun=shape_fun(Iint,ndim,MUA.nod,MUA.points) ; % nod x 1   : [N1 ; N2 ; N3] values of form functions at integration points

    Deriv=MUA.Deriv(:,:,:,Iint);
    detJ=MUA.DetJ(:,Iint);


    % Deriv : Nele x dof x nod
    %  detJ : Nele

    % values at integration point

    D0int=D0nod*fun;
    D1int=D1nod*fun;

    DNyeint=DNyenod*fun;

    u0int=u0nod*fun; u1int=u1nod*fun;
    v0int=v0nod*fun; v1int=v1nod*fun;

    a0int=a0nod*fun;
    a1int=a1nod*fun;

        
    etaint=etanod*fun;


    dD0dx=zeros(MUA.Nele,1); dD0dy=zeros(MUA.Nele,1);
    dD1dx=zeros(MUA.Nele,1); dD1dy=zeros(MUA.Nele,1);

    du0dx=zeros(MUA.Nele,1); du0dy=zeros(MUA.Nele,1);
    du1dx=zeros(MUA.Nele,1); du1dy=zeros(MUA.Nele,1);

    dv0dx=zeros(MUA.Nele,1); dv0dy=zeros(MUA.Nele,1);
    dv1dx=zeros(MUA.Nele,1); dv1dy=zeros(MUA.Nele,1);


    % derivatives at one integration point for all elements
    for Inod=1:MUA.nod

        dD0dx=dD0dx+Deriv(:,1,Inod).*D0nod(:,Inod);
        dD0dy=dD0dy+Deriv(:,2,Inod).*D0nod(:,Inod);

        dD1dx=dD1dx+Deriv(:,1,Inod).*D1nod(:,Inod);
        dD1dy=dD1dy+Deriv(:,2,Inod).*D1nod(:,Inod);

        du0dx=du0dx+Deriv(:,1,Inod).*u0nod(:,Inod);
        du0dy=du0dy+Deriv(:,2,Inod).*u0nod(:,Inod);

        du1dx=du1dx+Deriv(:,1,Inod).*u1nod(:,Inod);
        du1dy=du1dy+Deriv(:,2,Inod).*u1nod(:,Inod);

        dv0dx=dv0dx+Deriv(:,1,Inod).*v0nod(:,Inod);
        dv0dy=dv0dy+Deriv(:,2,Inod).*v0nod(:,Inod);

        dv1dx=dv1dx+Deriv(:,1,Inod).*v1nod(:,Inod);
        dv1dy=dv1dy+Deriv(:,2,Inod).*v1nod(:,Inod);

    end

    detJw=detJ*MUA.weights(Iint);
    speed0=sqrt(u0int.*u0int+v0int.*v0int+CtrlVar.SpeedZero^2);
    tau=SUPGtau(CtrlVar,speed0,l,dt,CtrlVar.Tracer.SUPG.tau) ;
    tauSUPGint=CtrlVar.SUPG.beta0*tau;

    % Sign convention:
    % Generally we solve   dR/dh \dh = - R
    % And this is how the system is assembled.
    % However, on return, the sign of R is reversed so that outside this assembly the system to solve is
    % K dh = R
    %
    % Also, I put the accumulation term to the left-hand side, rather then putting all the other terms over to the right-hande
    % side. So all terms R (ie in the vector loop) have the usual signs, but the mass balance terms gets a minus sign.
    %

    %kappaint=0 ;

  
    
    
    for Inod=1:MUA.nod

        SUPG=fun(Inod)+CtrlVar.Tracer.SUPG.Use*tauSUPGint.*(u0int.*Deriv(:,1,Inod)+v0int.*Deriv(:,2,Inod));
        SUPGdetJw=SUPG.*detJw;
        He0=HeavisideApprox(100,D0int,0);
        He1=HeavisideApprox(100,D1int,0);
        % Matrix loop:  Here the terms are the derivatives of the terms in the vector loop with respect to D1

        for Jnod=1:MUA.nod

            dh1term=fun(Jnod).*SUPGdetJw;

            dD1term= dt*theta*gamma*fun(Jnod).*SUPGdetJw;

            dC1=dt*theta* (fun(Jnod).*du1dx+Deriv(:,1,Jnod).*u1int+fun(Jnod).*dv1dy+Deriv(:,2,Jnod).*v1int).*SUPGdetJw;

            % the linear diffusion term
            dDLI1=dt*theta    * etaint.*(Deriv(:,1,Jnod).*Deriv(:,1,Inod)+Deriv(:,2,Jnod).*Deriv(:,2,Inod)).*detJw;

            % Barrier and diffusion penalty terms
            % dBarrier1=dt*(1-theta)*alpha* (D1int.^(-2).*fun(Jnod).*He1 - D1int.^(-1).*DiracDelta(100,D1int,0).*fun(Jnod))  .*SUPGdetJw ;
            dPenalty1=dt* theta *beta.* (fun(Jnod).*HeavisideApprox(100,-D1int,0)-D1int.*DiracDelta(100,D1int,0).*fun(Jnod)).*SUPGdetJw ;

            % Kelements(:,Inod,Jnod)=Kelements(:,Inod,Jnod)+dh1term+dC1+dBarrier1+dPenalty1+dDLI1;
            Kelements(:,Inod,Jnod)=Kelements(:,Inod,Jnod)+dh1term+dC1+dPenalty1+dDLI1+dD1term;

        end


        h1term=+D1int.*SUPGdetJw;
        h0term=-D0int.*SUPGdetJw;


        D0term=- dt*(1-theta)*gamma* (DNyeint-D0int).*SUPGdetJw;
        D1term=- dt* theta   *gamma* (DNyeint-D1int).*SUPGdetJw;

        a0term=- dt*(1-theta)* a0int.*SUPGdetJw;
        a1term=-    dt*theta * a1int.*SUPGdetJw;

        % This is the advection term:  \nabla (h v)
        C0=dt*(1-theta)*  (D0int.*du0dx+dD0dx.*u0int+D0int.*dv0dy+dD0dy.*v0int).*SUPGdetJw;
        C1=dt*theta*      (D1int.*du1dx+dD1dx.*u1int+D1int.*dv1dy+dD1dy.*v1int).*SUPGdetJw;
      

      % This is a linear isotropic diffusion term
        DLI0=dt*(1-theta)* etaint.*(dD0dx.*Deriv(:,1,Inod)+dD0dy.*Deriv(:,2,Inod)).*detJw;
        DLI1=dt*theta    * etaint.*(dD1dx.*Deriv(:,1,Inod)+dD1dy.*Deriv(:,2,Inod)).*detJw;

        % Barrier and diffusion penalty terms (disabled)
        % Barrier1=-dt*(1-theta)*alpha.*(D1int.^(-1)).*He1.*SUPGdetJw ;
        % Barrier0=-dt*   theta *alpha.*(D0int.^(-1)).*He0.*SUPGdetJw ;

        Penalty0=dt*(1-theta)*beta.*D0int.*(1-He0).*SUPGdetJw ;
        Penalty1=dt*   theta *beta.*D1int.*(1-He1).*SUPGdetJw ;

    

        %Relements(:,Inod)=Relements(:,Inod)+h0term+h1term+a0term+a1term+C0+C1+Barrier0+Barrier1+Penalty0+Penalty1+DLI0+DLI1; 
        Relements(:,Inod)=Relements(:,Inod)+h0term+h1term+a0term+a1term+C0+C1+Penalty0+Penalty1+DLI0+DLI1+D0term+D1term; 

    end




end

% assemble right-hand side

RR=sparseUA(neq,1);  % There is presumably no need to define this as a sparse vector
for Inod=1:MUA.nod
    RR=RR+sparseUA(MUA.connectivity(:,Inod),ones(MUA.Nele,1),Relements(:,Inod),neq,1);
end

Iind=zeros(MUA.nod*MUA.nod*MUA.Nele,1); Jind=zeros(MUA.nod*MUA.nod*MUA.Nele,1);Xval=zeros(MUA.nod*MUA.nod*MUA.Nele,1);
istak=0;

for Inod=1:MUA.nod
    for Jnod=1:MUA.nod
        Iind(istak+1:istak+MUA.Nele)=MUA.connectivity(:,Inod);
        Jind(istak+1:istak+MUA.Nele)=MUA.connectivity(:,Jnod);
        Xval(istak+1:istak+MUA.Nele)=Kelements(:,Inod,Jnod);
        istak=istak+MUA.Nele;
    end
end

KK=sparseUA(Iind,Jind,Xval,neq,neq);






