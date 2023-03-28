%%

% load("TestSaveuvMatrixAssembly.mat","CtrlVar","MUA","F")
% load("TestSaveuvMatrixAssembly22190.mat","CtrlVar","MUA","F")
 load("TestSaveuvMatrixAssembly86142","CtrlVar","MUA","F")
% load("TestSaveuvMatrixAssembly333294","CtrlVar","MUA","F")

%

CtrlVar.QuadratureRuleDegree=8 ;  MUA=UpdateMUA(CtrlVar,MUA); 



MUA.dM=[];
CtrlVar.uvMatrixAssembly.Ronly=0 ;

fprintf("Starting sequential \n")

tSeq=tic;
[Ruv,Kuv,Tint,Fext]=uvMatrixAssemblySSTREAM(CtrlVar,MUA,F) ;
tSeq=toc(tSeq) ;


% delete(gcp('nocreate'))

fprintf("Starting SPMD \n")
tSPMD=tic;
[RuvTest,KuvTest,TintTest,FextTest]=uvMatrixAssemblySSTREAMspmd(CtrlVar,MUA,F) ;
tSPMD=toc(tSPMD);

fprintf(' tSeq=%f \t tSPMD=%f \t speedup=%f \n',tSeq,tSPMD,tSeq/tSPMD)

norm(RuvTest-Ruv)/norm(Ruv)
if ~CtrlVar.uvMatrixAssembly.Ronly
    norm(diag(KuvTest-Kuv))/max(abs(diag(Kuv)))
end

%%




