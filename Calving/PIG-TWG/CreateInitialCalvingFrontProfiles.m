
function [UserVar,Xc,Yc]=CreateInitialCalvingFrontProfiles(UserVar,CtrlVar,MUA,F,options)

%%
% Example:
%
%   [UserVar,Xc,Yc]=CreateInitialCalvingFrontProfiles(UserVar,CtrlVar,MUA,F,Plot=true);
%
%%

arguments
    UserVar struct
    CtrlVar struct
    MUA     struct
    F       struct
    options.CalvingFront string="-BMCF-" ; % -BedmachineCalvingFronts-"
    options.Plot logical=false

end

%%  Here I am assuming we have files with the current groundign lines and calving fronts of of Antarctia


load("GroundingLineForAntarcticaBasedOnBedmachine.mat","xGL","yGL") ;
%load("GroundingLineForAntarcticaBasedOnBedmachine","GroundingLines") ; xGL=GroundingLines(:,1) ;   yGL=GroundingLines(:,2) ;
load("MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine.mat","Boundary");

%%


if contains(options.CalvingFront,"-BMCF-")    % Initial calving front will be the Bedmachine calving front


    Xc=Boundary(:,1) ; Yc=Boundary(:,2);      

elseif contains(options.CalvingFront,"-BMGL-")  % Initial calving front will be the Bedmachine grounding lines


    

    % Now do we want all the Bedmachine groundign lines to be calving fronts?
    % This would potentially create calving fronts upstream of the main grounding line, and all nunataks would become calving
    % fronts.
    %
    % Clearly this is not desirable.  Here I just take the single longest, and first, grounding line.

    inans=find(isnan(xGL));
    ikeep=1:(inans(1)-1) ;
    Xc=xGL(ikeep) ; Yc=yGL(ikeep) ; 




