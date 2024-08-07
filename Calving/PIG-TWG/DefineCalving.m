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

    if  contains(UserVar.RunType,"-c0isGL0-")  % -> Initial calving front (c0) is set a initial grounding line position (GL0)

        LSF=-ones(MUA.Nnodes,1) ;
        LSF(F.GF.node>0.5)=+1;
        Xc=[] ;  % If Xc and Yc are left empty, the Xc and Yc will be calculated as the zero contour line of the LSF field
        Yc=[] ;


    else

        [UserVar,Xc,Yc]=CreateInitialCalvingFrontProfiles(UserVar,CtrlVar,MUA,F,CalvingFront=UserVar.CalvingFront0);

        % A rough sign-correct initialisation for the LSF
        io=inpoly2([F.x F.y],[Xc Yc]);
        LSF=-ones(MUA.Nnodes,1) ;
        LSF(io)=+1;

        % figure ; PlotMuaMesh(CtrlVar,MUA);   hold on ; plot(F.x(io)/1000,F.y(io)/1000,'or')

    end

    [xc,yc,LSF]=CalvingFrontLevelSetGeometricalInitialisation(CtrlVar,MUA,Xc,Yc,LSF,plot=false);


end

%% Define calving rate (if needed)

if  CtrlVar.LevelSetEvolution=="-Prescribed-"

    c=nan;   % setting the calving rate to nan implies that the level set is not evolved

elseif  CtrlVar.CalvingLaw.Evaluation=="-int-"

    % c=0; % Must not be nan or otherwise the LSF will not be evolved.
    % But otherwise these c values are of no importance and the c defined at int points is the one used

    % This value for the calving rate will actually not be used directly by the code
    % because the calving rate is here defined at integration points.
    % But for plotting purposes it is good to define the calving at nodal points as well
    % so here a call is made to define c at the nodes. 
    % c=DefineCalvingAtIntegrationPoints(UserVar,CtrlVar,nan,nan,F.ub,F.vb,F.h,F.s,F.S,F.x,F.y) ;
    c=DefineCalvingAtIntegrationPoints(UserVar,CtrlVar,nan,nan,F) ;

    % OK, have to be careful here, if I define calving rate involving the level set derivatives themselves, then this does not
    % work, and I return a nan, but a nan would imply not evolving the level set at all. So must make sure that if c is nan, that
    % I then simply set it to some numerical value, again this is only for plotting purposes and should maybe better be done in
    % DefineOutputs

    if isnan(c)
        c=0;
    end
else

    % It's assumed that the calving is defined at integration points only, or prescribed directly.
    % Anything else is deemed an error.
    error("Define calving rate at integration points")

end


