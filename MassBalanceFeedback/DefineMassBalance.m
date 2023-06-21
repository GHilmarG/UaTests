
function [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)



Test="-uniform-" ;
%Test="-nonuniform-" ;

% Test #1 : Spatially uniform upper-surface mass balance, linearly dependent on ice thickness

switch Test

    case "-uniform-"

        as=F.h;
        dasdh=zeros(MUA.Nnodes,1)+1;


    case "-nonuniform-"

        % Test #2 : Spatially non-uniform mass balance, linearly dependent on ice thickness

        xl=min(F.x) ; xr=max(F.x) ;

        dh=5; 
        l=(xr-xl)/10 ;
        as=F.h+dh*sin(2*pi*(F.x-xl)/l);
        dasdh=zeros(MUA.Nnodes,1)+1;

        %fprintf('time=%f \t as=%f \t h=%f \n ',time,mean(as),mean(h))

        % if as=h and h=h0 at t=t0=0 and velocities are effectily zero, then:
        % dh/dt=a=h
        % h=h0 exp(t)

end

ab=F.s*0;
dabdh=zeros(MUA.Nnodes,1);

% dasdh=zeros(MUA.Nnodes,1);


end

