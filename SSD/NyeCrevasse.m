


function [d,D]=NyeCrevasse(UserVar,CtrlVar,MUA,F)




%%
%
%
%
%
% $$\mathcal{d}_{\mathrm{Nye}}=\tau_1/ (\rho g ) $$
%
%
%
%
%
%
%%

[etaInt,xint,yint,exx,eyy,exy,Eint,e,txx,tyy,txy]=calcStrainRatesEtaInt(CtrlVar,MUA,F.ub,F.vb,F.AGlen,F.n); % returns integration point values

% Project onto nodes
[txx,tyy,txy]=ProjectFintOntoNodes(MUA,txx,tyy,txy);

pV=CalcPrincipalValuesOfSymmetricalTwoByTwoMatrices(txx,txy,tyy,eigenvalues=true,eigenvectors=false) ;

tau1=max(pV,[],2);
tau1(tau1<0)=0 ;

d=tau1./(F.rho.*F.g) ;


if nargout>1

    
    D=d./F.h ;  
    
    D(F.h<CtrlVar.ThickMin)=0 ; 
    Dmax=0.9; Dmin=0;  % I've hardwire these limits in here, need to be changed later
    D(D>Dmax)=Dmax;  
    D(D<Dmin)=Dmin;


end


% cbar=UaPlots(CtrlVar,MUA,F,d,FigureTitle="Nye d")  ; title(cbar,"$(m)$",Interpreter="latex") ; title("Crevasse depth $d=\tau_1/(\rho g)$",Interpreter="latex")


end