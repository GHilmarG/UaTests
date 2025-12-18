





function [InverseRestartFile,InverseCFile,InverseAFile,InversePriorsFile]=CreateFilenamesForInverseRunOuputs(PreString,CtrlVar,nEle,nNodes)

%%
% Just a simple approach to define some filenames used in inverse runs
%
% I found that I was doing this in various different runs again and again, and always using a somewhat different approach.
%
% Maybe by using this utility, filenames will be more consistent across runs
%
%
% If number of elements and nodes are known at call time, I usually set PreString as, for example: PreString="panAntarctic-m3-n3-54kElements-28kNodes";
%
%
%
%
%%

if nargin<4
    nNodes=[];
    if nargin<3
        nEle=[];
    end
end

if isempty(nNodes)
   nNodesString="";
else
    nNodesString=sprintf("-N%gk-",round(nNodes/1000)) ;
end

if isempty(nEle)
   nEleString="";
else
    nEleString=sprintf("-E%gk-",round(nEle/1000)) ;
end




if isempty(PreString)
    PreString="" ;
end


filename=sprintf('-%s-%s-Nod%i-Cga%i-Cgs%i-Aga%i-Ags%i-%s',...
    PreString,...
    CtrlVar.SlidingLaw,...
    CtrlVar.TriNodes,...
    CtrlVar.Inverse.Regularize.logC.ga,...
    CtrlVar.Inverse.Regularize.logC.gs,...
    CtrlVar.Inverse.Regularize.logAGlen.ga,...
    CtrlVar.Inverse.Regularize.logAGlen.gs,...
    CtrlVar.Inverse.InvertFor);

filename=filename+nNodesString+nEleString ; 


filename=replace(filename,'.','k'); 
filename=replace(filename,'--','-');
filename=replace(filename,'logAGlen','logA');


InverseRestartFile="IR"+filename ;
InverseCFile="C"+filename ;
InverseAFile="A"+filename ;
InversePriorsFile="Priors"+filename ;




end