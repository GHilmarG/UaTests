
function [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
    
    %%
    %
    % [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    %
    %
    % Defines sliding-law parameters.
    %
    % The sliding law used is determined by the value of 
    %
    %   CtrlVar.SlidingLaw
    %
    % which is defined in 
    %
    %   DefineInitialInputs.m
    %
    % See description in Ua2D_DefaultParameters.m for further details and the
    % UaCompendium.pdf.
    %
    %%
    
    
  % tau=20kPa
  % ub=1000 m/yr
  % u=C tau^m
  % C=u/tau^m


    m=3;

    
    log10Cmax=1e2;  
    log10Cmin=1e-2; 
    Bmax=2000;
    Bmin=-500; 
    
  %  log10C=a0+a1*B ; 
  %
  %  log10(Cmin)=a0+a1*Bmax;
  %  log10(Cmax)=a0+a1*Bmin;

     % a0 = log10(Cmin)-a1*Bmax;
     % a0 = log10(Cmax)-a1*Bmin;
     %  0 = log10(Cmax)-log10(Cmin)-a1*(Bmin-Bmax) ;


     a1=(log10Cmin-log10Cmax)/(Bmax-Bmin);
     a0=log10Cmax-a1*Bmin;

     log10C=a0+a1*B; log10C(log10C>log10Cmax)=log10Cmax;
     C=10.^(log10C) ; 

     C=3.16e6^(-m)*1000^m*365.2422*24*60*60;
     C=C+zeros(MUA.Nnodes,1);
    
    
    q=1 ;      % only needed for Budd sliding law
    muk=0.5 ;  % required for Coulomb friction type sliding law as well as Budd, minCW (Tsai), rCW  (Umbi) and rpCW (Cornford).
    
    
end
