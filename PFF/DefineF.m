





function F=DefineF(UserVar,CtrlVar,MUA,hIce)


F=UaFields;
n=MUA.Nnodes;

if   UserVar.Experiment=="ice shelf single notch"

    h=1000;

elseif UserVar.Experiment=="ice shelf constricted"
    
    h=1000;

else


    h=300;

end

if nargin>3
    h=hIce;
end

rho=920;
rhow=1030;

F.s=zeros(n,1);
F.b=zeros(n,1);
F.h=zeros(n,1)+h;
F.S=zeros(n,1);
F.B=zeros(n,1)-1e10;
F.ub=zeros(n,1);
F.vb=zeros(n,1);
F.rho=zeros(n,1)+rho;
F.rhow=rhow;
F.AGlen=zeros(n,1)+AGlenVersusTemp(-10) ;
F.C=zeros(n,1)+3 ;
F.g=9.81/1000;
F.alpha=0;

F.x=MUA.coordinates(:,1) ;
F.y=MUA.coordinates(:,2) ;


F.n=zeros(n,1)+3;
F.m=zeros(n,1)+3;





F.AGlen0=F.AGlen; 
F.rho0=F.rho; 


switch UserVar.Experiment
    
    case "ice shelf stream flow"

    % I=abs(F.y)<20e3 ; 
    % F.AGlen(I)=AGlenVersusTemp(0) ;  % make ice here weaker

    F.h=F.h*0+700;


    case "ice shelf constricted"

        F.h=F.h*0+700;

end

[F.b,F.s,F.h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,F.h,F.S,F.B,F.rho,F.rhow);

end