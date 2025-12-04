function as=SMBSchemePDD()
    load('InitialMesh.mat');
    F.x = MUA.coordinates(:,1);
    F.y = MUA.coordinates(:,2);
    
    OGGM_param=readtable('OGGM_param.csv');
    
    % SMB scheme parameters obtained from OGGM calibration procedure
    UserVar.melt_f=OGGM_param.melt_f;
    UserVar.monthly_melt_f=UserVar.melt_f*365/12;
    UserVar.prcp_fac=OGGM_param.prcp_fac;
    UserVar.temp_bias=OGGM_param.temp_bias;
    UserVar.temp_all_solid=OGGM_param.temp_all_solid;
    UserVar.temp_all_liq=OGGM_param.temp_all_liq;
    UserVar.temp_melt=OGGM_param.temp_melt;
    
    %climate-data
    filename = 'monthly.nc';
    temp = double(ncread(filename, 'ts'));
    prcp = double(ncread(filename, 'pr'));
    xlat = double(ncread(filename, 'xlat'));
    xlon = double(ncread(filename, 'xlon'));
    ys = 1980;
    ye = 2010;
    UserVar.halfsize = 10;
    UserVar.y0 = 2000;
    
    Jan = 12*(UserVar.y0-UserVar.halfsize-ys)+1;
    Dec = 12*(UserVar.y0+UserVar.halfsize-ys+1);
    nyears_prcp = reshape(prcp(:,:,Jan:Dec),47,37,12,UserVar.halfsize*2+1);
    nyears_temp = reshape(temp(:,:,Jan:Dec),47,37,12,UserVar.halfsize*2+1);
    monthly_temp = mean(nyears_temp,4)-273.15;
    monthly_days = [31,29,31,30,31,30,31,31,30,31,30,31];
    monthly_prcp = mean(nyears_prcp,4);
    
    itemp = zeros(MUA.Nnodes,12);
    iprcp = zeros(MUA.Nnodes,12);
    
    % interpolation
    info = geotiffinfo('thickness.tif');
    [X,Y] = projfwd(info,xlat,xlon);
    for month=1:12
        Ftemp = griddata(X,Y,double(monthly_temp(:,:,month)),F.x,F.y);
        itemp(:,month) = Ftemp(:);
        
        Fprcp = griddata(X,Y,double(monthly_prcp(:,:,month)),F.x,F.y);
        iprcp(:,month) = Fprcp(:)*60*60*24*monthly_days(month);
    end
    
    itemp = itemp+UserVar.temp_bias;
    iprcp = iprcp*UserVar.prcp_fac;

    % Compute temperature above melting threshold
    itempformelt = itemp-UserVar.temp_melt;
    itempformelt = max(itempformelt, 0);
    % Compute solid precipitation from total precipitation
    fac = 1-(itemp-UserVar.temp_all_solid)/(UserVar.temp_all_liq-UserVar.temp_all_solid);
    fac(fac>1)=1; fac(fac<0)=0;
    iprcpsol = iprcp.*fac;
    
    % get annual smb
    ismb = iprcpsol-UserVar.monthly_melt_f*itempformelt;
    as = sum(ismb,2); % mm w.e. yr-1
    as = as/1000; % m/yr

    save as_control.mat as;

end



