




function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


%%
%
% Defines model geometry and ice densities
%
%   [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)
%
% FieldsToBeDefined is a string indicating which return values are required. For
% example if
%
%   FieldsToBeDefined="-s-b-S-B-rho-rhow-g-"
%
% then s, b, S, B, rho, rhow and g needed to be defined.
%
% Typically, in a transient run
%
%   FieldsToBeDefined="-S-B-rho-rhow-g-"
%
% implying that only s and b do not needed to be defined, and s and b can be set to any
% value, for example s=NaN and b=NaN.
%
% It is OK to define values that are not needed, these will simply be ignored by Úa.
%
% As in all other calls:
%
%  F.s       : is upper ice surface
%  F.b       : lower ice surface
%  F.B       : bedrock
%  F.S       : ocean surface
%  F.rhow    :  ocean density (scalar variable)
%  F.rho     :  ice density (nodal variable)
%  F.g       :  gravitational acceleration
%  F.x       : x nodal coordinates 
%  F.y       : y nodal coordinates 
%  F.time    : time (i.e. model time)
%  F.GF      : The nodal grounded/floating mask (has other subfields)
%
% These fields need to be returned at the nodal coordinates. 
% 
% The nodal x and y coordinates are also stored in MUA.coordinates in addition to F.x and F.y.
%
%%

rho=900+zeros(MUA.Nnodes,1) ;
rhow=1030;
g=9.81/1000;


if FieldsToBeDefined=="-rho-"
    s=[];
    b=[];
    S=[];
    B=[];

    return
end


switch lower(UserVar.RunType)

    case 'icestream'

        hmean=1000;
        b=zeros(MUA.Nnodes,1) ;
        S=zeros(MUA.Nnodes,1)-1e10;
        B=b ;
        s=hmean+b;

   

    case 'iceshelf'

        hmean=1000;
        b=zeros(MUA.Nnodes,1) ;
        S=zeros(MUA.Nnodes,1);
        B=S*0-1e10;
        s=hmean+b;

   

    case 'icestream+iceshelf'

        beta=0.01;
        hmean=1000;
        B0=500;

        x=MUA.coordinates(:,1);
        y=MUA.coordinates(:,2);


        B=B0-beta*x ;

        Ly=max(y)-min(y);
        B=B+0.25*hmean*cos(4*pi*y/Ly);

        b=B;
        S=B*0;
        s=hmean+b;

        [b,s,h,GF]=Calc_bs_From_hBS(CtrlVar,MUA,s-b,S,B,900,1030);



    case 'valley'


        [s,b,B,S]=Valley(UserVar,CtrlVar,MUA,F,false) ;


end

if UserVar.Inverse.CreateSyntData==2 && contains(UserVar.Inverse.SynthData.Pert,"-B-")

    fprintf(' Creating true B for the generation of synthetic measurements.\n')


    x=MUA.coordinates(:,1) ;
    y=MUA.coordinates(:,2);

    %dbType='Gauss' ;


    switch lower(UserVar.Inverse.Syntdata.GeoPerturbation)

        case 'gauss'

            sx=20e3 ; sy=20e3;
            db=hmean/2;
            bpert=db*exp(-(x.*x/sx^2+y.*y./sy^2));
            b=b+bpert ;
            B=B+bpert;

        case 'circ'

            R=sqrt(x.*x+y.*y) ;
            I=R<50e3 ;
            bpert=b*0;
            bpert(I)=hmean/2;
            b=b+bpert ;
            B=B+bpert;

        case 'valley'


            [s,b,B,S]=Valley(UserVar,CtrlVar,MUA,F,true) ;



    end

    figure ; Plot_sbB(CtrlVar,MUA,s,b,B) ; title(' with perturbation ' )


end


switch lower(UserVar.RunType)

    case 'icestream'

        B=b ;

    case 'iceshelf'

        B=b-1e10;


end

end




