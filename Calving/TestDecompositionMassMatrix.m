load PIG-TWG-RestartFile.mat


CtrlVarInRestartFile.MUA.MassMatrix=true;
MUA=UpdateMUA(CtrlVarInRestartFile,MUA);



x1=F.s ; x2=F.s ;x3=F.s ;
tic ;

N=10; 
for ii=1:N
    x1=MUA.M\x1 ;
    x1=x1/norm(x1);
end
tM=toc;

tic
dM=decomposition(MUA.M,"chol") ; 

for ii=1:N
    x2=dM\x2 ;
    x2=x2/norm(x2);
end
tdM=toc;

tic
MUA.R=chol(MUA.M) ; 
for ii=1:N
    x3=MUA.R\(MUA.R'\x3) ;
    x3=x3/norm(x3);
end
tR=toc;

[norm(x1-x2) norm(x1-x3)]


fprintf("\n\n    backslash  \t \t decomposition   \t\t Chol \t\t speed up \n")
fprintf("\t %f \t\t %f \t\t %f \t\t %f \t\t %f \n",tM,tdM,tR,tM/tdM,tM/tR)