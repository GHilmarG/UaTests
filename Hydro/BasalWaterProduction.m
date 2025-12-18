
function [UserVar,aw]=BasalWaterProduction(UserVar,CtrlVar,MUA,F)


persistent Faw


if contains(UserVar.Example,"-Antarctica-") ||  contains(UserVar.Example,"-WAIS-")


    if isempty(Faw)



        MUAinput=MUA;
        Finput=F;

        %% Antarctica
        InverseRestartFile="../Antarctica/Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile.mat";

        %PIG-TWG
        % InverseRestartFile="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Sandbox\InverseRestartFiles\InverseRestartFile-Cornford-Ca1-Cs100000-Aa1-As100000-5km-Alim-.mat";


    
        load(InverseRestartFile,"F","MUA","CtrlVarInRestartFile")
        
        if ~exist("CtrlVar")
            CtrlVar=CtrlVarInRestartFile;
        end

        


        He=F.GF.node;
        delta=He*0;

        H=F.S-F.B;


        [taubx,tauby] = ...
            BasalDrag(CtrlVar,MUA,He,delta,F.h,F.B,H,F.rho,F.rhow,F.ub,F.vb,F.C,F.m,F.uo,F.vo,F.Co,F.mo,F.ua,F.va,F.Ca,F.ma,F.q,F.g,F.muk,F.V0);

        tau=sqrt(taubx.*taubx+tauby.*tauby);

        cbar=UaPlots(CtrlVar,MUA,F,tau,FigureTitle="taub");
        title(cbar,"(kPa)",Interpreter="latex")
        clim([0 1000])



        % Pa = J/m^3
        %
        %
        L=334e3 ; % J/kg
        rho=1000;

        aw=1000*(F.ub.*taubx+F.vb.*tauby)/(L*rho) ; % multiplying with 1000 to get Joules

        speed=sqrt(F.ub.*F.ub+F.vb.*F.vb);
        NoSliding=speed < 10;
        aw(NoSliding)=1e-5 ;

        % Units: m/yr J/m^3  kg/J  m^3/kg = m/yr

        cbar=UaPlots(CtrlVar,MUA,F,aw,FigureTitle="aw");
        title(cbar,"(m/yr)",Interpreter="latex")
        title("Basal water production due to sliding (linear scale)",Interpreter="latex")
        clim([0 1.2])

        
        awlog=log10(aw);
        awlog(F.GF.node<0.5)=nan ;
        aw(F.GF.node<0.5)=0 ;

        cbar=UaPlots(CtrlVar,MUA,F,awlog,FigureTitle="log10(aw)");
        title(cbar,"$\log_{10} \mathrm{(m/yr)}$",Interpreter="latex")
        title("Basal water production due to sliding ($\log_{10}$ scale)",Interpreter="latex")
        clim([-3 1.2])



        dlat=[];
        dlon=[];
        LabelSpacing=[];
        Colour="k" ;
        isCircumpolar=true;
        [Lat,Lon,X0,Y0,Clat,hlat,Clon,hlon,ax1,ax2]=PlotLatLonGrid(CtrlVar.PlotXYscale,dlat,dlon,LabelSpacing,Colour,isCircumpolar);
          
        %%

        Faw=scatteredInterpolant(F.x,F.y,aw);

        F=Finput ; MUA=MUAinput;

    end

    aw=Faw(F.x,F.y);
    aw(F.GF.node<0.5)=0 ;
  
    % aw(aw<0)=0 ; 
    % awlog=log10(aw) ; awlog(F.GF.node<0.5)=nan ;
    % UaPlots(CtrlVar,MUA,F,awlog,FigureTitle="aw on mesh") ; 
else
    error("case not found")
end

%%

end