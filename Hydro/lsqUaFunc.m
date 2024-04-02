


function [RR,KK,Outs]=lsqUaFunc(hw,UserVar,CtrlVar,MUA,F0,F1,k,eta)

narginchk(8,8)
nargoutchk(1,3)

F1.hw=hw ;


if CtrlVar.WaterFilm.Assembly=="-AD-"    || CtrlVar.WaterFilm.Assembly=="-A-"


    [UserVar,RR,KK,qx1int,qy1int,x1int,y1int]=WaterFilmThicknessEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k,eta) ;
    Outs.qx1int=qx1int ; Outs.qy1int=qy1int ;
    Outs.qx1Phi1int=NaN ; Outs.qy1Phiint=NaN;
    Outs.qx1Y1int=NaN ;  Outs.qy1Yint=NaN;


    Outs.xint=x1int ; Outs.yint=y1int ;

elseif CtrlVar.WaterFilm.Assembly=="-D-"

    [UserVar,RR,KK,Outs]=WaterFilmThicknessDiffusionEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k,eta);

else
    error("case not found")
end



end