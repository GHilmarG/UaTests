function Huv=Huv(uv,lambda,UserVar,RunInfo,CtrlVar,MUA,F)



persistent MUAcopy Fcopy CtrlVarcopy

if nargin<3
    MUA=MUAcopy ;
    F=Fcopy;
    CtrlVar=CtrlVarcopy ;
else
    MUAcopy=MUA;
    Fcopy=F;
    CtrlVarcopy=CtrlVar;
end

if isempty(uv)
    Huv=[];
    return
end


N=MUA.Nnodes;

F.ub=uv(1:N);
F.vb=uv(N+1:2*N);

Mblock=MassMatrixBlockDiagonal2D(MUA);

if CtrlVar.Ex=="Quad"


    
    Huv=Mblock;

else

    [Ruv,Huv]=KRTFgeneralBCs(CtrlVar,MUA,F);
    Huv=Mblock*Huv; 


end


fprintf("Huv: Hessian \n")



end



