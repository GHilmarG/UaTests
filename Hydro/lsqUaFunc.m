function [RR,KK]=lsqUaFunc(x,UserVar,CtrlVar,MUA,F0,F1,k,eta)

narginchk(8,8)

F1.hw=x ;

if CtrlVar.WaterFilm.Assembly=="-AD-"    || CtrlVar.WaterFilm.Assembly=="-A-"
    [UserVar,RR,KK]=WaterFilmThicknessEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k,eta);
elseif CtrlVar.WaterFilm.Assembly=="-D-"   % "-AD-"   either diffusive only (D) or advective/diffusive "-AD-"
    [UserVar,RR,KK]=WaterFilmThicknessDiffusionEquationAssembly(UserVar,CtrlVar,MUA,F0,F1,k,eta);
else
    error("case not found")
end



end