function [UserVar,LSF,c]=DefineCalving(UserVar,CtrlVar,MUA,F,BCs)

%% To-Do
% Possibly better to write this as 
%
%  [UserVar,LSF,c]=DefineCalving(UserVar,CtrlVar,MUA,LSF,c,F,BCs)
%
% in which case LSF and c are always passed right through by default.
%
% 
% 
%
%%

%%
%
%   [UserVar,LSF,CalvingRate]=DefineCalving(UserVar,CtrlVar,MUA,F,BCs)
%
% Define calving the Level-Set Field (LSF) and the Calving Rate Field (c)
%
% Both the Level-Set Field (LSF) and the Calving-Rate Field (c) must be defined over
% the whole computational domain.
%
%
% The LSF should, in general, only be defined in the beginning of the run and set the
% initial value for the LSF. However, if required, the user can change LSF at any time
% step. The LSF is evolved by solving the Level-Set equation, so any changes done to
% LSF in this m-file will overwrite/replace the previously calculated values for LSF.
%
% The calving-rate field, c, is an input field to the Level-Set equation and needs to
% be defined in this m-file in each call.
%
% The variable F has F.LSF and F.c as subfields. In a transient run, these will be the
% corresponding values from the previous time step.
%
% If you do not want to modify LSF,  set
%
%   LSF=F.LSF
%
%
% Also, if you do not want to modify c, you could set
%
%   c=F.c
%
% However, note that in contrast to LSF, c is never evolved by Úa.  (Think of c as an
% input variable similar to the input as and ab for upper and lower surface balance,
% etc.)
%
% If c is returned as a NaN, ie
%
%       c=NaN;
%
% then the level-set is NOT evolved in time using by solving the level-set equation. This can be usefull if, for example, the
% user simply wants to manually prescribe the calving front position at each time step. 
%
%%


% LSF=F.LSF  ; %






%[ValuesB,FA]=ExtrapolateFromNodesAtoNodesB(CtrlVar,xA,yA,ValuesA,xB,yB);

%% initialize LSF
if isempty(F.LSF)   % Do I need to initialize the level set function?

     
    [UserVar,Xc,Yc]=CreateInitialCalvingFrontProfiles(UserVar,CtrlVar,MUA,F,CalvingFront=UserVar.CalvingFront0);

    % A rough sign-correct initialisation for the LSF
    io=inpoly2([F.x F.y],[Xc Yc]);
    LSF=-ones(MUA.Nnodes,1) ;
    LSF(io)=+1;

    % figure ; PlotMuaMesh(CtrlVar,MUA);   hold on ; plot(F.x(io)/1000,F.y(io)/1000,'or')

    [xc,yc,LSF]=CalvingFrontLevelSetGeometricalInitialisation(CtrlVar,MUA,Xc,Yc,LSF,plot=true);

else
    LSF=F.LSF ;  % rember to pass LSF through, in no initialisation is required
end

%% Define calving rate (if needed)

if  CtrlVar.LevelSetEvolution=="-Prescribed-"  

      
    c=nan;   % setting the calving rate to nan implies that the level set is not evolved
    return

end


if F.time< 0 

    c=nan;

elseif  CtrlVar.CalvingLaw.Evaluation=="-int-" 

    c=0; % must not be nan or otherwise the LSF will not be evolved.  But otherwise these c values are of no importance and the c defined at int points the one used

else


    % c=sqrt(F.ub.*F.ub+F.vb.*F.vb);  % the idea here is that the calving front does not move
    speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
    %CR=str2double(extract(UserVar.CalvingLaw,("+"|"-")+digitsPattern+"."+digitsPattern));
    CR=UserVar.CalvingLaw.Factor;

    switch UserVar.CalvingLaw.Type

        case "-FixedRate-"

            c=speed+CR;

        case "-ScalesWithSpeed-"

            c=CR*speed;

        case "-NV-"


            u=CR*F.ub ;
            v=CR*F.vb ;
            [c,cx,cy]=IceVelocity2CalvingRate(CtrlVar,MUA,F,LSF,u,v) ;

