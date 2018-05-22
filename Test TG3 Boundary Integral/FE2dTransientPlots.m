function FE2dTransientPlots(CtrlVar,DTxy,TRIxy,MeshBoundaryCoordinates,GF,dGFdt,coordinates,connectivity,...
            b,B,S,s,h,u,v,wSurf,dhdt,dsdt,dbdt,C,AGlen,m,n,xint,yint,wSurfInt,etaInt,exx,eyy,exy,e,time,...
            rho,rhow,a,as,ab)      
        
        x=coordinates(:,1); y=coordinates(:,2);
        %figure ; PlotFEmesh(coordinates,connectivity,CtrlVar); hold on
        
        figure(CtrlVar.TG3+1) ; 
        trisurf(TRIxy,x/CtrlVar.PlotXYscale,y/CtrlVar.PlotXYscale,h,'EdgeColor','none') ; title(sprintf(' h at t=%-g, TG3=%-i',time,CtrlVar.TG3))
        view(5.5,12)
        
        filename=sprintf('TG3is%i-%i.mat',CtrlVar.TG3,CtrlVar.IncludeTG3uvhBoundaryTerm);  save(filename,'time','h','dhdt','CtrlVar','TRIxy','x','y')
        
        
end