

%%



load("A-panAntarctic-m3-n3-Weertman-Nod3-Cga1-Cgs100000-Aga1-Ags100000-logC-logA-N1754k-E3494k-.mat","xA","xA","AGlen")
load("C-panAntarctic-m3-n3-Weertman-Nod3-Cga1-Cgs100000-Aga1-Ags100000-logC-logA-N1754k-E3494k-.mat","xC","yC","C")


x=xA ; y=yA ;  A=AGlen;

nccreate("AforAntarctica.nc","x","Dimensions",{"i",numel(x)}) ; ncwrite("AforAntarctica.nc","x",x)
nccreate("AforAntarctica.nc","y","Dimensions",{"i",numel(y)}) ; ncwrite("AforAntarctica.nc","y",y)
nccreate("AforAntarctica.nc","A","Dimensions",{"i",numel(A)}) ; ncwrite("AforAntarctica.nc","A",A)
nccreate("AforAntarctica.nc","C","Dimensions",{"i",numel(C)}) ; ncwrite("AforAntarctica.nc","C",C)





%%
