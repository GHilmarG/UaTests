







function [UserVar,RR,KK,Outs]=WaterFilmThicknessDiffusionEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k,eta)



%% Water film thickness equation
%
%
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
% We define the water velocity
%
% $$ \mathbf{v}_w:=-k \nabla \Phi $$
%
% and write the equation as
%
% $$\partial_t h_w +  \nabla \cdot (  h_w \mathbf{v}_w )  - \nabla \cdot (\kappa h_w \nabla h_w) = a_w $$
%
% It is also possible to add some further linear diffusion term, and to enable/disable the advection and the non-linear
% diffusion term by selecting the parameters $\alpha$, $\beta$ , and $\eta$, accordingly
%
% $$\partial_t h_w +  \alpha \, \nabla \cdot (  h_w \mathbf{v}_w )  - \beta \, \nabla \cdot (\kappa h_w \nabla h_w)  - \nabla \cdot (\eta  \nabla h_w ) = a_w $$
%
% This can also be written as
%
% $$\partial_t h_w +  \alpha \, \nabla \cdot ( \mathbf{q} ) = a_w $$
%
% with
%
% $$\mathbf{q} = \alpha \,  h_w \mathbf{v}_w   - \beta \,  \kappa h_w \nabla h_w   -   \eta  \nabla h_w  $$
%
% However, in the FE formulation, the resulting  second-order two terms containing $\nabla h_w$ are integrated
% 
%
% The system to solve if K dx = -R
%
% Notice the sign on the right-hand side
% 
%
%%

narginchk(7,7)


ndim=2; dof=1; neq=dof*MUA.Nnodes;

theta=CtrlVar.theta;
dt=CtrlVar.dt ;

Phi1=PhiPotential(CtrlVar,MUA,F1);
Phi0=PhiPotential(CtrlVar,MUA,F0);


kappa=F1.g*(F1.rhow-F1.rho).*k ;

etanod=reshape(eta(MUA.connectivity,1),MUA.Nele,MUA.nod);

x1nod=reshape(F1.x(MUA.connectivity,1),MUA.Nele,MUA.nod);
y1nod=reshape(F1.y(MUA.connectivity,1),MUA.Nele,MUA.nod);


h0nod=reshape(F0.hw(MUA.connectivity,1),MUA.Nele,MUA.nod);
h1nod=reshape(F1.hw(MUA.connectivity,1),MUA.Nele,MUA.nod);

a0nod=reshape(F1.aw(MUA.connectivity,1),MUA.Nele,MUA.nod);
a1nod=reshape(F0.aw(MUA.connectivity,1),MUA.Nele,MUA.nod);

% u0nod=reshape(F1.uw(MUA.connectivity,1),MUA.Nele,MUA.nod);
% u1nod=reshape(F1.uw(MUA.connectivity,1),MUA.Nele,MUA.nod);

% v0nod=reshape(F1.vw(MUA.connectivity,1),MUA.Nele,MUA.nod);
% v1nod=reshape(F0.vw(MUA.connectivity,1),MUA.Nele,MUA.nod);

FG=1-F1.GF.node ;
FGnod=reshape(FG(MUA.connectivity,1),MUA.Nele,MUA.nod);

Phi1nod=reshape(Phi1(MUA.connectivity,1),MUA.Nele,MUA.nod);
Phi0nod=reshape(Phi0(MUA.connectivity,1),MUA.Nele,MUA.nod);

kappanod=reshape(kappa(MUA.connectivity,1),MUA.Nele,MUA.nod);
knod=reshape(k(MUA.connectivity,1),MUA.Nele,MUA.nod);

Kelements=zeros(MUA.Nele,MUA.nod,MUA.nod);
Relements=zeros(MUA.Nele,MUA.nod);

l=sqrt(2*MUA.EleAreas);


qx1int=zeros(MUA.Nele,MUA.nip) ; qy1int=zeros(MUA.Nele,MUA.nip) ;
qx1Phiint=zeros(MUA.Nele,MUA.nip) ; qy1Phiint=zeros(MUA.Nele,MUA.nip) ;
qx1Yint=zeros(MUA.Nele,MUA.nip) ; qy1Yint=zeros(MUA.Nele,MUA.nip) ;
x1int=zeros(MUA.Nele,MUA.nip) ; y1int=zeros(MUA.Nele,MUA.nip) ;

