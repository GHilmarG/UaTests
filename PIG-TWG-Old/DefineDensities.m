function  [UserVar,rho,rhow,g]=DefineDensities(UserVar,CtrlVar,MUA,time,s,b,h,S,B)
    
persistent xFirn yFirn rhoeffective Fr

if isempty(xFirn)
    
    locdir=pwd;
    cd(UserVar.InterpolantsDirectory)
    AntarcticGlobalDataSets=getenv('AntarcticGlobalDataSets');
    
    if ~isempty(AntarcticGlobalDataSets)
        
        cd(AntarcticGlobalDataSets)
        cd('Antarctic Effective Ice Density')
    end
    
    FileName='FirnThickOnly.mat';
    fprintf('DefineIceDensity: loading file: %-s ',FileName)
    load(FileName,'xFirn','yFirn','rhoeffective')
    fprintf(' done \n')
    cd(locdir)
    
    % there are nan in the data set outside the ice boundary of the firn-density model. Possibly the FE model will need
    % values here and I set them to rhoIceShelf
    
    rhoIceShelf=800;
    
    rhoeffective(isnan(rhoeffective))=rhoIceShelf;
    
    fprintf(' Defining interpolants \n')
    [X,Y]=ndgrid(xFirn,yFirn);
    
    Fr = griddedInterpolant(X,Y,rot90(flipud(rhoeffective),-1), 'cubic');
    
end

rhow=1030; g=9.81/1000;

rho=Fr(MUA.coordinates(:,1),MUA.coordinates(:,2));

rho=900; 

end