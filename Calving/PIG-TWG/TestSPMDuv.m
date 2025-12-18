%%

% load("TestSaveuvMatrixAssembly.mat","CtrlVar","MUA","F")
% load("TestSaveuvMatrixAssembly22190.mat","CtrlVar","MUA","F")
% load("TestSaveuvMatrixAssembly86142","CtrlVar","MUA","F")
% load("TestSaveuvMatrixAssembly333294","CtrlVar","MUA","F")

%load("TestSaveuvMatrixAssemblynEle664509","CtrlVar","MUA","F")

load("TestSaveuvMatrixAssemblynEle171243","CtrlVar","MUA","F")


%

CtrlVar.QuadratureRuleDegree=4 ;  MUA=UpdateMUA(CtrlVar,MUA); 




CtrlVar.uvMatrixAssembly.Ronly=false ;
CtrlVar.Parallel.isTest=false ;


% seq
CtrlVar.Parallel.uvAssembly.spmd.isOn=false; 
CtrlVar.Parallel.uvAssembly.spmdInt.isOn=false;


fprintf("Seq \n")

tSeq=tic;

[Ruv,Kuv,Tint,Fext]=KRTFgeneralBCs(CtrlVar,MUA,F);

tSeq=toc(tSeq) ;


% Paralell

CtrlVar.Parallel.uvAssembly.spmd.isOn=1; CtrlVar.Parallel.uvAssembly.spmdInt.isOn=0;


fprintf("SPMD: partition=%i \t integration points=%i \n",CtrlVar.Parallel.uvAssembly.spmd.isOn,CtrlVar.Parallel.uvAssembly.spmdInt.isOn)

ticBytes(gcp);
tSPMD=tic;

[RuvTest,KuvTest,TintTest,FextTest]=KRTFgeneralBCs(CtrlVar,MUA,F);
tSPMD=toc(tSPMD);

tocBytes(gcp)


fprintf(' tSeq=%f \t tSPMD=%f \t speedup=%f \n',tSeq,tSPMD,tSeq/tSPMD)

norm(RuvTest-Ruv)/norm(Ruv)
if ~CtrlVar.uvMatrixAssembly.Ronly
    norm(diag(KuvTest-Kuv))/max(abs(diag(Kuv)))
end


%% parfeval


load("TestSaveuvMatrixAssemblynEle171243","CtrlVar","MUA","F")
% load("TestSaveuvMatrixAssemblynEle664509","CtrlVar","MUA","F")

CtrlVar.Parallel.uvAssembly.spmd.isOn=0; CtrlVar.Parallel.uvAssembly.spmdInt.isOn=0;

fprintf("Seq \n")

tSeq=tic;

[Ruv,Kuv,Tint,Fext]=KRTFgeneralBCs(CtrlVar,MUA,F);

tSeq=toc(tSeq) ;

fprintf("Parfeval \n")
tParf=tic;
[RuvTest,KuvTest,TintTest,FextTest]=uvAssemblyParfeval(CtrlVar,MUA,F) ;
tParf=toc(tParf) ;

fprintf(' tSeq=%f \t tParf=%f \t speedup=%f \n',tSeq,tParf,tSeq/tParf)

norm(RuvTest-Ruv)/norm(Ruv)
if ~CtrlVar.uvMatrixAssembly.Ronly
    norm(diag(KuvTest-Kuv))/max(abs(diag(Kuv)))
end

