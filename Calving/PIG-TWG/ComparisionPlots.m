%% Comparision plots

WorkDir=pwd; 

if ~contains(WorkDir,"ResultsFiles")
    [~,hostname]=system('hostname') ;
    if contains(hostname,"DESKTOP-G5TCRTD")
        UserVar.ResultsFileDirectory="F:\Runs\Calving\PIG-TWG\ResultsFiles\";
    elseif contains(hostname,"DESKTOP-BU2IHIR")
        UserVar.ResultsFileDirectory="D:\Runs\Calving\PIG-TWG\ResultsFiles\";
    else
        error("case not implemented")
    end
    cd(UserVar.ResultsFileDirectory)
end



IRange=1:2;



% 30km = 14km
% 20km = 9.3km
% 10km = 4.6km
%  5km = 2.3km
% 2.5km = 1.16km


TextString="";

SaveFigures=false;  
% FigureDirectory="C:\Users\lapnjc6\OneDrive - Northumbria University - Production Azure AD\Work\Manuscripts\2022 ThwaitesIceShelfButtressing\Figures\"; 
FigureDirectory="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Work\Manuscripts\2022 ThwaitesIceShelfButtressing\Figures\";

Region="Thwaites" ;  % only one implemented

Compare="2.3km C2 Weertman";


Compare="4.6km C2 Cornford";
Compare="2.3km C2 Cornford";




Compare="2.3km Weertman-Cornford";
Compare="2.3km Weertman-Cornford TWISC0";

Compare="4.6km Cornford";

Compare="2.3km Cornford C0-C2"; 

Compare="2.3km Cornford C0 1m 1cm"; 

Compare="2.3km Cornford";

% Compare="SUPG";

% Compare="2.3km Weertman";  % This one covers 200 years for both runs
% Note: When comparing I subtract Data(2)-Data(1)
QuiverColorSpeedLimits=[0 1000];
xb=[-1520 -1445 -1100 -1100 -1350 -1590 -1520] ;yb=[-510  -547  -547 -180 -180   -390 -510];  % Thwaites
xyBoundary=[xb(:) yb(:)]*1000;
AxisLimits=[-1620 -1400 -520 -340] ;
switch Compare


    case "4.6km Weertman"

     SubString(1)="-FT-P-TWIS-MR4-SM-10km-Alim-";
     %SubString(2)="-FT-P-TWISC0-MR4-SM-10km" ; 
     SubString(2)="-T-P-TWISC0-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC0-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG.mat"; 
     

     case "4.6km C2 Weertman"
          
     SubString(1)="-FT-P-TWIS-MR4-SM-10km-Alim-";
     SubString(2)="-T-P-TWISC2-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC2-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";


    case  "4.6km Cornford"
        


        % 10km Cornford
        SubString(1)="-Tri3-kH10000-ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";
        SubString(2)="-Tri3-kH10000-ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";


        SubString(1)="FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-";

    case  "4.6km C2 Cornford"

        SubString(1)="-Tri3-kH10000-ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";
        SubString(2)="TWISC2-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC2";


    case  "2.3km Weertman"
        % 5km Weertman
        SubString(1)="-Tri3-kH10000-FT-P-TWIS-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-Tri3-kH10000-FT-P-TWISC0-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        TextString=["With Iceshelf: thin lines","Without Iceshelf: thick lines"] ;

    case  "2.3km Cornford"
        % 5km Cornford

        SubString(1)="-FT-P-TWIS-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

        SubString(1)="-FT-P-TWIS-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-FT-P-TWISC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

   case  "2.3km Cornford C0-C2"
                       
        SubString(1)="-ThickMin0k01-FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-" ; % only have this with Duvh
        SubString(2)="-ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-" ;      % for some reason missing the first 10 years, and also do not have this with Duvh

        

        TextString=["2km iceshelf: thin lines","No iceshelf: thick lines"] ;

    case  "2.3km C2 Cornford"

        SubString(1)="-FT-P-TWIS-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";              
        SubString(2)="-Tri3-kH10000-ThickMin0k01-FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";   % only have this with Duvh
        
        

    case  "2.3km C2 Weertman"


        SubString(1)="-Tri3-kH10000-FT-P-TWIS-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-T-P-TWISC2-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC2-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG"; 

    case  "9.3km Cornford"
        % 20km Cornford
        SubString(1)="Nodes5348-Ele10433-Tri3-kH10000-ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="Nodes5348-Ele10433-Tri3-kH10000-ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-";





    case "2.3km Weertman-Cornford"

         SubString(1)="-FT-P-TWIS-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
         SubString(2)="-Tri3-kH10000-FT-P-TWIS-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

         TextString=["Cornford: thin lines","Weertman: thick lines"] ;



    case "2.3km Weertman-Cornford TWISC0"

        SubString(1)="-FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-Tri3-kH10000-FT-P-TWISC0-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

        TextString=["Cornford: thin lines","Weertman: thick lines"] ;

    case "2.3km Cornford C0 1m 1cm"

        SubString(1)="-FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-FT-P-TWISC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";

        QuiverColorSpeedLimits=[0 1];
        TextString=["Cornford: thin lines","Weertman: thick lines"] ;


    case "SUPG"


      

        SubString(1)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-tau1-beta01";    % 200 years
        SubString(2)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-tau1-SUPGM100";    % 400 years
        
        SubString(1)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-taut-beta01";    % 200 years
        SubString(2)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-taut-SUPGM100";    % 400 years

        SubString(1)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-tau2-beta01";    % 200 years
        SubString(2)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-tau2-SUPGM100";    % 400 years

        SubString(1)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";   
        SubString(2)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-tau2-beta01";    % 200 years
        
        SubString(1)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-.mat";   
        SubString(2)="ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-taus-SUPGm2";    % 200 years
                      

        xyBoundary=NaN;
        AxisLimits=[ -1735.8                   -1012.6                    -725.3                      52.3] ; 

        QuiverColorSpeedLimits=[0 1];
        TextString=["tau2: thin lines","tau2 m100: thick lines"] ;

    otherwise
        error("which case")

