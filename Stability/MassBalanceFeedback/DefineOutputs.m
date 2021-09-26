function  UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo);


time=CtrlVar.time;

if strcmp(CtrlVar.DefineOutputsInfostring,'First call') 
    return
end
persistent nCalls Acc Surf Time V iCount

if isempty(nCalls)
    nCalls=0;

end


%%
if ~isfield(CtrlVar,'DefineOutputs')
    CtrlVar.uvPlotScale=[];
    %plots='-ubvb-udvd-log10(C)-log10(Surfspeed)-log10(DeformationalSpeed)-log10(BasalSpeed)-log10(AGlen)-';
    % plots='-ubvb-log10(BasalSpeed)-sbB-ab-log10(C)-log10(AGlen)-';
    plots='-';
    
else
    plots=CtrlVar.DefineOutputs;
end



CtrlVar.QuiverColorPowRange=2; 

GLgeo=GLgeometry(MUA.connectivity,MUA.coordinates,GF,CtrlVar);
TRI=[]; DT=[];
x=MUA.coordinates(:,1);  y=MUA.coordinates(:,2);

%%
if contains(plots,'-stresses-')
    
    figure
    %PathName='E:/GHG/Satellite Images/Landsat/Brunt/Landsat 8/2015-02-06/';
    %ImageFile='LC81841142015037LGN00_B3.TIF';
    %[Image,ImageFile,PathName]=ReadLandsatFile(ImageFile,PathName);
    %
    %low=0.1 ; high=0.4 ;
    
    %MapHandle=PlotStreachedLandsatImage(Image,low,high,CtrlVar.PlotXYscale);
    
    hold on
    [txzb,tyzb,txx,tyy,txy,exx,eyy,exy,e]=CalcNodalStrainRatesAndStresses(CtrlVar,MUA,AGlen,n,C,m,GF,s,b,ub,vb,ud,vd);
    N=10;
    
    %xmin=-750e3 ; xmax=-620e3 ; ymin=1340e3 ; ymax = 1460e3 ;
    %I=find(x>xmin & x< xmax & y>ymin & y< ymax) ;
    %I=I(1:N:end);
    I=1:N:MUA.Nnodes;
    
    scale=1e-2;
    PlotTensor(x(I)/CtrlVar.PlotXYscale,y(I)/CtrlVar.PlotXYscale,txx(I),txy(I),tyy(I),scale);
    hold on
    plot(x(MUA.Boundary.Edges)/CtrlVar.PlotXYscale, y(MUA.Boundary.Edges)/CtrlVar.PlotXYscale, 'k', 'LineWidth',2) ;
    hold on ; plot(GLgeo(:,[3 4])'/CtrlVar.PlotXYscale,GLgeo(:,[5 6])'/CtrlVar.PlotXYscale,'k','LineWidth',1);
    axis equal
    axis([xmin xmax ymin ymax]/CtrlVar.PlotXYscale)
    xlabel(CtrlVar.PlotsXaxisLabel) ;
    ylabel(CtrlVar.PlotsYaxisLabel) ;
    
end


if ~strcmp(CtrlVar.DefineOutputsInfostring,'Last call')
    
    if isempty(iCount)
        iCount=0;
        N=1000;
        Acc=NaN(N,1);
        Time=NaN(N,1);
        Surf=NaN(N,1);
        V=NaN(N,1);
    end

    iCount=iCount+1;

    if numel(Acc) < iCount

        Acc=[Acc;Acc+NaN];
        Surf=[Surf;Surf+NaN];
        Time=[Time;Time+NaN];
        V=[V;V+NaN];
    end


    
    Acc(iCount)=mean(F.as);
    Surf(iCount)=mean(F.s);
    Time(iCount)=F.time;
    
    IceVolume=sum(FEintegrate2D(CtrlVar,MUA,F.h)) ;
    V(iCount)=IceVolume ;

end
    
if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if strcmp(CtrlVar.DefineOutputsInfostring,'First call ') && exist('ResultsFiles','dir')~=7 ;
        mkdir('ResultsFiles') ;
    end
    
    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0
        %FileName=['ResultsFiles/',sprintf('%07i',round(100*time)),'-',CtrlVar.Experiment]; good for transient runs
        %FileName=['ResultsFiles/',sprintf('%07i',CtrlVar.DefineOutputsCounter),'-',CtrlVar.Experiment];
        
        FileName=sprintf('ResultsFiles/%07i-Nodes%i-Ele%i-Tri%i-%s.mat',...
            round(100*time),MUA.Nnodes,MUA.Nele,MUA.nod,CtrlVar.Experiment);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'CtrlVar','UserVar','MUA','F')
        
    end
end

% only do plots at end of run
if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')
    

    switch UserVar.Experiment

        case "MB-plane-"


            %load AccSurf ;
            figure ; plot(Time,Surf,'or') ; xlabel('time (yr)') ; ylabel('Surface elevation (m)')
            ELA=UserVar.ELA;
            lambda=UserVar.lambda;
            hStart=UserVar.hStart;
            Analytical=(hStart-ELA)*exp(lambda*Time)+ELA ;

            hold on ; plot(Time,Analytical,'g'); legend('Numerical','Analytical')


            Numerical=Surf;
            Error=Numerical-Analytical;
            T=table(Time,Numerical,Analytical,Error);
            disp(T)

        case "MB-1dMountain-"

            FindOrCreateFigure("Mass balance")
            yyaxis left
            plot(F.x/1000,F.b,'ok') ; hold on
            plot(F.x/1000,F.s,'.b') ;
            ylabel("upper and lower surfaces (m)")
            yyaxis right
            plot(F.x/1000,F.as,'*r') ;
            ylabel("surface mass balance (m/yr)")


            FindOrCreateFigure("Velocity")
        
            plot(F.x/1000,F.ub,'ok') ;
            ylabel("velocity (m/yr)")
            

            FindOrCreateFigure("Volume versus time")
            plot(Time,V/1e9)
            ylabel("Ice Volume (km^3)")
            xlabel("time (yr)")

    end


end



end
