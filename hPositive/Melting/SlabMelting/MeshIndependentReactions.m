%%
load TestSaveUaOutputs.mat
   
MLC=BCs2MLC(MUA,BCs) ;
Reactions=CalculateReactions(MLC,l);

M=MassMatrix2D1dof(MUA);
P=NodalFormFunctionInfluence(MUA);

Msum=sum(M); Msum=Msum(:);

MeshIndependent1=Reactions.h./Msum;
MeshIndependent2=Reactions.h./P;

[UserVar,rho,rhow,g]=DefineDensities(CtrlVar.UserVar,CtrlVar,MUA,CtrlVar.time,s,b,h,S,B);

MeshIndependent1=MeshIndependent1./rho;
MeshIndependent2=MeshIndependent2./rho;

figure ; PlotMeshScalarVariable(CtrlVar,MUA,MeshIndependent1); title('M')


figure ; PlotMeshScalarVariable(CtrlVar,MUA,MeshIndependent2); title('P')

