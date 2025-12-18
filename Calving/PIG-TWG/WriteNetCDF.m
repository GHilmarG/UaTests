

%%





load("InvA-Cornford-Ca1-Cs100000-Aa1-As100000-2k5km-Alim-Clim-uvGroup-.mat","xA","yA","AGlen")
load("InvC-Cornford-Ca1-Cs100000-Aa1-As100000-2k5km-Alim-Clim-uvGroup-.mat","xC","yC","C")

x=xA ; y=yA ;  A=AGlen;

nccreate("AforPIGandTWG.nc","x","Dimensions",{"i",numel(x)}) ; ncwrite("AforPIGandTWG.nc","x",x)
nccreate("AforPIGandTWG.nc","y","Dimensions",{"i",numel(y)}) ; ncwrite("AforPIGandTWG.nc","y",y)
nccreate("AforPIGandTWG.nc","A","Dimensions",{"i",numel(A)}) ; ncwrite("AforPIGandTWG.nc","A",A)
nccreate("AforPIGandTWG.nc","C","Dimensions",{"i",numel(C)}) ; ncwrite("AforPIGandTWG.nc","C",C)





%%
