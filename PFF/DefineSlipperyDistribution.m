
function  [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F)
    
    
    %%
    %
    % [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F)
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
    
    C=zeros(MUA.Nnodes,1)+3 ;
    m=zeros(MUA.Nnodes,1)+3;
      
    q=[] ;      % only needed for Budd sliding law
    muk=[] ;  % required for Coulomb friction type sliding law as well as Budd, minCW (Tsai), rCW  (Umbi) and rpCW (Cornford. 
    
    
end
