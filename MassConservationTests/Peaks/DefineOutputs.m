function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l)

persistent hFirst VolumeFirst tVector VolumeVector iCount


if isempty(iCount)

    iCount=0;
    tVector=nan(1000,1);
    VolumeVector=nan(1000,1) ;

end

[TotalIceVolume,ElementIceVolume]=CalcIceVolume(CtrlVar,MUA,F.h) ;

iCount=iCount+1; 
tVector(iCount)=F.time;
VolumeVector(iCount)=TotalIceVolume; 



UaPlots(CtrlVar,MUA,F,F.h,FigureTitle="ice thickness")
title(sprintf("ice thickness at t=%g",F.time))
subtitle(sprintf("ice volume=%g",TotalIceVolume))

UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="velocity")
title(sprintf("Velocities at t=%g",F.time))
xlabel("x (km)",Interpreter="latex") ; 
ylabel("y (km)",Interpreter="latex")


if ~isempty(hFirst)
    
    cbar=UaPlots(CtrlVar,MUA,F,F.h-hFirst,FigureTitle="Change in ice thickness");
    title(sprintf("Change in ice thickness at t=%g compared to t=0",F.time))
    subtitle(sprintf("change in ice volume=%g m^3",TotalIceVolume-VolumeFirst))
    xlabel("x (km)",Interpreter="latex") ; ylabel("y (km)",Interpreter="latex")
    title(cbar,"(m)",Interpreter="latex")
end

if isempty(hFirst)
    hFirst=F.h ;
    VolumeFirst=TotalIceVolume;

   
    UaPlots(CtrlVar,MUA,F,F.h,FigureTitle="Initial thickness distribution"); 
    xlabel("x (km)",Interpreter="latex") ; ylabel("y (km)",Interpreter="latex")

end

figure(10) ; hold on 
Plot_sbB(CtrlVar,MUA,F.s,F.b,F.B) ;

if CtrlVar.DefineOutputsInfostring=="Last call"

    FindOrCreateFigure("ice volume")
    yyaxis left
    plot(tVector,VolumeVector/1e9,"o-")
    ylabel("Volume (Gt)")
    yyaxis right
    plot(tVector,(VolumeVector-VolumeVector(1))/1e9,"*-")
    ylabel("Change in volume (Gt)")

    xlabel("time (yr)")
    legend("Volume","Volume change",Location="best")
    
    fbcs=FindOrCreateFigure("BCs") ; clf(fbcs)
    PlotBoundaryConditions(CtrlVar,MUA,BCs) ;

   

end


end
