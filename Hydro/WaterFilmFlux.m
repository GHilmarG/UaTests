function [UserVar,qwx,qwy,qphix,qphiy,qPhix,qPhiy]=WaterFilmFlux(UserVar,CtrlVar,MUA,F0,F1,k,u0,v0,u1,v1)


ndim=2; dof=1; neq=dof*MUA.Nnodes;

theta=CtrlVar.theta;
dt=CtrlVar.dt ;


% Phi=F1.g.* ( (F1.rhow-F1.rho).*F1.B + F1.rho.*F1.s) ;   % does not change, if s and b do not
kappa=F1.g*(F1.rhow-F1.rho).*k ;


h0nod=reshape(F0.hw(MUA.connectivity,1),MUA.Nele,MUA.nod);
h1nod=reshape(F1.hw(MUA.connectivity,1),MUA.Nele,MUA.nod);


kappanod=reshape(kappa(MUA.connectivity,1),MUA.Nele,MUA.nod);


qxElements=zeros(MUA.Nele,MUA.nod);
qyElements=zeros(MUA.Nele,MUA.nod);


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

    kappaint=kappanod*fun;


    dh0dx=zeros(MUA.Nele,1); dh0dy=zeros(MUA.Nele,1);
    dh1dx=zeros(MUA.Nele,1); dh1dy=zeros(MUA.Nele,1);
    % derivatives at one integration point for all elements
    for Inod=1:MUA.nod

        dh0dx=dh0dx+Deriv(:,1,Inod).*h0nod(:,Inod);
        dh0dy=dh0dy+Deriv(:,2,Inod).*h0nod(:,Inod);

        dh1dx=dh1dx+Deriv(:,1,Inod).*h1nod(:,Inod);
        dh1dy=dh1dy+Deriv(:,2,Inod).*h1nod(:,Inod);

    end

    detJw=detJ*MUA.weights(Iint);
 
    for Inod=1:MUA.nod


        qxphi0=-(1-theta)* kappaint.*h0int.*dh0dx.*fun(Inod).*detJw ; 
        qyphi0=-(1-theta)* kappaint.*h0int.*dh0dy.*fun(Inod).*detJw ; 
        qxphi1=-theta*     kappaint.*h1int.*dh1dx.*fun(Inod).*detJw ; 
        qyphi1=-theta*     kappaint.*h1int.*dh1dy.*fun(Inod).*detJw ; 
        

        qxElements(:,Inod)=qxElements(:,Inod)+qxphi0+qxphi1 ;
        qyElements(:,Inod)=qyElements(:,Inod)+qyphi0+qyphi1 ;

    end
end

% assemble right-hand side

Qx=sparseUA(neq,1); 
Qy=sparseUA(neq,1); 
for Inod=1:MUA.nod
    Qx=Qx+sparseUA(MUA.connectivity(:,Inod),ones(MUA.Nele,1),qxElements(:,Inod),neq,1);
    Qy=Qy+sparseUA(MUA.connectivity(:,Inod),ones(MUA.Nele,1),qyElements(:,Inod),neq,1);
end


qphix=MUA.M\Qx;
qphiy=MUA.M\Qy;

qPhix=((1-theta).*u0.*F0.hw+theta*u1.*F1.hw);
qPhiy=((1-theta).*v0.*F0.hw+theta*v1.*F1.hw);


qwx=qphix+qPhix ;
qwy=qphiy+qPhiy ;


end





