





function [UserVar,qwx,qwy,qUpsilonx,qUpsilony,qPhix,qPhiy]=WaterFilmFlux(UserVar,CtrlVar,MUA,F0,F1,k)


narginchk(6,6)

ndim=2; dof=1; neq=dof*MUA.Nnodes;

theta=CtrlVar.theta;



% Phi=F1.g.* ( (F1.rhow-F1.rho).*F1.B + F1.rho.*F1.s) ;   % does not change, if s and b do not
kappa=F1.g*(F1.rhow-F1.rho).*k ;


h0nod=reshape(F0.hw(MUA.connectivity,1),MUA.Nele,MUA.nod);
h1nod=reshape(F1.hw(MUA.connectivity,1),MUA.Nele,MUA.nod);


kappanod=reshape(kappa(MUA.connectivity,1),MUA.Nele,MUA.nod);
knod=reshape(k(MUA.connectivity,1),MUA.Nele,MUA.nod);



switch CtrlVar.WaterFilm.Assembly


    case "-AD-"

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


        qUpsilonx=MUA.M\Qx;
        qUpsilony=MUA.M\Qy;

        qPhix=((1-theta).*F0.uw.*F0.hw+theta*F1.uw.*F1.hw);
        qPhiy=((1-theta).*F0.vw.*F0.hw+theta*F1.vw.*F1.hw);


        qwx=qUpsilonx+qPhix ;
        qwy=qUpsilony+qPhiy ;

    case "-D-"

        qxUpsilonElements=zeros(MUA.Nele,MUA.nod);
        qyUpsilonElements=zeros(MUA.Nele,MUA.nod);
        qxPhiElements=zeros(MUA.Nele,MUA.nod);
        qyPhiElements=zeros(MUA.Nele,MUA.nod);


        Phi1=PhiPotential(CtrlVar,MUA,F1);
        Phi0=PhiPotential(CtrlVar,MUA,F0);

        Phi0nod=reshape(Phi1(MUA.connectivity,1),MUA.Nele,MUA.nod);
        Phi1nod=reshape(Phi0(MUA.connectivity,1),MUA.Nele,MUA.nod);

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
            %Phi0int=Phi0nod*fun;
            %Phi1int=Phi1nod*fun;

            kappaint=kappanod*fun;
            kint=knod*fun;


            dh0dx=zeros(MUA.Nele,1); dh0dy=zeros(MUA.Nele,1);
            dh1dx=zeros(MUA.Nele,1); dh1dy=zeros(MUA.Nele,1);
            dPhi0dx=zeros(MUA.Nele,1); dPhi0dy=zeros(MUA.Nele,1);
            dPhi1dx=zeros(MUA.Nele,1); dPhi1dy=zeros(MUA.Nele,1);

            % derivatives at one integration point for all elements
            for Inod=1:MUA.nod

                dh0dx=dh0dx+Deriv(:,1,Inod).*h0nod(:,Inod);
                dh0dy=dh0dy+Deriv(:,2,Inod).*h0nod(:,Inod);

                dh1dx=dh1dx+Deriv(:,1,Inod).*h1nod(:,Inod);
                dh1dy=dh1dy+Deriv(:,2,Inod).*h1nod(:,Inod);

                dPhi0dx=dPhi0dx+Deriv(:,1,Inod).*Phi0nod(:,Inod);
                dPhi0dy=dPhi0dy+Deriv(:,2,Inod).*Phi0nod(:,Inod);

                dPhi1dx=dPhi1dx+Deriv(:,1,Inod).*Phi1nod(:,Inod);
                dPhi1dy=dPhi1dy+Deriv(:,2,Inod).*Phi1nod(:,Inod);


            end

            detJw=detJ*MUA.weights(Iint);

            for Inod=1:MUA.nod


                qUpsilonx0=-(1-theta)* kappaint.*h0int.*dh0dx.*fun(Inod).*detJw ;
                qUpsilony0=-(1-theta)* kappaint.*h0int.*dh0dy.*fun(Inod).*detJw ;
                qUpsilonx1=-theta*     kappaint.*h1int.*dh1dx.*fun(Inod).*detJw ;
                qUpsilony1=-theta*     kappaint.*h1int.*dh1dy.*fun(Inod).*detJw ;



                qPhix0=-(1-theta)* kint.*h0int.*dPhi0dx.*fun(Inod).*detJw ;
                qPhiy0=-(1-theta)* kint.*h0int.*dPhi0dy.*fun(Inod).*detJw ;
                qPhix1=-theta*     kint.*h1int.*dPhi1dx.*fun(Inod).*detJw ;
                qPhiy1=-theta*     kint.*h1int.*dPhi1dy.*fun(Inod).*detJw ;


                qxUpsilonElements(:,Inod)=qxUpsilonElements(:,Inod)+qUpsilonx0+qUpsilonx1 ;
                qyUpsilonElements(:,Inod)=qyUpsilonElements(:,Inod)+qUpsilony0+qUpsilony1 ;

                qxPhiElements(:,Inod)=qxPhiElements(:,Inod)+qPhix0+qPhix1 ;
                qyPhiElements(:,Inod)=qyPhiElements(:,Inod)+qPhiy0+qPhiy1 ;

                
            end
        end

        % assemble right-hand side

        QUx=sparseUA(neq,1); QUy=sparseUA(neq,1);
        QPx=sparseUA(neq,1); QPy=sparseUA(neq,1);

        for Inod=1:MUA.nod
            QUx=QUx+sparseUA(MUA.connectivity(:,Inod),ones(MUA.Nele,1),qxUpsilonElements(:,Inod),neq,1);
            QUy=QUy+sparseUA(MUA.connectivity(:,Inod),ones(MUA.Nele,1),qyUpsilonElements(:,Inod),neq,1);
            QPx=QPx+sparseUA(MUA.connectivity(:,Inod),ones(MUA.Nele,1),qxPhiElements(:,Inod),neq,1);
            QPy=QPy+sparseUA(MUA.connectivity(:,Inod),ones(MUA.Nele,1),qyPhiElements(:,Inod),neq,1);
        end


        qPhix=full(MUA.M\QPx);
        qPhiy=full(MUA.M\QPy);

        qUpsilonx=full(MUA.M\QUx);
        qUpsilony=full(MUA.M\QUy);

        qwx=qPhix+qUpsilonx;
        qwy=qPhiy+qUpsilony;


    case "-A-"

        qwx=F1.hw.*F1.uw ;
        qwy=F1.hw.*F1.vw;
        qUpsilonx=nan;
        qUpsilony=nan;
        qPhix=nan;
        qPhiy=nan;



    otherwise



        error("case not found")


end



end





