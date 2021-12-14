function [UserVar,LSF,c]=DefineCalving(UserVar,CtrlVar,MUA,F,BCs)


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
% Initilizing the LSF is the task of the user and needs to be done in this m-file.
% Typically LSF is defined as a signed distance function from the initial calving
% front position. There are various ways of doing this and you might find the matlab
% function
%
%   pdist2
%
% usefull to do this.
%
% Note: Currenlty only prescribed calving front movements are allowed.
%       So define LSF in every call.
%%


% LSF=F.LSF  ; %

c=[] ;



%[ValuesB,FA]=ExtrapolateFromNodesAtoNodesB(CtrlVar,xA,yA,ValuesA,xB,yB);



switch CtrlVar.LevelSetEvolution

    case "-By solving the level set equation-"

        if F.time<eps
            % Prescribe initial LSF
            switch UserVar.CalvingFront0

                case "-GL0-"

                    LSF=F.GF.node-0.5 ;

                case  "-BedMachineCalvingFronts-"


                    io=inpoly2([F.x F.y],UserVar.BedMachineBoundary);
                    NodesSelected=~io ;

                    LSF=zeros(MUA.Nnodes,1) + 1 ;
                    LSF(NodesSelected)=-1;
                    LSF(F.x<-1660e3)=+1;  % get rid of the additional calving front to the east of the main trunk

                    % plot(F.x(~io)/1000,F.y(~io)/1000,'or')
            end

            [xC,yC]=CalcMuaFieldsContourLine(CtrlVar,MUA,LSF,0);
            [LSF,UserVar]=SignedDistUpdate(UserVar,[],CtrlVar,MUA,LSF,xC,yC);


        else
            LSF=F.LSF ;
        end



        % c=sqrt(F.ub.*F.ub+F.vb.*F.vb);  % the idea here is that the calving front does not move
        speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
        if contains(UserVar.CalvingLaw,"FixedRate")
            CR=str2double(extract(UserVar.CalvingLaw,digitsPattern));
            c=speed+CR;

        elseif contains(UserVar.CalvingLaw,"ScalesWithSpeed")

            CR=str2double(extract(UserVar.CalvingLaw,digitsPattern));
            c=CR*speed;

        elseif contains(UserVar.CalvingLaw,"IceThickness")

            CR=str2double(extract(UserVar.CalvingLaw,digitsPattern));
            c=CR*F.h ;

        elseif contains(UserVar.CalvingLaw,"CliffHeight")

            CliffHeight=min((F.s-F.S),F.h) ;



            % FindOrCreateFigure("CliffHeightUnmodified") ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeightUnmodified) ;
            % FindOrCreateFigure("CliffHeight") ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeight) ;
            % FindOrCreateFigure("CliffHeight-CliffHeightUnmodified") ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeight-CliffHeightUnmodified) ;

            if contains(UserVar.CalvingLaw,"CliffHeight-Linear")


                CR=str2double(extract(UserVar.CalvingLaw,digitsPattern));
                c=CR*CliffHeight ;

            elseif contains(UserVar.CalvingLaw,"CliffHeight-Crawford")


                

                fI=3.2e-17*365.25 ; c=fI*CliffHeight.^(7.2) ;
                % Now set calving rate to zero for cliff less than 135meters
                c(CliffHeight<135)=0 ;
                % and set maximum at at cliff height equalt to 450m 
                cMax=fI*450.^(7.2) ;
                c(c>cMax)=cMax ;
            end

            % For Plotting purposes: Get cliff height along calving front and the calving rate used
            [xc,yc]=PlotCalvingFronts(CtrlVar,MUA,F,'b',LineWidth=2);

            FCliffHeight=scatteredInterpolant(F.x,F.y,CliffHeight);
            FCalvingRate=scatteredInterpolant(F.x,F.y,c);
            UserVar.xc=xc ;
            UserVar.yc=yc ;
            UserVar.CliffHeight=FCliffHeight(xc,yc) ;
            UserVar.CalvingRate=FCalvingRate(xc,yc) ;


            
            
            

            if UserVar.CalvingRateOutsideDist<inf

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


        else

            error("asfda")
        end

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
            c(c>cMax)=cMax ;


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

    case "-prescribed-"

        if F.time > 2

            F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
            NodesSelected=F.x>500e3 & F.GF.NodesDownstreamOfGroundingLines;
            LSF=zeros(MUA.Nnodes,1)+ 1 ;
            LSF(NodesSelected)=-1;

        else

            LSF=1 ; % just some positive number to indicate that there is ice in all of the domain

        end

    otherwise

        error("case not found")

end


