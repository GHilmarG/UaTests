
%%
load TestSave

db=1;

nk=10;
dh=-F.GF.node.*db-(1-F.GF.node).*db.*F.rhow./F.rho ;
for k=1:nk
    
    
    F.GF.node = HeavisideApprox(CtrlVar.kH,F.h+dh-hf,CtrlVar.Hh0);
    dh=-F.GF.node.*db-(1-F.GF.node).*db.*F.rhow./F.rho ;
    %F.h=F.h+dh;
    fprintf('norm(dh)=%20.10g \n',norm(dh))
end


F.s=F.b+F.h;

%%
