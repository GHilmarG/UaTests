function [UserVar,RunInfo,F1,l1,BCs1]=uvhPrescibed(UserVar,RunInfo,CtrlVar,MUA,F0,F1,l1,BCs1)




r=sqrt(F1.x.*F1.x+F1.y.*F1.y);
theta=atan2(F1.y,F1.x);
R=1000e3; speedMax=1000;


F1.ub=-speedMax*(r/R).*sin(theta);
F1.vb= speedMax*(r/R).*cos(theta);









end