elseif  contains(options.CalvingFront,"-TWISC")  % Thwaites ice shelf to be (partly) eliminated

    Dist2GL=str2double(extract(options.CalvingFront,digitsPattern)) ;

    if  ~isempty(Dist2GL)  &&  Dist2GL~=0



        iNaN=find(isnan(xGL));  xGL=xGL(1:iNaN(1)-1); yGL=yGL(1:iNaN(1)-1);  % get rid of all but the fist and longest grounding line

        Dist=pdist2([xGL(:) yGL(:)],MUA.coordinates,'euclidean','Smallest',1) ; % calculate distance from grounding line to nodal points
        Dist=Dist(:) ;

        PM=sign(F.GF.node-0.5) ;  % make sure this is signed distance from grounding line, with negative values downstream
        Field=PM.*Dist;
        %Value=-10e3 ;
        Value=-Dist2GL*1000 ;

        [XCFI,YCFI]=CalcMuaFieldsContourLine(CtrlVar,MUA,Field,Value,lineup=true,plot=false,subdivide=false) ; % find the 10km downstream contour line
        iNaN=find(isnan(XCFI));  XCFI=XCFI(1:iNaN(1)-1); YCFI=YCFI(1:iNaN(1)-1);  % again get just the longest contour line, this eliminates pinning points, may or may not be what we want

        % find the crossovers between calving font [Xc,Yc]  and the calving-front insert (CFI
        % )

        io=inpoly2(Boundary, [MUA.Boundary.x MUA.Boundary.y]);
        %            Boundary=Boundary(io,:) ;               % only keep the part of the Boundary (here Bedmachine boundary) which is within the boundary of the computational domain
        Xc=Boundary(io,1) ; Yc=Boundary(io,2);    % starting point for calving front is the current calving front



        % now I replace the initial calving front over Thwaites with the 'downstream grounding line'.
        % just do this for Thwaites, so this involves finding the location of crossing points and the relevant sections of the initial calving
        % front and the new 'downstream calving front'. This is a bit of a faff..
        [xcEdges,ycEdges]=polyxpoly(Xc,Yc,XCFI,YCFI);  % crossing points between (Xc,Yc) calving front and 'donwstream' grounding line
        BoxTWIS=[-1.6273   -1.5036   -0.4936   -0.3960]*1e6 ;
        BoxTWIS=[BoxTWIS(1) BoxTWIS(3) ; BoxTWIS(2) BoxTWIS(3) ; BoxTWIS(2) BoxTWIS(4) ; BoxTWIS(1) BoxTWIS(4) ; BoxTWIS(1) BoxTWIS(3) ] ;
        io=inpoly2([xcEdges(:) ycEdges(:)],BoxTWIS);  % only take those crossing points that cover Thwaites Ice Shelf.
        xcEdges=xcEdges(io) ; ycEdges=ycEdges(io) ;

        x1=xcEdges(1) ; y1=ycEdges(1) ;   % this is not robust, I could have many crossing points, I take the first and the last
        x2=xcEdges(end) ; y2=ycEdges(end) ;

        d1=(XCFI-x1).^2+(YCFI-y1).^2;
        d2=(XCFI-x2).^2+(YCFI-y2).^2;
        [~,i1]=min(d1);
        [~,i2]=min(d2);

        Xc=Boundary(:,1) ; Yc=Boundary(:,2);    % now get back the whole Boundary (here the Bedmachine calving fronts (this could be improved)
        d1=(Xc-x1).^2+(Yc-y1).^2;
        d2=(Xc-x2).^2+(Yc-y2).^2;
        [~,j1]=min(d1);
        [~,j2]=min(d2);


        % OK, I now have the information I need to calving front on input, and splice in the XCFI,YCFI section between i1 and i2

        XcInsert=XCFI(i2:-1:i1); YcInsert=YCFI(i2:-1:i1);                          % new section
        XcNew=Xc(1:j2-1) ; YcNew=Yc(1:j2-1) ;                                % old section ahead of insert
        XcNew=[XcNew;XcInsert] ; YcNew=[YcNew;YcInsert] ;                    % inserting the new section
        XcNew=[XcNew;Xc(j1+1:end)] ; YcNew=[YcNew;Yc(j1+1:end)] ;            % adding the remaining part of the old section




        fig=FindOrCreateFigure("Creating initial calving fronts") ;clf(fig)
        plot(Xc,Yc,'m') ;
        axis equal ; hold on ;
        plot(xcEdges,ycEdges,'or') ;
        plot(XCFI,YCFI,'b')
        plot(xGL,yGL,'r')
        plot(XcNew,YcNew,'k',LineWidth=1.5)

        Xc=XcNew ; Yc=YcNew;

    else

        % take out Thwaites ice shelf by replacing current Thwaites calving front with current Thwaites grounding line as in
        % Bedmachine
        %
        % 1) find the start and end locations within the calving front profile

        x1=-1580e3 ; y1=-382.5e3 ;
        x2=-1531e3 ; y2=-472.7e3 ;

        % shift grounding line

        d1=(xGL-x1).^2+(yGL-y1).^2;
        d2=(xGL-x2).^2+(yGL-y2).^2;


        [~,i1]=min(d1);
        [~,i2]=min(d2);


        Xc=Boundary(:,1) ; Yc=Boundary(:,2);      % starting point for calving front is t
        % he current calving front
        XcInsert=xGL(i2:i1); YcInsert=yGL(i2:i1); % this is the new calving front for Thwaites, ie the current grounding line

        d1=(Xc-x1).^2+(Yc-y1).^2;
        d2=(Xc-x2).^2+(Yc-y2).^2;
        [~,j1]=min(d1);
        [~,j2]=min(d2);

        % must take out from j2 to j1
        XcNew=Xc(1:j2-1) ; YcNew=Yc(1:j2-1) ;
        XcNew=[XcNew;XcInsert] ; YcNew=[YcNew;YcInsert] ;
        XcNew=[XcNew;Xc(j1+1:end)] ; YcNew=[YcNew;Yc(j1+1:end)] ;

        Xc=XcNew ; Yc=YcNew;
    end


else


    error("CreateInitialCalvingFrontProfiles:CaseNotFound","Case not found")
end


if options.Plot

    FindOrCreateFigure("Grounding lines and Calving fronts")
    plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
    hold on
    plot(Boundary(:,1)/CtrlVar.PlotXYscale,Boundary(:,2)/CtrlVar.PlotXYscale,'b')
    plot(Xc/CtrlVar.PlotXYscale,Yc/CtrlVar.PlotXYscale,'k',LineWidth=2)
    axis equal
    legend("Bedmachine Grounding Lines","Bedmachine Calving Fronts","Returned Calving Front")
    xlabel("xps (km)",Interpreter="latex"); ylabel("yps (km)",Interpreter="latex");
    % axis([-1800 -1400 -700 -200])
end



end