end


TimeVector=0:20:200;
% TimeVector=0:1:50;
TimeVector=20;



AskForInput=true;
VAFnode=[] ;
VAFn=[nan;nan];
iCount=0; 

for J=1:numel(TimeVector)

    iCount=iCount+1;
    TimeString=sprintf("%7.7i",100*TimeVector(J)) ;

    if ~contains(SubString(1),".mat")
        File1=dir(TimeString+"*"+SubString(1)+"*.mat") ;
    else
        File1=dir(TimeString+"*"+SubString(1)) ;
    end

    if ~contains(SubString(2),".mat")
        File2=dir(TimeString+"*"+SubString(2)+"*.mat") ;
        
    else
        File2=dir(TimeString+"*"+SubString(2)) ;
    end

    if numel(File1) > 0  && numel(File2) > 0

        load(File1(1).name,"MUA","CtrlVar","F") ;
        F1= F ; MUA1=MUA;

        load(File2(1).name,"MUA","CtrlVar","F") ;
        F2=F; MUA2=MUA;

    else
        fprintf("numel(File1)=%i \t numel(File2)=%i \t Breaking out of loop \n",numel(File1),numel(File2))
        continue
    end


    [VAF1,IceVolume1,GroundedArea1,hAF1,hfPos1]=CalcVAF(CtrlVar,MUA1,F1.h,F1.B,F1.S,F1.rho,F1.rhow,F1.GF,boundary=xyBoundary);
    [VAF2,IceVolume2,GroundedArea2,hAF2,hfPos2]=CalcVAF(CtrlVar,MUA2,F2.h,F2.B,F2.S,F2.rho,F2.rhow,F2.GF,boundary=xyBoundary);

    hold off

    if MUA1.Nnodes==MUA2.Nnodes

        VAF2node=VAF2.node; 
        dVAFnode=VAF2.node-VAF1.node ;
        ub2=F2.ub;
        vb2=F2.vb;

    else

        % map variables onto mesh1
        [RunInfo,VAF2node,ub2,vb2]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,[],MUA2,MUA1,[],VAF2.node,F2.ub,F2.vb);
        dVAFnode=VAF2node-VAF1.node ;


    end


    figVAF=FindOrCreateFigure("Compare",[50 700 700 550]); clf(figVAF) ;  
    hold off
    
    Tile=tiledlayout(1,2) ; 
    nexttile(1)
    cbarVAF=UaPlots(CtrlVar,MUA1,F1,dVAFnode,GroundingLineColor="r",CalvingFrontColor="b") ;
    title(cbarVAF,["Height above","flotation","(m w.eq.)"],interpreter="latex") ;
    
    
    dVAFGt=(VAF2.Total-VAF1.Total)/1e9;
    SLR=-dVAFGt/362 ; 


    title(sprintf("%s: VAF diff at time=%3.1f yr \n dVAF=%g Gt, SLR=%5.2f (mm)",Compare,F1.time,(VAF2.Total-VAF1.Total)/1e9,SLR),Interpreter="latex" )
    fprintf("t=%f \t VAF1=%f \t VAF2=%f \n ",F1.time,VAF1.Total/1e9,VAF2.Total/1e9)
    hold on
    PlotGroundingLines(CtrlVar,MUA2,F2.GF,[],[],[],color="r",LineStyle="-",LineWidth=2);
    PlotCalvingFronts(CtrlVar,MUA2,F2,color="b",LineWidth=2,LineStyle="-");



    axis(AxisLimits)

    clim([-50 50])
    ModifyColormap();

    % PlotLatLonGrid(1000,5/4,10/4);
    text(-1445,-350,TextString,BackgroundColor="w",FontSize=10,EdgeColor="k");
    text(-1560,-350,["Grounding lines in red","Calving fronts in blue"],BackgroundColor="w",FontSize=9,EdgeColor="k");
    cbarVAF.Position=[0.8 0.2 0.03, 0.6]; title("")
    % dlat=5/4 ; dlon=10/2 ; PlotLatLonGrid(1000,dlat,dlon);
    

    if SaveFigures
        title("")  % get rid of title
        
        FigureName="HeightAboveFlotationDiff"+TimeString+Region;
        exportgraphics(figVAF,FigureDirectory+FigureName+".pdf")
        savefig(figVAF,FigureDirectory+FigureName+".fig","compact")

    end


    % figVel=FindOrCreateFigure("Velocity",[800 700 700 550]); clf(figVel) ; 
    hold off
    nexttile(2)


    dub=ub2-F1.ub;
    dvb=vb2-F1.vb;

