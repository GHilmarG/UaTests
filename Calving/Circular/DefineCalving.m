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


            CR=str2double(extract(UserVar.CalvingFrontInitRadius,digitsPattern));
            r=sqrt( F.x.*F.x+F.y.*F.y ) ;

            LSF=2*((r<CR)-0.5)  ;
            LSF(F.GF.node>0.5)=1 ;
            % io=inpoly2([F.x F.y],UserVar.BedMachineBoundary);
            % NodesSelected=~io ;


            [xC,yC]=CalcMuaFieldsContourLine(CtrlVar,MUA,LSF,0);
            [LSF,UserVar]=SignedDistUpdate(UserVar,[],CtrlVar,MUA,LSF,xC,yC);


        else
            LSF=F.LSF ;
        end

        speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ; 
        c=speed;

    otherwise


        error("no case")


end

% if UserVar.CalvingRateExtrapolated
%     GFLSF.node=sign(LSF) ;
%     GFLSF=IceSheetIceShelves(CtrlVar,MUA,GFLSF);
%     NodesA=GFLSF.NodesUpstreamOfGroundingLines ; %  & LSF < 100e3 ;  % these are actually nodes strickly upstream of the zero level in LSF
%     NodesB=~NodesA;
%     c=ExtrapolateFromNodesAtoNodesB(CtrlVar,F.x,F.y,NodesA,NodesB,c) ;
%     c(c>cMax)=cMax ;
% end


%         % Rough limitation on calving migration
%          speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
%          vFrontMax=5e3 ;
%          ii=c>(speed+vFrontMax) ;
%          c(ii)=speed(ii)+vFrontMax ;



end

