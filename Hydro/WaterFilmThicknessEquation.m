function [UserVar,phi1,Phi1,N1,RR,KK]=WaterFilmThicknessEquation(UserVar,CtrlVar,MUA,F0,F1,k)


%% Water film thickness equation
%
%
% $$\partial_t h_w -  \nabla \cdot ( k h_w \nabla \Phi )  - \nabla \cdot (\kappa h_w \nabla h_w) = a_w $$
%
% where
%
% $$\Phi = (\rho_w-\rho) g \nabla B - \rho g \nabla s  $$
%
% $$N=0 $$
%
%%





dhw=zeros(MUA.Nnodes,1) ;
dlambda=[]; lambda=0;

BCs=BoundaryConditions ;
[UserVar,BCs]=GetBoundaryConditions(UserVar,CtrlVar,MUA,BCs,F1) ;
MLC=BCs2MLC(CtrlVar,MUA,BCs);
LL=MLC.hL ; cc=MLC.hRhs ;

if ~isempty(LL)
    BCsRes=LL*phi1-cc ;
    if norm(BCsRes) >1e-6
        phi1=LL\cc;   % make feasable
    end
end


for JNL=1:2  % since the system is linear, only one iteration is required

    [UserVar,RR,KK]=WaterFilmThicknessEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k);


    if ~isempty(LL)
        hh=cc-LL*phi1;
    else
        hh=[];
    end

    [dhw,dlambda]=solveKApeSymmetric(KK,LL,RR,hh,dhw,dlambda,CtrlVar) ;
    hw1=hw1+dhw ;
    lambda=lambda+dlambda ;

    fprintf("nit=%i \t norm(dphi)=%g \t norm(hh)=%g \n",JNL,norm(dhw),norm(hh))


end


N1=Phi1-phi1 ;



end


