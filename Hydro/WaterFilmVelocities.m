


function [uw,vw]=WaterFilmVelocities(CtrlVar,UserVar,MUA,F,k)


persistent Fuw Fvw



if UserVar.Example=="-Antarctica-" &&  UserVar.VelocityFieldPrescribed

    if isempty(Fuw)

        %% Antarctica
        InverseRestartFile="../Antarctica/Antarctica-Inverse-AntarcticaMUAwith54kElements-logC-logA-MatlabOptimization-HessianBased-MAdjointRHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-0-InverseRestartFile.mat";
        %PIG-TWG
        % InverseRestartFile="C:\Users\Hilmar\OneDrive - Northumbria University - Production Azure AD\Sandbox\InverseRestartFiles\InverseRestartFile-Cornford-Ca1-Cs100000-Aa1-As100000-5km-Alim-.mat";

        Finput=F;
        load(InverseRestartFile,"F");

        Fuw=scatteredInterpolant(F.x,F.y,F.ub);
        Fvw=scatteredInterpolant(F.x,F.y,F.vb);

        F=Finput ;

    end

    uw=Fuw(F.x,F.y) ;
    vw=Fvw(F.x,F.y) ;

    F.ub=uw ; F.vb=vw ;

    UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle="-(uw,vw)-")





else


    Phi=PhiPotential(CtrlVar,MUA,F);
    [dPhidx,dPhidy]=gradUa(CtrlVar,MUA,Phi) ;
    uw=-k.*dPhidx;
    vw=-k.*dPhidy;
    I=F.GF.node<0.1;
    uw(I)=10*uw(I);
    vw(I)=10*vw(I);


end



end