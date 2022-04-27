function [UserVar,LSF,c]=DefineCalving(UserVar,CtrlVar,MUA,LSF,c,F,BCs)



%%
%
%   [UserVar,LSF,c]=DefineCalving(UserVar,CtrlVar,MUA,LSF,c,F,BCs)
%
% Define calving the Level-Set Field (LSF) and the Calving Rate Field (c)
%
% Both the Level-Set Field (LSF) and the Calving-Rate Field (c) must be defined over the whole computational domain.
%
%
% The LSF should, in general, only be defined in the beginning of the run and set the initial value for the LSF. However, if
% required, the user can change LSF at any time step. The LSF is evolved by solving the Level-Set equation, so any changes
% done to LSF in this m-file will overwrite/replace the previously calculated values for LSF.
%
% The calving-rate field, c, is an input field to the Level-Set equation and needs to be defined in this m-file in each call.
%
% The variable F has F.LSF and F.c as subfields. In a transient run, these will be the corresponding values from the previous
% time step.
%
%
% In contrast to LSF, c is never evolved by Úa.  (Think of c as an input variable similar to the input as and ab for upper
% and lower surface balance, etc.)
%
% If c is returned as a NaN, ie
%
%       c=NaN;
%
% then the level-set is NOT evolved in time using by solving the level-set equation. This can be usefull if, for example, the
% user simply wants to manually prescribe the calving front position at each time step.
%
%%

%% initialize LSF
if isempty(F.LSF)   % Do I need to initialize the level set function?


    Xc=UserVar.CalvingFront0.Xc;
    Yc=UserVar.CalvingFront0.Yc;

    % A rough sign-correct initialisation for the LSF
    io=inpoly2([F.x F.y],[Xc(:) Yc(:)]);
    LSF=-ones(MUA.Nnodes,1) ;
    LSF(io)=+1;

    % figure ; PlotMuaMesh(CtrlVar,MUA);   hold on ; plot(F.x(io)/1000,F.y(io)/1000,'or')

    [xc,yc,LSF]=CalvingFrontLevelSetGeometricalInitialisation(CtrlVar,MUA,Xc,Yc,LSF,plot=true,ResampleCalvingFront=true);


end

%% Define calving rate (if needed)

if  CtrlVar.LevelSetEvolution=="-Prescribed-"

    c=nan;   % setting the calving rate to nan implies that the level set is not evolved

elseif  CtrlVar.CalvingLaw.Evaluation=="-int-"

    c=0; % Must not be nan or otherwise the LSF will not be evolved.
    %      But otherwise these c values are of no importance and the c defined at int points is the one used

else

    % It's assumed that the calving is defined at integration points only, or prescribed directly.
    % Anything else is deemed an error.
    error("Define calving rate at integration points")

end

