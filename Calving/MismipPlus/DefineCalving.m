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
            F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
            NodesSelected=F.x>500e3 & F.GF.NodesDownstreamOfGroundingLines;
            LSF=zeros(MUA.Nnodes,1) + 1 ;
            LSF(NodesSelected)=-1;

            [xC,yC]=CalcMuaFieldsContourLine(CtrlVar,MUA,LSF,0);
            [LSF,UserVar]=SignedDistUpdate(UserVar,[],CtrlVar,MUA,LSF,xC,yC);
        else
            LSF=F.LSF ;
        end



        % c=sqrt(F.ub.*F.ub+F.vb.*F.vb);  % the idea here is that the calving front does not move
        c=F.ub ;
        if contains(UserVar.CalvingLaw,"FixedRate")
            CR=str2double(extract(UserVar.CalvingLaw,digitsPattern));
            c=c+CR;
        elseif contains(UserVar.CalvingLaw,"IceThickness")

            CR=str2double(extract(UserVar.CalvingLaw,digitsPattern));
            c=c+CR*F.h ;

        elseif contains(UserVar.CalvingLaw,"CliffHeight")

            CliffHeight=min((F.s-F.S),F.h) ;
            % CliffHeightUnmodified=CliffHeight;


            GFLSF.node=sign(LSF) ;
            GFLSF=IceSheetIceShelves(CtrlVar,MUA,GFLSF);
            NodesA=GFLSF.NodesUpstreamOfGroundingLines;
            NodesB=~NodesA;

            CliffHeight=ExtrapolateFromNodesAtoNodesB(CtrlVar,F.x,F.y,NodesA,NodesB,CliffHeight) ;


            % FindOrCreateFigure("CliffHeightUnmodified") ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeightUnmodified) ;
            % FindOrCreateFigure("CliffHeight") ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeight) ;
            % FindOrCreateFigure("CliffHeight-CliffHeightUnmodified") ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeight-CliffHeightUnmodified) ;

            if contains(UserVar.CalvingLaw,"CliffHeight-Linear")


                CR=str2double(extract(UserVar.CalvingLaw,digitsPattern));
                c=CR*CliffHeight ;
                % c=1000;
                cMax=5000;
                c(c>cMax)=cMax;

            elseif contains(UserVar.CalvingLaw,"CliffHeight-Crawford")

                fI=1e-17 ; % Units m/d
                fI=fI*365.25 ;
                c= fI*CliffHeight.^7 ;
                c(CliffHeight<135)=0 ;

                NodesA=abs(LSF) < 50e3 ;
                NodesB=~NodesA;
                c=ExtrapolateFromNodesAtoNodesB(CtrlVar,F.x,F.y,NodesA,NodesB,c) ;

                CliffHeightPlot=CliffHeight ; CliffHeightPlot(NodesB)=NaN ;
                cPlot=c ; cPlot(NodesB)=NaN;
              
                % FindOrCreateFigure("CliffHeight") ; PlotMeshScalarVariable(CtrlVar,MUA,CliffHeightPlot) ;
                % FindOrCreateFigure("Calving Rate") ; PlotMeshScalarVariable(CtrlVar,MUA,cPlot) ;



            end



        else

            error("asfda")
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


