


function [RR,KK,Outs]=lsqUaFunc(x,UserVar,CtrlVar,MUA,F0,F1,k,eta)

narginchk(8,8)
nargoutchk(1,3)

F1.hw=x ;


if CtrlVar.WaterFilm.Assembly=="-AD-"    || CtrlVar.WaterFilm.Assembly=="-A-"


    [UserVar,RR,KK,qx1int,qy1int,x1int,y1int]=WaterFilmThicknessEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k,eta) ;


elseif CtrlVar.WaterFilm.Assembly=="-D-"

    [UserVar,RR,KK,qx1int,qy1int,x1int,y1int]=WaterFilmThicknessDiffusionEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k,eta);

else
    error("case not found")
end

Outs.qx1int=qx1int ; Outs.qy1int=qy1int ;  Outs.xint=x1int ; Outs.yint=y1int ;

end