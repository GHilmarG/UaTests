function  [c,dcDdfdx,dcDdfdy]=DefineCalvingAtIntegrationPoints(UserVar,CtrlVar,dfdx,dfdy,u,v,h,s)

%
%  f is the level set function
%
%
%
% cint=DefineCalvingAtIntegrationPoints(UserVar,CtrlVar,nx,ny,uint,vint)

switch UserVar.CalvingLaw.Type

    case "-AC-"

        CliffHeight=min((s-S),h) ;

        fI=3.2e-17*365.25 ; c=fI*CliffHeight.^(7.2) ;
        % Now set calving rate to zero for cliff less than 135meters
        c(CliffHeight<135)=0 ;
        % and set maximum at at cliff height equalt to 450m
        %cMax=fI*450.^(7.2) ;
        %c(c>cMax)=cMax ;

        c(c>UserVar.CalvingRateMax)=UserVar.CalvingRateMax ; % set an upper max
        dcDdfdx=0;
        dcDdfdy=0;

    case "-NV-"   % Calving is a function of the normal velocity component to the calving front
        % That is:  c = f(v_n)   where c is the calving rate and v_n the ice velocity normal to the calving front
        % v_n = v \cdot n  , where n is a normal to the calving front
        % Using the level set \varphi, we have n=\nabla \varphi / norm(\varphi)

        factor=UserVar.CalvingLaw.Factor ;
        % c=factor*(u.*nx+v.*ny);

        N=sqrt(dfdx.*dfdx+dfdy.*dfdy+eps);

        Vn=-(u.*dfdx+v.*dfdy)./N;  % Note the sign convention 
        c=factor*Vn;

        % c=-factor*(u.*dfdx+v.*dfdy)./N;

        dcDdfdx=-factor.* (u./N - dfdx.*(u.*dfdx+v.*dfdy)./( (dfdx.*dfdx+dfdy.*dfdy+eps).^(3/2))  ) ;
        dcDdfdy=-factor.* (v./N - dfdy.*(u.*dfdx+v.*dfdy)./( (dfdx.*dfdx+dfdy.*dfdy+eps).^(3/2))  ) ;

    case "-RR-"    % Prescribing retreat rate

       

        factor=1 ; 
        N=sqrt(dfdx.*dfdx+dfdy.*dfdy+eps);
        Vn=-(u.*dfdx+v.*dfdy)./N;  % Normal velocity component

        RetreatRate=Vn*0;
        RetreatRate(Vn>1000)=1000;  % Retreat rate equal to 1000 m/yr where Vn > 1000 m/yr 

        c=Vn+RetreatRate ;

        % c=-factor*(u.*dfdx+v.*dfdy)./N;

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