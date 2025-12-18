[ele,R] = readgeoraster('surface_elevation.tif');
x=R.XWorldLimits(1):(R.XWorldLimits(2) - R.XWorldLimits(1))/(R.RasterSize(2)-1):R.XWorldLimits(2); x=x.';
y=R.YWorldLimits(1):(R.YWorldLimits(2) - R.YWorldLimits(1))/(R.RasterSize(1)-1):R.YWorldLimits(2); y=y.';
ele(ele==32767)=0; ele=ele.';

N = 1;
x = x(1:N:end); y = y(1:N:end);
surface = ele(1:N:end, 1:N:end);
%K = (1/9)*ones(5);
%surface = conv2(surface,K,'same');
%surface = smoothdata2(surface);
surface = imgaussfilt(surface);

[X,Y] = ndgrid(double(x),double(y));
Fs = griddedInterpolant(X,Y,fliplr(double(surface)));

% thickness and bedrock
[thk,R] = readgeoraster('thickness.tif'); % Millan
x=R.XWorldLimits(1):(R.XWorldLimits(2) - R.XWorldLimits(1))/(R.RasterSize(2)-1):R.XWorldLimits(2); x=x.';
y=R.YWorldLimits(1):(R.YWorldLimits(2) - R.YWorldLimits(1))/(R.RasterSize(1)-1):R.YWorldLimits(2); y=y.';
thk(thk<0)=0; thk=thk.';

N = 1;
x = x(1:N:end); y = y(1:N:end);
thk = thk(1:N:end, 1:N:end);
%thk = conv2(thk,K,'same');
%thk = smoothdata2(thk);
thk = imgaussfilt(thk);

[X,Y] = ndgrid(double(x),double(y));
Fthk = griddedInterpolant(X,Y,fliplr(double(thk)));

save('InterpolantF.mat','Fs','Fthk');