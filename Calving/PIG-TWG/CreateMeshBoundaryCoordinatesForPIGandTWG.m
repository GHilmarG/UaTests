
function MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar)


%%


xByB = [ -1582.37420767669         -374.936485955611 ; ...
    -1516.99559307763          -389.42580054243 ; ...
    -1415.92378888666          -271.03749843062 ; ...
    -1368.21507012518          2.13909121842005 ; ...
    -1703.58969312252          2.49248913517175 ; ...
    -1704.29648895602         -336.062715112928 ]  ;


MeshBoundaryCoordinates=1000*xByB;

% FindOrCreateFigure("MeshBoundaryCoordinates")
% plot(MeshBoundaryCoordinates(:,1)/1000,MeshBoundaryCoordinates(:,2)/1000,'r.-')
% axis equal


end