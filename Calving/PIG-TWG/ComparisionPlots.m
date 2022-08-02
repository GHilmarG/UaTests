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








Compare="5km C2 Weertman";
Compare="5km Weertman";  % This one covers 200 years for both runs


Compare="5km Cornford";
Compare="10km Cornford";
Compare="10km C2 Cornford";
Compare="5km C2 Cornford";

switch Compare


    case "10km Weertman"

     SubString(1)="-FT-P-TWIS-MR4-SM-10km-Alim-";
     %SubString(2)="-FT-P-TWISC0-MR4-SM-10km" ; 
     SubString(2)="-T-P-TWISC0-MR4-SM-Clim-Alim-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC0-int-kH=10-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG.mat"; 
     

     case "10km C2 Weertman"
          
     SubString(1)="-FT-P-TWIS-MR4-SM-10km-Alim-";
     SubString(2)="-T-P-TWISC2-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC2-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";


    case  "10km Cornford"


        % 10km Cornford
        SubString(1)="-Tri3-kH10000-ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";
        SubString(2)="-Tri3-kH10000-ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";

        % SubString(1)="-Tri3-kH10000-ThickMin0k01-FT-P-Duvh-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";
        % SubString(2)="-Tri3-kH10000-ThickMin0k01-FT-P-Duvh-TWISC0-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";

    case  "10km C2 Cornford"

        SubString(1)="-Tri3-kH10000-ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-10km-Alim-Ca1-Cs100000-Aa1-As100000-kmat";
        SubString(2)="TWISC2-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC2";


    case  "5km Weertman"
        % 5km Weertman
        SubString(1)="-Tri3-kH10000-FT-P-TWIS-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-Tri3-kH10000-FT-P-TWISC0-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-";


    case  "5km Cornford"
        % 5km Cornford
                      
        SubString(1)="-FT-P-TWIS-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-FT-P-TWISC0-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        %         -Tri3-kH10000-ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-

    case  "5km C2 Cornford"

        SubString(1)="-FT-P-TWIS-MR4-SM-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-FT-P-Duvh-TWISC2-MR4-SM-TM001-Cornford-5km-Alim-Ca1-Cs100000-Aa1-As100000-"; 

    case  "5km C2 Weertman"

        
        SubString(1)="-Tri3-kH10000-FT-P-TWIS-MR4-SM-5km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="-T-P-TWISC2-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-NoCalving-0-TWISC2-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG"; 

    case  "20km Cornford"
        % 20km Cornford
        SubString(1)="Nodes5348-Ele10433-Tri3-kH10000-ThickMin0k01-FT-P-TWIS-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-";
        SubString(2)="Nodes5348-Ele10433-Tri3-kH10000-ThickMin0k01-FT-P-TWISC0-MR4-SM-TM001-Cornford-20km-Alim-Ca1-Cs100000-Aa1-As100000-";


    otherwise
        error("which case")

end


xb=[-1520 -1445 -1100 -1100 -1350 -1590 -1520] ;yb=[-510  -547  -547 -180 -180   -390 -510];
xyBoundary=[xb(:) yb(:)]*1000;
TimeVector=0:10:200;
TimeVector=0:1:5;


figVAF=FindOrCreateFigure("Compare");
figVel=FindOrCreateFigure("Velocity");



VAFnode=[] ;
VAFn=[nan;nan];

for J=1:numel(TimeVector)


    TimeString=sprintf("%7.7i",100*TimeVector(J)) ;

    File1=dir(TimeString+"*"+SubString(1)+"*.mat") ;
    File2=dir(TimeString+"*"+SubString(2)+"*.mat") ;

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

        dVAFnode=VAF2.node-VAF1.node ;
        ub2=F2.ub;
        vb2=F2.vb;

    else

        % map variables onto mesh1
        [RunInfo,VAF2node,ub2,vb2]=MapNodalVariablesFromMesh1ToMesh2(CtrlVar,[],MUA2,MUA1,[],VAF2.node,F2.ub,F2,vb);
        dVAFnode=VAF2node-VAF1.node ;


    end


    figure(figVAF)
    UaPlots(CtrlVar,MUA1,F1,dVAFnode,GroundingLineColor="r",CalvingFrontColor="b") ;

    
    
    dVAFGt=(VAF2.Total-VAF1.Total)/1e9;
    SLR=-dVAFGt/362 ; 


    title(sprintf("%s: VAF diff at time %3.1f, dVAF=%g Gt, SLR=%5.2f (mm)",Compare,F1.time,(VAF2.Total-VAF1.Total)/1e9,SLR),Interpreter="latex" )
    fprintf("t=%f \t VAF1=%f \t VAF2=%f \n ",F1.time,VAF1.Total/1e9,VAF2.Total/1e9)
    hold on
    PlotGroundingLines(CtrlVar,MUA2,F2.GF,[],[],[],color="r",LineStyle="-",LineWidth=2);
    PlotCalvingFronts(CtrlVar,MUA2,F2,color="b",LineWidth=2,LineStyle="-");


    axis([-1620 -1400 -520 -340])
    caxis([-50 50])
    ModifyColormap
    figVAF.Position=[50 500 1000 800];

    figure(figVel)
    hold off

    dub=ub2-F1.ub;
    dvb=vb2-F1.vb;

%     % get rid of values downstream of the calving front of F1
%     if isempty(F.LSFMask)
%         F1.LSFMask=CalcMeshMask(CtrlVar,MUA1,F1.LSF,0);
%     end
%     dub(~F1.LSFMask.NodesIn)=NaN;
%     dvb(~F1.LSFMask.NodesIn)=NaN;

    % get rid of values downstream of the grounding line of F1
    F1.GF=IceSheetIceShelves(CtrlVar,MUA,F1.GF);
    dub(F1.GF.NodesDownstreamOfGroundingLines)=NaN;
    dvb(F1.GF.NodesDownstreamOfGroundingLines)=NaN;


    CtrlVar.VelColorMap=jet(100) ;
    cbar=QuiverColorGHG(F1.x,F1.y,dub,dvb,CtrlVar) ;
    title(cbar,"(m/a)")
    title(sprintf("%s \n velocities difference at t=%f",Compare,CtrlVar.time),Interpreter="latex")

    hold on
    PlotGroundingLines(CtrlVar,MUA1,F1.GF,[],[],[],color="r",LineStyle="-",LineWidth=1);
    PlotCalvingFronts(CtrlVar,MUA1,F1,color="b",LineWidth=1,LineStyle="-");

    PlotGroundingLines(CtrlVar,MUA2,F2.GF,[],[],[],color="r",LineStyle="-",LineWidth=2);
    PlotCalvingFronts(CtrlVar,MUA2,F2,color="b",LineWidth=2,LineStyle="-");
    axis([-1620 -1400 -520 -340])
    figVel.Position=[1050 500 1000 800];

    drawnow
    prompt = "Do you want more? Y/N [Y]: ";
    txt = input("Press RET for continue","s");
    if ~isempty(txt)
        break
    end


end


% fig.Position=[40 450 1080 850];


%%

% f=gcf; exportgraphics(f,'ThwaitesIceShelf.pdf')

fprintf("Plots and videos were saved in the folder %s \n",pwd)

cd(WorkDir)