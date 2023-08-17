

function [UserVar,hw1,Phi1,uw1,vw1,RR,KK]=WaterFilmThicknessEquation(UserVar,CtrlVar,MUA,F0,F1,k)


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

Phi1=F1.g.* ( (F1.rhow-F1.rho).*F1.B + F1.rho.*F1.s) ;   % does not change, if s and b do not
Phi0=F0.g.* ( (F0.rhow-F0.rho).*F0.B + F0.rho.*F0.s) ;   % does not change, if s and b do not

[dPhidx,dPhidy]=gradUa(CtrlVar,MUA,Phi1) ; uw1=-k.*dPhidx;  vw1=-k.*dPhidy;
[dPhidx,dPhidy]=gradUa(CtrlVar,MUA,Phi0) ; uw0=-k.*dPhidx;  vw0=-k.*dPhidy;

% %% Figure
% figP=FindOrCreateFigure("(uw,vw)") ; clf(figP) ;
% QuiverColorGHG(F1.x,F1.y,uw1,vw1,CtrlVar) ;
% hold on
% % plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
% PlotMuaBoundary(CtrlVar,MUA) ;
% title(sprintf("$\\mathbf{v}_w$ time=%g",CtrlVar.time),Interpreter="latex")
% hold off
% 
% %%



dhw=zeros(MUA.Nnodes,1) ;
dlambda=[]; lambda=0;


BCs=BoundaryConditions ;
[UserVar,BCs]=GetBoundaryConditions(UserVar,CtrlVar,MUA,BCs,F1) ;
MLC=BCs2MLC(CtrlVar,MUA,BCs);
LL=MLC.hL ; cc=MLC.hRhs ;

if ~isempty(LL)
    BCsRes=LL*F1.hw-cc ;
    if norm(BCsRes) > 1e-6
        F1.hw(BCs.hFixedNode)= BCs.hFixedValue; 
        F0.hw(BCs.hFixedNode)= BCs.hFixedValue; 
%        F1.hw=LL\cc;   % make feasable
    end
end

if CtrlVar.WaterFilm.ResetThickness 
    ThickMin=CtrlVar.WaterFilm.ThickMin; 
    F0.hw(F0.hw<ThickMin)=ThickMin;
    F1.hw(F1.hw<ThickMin)=ThickMin;

end

for JNL=1:5  % since the system is linear, only one iteration is required


    [UserVar,RR,KK]=WaterFilmThicknessEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k,uw0,vw0,uw1,vw1);
 
    [UserVar,BCs]=GetBoundaryConditions(UserVar,CtrlVar,MUA,BCs,F1) ;
    MLC=BCs2MLC(CtrlVar,MUA,BCs);
    LL=MLC.hL ; cc=MLC.hRhs ;

    if ~isempty(LL)
        hh=cc-LL*F1.hw;
        
    else
        hh=[];
    end
    dlambda=[]; 


    [dhw,dlambda]=solveKApeSymmetric(KK,LL,RR,hh,dhw,dlambda,CtrlVar) ;
    F1.hw=F1.hw+dhw ;
   % lambda=lambda+dlambda ;


    fprintf("nit=%i \t norm(dphi)=%g \t norm(hh)=%g \n",JNL,norm(dhw),norm(hh))


end

hw1=F1.hw;

end


