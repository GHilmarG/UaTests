function [UserVar,LSF,c]=DefineCalving(UserVar,CtrlVar,MUA,LSF,c,F,BCs)

%% initialize LSF

if isempty(F.LSF)

    F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
    NodesSelected=F.GF.NodesDownstreamOfGroundingLines;
    LSF=zeros(MUA.Nnodes,1)+1;
    LSF(NodesSelected)=-1;

end

%% Define calving rate (if needed)

if  CtrlVar.LevelSetEvolution=="-Prescribed-"

    F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
    NodesSelected=F.GF.NodesDownstreamOfGroundingLines;
    LSF=zeros(MUA.Nnodes,1)+1;
    LSF(NodesSelected)=-1;
    c=nan;   % setting the calving rate to nan implies that the level set is not evolved

else

    % It's assumed that the calving is defined at integration points only, or prescribed directly.
    % Anything else is deemed an error.
    k = 2; % according to Oerlemans and Nick (2005)
    d = F.h-(F.s-F.S);
    c = k * d;
    c=0;

end

