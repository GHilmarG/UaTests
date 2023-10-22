 


function [UserVar,MUA]=CreateMeshAndMua(UserVar,CtrlVar)

persistent MUAlocal MeshSize


if isempty(MUAlocal)  || CtrlVar.MeshSize~=MeshSize


    % %% PIG and TWG
    % 
    % xByB= [ ...
    %     -1.6044   -0.7253 ; ...
    %     -1.0126   -0.6393 ; ...
    %     -1.0412   -0.1789 ; ...
    %     -1.3791    0.0118 ; ...
    %     -1.5876    0.0523 ; ...
    %     -1.7358    0.0395 ; ...
    %     -1.7318   -0.3953 ; ...
    %     ] ;
    % xByB=1000*xByB;
    % MeshBoundaryCoordinates=1000*xByB;

    %% WAIS

    % xByB=1.0e+06* ...
    %     [ 0.00   -1.40  ; ...
    %     0.0015    0.05  ; ...
    %     -2.0       0.05  ; ...
    %     -2.0      -0.6051  ; ...
    %     -1.6638   -1.0292  ; ...
    %     -1.0412   -1.4 ] ;
    % 
    % MeshBoundaryCoordinates=xByB;

    %%  PIG ice shelf


    % xByB=1000* ...
    %     [ -1700 -340 ; ...
    %       -1550 -360  ; ...
    %       -1520 -220 ; ...
    %       -1680 -220 ];       
    % MeshBoundaryCoordinates=xByB;

   %% PIG upstream of grounding line
   % xByB=[ -1750 -250 ; -1400 -250 ; -1400 0 ; -1750 0 ];   
   % MeshBoundaryCoordinates=1000*xByB;


    
    [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
    CtrlVar.TriNodes=3;  MUA=UpdateMUA(CtrlVar,MUA);

    FindOrCreateFigure("Mesh") ; PlotMuaMesh(CtrlVar,MUA); drawnow

    MUAlocal=MUA; 
else

    MUA=MUAlocal; 

end

MeshSize=CtrlVar.MeshSize ;


end