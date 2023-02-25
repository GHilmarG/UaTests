
[~,hostname]=system('hostname') ;


if contains(hostname,"DESKTOP-G5TCRTD")

elseif contains(hostname,"DESKTOP-014ILS5")

   OneDriveFolder="C:\Users\lapnjc6\OneDrive - Northumbria University - Production Azure AD\Work\Ua\Antarctic Global Data Sets\";

elseif contains(hostname,"DESKTOP-BU2IHIR")

    OneDriveFolder="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Work\Ua\Antarctic Global Data Sets\" ;

end



%%  Reading nc file with velocities


wdir=OneDriveFolder+"ITS_LIVE\";

filenameITS="ANT_G0240_1996.nc" ; 
filenameITS="ANT_G0240_2018.nc" ; 
filenameITS="ANT_G0120_0000.nc";

fprintf(" Reading %s  ...",wdir+filenameITS)

finfo = ncinfo(wdir+filenameITS) ;

xITS=ncread(wdir+filenameITS,"x");   fprintf("x ...")
yITS=ncread(wdir+filenameITS,"y");    fprintf("y ...")    % these y values are in decending order
vx=ncread(wdir+filenameITS,"vx");   fprintf("vx ...")
vy=ncread(wdir+filenameITS,"vy");   fprintf("vy ...")
rock=ncread(wdir+filenameITS,"rock");   fprintf("rock ...")
ice=ncread(wdir+filenameITS,"ice");   fprintf("ice ...")

fprintf("done. \n")

% y values are in decending order, so flip

yITS=flipud(yITS);
vx=fliplr(vx);
vy=fliplr(vy);
rock=fliplr(rock);
ice=fliplr(ice);


%% Read REMA 
% y corresponds to the  first index in the original data set
%

P=OneDriveFolder+"REMA\rema_mosaci_1km_v2k0_filled_cop30\";
filenameREMA=P+"rema_mosaic_1km_v2.0_filled_cop30_dem.tif";


% P=OneDriveFolder+"REMA\rema_mosaic_100m_v2k0_filled_cop30\";
% filenameREMA=P+"rema_mosaic_100m_v2.0_filled_cop30_dem.tif";

fprintf("Reading REMA...    ")
[sREMA,R] = readgeoraster(filenameREMA) ;
fprintf("done\n")


dx=(R.XWorldLimits(2)-R.XWorldLimits(1))/(R.RasterSize(2)) ;
dy=(R.YWorldLimits(2)-R.YWorldLimits(1))/(R.RasterSize(1)) ;

xRema=(R.XWorldLimits(1)+dx/2):dx:(R.XWorldLimits(2)-dx/2); 
yRema=(R.YWorldLimits(1)+dy/2):dy:(R.YWorldLimits(2)-dy/2);   % I guess this is what they did (why not just include xps and yps in the data set?!) 

xRema=xRema(:) ; yRema=yRema(:);


%[X,Y]=ndgrid(single(xRema),single(yRema)) ;

Fs=griddedInterpolant({xRema,yRema},single(rot90(sREMA,3))); 

%% Define region of interest

Region=[-2440 -2320 1200 1320]*1000 ; % This defines the region considered, in xps,yps coordinates



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
rockRegion=rock(ix,iy); iceRegion=ice(ix,iy);



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

FindOrCreateFigure("REMA") ;
contourf(XRegion/1000,YRegion/1000,sRegion) ; colorbar
hold on ; [cGL,yGL]=PlotGroundingLines([],"Bedmachine",[],[],[],[],"w");
xlabel("xps (km)",Interpreter="latex")  ; ylabel("yps (km)",Interpreter="latex")


%% Surface mass balance



P=OneDriveFolder+"Antarctic Accumulation Maps\";
filenameRACMO="SMB_RACMO2.3_1979_2011.nc" ;



LAT=ncread(P+filenameRACMO,'lat2d')';
LON=ncread(P+filenameRACMO,'lon2d')';
SMB=ncread(P+filenameRACMO,'SMB')';


[X, Y]=ll2xy(LAT,LON); %transform to your Polar stereo projection

disp('interpolating (assuming rho_ice = 917 kg/m^3)');
rho_ice = 917;

acc=SMB/rho_ice ; 

% smb = griddata(X,Y,SMB,x,y) / 917; %in m/yr

Fas=scatteredInterpolant(X(:),Y(:),acc(:)); 

% map on region
asRegion=Fas(XRegion,YRegion) ;

%%
FindOrCreateFigure("as Region") ;
contourf(XRegion/1000,YRegion/1000,asRegion) ; cbar=colorbar ; 
title(cbar,"(m/yr)")
hold on ; [cGL,yGL]=PlotGroundingLines([],"Bedmachine",[],[],[],[],"w");
xlabel("xps (km)",Interpreter="latex")  ; ylabel("yps (km)",Interpreter="latex")


%%
FindOrCreateFigure("rock Region") ;
contourf(XRegion/1000,YRegion/1000,rockRegion) ; cbar=colorbar ; 
hold on ; [cGL,yGL]=PlotGroundingLines([],"Bedmachine",[],[],[],[],"w");
xlabel("xps (km)",Interpreter="latex")  ; ylabel("yps (km)",Interpreter="latex")

FindOrCreateFigure("ice Region") ;
contourf(XRegion/1000,YRegion/1000,iceRegion) ; cbar=colorbar ; 
hold on ; [cGL,yGL]=PlotGroundingLines([],"Bedmachine",[],[],[],[],"w");
xlabel("xps (km)",Interpreter="latex")  ; ylabel("yps (km)",Interpreter="latex")



%% Regional interpolants
%
Fs=griddedInterpolant({xRegion,yRegion},sRegion) ;
Fvx=griddedInterpolant({xRegion,yRegion},vxRegion) ;
Fvy=griddedInterpolant({xRegion,yRegion},vyRegion) ;
Fas=griddedInterpolant({xRegion,yRegion},asRegion) ;
Frock=griddedInterpolant({xRegion,yRegion},single(rockRegion)) ;
Fice=griddedInterpolant({xRegion,yRegion},single(iceRegion)) ;





