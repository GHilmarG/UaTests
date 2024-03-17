





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

persistent Fs FB Fb Frho


if contains(UserVar.Example,"-PIG-")

    if isempty(Fs)

        UserVar.GeometryInterpolant='../../Interpolants/BedMachineGriddedInterpolants.mat';


        if isempty(Fs)
            fprintf('DefineGeometry: loading file: %-s ',UserVar.GeometryInterpolant)
            load(UserVar.GeometryInterpolant,'FB','Fs','Fb','Frho')
            fprintf(' done \n')
        end

    end

    s=Fs(F.x,F.y);
    B=FB(F.x,F.y);
    b=Fb(F.x,F.y);
    rho=Frho(F.x,F.y); 
    rhow=1030;
    g=9.81/1000;
    S=s*0 ;

    h=s-b ; 
    h(h<CtrlVar.ThickMin)=CtrlVar.ThickMin ; 
    [b,s,h]=Calc_bs_From_hBS(CtrlVar,MUA,h,S,B,rho,rhow) ;

end


end