%             FindOrCreateFigure("calving velocity")
%             QuiverColorGHG(F.x,F.y,cx,cy,CtrlVar) ;
%             hold on
%             [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=1);
%             PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'color','r','LineWidth',1);

        case "IceThickness"


            c=CR*F.h ;

        case "CliffHeight-Linear"

            CliffHeight=min((F.s-F.S),F.h) ;
            c=CR*CliffHeight ;

        case "CliffHeight-Crawford"


            CliffHeight=min((F.s-F.S),F.h) ;

            fI=3.2e-17*365.25 ; c=fI*CliffHeight.^(7.2) ;
            % Now set calving rate to zero for cliff less than 135meters
            c(CliffHeight<135)=0 ;
            % and set maximum at at cliff height equalt to 450m
            %cMax=fI*450.^(7.2) ;
            %c(c>cMax)=cMax ;

            c(c>UserVar.CalvingRateMax)=UserVar.CalvingRateMax ; % set an upper max

        otherwise

            error("case not found")

    end

    if isempty(c)  % this can happen if the geometry has not been defined yet in the run
        c=NaN;  % in this case the level set equation is not solved
    end


    %% Potential modifications to prescribed calving rate applied some save distance AWAY from the calving front
    if UserVar.CalvingRateOutsideDist<inf  && ~isempty(c)  && ~isempty(LSF)  && ~isempty(F.ub)

        %%  Now consider doing some modifications to the calculated calving rate
        % but do so only well outside the calving front area

        cDist=UserVar.CalvingRateOutsideDist ; % no modification within this distance away from the calving front
        cMin=UserVar.CalvingRateOutsideMin;  % set a minimum on absolut calving rate
        cMax=UserVar.CalvingRateOutsideMax ;  % set a maximum on absolut calving rate
        % and then taper the calving velocity towards the ice velocity over the distance
        % 10 cDist

        [dLSFdx,dLSFdy]=calcFEderivativesMUA(LSF,MUA,CtrlVar);
        [nx,ny]=ProjectFintOntoNodes(MUA,dLSFdx,dLSFdy);
        cx=c.*nx ; cy=c.*ny;
        % FindOrCreateFigure("calving rate velocity") ;
        % QuiverColorGHG(F.x,F.y,cx,cy,CtrlVar) ;
        % hold on
        % hold on ; PlotCalvingFronts(CtrlVar,MUA,LSF,'r') ;

        % ur=F.ub-cx ; % Retreat velocity
        % vr=F.vb-cy ;
        % RetreatSpeed=sqrt(ur.*ur+vr.*vr); % Retreat speed

        cxMod=cx ; cyMod=cy ;
        I=c>cMax ; cxMod(I)=nx(I).*cMax ;  cyMod(I)=ny(I).*cMax ;
        I=c<cMin ; cxMod(I)=nx(I).*cMin ;  cyMod(I)=ny(I).*cMin ;
        I=LSF<cDist ; cxMod(I)=cx(I) ;  cyMod(I)=cy(I);

        % taper calving velocity to ice velocity with distance away from calving front

        He = LinTaper(LSF,cDist,10*cDist);
        cxNew=cxMod+He.*(F.ub-cxMod);
        cyNew=cyMod+He.*(F.vb-cyMod);
        cNew=sqrt(cxNew.*cxNew+cyNew.*cyNew) ;
        c=cNew ; % set the calving rate to this new value


        c(c>UserVar.CalvingRateMax)=UserVar.CalvingRateMax ; % set an overall upper max

        %
        %                 FindOrCreateFigure("New calving rate velocity") ;
        %                 QuiverColorGHG(F.x,F.y,cxNew,cyNew,CtrlVar) ;
        %                 hold on ; PlotCalvingFronts(CtrlVar,MUA,LSF,'r') ;
        %
        %                 % FindOrCreateFigure("limited calving rate velocity") ;
        %                 % QuiverColorGHG(F.x,F.y,cxMod,cyMod,CtrlVar) ;
        %                 % hold on ; PlotCalvingFronts(CtrlVar,MUA,LSF,'r') ;
        %
        %                 FindOrCreateFigure("c new")
        %                 PlotMeshScalarVariable(CtrlVar,MUA,cNew);
        %                 title(" c after having set some limits and tapered down away from calving front")

    end
    %%
    %            if ~isempty(xc)
    %                ch=UserVar.CliffHeight ;
    %                cr=UserVar.CalvingRate ;
    %                figure ; plot3([xc xc]'/1000,[yc yc]'/1000,[ch*0 ch]','or-') ; axis equal  ; title("cliff heigh (m)")
    %
    %                figure ; plot3([xc xc]'/1000,[yc yc]'/1000,[cr*0 cr]','or-') ; daspect([1 1 0.05]) ; title("calving rate (m/yr)")
    %            end
    %

    %% Consider extrapolating values onto the calving front.  However, this should not be needed because
    % the melt distribution applied internally to get rid of the ice downstream of the calving front is defined in a 'strickt'
    % sense.  So this is here only for testing the sensitiviy of how values at the calving front are calculated.
    %

    if UserVar.CalvingRateExtrapolated
        GFLSF.node=sign(LSF) ;
        GFLSF=IceSheetIceShelves(CtrlVar,MUA,GFLSF);
        NodesA=GFLSF.NodesUpstreamOfGroundingLines ;  % these are actually nodes strickly upstream of the zero level in LSF
        % this is too far upstream,
        % not sure extrapolation is needed as the calving "melt" is
        % applied strickly downstream of the calving fron
        NodesB=~NodesA;

        cOld=c ;
        c=ExtrapolateFromNodesAtoNodesB(CtrlVar,F.x,F.y,NodesA,NodesB,c) ;
        % c(c>cMax)=cMax ;
        c(c>UserVar.CalvingRateMax)=UserVar.CalvingRateMax ; % set an upper max

        FCalvingRateExtrapolated=scatteredInterpolant(F.x,F.y,c);
        UserVar.CalvingRateExtrapolatedValues=FCalvingRateExtrapolated(xc,yc) ;

        if CtrlVar.doplots
            FindOrCreateFigure("upstream nodes used for extrapolation ") ; PlotMuaMesh(CtrlVar,MUA) ;
            hold on ; plot(F.x(NodesA)/CtrlVar.PlotXYscale,F.y(NodesA)/CtrlVar.PlotXYscale,'or')
            PlotCalvingFronts(CtrlVar,MUA,F,color='b');

            FindOrCreateFigure("Calving Rate : Extrapolated - Original")
            PlotMeshScalarVariable(CtrlVar,MUA,c-cOld)
            hold on ;  PlotCalvingFronts(CtrlVar,MUA,F,color='w');
            title("Extrapolated - original calving rate")


            % checking
            CliffHeightExtrapolated=ExtrapolateFromNodesAtoNodesB(CtrlVar,F.x,F.y,NodesA,NodesB,CliffHeight) ;

            FindOrCreateFigure("Cliff Height : Extrapolated - Original")
            PlotMeshScalarVariable(CtrlVar,MUA,CliffHeightExtrapolated-CliffHeight);
            hold on ; PlotMuaMesh(CtrlVar,MUA,[],color="w") ;
            hold on ; plot(F.x(NodesA)/CtrlVar.PlotXYscale,F.y(NodesA)/CtrlVar.PlotXYscale,'or',MarkerFaceColor="w")
            hold on ;  PlotCalvingFronts(CtrlVar,MUA,F,color='r',LineWidth=2);
            title("Extrapolated - original cliff height")

        end
    end
end
