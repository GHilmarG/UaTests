







function [rg,Domain_radius,shelf_width,h0,Bedrock,rho,rhow,g,thinice,ur,n,AGlen]=DefineMyParameters(UserVar)
%units are aimed to be (through the physical parameters) 
%Length in meter;
%time in sec;
%Pressure in Pa;

Bedrock=10; %Ocean depth everywhere. The B field. Given positive then B=-Bedrock.
rg=0.015; % inner radius of initial ice/polymer, also inner boundary of computational domain

Domain_radius=0.3; %Width of circular computational domain
shelf_width=rg/5; %Width of initial shelf, where Dirichlet conditions apply, not used currenly
h0=0.02; %thickness of initial floating shelf (2cm)
thinice=h0/10000; %The thin layer of artificial ice/polymer everywhere in the computational domain. In Brunt this was taken as 1m, compared to the 150m thickness of the shelf


rho=1020; %Density of Ice / polymer fluid, LS 1020 is in [kg/m^3]. Can also be scalar field +zeros(MUA.Nnodes,1);
rhow=1181; %Density of water / ambient fluid
g=9.81; %9.81[m/s^2] . 
ur=0.001; %[m/sec] LS the radial velocity on the inner boundary. Dirichlet constant velocity. I would say roughly 1-5[mm/sec]


Viscosity='nonNewtonian';
Viscosity='Newtonian';
Pegler2012='e';

switch UserVar.n
    case  1
        n=1;
        AGlen=0.015; %About 0.1 for viscosity=10[Pa sec] or 0.01 for viscosity=100[Pa sec] ~ Golden Syrup
        rho=1400; %Density of Golden Syrup [kg/m^3]. Can also be scalar field +zeros(MUA.Nnodes,1);
        rhow=1560; %Density of ambient fluid
        switch Pegler2012
            case 'a'
                nu=73; %[cm^2/sec] Pegler units
                mu=nu*1e-04*rho; %[Pa*sec] MY Ua units, using meters and kg
                [AGlen,rg,h0,Q]=deal(1/(2*mu),0.015,0.02,7.5*10^-06); %from Pegler's experiments, units here: [Pa^-1 sec^-1],[m],[m],[m^3,sec]
            case 'b'
                nu=329; %[cm^2/sec]
                mu=nu*1e-04*rho; %[Pa*sec] MY Ua units, using meters and kg
                [AGlen,rg,h0,Q]=deal(1/mu,0.015,0.02,9.5*10^-06);
            case 'c'
                nu=436; %[cm^2/sec]
                mu=nu*1e-04*rho; %[Pa*sec] MY Ua units, using meters and kg
                [AGlen,rg,h0,Q]=deal(1/mu,0.015,0.02,6.9*10^-06);
            case 'd'
                nu=271; %[cm^2/sec]
                mu=nu*1e-04*rho; %[Pa*sec] MY Ua units, using meters and kg
                [AGlen,rg,h0,Q]=deal(1/mu,0.015,0.02,2.1*10^-06);
            case 'e'  
                nu=530; %[cm^2/sec]
                mu=nu*1e-04*rho; %[Pa*sec] MY Ua units, using meters and kg
                [AGlen,rg,h0,Q]=deal(1/(2*mu),0.015,0.02,6.4*10^-06);
        end
        ur=Q/(2*pi*rg*h0); %[m/sec] radial velocity , instead of Pegler flux Q0
    case 6
        n=6;
        AGlen=9.7e-09; % LS  softness for polymer in [Pa^-n Sec^-1]
        Q=6.4*10^-06; %[m3/sec] flux nters from inner boundary
        ur=Q/(2*pi*rg*h0); %[m/sec] radial velocity to be given into Boundary Conditions
    case 'IceUa'
        n=3;
        AGlen=6.338e-25*1e9*365.2422*24*60*60; %Which is roughly 1e-09. Can also use it as a scalar field by adding +zeros(MUA.Nnodes,1)
end

%% About units
%check inside Ua2D_DefaultParameters if those are marked
%CtrlVar.Plot.Units.zDistance="m" ; 
%CtrlVar.Plot.Units.Time="s" ; 
%CtrlVar.Plot.Units.Stress="Pa" ; 

end
