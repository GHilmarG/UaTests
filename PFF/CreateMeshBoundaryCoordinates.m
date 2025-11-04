
function [CtrlVar,MeshBoundaryCoordinates]=CreateMeshBoundaryCoordinates(UserVar,CtrlVar)


if UserVar.Experiment=="ice shelf constricted"

    CtrlVar.MeshSizeMax=1000e3;
    CtrlVar.MeshSizeMin=1e3;
    CtrlVar.MeshSize=5e3;
    CtrlVar.TriNodes=3;
    xmin=-100e3 ; xmax=100e3 ; ymin=-100e3 ; ymax=100e3;
    lx=xmax-xmin;
    ly=ymax-ymin;
    MeshBoundaryCoordinates=[xmin ymin ; xmax ymin ; xmax ymax ;  (xmin+0.55*lx) ymax ; (xmin+0.55*lx) (ymax-0.25*ly) ; (xmin+0.45*lx) (ymax-0.25*ly) ;  (xmin+0.45*lx) ymax ;    xmin ymax];


elseif UserVar.Experiment=="ice shelf stream flow"

    CtrlVar.MeshSizeMax=1000e3;
    CtrlVar.MeshSizeMin=1e3;
    CtrlVar.MeshSize=5e3;
    CtrlVar.TriNodes=3;
    xmin=-100e3 ; xmax=100e3 ; ymin=-100e3 ; ymax=100e3;

    MeshBoundaryCoordinates=[xmin ymin ; xmax ymin ; xmax ymax ; xmin ymax];

elseif UserVar.Experiment=="1D ice shelf"

    lIce=100e3 ; lGap=10e3 ;
    ymin=-20e3 ; ymax=20e3;
    MeshBoundaryCoordinates=[(-lIce-lGap) ymin ;  -lGap ymin ; -lGap ymax ; -lGap ymin ; lGap ymin ; lGap ymax ; lGap ymin ; (lIce+lGap) ymin ; (lIce+lGap) ymax ; (-lIce-lGap) ymax ; (-lIce-lGap) ymin ] ;

elseif UserVar.Experiment=="ice shelf single notch"

    xl=50e3 ; xr=70e3 ; yd=-30e3 ; yu=30e3;
    xmin=0e3 ; xmax=100e3 ; ymin=-100e3 ; ymax=100e3;
    MeshBoundaryCoordinates=[xmin (ymin+ymax)/2 ; xmax ymax ; xmax ymin ; xmin (ymin+ymax)/2  ; ...
        xl 0 ; xl  yu ;  xr yu   ; xr yd ; xl yd ; ...
        xl 0 ; xl yd ;  xr yd  ; xr  yu ; xl yu  ; ...
        xl 0 ];

elseif UserVar.Experiment=="double notch"

    xmin=-100e3 ; xmax=100e3 ; ymin=-100e3 ; ymax=100e3;

    MeshBoundaryCoordinates=[xmin ymin ; xmax ymin ; xmax ymax ; xmin ymax];

elseif UserVar.Experiment=="single notch"

    CtrlVar.MeshSizeMax=1000e3;
    CtrlVar.MeshSizeMin=1e3;
    CtrlVar.MeshSize=5e3;
    CtrlVar.TriNodes=3;

    if UserVar.Geometry=="wide quadrilateral"
        xmin=-100e3 ; xmax=100e3 ; ymin=-200e3 ; ymax=200e3;
    else
        xmin=-100e3 ; xmax=100e3 ; ymin=-100e3 ; ymax=100e3;
    end

    MeshBoundaryCoordinates=[xmin ymin ; xmax ymin ; xmax ymax ; xmin ymax];



else

    error("CreateMeshBoundaryCoordinates:CaseNotFound","Case not found")

end

