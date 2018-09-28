function [rho,rhow,g]=DefineDensities(Experiment,coordinates,connectivity,s,b,h,S,B,Itime,time,CtrlVar)

    
    

    Nnodes=size(coordinates,1);
        
    rho=920+zeros(Nnodes,1) ; rhow=1030; g=9.81/1000;
    
    
end
