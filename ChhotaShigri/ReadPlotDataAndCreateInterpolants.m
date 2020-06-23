
%% Read original data and save in native matlab format
Data=importdata('CS_Data\CS_Surface_BedTopo.txt');

figure ; plot(Data(:,1),Data(:,2),'.') ; axis equal

x=Data(:,1) ; y=Data(:,2) ; s=Data(:,3) ; B=Data(:,4);
clear Data

save('CS_xysB.mat','x','y','s','B');  % this is a faster input output format


%% Define MeshBoundaryCoordinates
load('CS_xysB.mat','x','y','s','B');  
K=convhull(x,y);

figure
plot(x(K),y(K),'r-*') ; axis equal

BoundaryCoordinates=[];
[xmin,i]=min(x(K));  BoundaryCoordinates=[BoundaryCoordinates ;    x(K(i)) y(K(i))];
[ymax,i]=max(y(K));  BoundaryCoordinates=[BoundaryCoordinates ;    x(K(i)) y(K(i))];
[xmax,i]=max(x(K));  BoundaryCoordinates=[BoundaryCoordinates ;    x(K(i)) y(K(i))];
[ymin,i]=min(y(K));  BoundaryCoordinates=[BoundaryCoordinates ;    x(K(i)) y(K(i))];

figure ; plot(BoundaryCoordinates(:,1),BoundaryCoordinates(:,2)); 

save('BoundaryCoordinates.mat','BoundaryCoordinates')

%% Scattter plot of original data 
N=1000;
figure
plot3(x(1:N:end),y(1:N:end),s(1:N:end),'.b')
hold on
plot3(x(1:N:end),y(1:N:end),B(1:N:end),'.r')
%% create scattered interpolants, and for improved performance create gridded interpolants from those.

N=1; % possibly subsample data points
FBscatter=scatteredInterpolant(x(1:N:end),y(1:N:end),B(1:N:end)) ;
Fsscatter=scatteredInterpolant(x(1:N:end),y(1:N:end),s(1:N:end)) ;

dx=10;  % define new data resulution in xy plen
[X,Y]=ndgrid(xmin:dx:xmax,ymin:dx:ymax);

BXY=FBscatter(X,Y); % map B onto grid
FB=griddedInterpolant(X,Y,BXY);  % define B gridded interpolant

sXY=Fsscatter(X,Y);
Fs=griddedInterpolant(X,Y,sXY);

Fb=FB; 

save('GriddedInterpolants.mat','Fs','FB','Fb')

%%
xmin=min(FB.GridVectors{1});
xmax=max(FB.GridVectors{1});
ymin=min(FB.GridVectors{2});
ymax=max(FB.GridVectors{2});
dx=100;
[X,Y]=ndgrid(xmin:dx:xmax,ymin:dx:ymax);
surf=Fs(X,Y);  % calculate surface over grid and plot
figure ; contourf(X,Y,surf) ; axis equal ; title('Surface') ; colorbar

Bed=FB(X,Y);  % calculate surface over grid and plot
figure ; contourf(X,Y,Bed) ; axis equal ; title('Bed') ; colorbar

h=surf-Bed;
figure ; contourf(X,Y,h) ; axis equal ; title('Ice Thickness') ; colorbar




