

Var her ekki buid


load("InvA-Weertman-Ca1-Cs100000-Aa1-As100000-10km") ;
FA=scatteredInterpolant(xA,yA,AGlen);  
save("FA-Weertman-Ca1-Cs100000-Aa1-As100000-10km.mat") ;



load("InvC-Weertman-Ca1-Cs100000-Aa1-As100000-10km") ;
FC=scatteredInterpolant(xC,yC,C);  
save("FC-Weertman-Ca1-Cs100000-Aa1-As100000-10km.mat") ;

UserVar.RunType="-FT-P-TWISC0-MR4-SM-5km-Alim" ;  % -P-TWISC- is Thwaites Ice Shelf Calved off, 0km away