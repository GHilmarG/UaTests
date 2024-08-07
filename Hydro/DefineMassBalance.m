function [UserVar,as,aw]=DefineMassBalance(UserVar,CtrlVar,MUA,F)


%%
% Defines mass balance along upper and lower ice surfaces.
%
%   [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
%
%   [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,F);
%
%   [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,CtrlVar.time,s,b,h,S,B,rho,rhow,GF);
%
%   as        mass balance along upper surface
%   ab        mass balance along lower ice surface
%   dasdh     upper surface mass balance gradient with respect to ice thickness
%   dabdh     lower surface mass balance gradient with respect to ice thickness
%
% dasdh and dabdh only need to be specified if the mass-balance feedback option is
% being used.
%
% In �a the mass balance, as returned by this m-file, is multiplied internally by the local ice density.
%
% The units of as and ab are water equivalent per time, i.e. usually
% as and ab will have the same units as velocity (something like m/yr or m/day).
%
% As in all other calls:
%
%  F.s       : is upper ice surface
%  F.b       : lower ice surface
%  F.B       : bedrock
%  F.S       : ocean surface
%  F.rhow    :  ocean density (scalar variable)
%  F.rho     :  ice density (nodal variable)
%  F.g       :  gravitational acceleration
%  F.x       : x nodal coordinates
%  F.y       : y nodal coordinates
%  F.GF      : The nodal grounded/floating mask (has other subfields)
%
%
%
% These fields need to be returned at the nodal coordinates. The nodal
% x and y coordinates are stored in MUA.coordinates, and also in F as F.x and F.y
%
% Examples:
%
% To set upper surface mass balance to zero, and melt along the lower ice
% surface to 10 over all ice shelves:
%
%   as=zeros(MUA.Nnodes,1);
%   ab=-(1-F.GF.node)*10
%
%
% To set upper surface mass balance as a function of local surface elevation and
% prescribe mass-balance feedback for the upper surface:
%
%   as=0.1*F.h+F.b;
%   dasdh=zeros(MUA.Nnodes,1)+0.1;
%   ab=F.s*0;
%   dabdh=zeros(MUA.Nnodes,1);
%
%
%%

as=zeros(MUA.Nnodes,1); aw=zeros(MUA.Nnodes,1);




if contains(UserVar.Example,"-Antarctica-") ||  contains(UserVar.Example,"-WAIS-")


    if UserVar.awSource=="-BasalFriction-"

        [UserVar,aw]=BasalWaterProduction(UserVar,CtrlVar,MUA,F) ;

        % Sometimes these values are a bit bonkers
        awmax=100;
        aw(aw>awmax)=awmax ;

    elseif UserVar.awSource=="-Box-"

        aw=zeros(MUA.Nnodes,1);
        % Box=[-1600 -1500 -200 -100]*1000;
        Box=[-1500 -1200 -500 -200]*1000;
        In=IsInBox(Box,F.x,F.y) ;
        aw(In)=100;
        %  UaPlots(CtrlVar,MUA,F,ab,FigureTitle="aw")

    end

    if contains(UserVar.Example,"-aw0-")
        as=zeros(MUA.Nnodes,1); aw=zeros(MUA.Nnodes,1);

    end

    aw(~F.GF.NodesUpstreamOfGroundingLines)=0 ; % Set water production downstream and across grounding lines to zero

    ds=100e3;
    CtrlVar.PlotGLs=0;
    [xGL,yGL]=PlotGroundingLines(CtrlVar,MUA,F.GF,[],[],[],'LineWidth',2);
    ID=FindAllNodesWithinGivenRangeFromGroundingLine([],MUA,xGL,yGL,ds) ;
    aw(ID)=0;


elseif contains(UserVar.Example,"-Island-")

    aw=zeros(MUA.Nnodes,1)+UserVar.aw;  % defined in driver

    r=vecnorm([F.x F.y],2,2)  ;
    aw(r>UserVar.RadiusWaterAdded)=0;
    UserVar.QnTheoretical=pi*UserVar.RadiusWaterAdded^2*UserVar.aw ;


    aw(F.x<0) =0 ; UserVar.QnTheoretical=0.5*UserVar.QnTheoretical;


elseif contains(UserVar.Example,"-Plane-")

    aw=zeros(MUA.Nnodes,1)+UserVar.aw;  % defined in driver

    % r=vecnorm([F.x F.y],2,2)  ;
    % aw(r>UserVar.RadiusWaterAdded)=0;
    % UserVar.QnTheoretical=2*pi*UserVar.RadiusWaterAdded^2*UserVar.aw ;

   UserVar.QnTheoretical=nan ;

else

    error("case not found")

end


if contains(UserVar.Example,"-aw0-")
    as=zeros(MUA.Nnodes,1); aw=zeros(MUA.Nnodes,1);

end

% trying to get rid of hw downstream of grounding line
Mask=double(~F.GF.NodesUpstreamOfGroundingLines) ;
aw=aw-0.5*Mask.*(F.hw-CtrlVar.WaterFilm.ThickMin)/CtrlVar.dt;



end

