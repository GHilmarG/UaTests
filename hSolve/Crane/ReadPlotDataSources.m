
[~,hostname]=system('hostname') ;


if contains(hostname,"DESKTOP-G5TCRTD")


elseif contains(hostname,"DESKTOP-BU2IHIR")

    OneDriveFolder="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Work\Ua\Antarctic Global Data Sets\" ;


end



%%  Reading nc file with velocities

wdir="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Work\Ua\Antarctic Global Data Sets\ITS_LIVE\"; 
wdir=OneDriveFolder+"ITS_LIVE\";

filenameITS="ANT_G0240_1996.nc" ; 
filenameITS="ANT_G0240_2018.nc" ; 
filenameITS="ANT_G0120_0000.nc";

fprintf(" Reading %s  ...",filename)

finfo = ncinfo(filenameITS) ;

xITS=ncread(filenameITS,"x");   fprintf("x ...")
yITS=ncread(filenameITS,"y");    fprintf("y ...")    % these y values are in decending order
vx=ncread(filenameITS,"vx");   fprintf("vx ...")
vy=ncread(wdir+filenameITS,"vy");   fprintf("vy ...")

fprintf("done. \n")

% y values are in decending order, so flip
yITS=flipud(yITS);
vx=flipud(vx);
vy=flipud(vy);


%% Read REMA 
% y corresponds to the  first index in the original data set
%

P=OneDriveFolder+"REMA\rema_mosaci_1km_v2k0_filled_cop30\";
filenameREMA=P+"rema_mosaic_1km_v2.0_filled_cop30_dem.tif";

fprintf("Reading REMA...    ")
[sREMA,R] = readgeoraster(filenameREMA) ;
fprintf("done\n")


dx=(R.XWorldLimits(2)-R.XWorldLimits(1))/(R.RasterSize(2)) ;
dy=(R.YWorldLimits(2)-R.YWorldLimits(1))/(R.RasterSize(1)) ;

xRema=(R.XWorldLimits(1)+dx/2):dx:(R.XWorldLimits(2)-dx/2); 
yRema=(R.YWorldLimits(1)+dy/2):dy:(R.YWorldLimits(2)-dy/2);   % I guess this is what they did (why not just include xps and yps in the data set?!) 

xRema=xRema(:) ; yRema=yRema(:);
yRema=flipud(yRema);



[X,Y]=ndgrid(double(xRema),double(flipud(yRema))) ;

Fs=griddedInterpolant(X,Y,rot90(double(sREMA),3)); 

%% Define region of interest

Region=[-2440 -2320 1200 1320]*1000 ; % This defines the region considered, in xp,up coordinates



%% Plotting velocities
I=vx==-32767;  vx(I)=nan;  vy(I)=nan;


fprintf("plotting Antarctic velocities.\n")
fig=FindOrCreateFigure("Velocities");

istep=20;
Par.VelPlotIntervalSpacing='log10' ;

QuiverColorGHG(xITS(1:istep:end)/1000,yITS(1:istep:end)/1000,vx(1:istep:end,1:istep:end),vy(1:istep:end,1:istep:end),Par) ;

[cGL,yGL]=PlotGroundingLines([],"Bedmachine",[],[],[],[],"k");
xlabel("xps (km)",Interpreter="latex")  ; ylabel("yps (km)",Interpreter="latex")
title(replace(sprintf("%s",filenameITS),"_","-"))

%%

fprintf("plotting regional Antarctic velocities.\n")

fig=FindOrCreateFigure("Regional Velocities");


ix=xITS>Region(1)    & xITS < Region(2) ;
iy=yITS>Region(3)    & yITS < Region(4) ; 


xRegion=xITS(ix) ;   % These are the x,y vectors of the region
yRegion=yITS(iy) ; 

vxRegion=vx(ix,iy);  vyRegion=vy(ix,iy);
axis(Region)

Par.VelPlotIntervalSpacing='log10' ;

QuiverColorGHG(xRegion/1000,yRegion/1000,vxRegion,vyRegion,Par) ;

[cGL,yGL]=PlotGroundingLines([],"Bedmachine",[],[],[],[],"k");

axis(Region/1000) ; 

xlabel("xps (km)",Interpreter="latex")  ; ylabel("yps (km)",Interpreter="latex")
title(replace(sprintf("%s",filenameITS),"_","-"))



%%


[XRegion,YRegion]=ndgrid(xRegion,yRegion);

sRegion=Fs(XRegion,YRegion) ;

figure ; contourf(XRegion/1000,YRegion/1000,sRegion) ; colorbar

hold on ; [cGL,yGL]=PlotGroundingLines([],"Bedmachine",[],[],[],[],"k");



%% Surface mass balance



P=OneDriveFolder+"Antarctic Accumulation Maps\";
filenameRACMO="SMB_RACMO2.3_1979_2011.nc" ;



LAT=ncread(filenameRACMO,'lat2d')';
LON=ncread(filenameRACMO,'lon2d')';
SMB=ncread(filenameRACMO,'SMB')';


[X, Y]=ll2xy(LAT,LON); %transform to your Polar stereo projection

disp('interpolating (assuming rho_ice = 917 kg/m^3)');
rho_ice = 917;

acc=SMB/rho_ice ; 

% smb = griddata(X,Y,SMB,x,y) / 917; %in m/yr

Fas=scatteredInterpolant(X(:),Y(:),acc(:)); 
% Create a gridded interpolant
dx=10;  % units km
dy=10;
x=[-3000:dx:3000]*1000 ;
y=[-2500:dy:2500]*1000 ;
[X,Y]=ndgrid(double(x),double(flipud(y))) ;

AS=Fas(X,Y); 

FasGridded=griddedInterpolant(X,Y,AS) ; 
%
% Test gridded interpolants

% load in an old mesh of Antarctica and map on this mesh. Just done for testing purposes and to see if the gridded data looks sensible.
fprintf(' Testing interpolants by mapping on a FE grid of Antartica. \n')

load MUA_Antarctica.mat; 
xFE=MUA.coordinates(:,1) ; yFE=MUA.coordinates(:,2) ; 

%as=Fas(xFE,yFE);
as=FasGridded(xFE,yFE);


CtrlVar.PlotXYscale=1000;
 
asfig=FindOrCreateFigure('as') ; clf(asfig);
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,as);
xlabel('xps (km)' ) ; xlabel('yps (km)' ) ; title('as') ; title(cbar,'(m/yr)')





















%% Regional interpolants

% Fs=griddedInterpolant(XRegion,YRegion,sRegion) ; 
% Fu=griddedInterpolant(XRegion,YRegion,vxRegion) ; 
% Fv=griddedInterpolant(XRegion,YRegion,vyRegion) ; 
% 


