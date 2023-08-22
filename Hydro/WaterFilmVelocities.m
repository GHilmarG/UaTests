


function [uw,vw]=WaterFilmVelocities(CtrlVar,MUA,F,k)



Phi=PhiPotential(CtrlVar,MUA,F);





[dPhidx,dPhidy]=gradUa(CtrlVar,MUA,Phi) ; 

uw=-k.*dPhidx;  
vw=-k.*dPhidy;




I=F.GF.node<0.1; 
uw(I)=10*uw(I);
vw(I)=10*vw(I);



end