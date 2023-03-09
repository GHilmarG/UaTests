  
%%

clearvars

load uvh2TestSave.mat

tic 
F1.h(BCs1.hPosNode)=CtrlVar.ThickMin;  % Make sure iterate is feasible, but this should be delt with by the BCs anyhow

F1.ub(BCs1.hPosNode)=F0.ub(BCs1.hPosNode);
F1.vb(BCs1.hPosNode)=F0.vb(BCs1.hPosNode);

[UserVar,RunInfo,F1,l1,BCs1]=uvh2D(UserVar,RunInfo,CtrlVar,MUA,F0,F1,l1,BCs1);

toc


%%

clearvars

load uvh2TestSave.mat

tic 
F1.h(BCs1.hPosNode)=CtrlVar.ThickMin;  % Make sure iterate is feasible, but this should be delt with by the BCs anyhow

% F1.ub(BCs1.hPosNode)=F0.ub(BCs1.hPosNode);
% F1.vb(BCs1.hPosNode)=F0.vb(BCs1.hPosNode);

[UserVar,RunInfo,F1,l1,BCs1]=uvh2D(UserVar,RunInfo,CtrlVar,MUA,F0,F1,l1,BCs1);

toc

%%