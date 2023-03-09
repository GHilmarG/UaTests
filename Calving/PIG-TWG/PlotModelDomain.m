  

%% 



UserVar.GeometryInterpolant='../../../Interpolants/BedMachineGriddedInterpolants.mat';
UserVar.SurfaceVelocityInterpolant='../../../Interpolants/SurfVelMeasures990mInterpolants.mat';
UserVar.MeshBoundaryCoordinatesFile='../../../Interpolants/MeshBoundaryCoordinatesForAntarcticaBasedOnBedmachine';
load(UserVar.MeshBoundaryCoordinatesFile,"Boundary") ; UserVar.BedMachineBoundary=Boundary;


fprintf('DefineGeometry: loading file: %-s ',UserVar.GeometryInterpolant)
load(UserVar.GeometryInterpolant,'FB','Fb','Fs','Frho')

%%


CtrlVar=Ua2D_DefaultParameters();
[UserVar,CtrlVar,MeshBoundaryCoordinates]=DefineInitialInputs(UserVar,CtrlVar);

%%



nlevels=50 ; % 

xmin=-2500e3 ; xmax=2500e3 ;  % This sets the bounday of the area plotted
ymin=-2500e3 ; ymax=2500e3 ;

x=linspace(xmin,xmax,200);
y=linspace(ymin,ymax,200);


s=Fs({x,y}) ; 
s(s<2)=NaN ; 
%%



sFig=FindOrCreateFigure("Surface")  ; clf(sFig)
hold on 
contourf(x/1000,y/1000,s',nlevels, LineStyle="none")
axis equal
hold on

CtrlVar.PlotXYscale=1000;
PlotGroundingLines(CtrlVar,"Bedmachine",[],[],[],[],"k");

plot(Boundary(:,1)/1000,Boundary(:,2)/1000,'b')
plot(MeshBoundaryCoordinates(:,1)/1000,MeshBoundaryCoordinates(:,2)/1000,'k',LineWidth=2)
cmap=colormap(othercolor("Blues3",1024)) ;

axis([-2200 -130 -1350 740]) ; hold on 
PlotLatLonGrid(1000,5,20,[],[],true);


% distance scale

xd=-1800 ; yd=-1200 ; scaledist=500;  % This set the location and size of the distance scale bar
plot([xd, xd+scaledist],[yd yd],color="k",LineWidth=5);
text(xd+scaledist/2,yd,sprintf("%i km",scaledist),VerticalAlignment="cap",HorizontalAlignment="center")

sFig.Position=[40 760 620 590];
axis off

SaveFig=false ;

if SaveFig
    CurDir=pwd;
    FigureDirectory="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Work\Manuscripts\2022 ThwaitesIceShelfButtressing\Figures\";
    cd(FigureDirectory)
    exportgraphics(sFig,'ModelDomain.pdf')
    cd(CurDir)
end


