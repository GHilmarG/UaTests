


function [uw,vw]=WaterFilmVelocities(CtrlVar,UserVar,MUA,F,k)



Phi=PhiPotential(CtrlVar,MUA,F);





[dPhidx,dPhidy]=gradUa(CtrlVar,MUA,Phi) ; 

uw=-k.*dPhidx;  
vw=-k.*dPhidy;


I=F.GF.node<0.1; 
uw(I)=10*uw(I);
vw(I)=10*vw(I);


if UserVar.Example=="-Antarctica-" 

uw(MUA.Boundary.Nodes)=0;
vw(MUA.Boundary.Nodes)=0;


end



end