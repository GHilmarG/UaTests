function [UserVar,rho,rhow,g]=DefineDensities(UserVar,CtrlVar,MUA,time,s,b,h,S,B)
%  rhow    :  ocean density (scalar variable)
%  rho     :  ice density (nodal variable)
%  g       :  gravitational acceleration   

%I use and take all physical parameters from this one file MYPARAMETERS
[rg,Domain_radius,shelf_width,h0,Bedrock,rho,rhow,g,thinice,ur,n,AGlen]=DefineMyParameters();

% units: kPa, m , a
%LS pa=[kg m^-1 sec^-2]
x=MUA.coordinates(:,1);
%rho=rho+x*0;
rhow=rhow;
rho=rho;

g=g;
        
end
