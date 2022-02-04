
function [Xc,Yc]=CreateInitialCalvingFrontProfiles(CtrlVar,MUA,options)


arguments
    CtrlVar struct
    MUA     struct
    options.CalvingFront string="-BedmachineCalvingFronts-"
    options.Plot logical=false
    options.CFI (:,2) double = [] 

end

%%  Here I am assuming we have files with the current groundign lines and calving fronts of of Antarctia


load("GroundingLineForAntarcticaBasedOnBedmachine.mat","xGL","yGL") ;
load("MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine.mat","Boundary");

%%

switch options.CalvingFront

    case {"-BedMachineCalvingFronts-","-BMCF-"}

        Xc=Boundary(:,1) ; Yc=Boundary(:,2);      % starting point for calving front is the current calving front

    case {"-BedMachineGroundingLines-","-BMGL-"}

        Xc=xGL ; Yc=yGL ;

    case {"-RemoveThwaitesIceShelve-","-TWISC-"}



        if ~isempty(options.CFI)

            % find the crossovers between calving font [Xc,Yc]  and the calving-front insert (CFI
            % )

         

            io=inpoly2(Boundary, [MUA.Boundary.x MUA.Boundary.y]);
            Boundary=Boundary(io,:) ;
            Xc=Boundary(:,1) ; Yc=Boundary(:,2);      % starting point for calving front is the current calving front


            XCFI=options.CFI(:,1);  YCFI=options.CFI(:,2);
            [xcEdges,ycEdges]=polyxpoly(Xc,Yc,XCFI,YCFI);
            BoxTWIS=[-1.6273   -1.5036   -0.4936   -0.3960] ; 
            BoxTWIS=[BoxTWIS(1) BoxTWIS(3) ; BoxTWIS(2) BoxTWIS(3) ; BoxTWIS(2) BoxTWIS(4) ; BoxTWIS(1) BoxTWIS(4) ] ; 
            io=inpoly2([xcEdges(:) ycEdges(:)],BoxTWIS);


            figure ; plot(Xc,Yc,'.k') ; axis equal ; hold on ; plot(xcEdges,ycEdges,'or') ; plot(XCFI,YCFI,'b')


        else

            % take out Thwaites ice shelf by replacing current Thwaites calving front with current Thwaites grounding line
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


    otherwise


        error("CreateInitialCalvingFrontProfiles:CaseNotFound","Case not found")
end


if options.Plot



    FindOrCreateFigure("Grounding lines and Calving fronts")


    plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,'r')
    hold on
    plot(Boundary(:,1)/CtrlVar.PlotXYscale,Boundary(:,2)/CtrlVar.PlotXYscale,'b')
    plot(Xc/CtrlVar.PlotXYscale,Yc/CtrlVar.PlotXYscale,'k')
    axis equal

    legend("BM Grounding lines","BM Calving Fronts","Returned Calving Front")
end



end





