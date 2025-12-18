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
%  F.rho     :  ice density (nodal variable)edit 
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



B=zeros(MUA.Nnodes,1) ;
S=B*0-1e10;




switch  UserVar.TestCase

    case "sGaussPeak"

        
        s0=100 ;
        ampl=1000; sigma_x=10000 ; sigma_y=10000;
        s=ampl*exp(-((F.x/sigma_x).^2+(F.y/sigma_y).^2))+s0;

    case "sDeltaPeak"

        % Sharp upper surface (s) delta peak, but bed is flat.
        s0=100;
        W=10e3 ;
        A=1000;
        r=sqrt(F.x.*F.x+F.y.*F.y);
        s=A*2*W*DiracDelta(1/W,r,0)+s0;

    case "BDeltaPeak"

        % Here the B delta peak cuts through the ice surface, creating a nunatack
        s0=100;
        s=s0;
        W=10e3 ;
        A=1000;
        r=sqrt(F.x.*F.x+F.y.*F.y);
        B=A*2*W*DiracDelta(1/W,r,0);  % A delta peak of width W and amplitude A centered around x0=0;
        


    otherwise

        error("what case?")

end

b=B; 
h=s-b;
h(s0<CtrlVar.ThickMin)=CtrlVar.ThickMin;
s=b+h;


rho=900+zeros(MUA.Nnodes,1) ; rhow=1030; g=9.81/1000;

end



