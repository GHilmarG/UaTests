function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


%%
%
% Defines model geometry and ice densities
%
%  [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
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
%  F.GF      : The nodal grounded/floating mask (has other subfields)
%
% These fields need to be returned at the nodal coordinates. The nodal
% x and y coordinates are stored in MUA.coordinates, and also in F as F.x and F.y
%
%%

persistent Fs FB Frho


if contains(UserVar.Example,"-Antarctica-") ||  contains(UserVar.Example,"-WAIS-")

    if isempty(Fs)

        UserVar.GeometryInterpolant='../../Interpolants/BedMachineGriddedInterpolants.mat';


        if isempty(Fs)
            fprintf('DefineGeometry: loading file: %-s ',UserVar.GeometryInterpolant)
            load(UserVar.GeometryInterpolant,'FB','Fs','Frho')
            fprintf(' done \n')
        end

    end

    s=Fs(F.x,F.y);
    B=FB(F.x,F.y);
    % b=Fb(x,y);
    rho=Frho(F.x,F.y);
    rhow=1030;
    g=9.81/1000;
    S=s*0 ;


    if UserVar.HelmholtzSmoothingLengthScale>0
        LL=UserVar.HelmholtzSmoothingLengthScale;

        [UserVar,s]=HelmholtzEquation(UserVar,CtrlVar,MUA,1,LL^2,s,0);
        [UserVar,B]=HelmholtzEquation(UserVar,CtrlVar,MUA,1,LL^2,B,0);

    end

    b=Calc_bh_From_sBS(CtrlVar,MUA,s,B,S,rho,rhow);


elseif contains(UserVar.Example,"-Island-")


    if contains(UserVar.Example,"-Retrograde-")

        l=UserVar.l;
        r=vecnorm([F.x F.y],2,2)  ;

        B0=-500 ; B=2000*  (3*(r/2/l).^2 - (r/l).^4) + B0  ;
        s0=1000 ;
        s=s0*exp(-(r/(l/3)).^2) ;


        S=s*0;
        rho=920;
        rhow=1030;
        g=9.81/1000;

        % now calculate h based on these B and s fields
        [b,h,GF]=Calc_bh_From_sBS(CtrlVar,MUA,s,B,S,rho,rhow);

        % add a perturbation to B
        if contains(UserVar.Example,"-Peaks-")

            % positive peak, ie mountain
            xc=25e3 ; yc=0e3 ;
            r=vecnorm([(F.x-xc) (F.y-yc)],2,2)  ;
            Peak = 100*l*DiracDelta(1/(5000),r,0) ;
            B=B+Peak;


            % positive peak, ie mountain
            xc=-25e3 ; yc=0e3 ;
            r=vecnorm([(F.x-xc) (F.y-yc)],2,2)  ;
            Peak = 100*l*DiracDelta(1/(5000),r,0) ;
            B=B+Peak;


            % Negative peak, ie trough
            xc=0e3 ; yc=20e3 ;
            r=vecnorm([(F.x-xc) (F.y-yc)],2,2)  ;
            W=l/5 ; A=-250;
            W=l/10 ; A=-250;
            W=l/20 ; A=-500;
            Peak = A*2*W*DiracDelta(1/W,r,0) ;
            B=B+Peak;




        end
        %but keep the same ice thickness, so now calculate s and b from h and B

        [b,s,h,GF]=Calc_bs_From_hBS(CtrlVar,MUA,h,S,B,rho,rhow);



        % figure(1); hold off; plot(r/1000,B) ; hold on ; plot(r/1000,s) ; plot(r/1000,b) ;plot(r/1000,S) ;

        %%

    else

        l=UserVar.l;
        r=vecnorm([F.x F.y],2,2)  ;

        B0=500 ;
        h=100+F.x*0;
        B= B0* (1 - 2*r/l) ;
        S=F.x*0;

        rho=920;
        rhow=1030;
        g=9.81/1000;

        [b,s,h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,h,S,B,rho,rhow);


    end

elseif contains(UserVar.Example,"-Plane-")

    S=zeros(MUA.Nnodes,1)-1e10;
    B=zeros(MUA.Nnodes,1);

    h=zeros(MUA.Nnodes,1)+1000;

    l=UserVar.l;
    r=vecnorm([F.x F.y],2,2)  ;

    %  W=100 ; A=5; x0=0 ; x=linspace(-10*W,10*W,1000) ; Peak = A*2*W*DiracDelta(1/W,x,x0) ; figure ; plot(x,Peak)

    w=20e3; 
    A=100; 
    dh = A*2*w*DiracDelta(1/w,r,0) ;
    h=h+dh ;
        
    rho=920;
    rhow=1030;
    g=9.81/1000;


    [b,s,h,F.GF]=Calc_bs_From_hBS(CtrlVar,MUA,h,S,B,rho,rhow);


else

    error("case not found")

end



end




