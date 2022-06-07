
%%
clearvars
load TestSave

F=UaNewFields(); 
F.ub=F0.ub ; F.vb=F0.vb ;
F.MUA=MUA;
F.MUA.dM=decomposition(MUA.M,'chol','upper') ;