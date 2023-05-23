function [Juv,dJduv,Huv,RunInfo]=JQuad(uv,UserVar,RunInfo,CtrlVar,MUA,F,fext0)



Mblock=MassMatrixBlockDiagonal2D(MUA);


H=Mblock;

Jmin=0;



Juv=Jmin+uv'*H*uv /2 ;

if nargout>1
    fprintf("Gradient \n ")
    dJduv=H*uv;
    if nargout>2
        fprintf("Hessian \n ")
        Huv=H ;
    end
end
% Newton:   H duv + dJduv =0
%             duv = - H \ dJduv
%                 = -H \ H uv
%                 = -uv

end