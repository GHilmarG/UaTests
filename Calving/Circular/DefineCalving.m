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


persistent nCalls isInitialized



if isempty(isInitialized)
    isInitialized=false;
    nCalls=0;
else
    nCalls=nCalls+1;
end

%% initialize LSF
if ~isInitialized
    isInitialized=true;
    if contains(lower(UserVar.CalvingFrontInit),"wavy")

        theta=linspace(0,2*pi,200);
        R=700e3;

        r=R*(1/2+1/3*cos(2*theta));

        % boundary 1 : figure of 8
        [Xc,Yc]=pol2cart(theta,r) ; Xc=Xc(:) ; Yc=Yc(:);
        
        % boundary 2 : square
        
        SL2=200 ; CP=[0 500 ]; % SideLength/2 and CentrePoint
        B2=CP +  [-SL2 -SL2 ; SL2 -SL2 ; SL2 SL2 ; -SL2 SL2 ; -SL2 -SL2] ; B2=1000*B2 ; 
        Xc=[Xc(:); NaN ; B2(:,1)]; Yc=[Yc(:); NaN ; B2(:,2)]; 

        SL2=200 ; CP=[0 -500 ]; % SideLength/2 and CentrePoint
        B3=CP +  [-SL2 -SL2 ; SL2 -SL2 ; 0 SL2 ; -SL2 -SL2] ;  B3=1000*B3;
        Xc=[Xc(:); NaN ; B3(:,1)]; Yc=[Yc(:); NaN ; B3(:,2)]; 

        % io=inpoly2([F.x F.y],[Xc Yc]);

        io=InsideOutside([F.x F.y],[Xc Yc]);  % this deals with several seperated boundaries

        NodesSelected=~io ;

        LSF=zeros(MUA.Nnodes,1) + 1 ;
        LSF(NodesSelected)=-1;

    else

        error('case not found')


    end

 
     
     [xc,yc,LSF]=CalvingFrontLevelSetGeometricalInitialisation(CtrlVar,MUA,Xc,Yc,LSF,plot=true,ResampleCalvingFront=true);



else
    LSF=F.LSF ;
end

%% Define calving rate

if  contains(CtrlVar.CalvingLaw.Evaluation,"-int-")

    c=[];

elseif contains(CtrlVar.CalvingLaw.Evaluation,"-nodes-")

    speed=sqrt(F.ub.*F.ub+F.vb.*F.vb) ;
    CR=UserVar.CalvingLaw.Factor;
    c=CR*speed;

else

    error("no case")

end




end

