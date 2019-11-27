function [ufixednode,ufixedvalue,vfixednode,vfixedvalue,utiedA,utiedB,vtiedA,vtiedB,hfixednode,hfixedvalue,htiedA,htiedB]=...
    DefineBCs(UserVar,CtrlVar,MUA,time,s,b,h,S,B,ub,vb,ud,vd,GF)

utiedA=[] ; utiedB=[];
vtiedA=[] ; vtiedB=[];
vfixednode=[];
ufixednode=[];
ufixedvalue=[];
vfixedvalue=[];
htiedA=[] ; htiedB=[];
hfixednode=[];  hfixedvalue=[];

%PlotBCs(coordinates,connectivity,ufixednode,vfixednode,Boundary,CtrlVar)



end