%     % get rid of values downstream of the calving front of F1
%     if isempty(F.LSFMask)
%         F1.LSFMask=CalcMeshMask(CtrlVar,MUA1,F1.LSF,0);
%     end
%     dub(~F1.LSFMask.NodesIn)=NaN;
%     dvb(~F1.LSFMask.NodesIn)=NaN;

    % get rid of values downstream of the grounding line of F1
    F1.GF=IceSheetIceShelves(CtrlVar,MUA1,F1.GF);
    dub(F1.GF.NodesDownstreamOfGroundingLines)=NaN;
    dvb(F1.GF.NodesDownstreamOfGroundingLines)=NaN;

    dub(VAF2node<eps  | VAF1.node < eps)=NaN;  % also, if interpolated VAF values are small, indicating floating areas, get rid of those too.
    dvb(VAF2node<eps  | VAF1.node < eps)=NaN;

    CtrlVar.VelColorMap=jet(100) ; CtrlVar.QuiverColorSpeedLimits=QuiverColorSpeedLimits ; 

    if J==1
        CtrlVar.QuiverSameVelocityScalingsAsBefore=false ;
    else
        CtrlVar.QuiverSameVelocityScalingsAsBefore=true ;
    end

    
    [cbarVel,Qh,QVPar]=QuiverColorGHG(F1.x,F1.y,dub,dvb,CtrlVar) ;
    title(cbarVel,["Speed","$(\mathrm{m/yr})$"],interpreter="latex")
    title(sprintf("%s: Vel diff at time=%3.1f yr \n dVAF=%g Gt, SLR=%5.2f (mm)",Compare,F1.time,(VAF2.Total-VAF1.Total)/1e9,SLR),Interpreter="latex" )


    xlabel("xps (km)",Interpreter="latex")
    ylabel("yps (km)",Interpreter="latex")
    hold on
    PlotGroundingLines(CtrlVar,MUA1,F1.GF,[],[],[],color="r",LineStyle="-",LineWidth=1);
    PlotCalvingFronts(CtrlVar,MUA1,F1,color="b",LineWidth=1,LineStyle="-");

    PlotGroundingLines(CtrlVar,MUA2,F2.GF,[],[],[],color="r",LineStyle="-",LineWidth=2);
    PlotCalvingFronts(CtrlVar,MUA2,F2,color="b",LineWidth=2,LineStyle="-");

    axis(AxisLimits)
    



    text(-1445,-350,TextString,BackgroundColor="w",FontSize=10,EdgeColor="k");
    text(-1560,-350,["Grounding lines in red","Calving fronts in blue"],BackgroundColor="w",FontSize=9,EdgeColor="k");
    cbarVel.Position=[0.9 0.2 0.02, 0.55]; title("")
    cbarVAF.Position=[0.42 0.2 0.02 0.55];
    text(-1.3,1,"(a)",Units="normalized",FontWeight="bold")
    text(-0.12,1,"(b)",Units="normalized",FontWeight="bold")
    drawnow

    Tile.TileSpacing="compact" ; Tile.Padding="compact";
    figVAF.Position=[50 700 1200 550];
    nexttile(1) ; ModifyColormap;
    if SaveFigures
        title("")  % get rid of title
        % cbarVel.Position=[0.85 0.2 0.03, 0.6];
        FigureName="VelocityDiff"+TimeString+Region;
        exportgraphics(figVAF,FigureDirectory+FigureName+".pdf")
        savefig(figVAF,FigureDirectory+FigureName+".fig","compact")

    end


    % show changes in height above floation for each run, from start of run.

    FigVAF1=FindOrCreateFigure("VAF1") ;

    if iCount==1 ; VAF1start=VAF1; end
    
    UaPlots(CtrlVar,MUA1,F1,VAF1.node-VAF1start.node) ;
    title(sprintf("%s: \n VAF diff at time=%3.1f yr \n dVAF=%g Gt, SLR=%5.2f (mm)",SubString(1),F1.time,(VAF1.Total-VAF1start.Total)/1e9,SLR),Interpreter="latex" )
    CLim=clim;

    FigVAF2=FindOrCreateFigure("VAF2") ;
    
    if iCount==1 ; VAF2start=VAF2; end

    UaPlots(CtrlVar,MUA2,F2,VAF2.node-VAF2start.node) ;
    title(sprintf("%s: \n VAF diff at time=%3.1f yr \n dVAF=%g Gt, SLR=%5.2f (mm)",SubString(2),F2.time,(VAF2.Total-VAF2start.Total)/1e9,SLR),Interpreter="latex" )
    clim(CLim)
    if AskForInput
        prompt = " Y/N/C [Y]: ";
        txt = input("Ret to continue, N for break, C for continuous: ","s");
        if txt=="C" || txt=="c"
            AskForInput=false;
        elseif txt=="N" || txt=="n"
            break
        end
    end
    

end


% fig.Position=[40 450 1080 850];


%%

% f=gcf; exportgraphics(f,'ThwaitesIceShelf.pdf')

fprintf("Plots and videos were saved in the folder %s \n",pwd)

cd(WorkDir)