% vector over all elements for each integration point
for Iint=1:MUA.nip

    fun=shape_fun(Iint,ndim,MUA.nod,MUA.points) ; % nod x 1   : [N1 ; N2 ; N3] values of form functions at integration points

    Deriv=MUA.Deriv(:,:,:,Iint);
    detJ=MUA.DetJ(:,Iint);


    % Deriv : Nele x dof x nod
    %  detJ : Nele

    % values at integration point

    h0int=h0nod*fun;
    h1int=h1nod*fun;

   % u0int=u0nod*fun;
   % v0int=v0nod*fun;

    a0int=a0nod*fun;
    a1int=a1nod*fun;

    FGint=FGnod*fun; 

    kappaint=kappanod*fun;
    etaint=etanod*fun;
    kint=knod*fun;


    dh0dx=zeros(MUA.Nele,1); dh0dy=zeros(MUA.Nele,1);
    dh1dx=zeros(MUA.Nele,1); dh1dy=zeros(MUA.Nele,1);

    % du0dx=zeros(MUA.Nele,1); du0dy=zeros(MUA.Nele,1);
    % du1dx=zeros(MUA.Nele,1); du1dy=zeros(MUA.Nele,1);
    % 
    % dv0dx=zeros(MUA.Nele,1); dv0dy=zeros(MUA.Nele,1);
    % dv1dx=zeros(MUA.Nele,1); dv1dy=zeros(MUA.Nele,1);

    dPhi0dx=zeros(MUA.Nele,1); dPhi0dy=zeros(MUA.Nele,1);
    dPhi1dx=zeros(MUA.Nele,1); dPhi1dy=zeros(MUA.Nele,1);


    % derivatives at one integration point for all elements
    for Inod=1:MUA.nod

        dh0dx=dh0dx+Deriv(:,1,Inod).*h0nod(:,Inod);
        dh0dy=dh0dy+Deriv(:,2,Inod).*h0nod(:,Inod);

        dh1dx=dh1dx+Deriv(:,1,Inod).*h1nod(:,Inod);
        dh1dy=dh1dy+Deriv(:,2,Inod).*h1nod(:,Inod);

        % du0dx=du0dx+Deriv(:,1,Inod).*u0nod(:,Inod);
        % du0dy=du0dy+Deriv(:,2,Inod).*u0nod(:,Inod);
        % 
        % du1dx=du1dx+Deriv(:,1,Inod).*u1nod(:,Inod);
        % du1dy=du1dy+Deriv(:,2,Inod).*u1nod(:,Inod);
        % 
        % dv0dx=dv0dx+Deriv(:,1,Inod).*v0nod(:,Inod);
        % dv0dy=dv0dy+Deriv(:,2,Inod).*v0nod(:,Inod);
        % 
        % dv1dx=dv1dx+Deriv(:,1,Inod).*v1nod(:,Inod);
        % dv1dy=dv1dy+Deriv(:,2,Inod).*v1nod(:,Inod);

        dPhi0dx=dPhi0dx+Deriv(:,1,Inod).*Phi0nod(:,Inod);
        dPhi0dy=dPhi0dy+Deriv(:,2,Inod).*Phi0nod(:,Inod);

        dPhi1dx=dPhi1dx+Deriv(:,1,Inod).*Phi1nod(:,Inod);
        dPhi1dy=dPhi1dy+Deriv(:,2,Inod).*Phi1nod(:,Inod);



    end

    detJw=detJ*MUA.weights(Iint);
    % speed0=sqrt(u0int.*u0int+v0int.*v0int+CtrlVar.SpeedZero^2);
    % tau=SUPGtau(CtrlVar,speed0,l,dt,CtrlVar.Tracer.SUPG.tau) ;
    % tauSUPGint=CtrlVar.SUPG.beta0*tau;

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

    BarrierFlag=CtrlVar.WaterFilm.Barrier ;
    PenaltyFlag=CtrlVar.WaterFilm.Penalty ;
    gamma=CtrlVar.WaterFilm.qwAfloatMultiplier ;

    for Inod=1:MUA.nod

        SUPG=fun(Inod); %+CtrlVar.Tracer.SUPG.Use*tauSUPGint.*(u0int.*Deriv(:,1,Inod)+v0int.*Deriv(:,2,Inod));
        SUPGdetJw=SUPG.*detJw;
        He0=HeavisideApprox(100,h0int,0);
        He1=HeavisideApprox(100,h1int,0);
        % Matrix loop:  Here the terms are the derivatives of the terms in the vector loop with respect to h1

        for Jnod=1:MUA.nod

            dh1term=fun(Jnod).*SUPGdetJw;

            daFG=dt*FGint.*gamma.*fun(Jnod).*SUPGdetJw ;

            %    dC1=dt*theta* (fun(Jnod).*du1dx+Deriv(:,1,Jnod).*u1int+fun(Jnod).*dv1dy+Deriv(:,2,Jnod).*v1int).*SUPGdetJw;

            dBarrier1=dt*(1-theta)*BarrierFlag* (h1int.^(-2).*fun(Jnod).*He1 - h1int.^(-1).*DiracDelta(100,h1int,0).*fun(Jnod))  .*SUPGdetJw ;


            dPenalty1=dt* theta *PenaltyFlag.* (fun(Jnod).*HeavisideApprox(100,-h1int,0)-h1int.*DiracDelta(100,h1int,0).*fun(Jnod)).*SUPGdetJw ;

            % the non-linear diffusion term
            dD1=+dt*theta.*kappaint.* (   ...
                h1int     .*   (Deriv(:,1,Jnod).*Deriv(:,1,Inod)+ Deriv(:,2,Jnod).*Deriv(:,2,Inod)) ...
                + fun(Jnod) .*   (  dh1dx        .*Deriv(:,1,Inod)+    dh1dy        .*Deriv(:,2,Inod)))   .*detJw ;

            % the "velocity"-diffusion term
            dDPhi1=+dt*theta.*kint.* (   ...
                + fun(Jnod) .*   (  dPhi1dx        .*Deriv(:,1,Inod)+    dPhi1dy        .*Deriv(:,2,Inod)))   .*detJw ;

            % the linear diffusion term
            dDLI1=dt*theta    * etaint.*(Deriv(:,1,Jnod).*Deriv(:,1,Inod)+Deriv(:,2,Jnod).*Deriv(:,2,Inod)).*detJw;

            Kelements(:,Inod,Jnod)=Kelements(:,Inod,Jnod)+dh1term+dD1+dDLI1+dDPhi1++dBarrier1+dPenalty1+daFG;

        end

        % Vector loop

        h1term=+h1int.*SUPGdetJw;
        h0term=-h0int.*SUPGdetJw;


        a0term=- dt*(1-theta)* a0int.*SUPGdetJw;
        a1term=-    dt*theta * a1int.*SUPGdetJw;

        aFG=gamma*dt*FGint.*h1int.*SUPGdetJw ;



        %  C0=dt*(1-theta)*  (h0int.*du0dx+dh0dx.*u0int+h0int.*dv0dy+dh0dy.*v0int).*SUPGdetJw;
        %  C1=dt*theta*      (h1int.*du1dx+dh1dx.*u1int+h1int.*dv1dy+dh1dy.*v1int).*SUPGdetJw;
       

        % This is a non-linear diffusion term
        D0=dt*(1-theta)* kappaint.*h0int.*   (dh0dx.*Deriv(:,1,Inod)+dh0dy.*Deriv(:,2,Inod)).*detJw;
        D1=dt*theta    * kappaint.*h1int.*   (dh1dx.*Deriv(:,1,Inod)+dh1dy.*Deriv(:,2,Inod)).*detJw;

        % the "velocity"-diffusion term
        DPhi0=dt*(1-theta)* kint.*h0int.*   (dPhi0dx.*Deriv(:,1,Inod)+dPhi0dy.*Deriv(:,2,Inod)).*detJw;
        DPhi1=dt*theta    * kint.*h1int.*   (dPhi1dx.*Deriv(:,1,Inod)+dPhi1dy.*Deriv(:,2,Inod)).*detJw;

        % This is a linear isotropic diffusion term
        DLI0=dt*(1-theta)* etaint.*(dh0dx.*Deriv(:,1,Inod)+dh0dy.*Deriv(:,2,Inod)).*detJw;
        DLI1=dt*theta    * etaint.*(dh1dx.*Deriv(:,1,Inod)+dh1dy.*Deriv(:,2,Inod)).*detJw;

        Barrier1=-dt*(1-theta)*BarrierFlag.*(h1int.^(-1)).*He1.*SUPGdetJw ;  % this is incomplete, assumes that the min value is zero
        Barrier0=-dt*   theta *BarrierFlag.*(h0int.^(-1)).*He0.*SUPGdetJw ;

        Penalty0=dt*(1-theta)*PenaltyFlag.*h0int.*(1-He0).*SUPGdetJw ;
        Penalty1=dt*   theta *PenaltyFlag.*h1int.*(1-He1).*SUPGdetJw ;

        % Relements(:,Inod)=Relements(:,Inod)+h0term+h1term+a0term+a1term+C0+C1+D0+D1+Barrier0+Barrier1+Penalty0+Penalty1+aFG;
        Relements(:,Inod)=Relements(:,Inod)+h0term+h1term+a0term+a1term+D0+D1+DLI0+DLI1+DPhi0+DPhi1+Barrier0+Barrier1+Penalty0+Penalty1+aFG;

    end

    qx1Phiint(:,Iint)=-kint.*h1int.*dPhi1dx ;
    qy1Phiint(:,Iint)=-kint.*h1int.*dPhi1dy ;

    qx1Yint(:,Iint)=-kappaint.*h1int.*dh0dx;
    qy1Yint(:,Iint)=-kappaint.*h1int.*dh0dy;


    qx1int(:,Iint)=...
        - kappaint.*h1int.*dh0dx ...
        - kint.*h1int.*dPhi1dx ...
        - etaint.*dh0dy ;

    qy1int(:,Iint)=...
        - kappaint.*h1int.*dh0dy ...
        - kint.*h1int.*dPhi1dy ...
        - etaint.*dh0dy ;



    x1int(:,Iint)=x1nod*fun;
    y1int(:,Iint)=y1nod*fun;


end


%  qw = - \nabla (hw (k \nabla Phi + \kappa \nabla hw)  



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

Outs.qx1int=qx1int ; Outs.qy1int=qy1int ;  
Outs.qx1Phiint=qx1Phiint ; Outs.qy1Phiint=qy1Phiint;
Outs.qx1Yint=qx1Yint ; Outs.qy1Yint=qy1Yint;

Outs.xint=x1int ; Outs.yint=y1int ;


end



