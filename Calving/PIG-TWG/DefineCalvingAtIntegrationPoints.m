function  [c,dcDdfdx,dcDdfdy]=DefineCalvingAtIntegrationPoints(UserVar,CtrlVar,dfdx,dfdy,u,v,h)

% cint=DefineCalvingAtIntegrationPoints(UserVar,CtrlVar,nx,ny,uint,vint)

switch UserVar.CalvingLaw.Scale

    case "-NV-"


        factor=UserVar.CalvingLaw.Factor ;
        % c=factor*(u.*nx+v.*ny);

        N=sqrt(dfdx.*dfdx+dfdy.*dfdy+eps);
        c=-factor*(u.*dfdx+v.*dfdy)./N;

        dcDdfdx=-factor.* (u./N - dfdx.*(u.*dfdx+v.*dfdy)./( (dfdx.*dfdx+dfdy.*dfdy+eps).^(3/2))  ) ;
        dcDdfdy=-factor.* (v./N - dfdy.*(u.*dfdx+v.*dfdy)./( (dfdx.*dfdx+dfdy.*dfdy+eps).^(3/2))  ) ;
       
    case "-hqk-"

        q=-2;

        k=86320694.4400036;
        c=k*h.^q;

        dcDdfdx=0; 
        dcDdfdy=0;

    otherwise

        error("CaseNotFound")

end