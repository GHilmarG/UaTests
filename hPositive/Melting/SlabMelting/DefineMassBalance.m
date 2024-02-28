


function [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)

ab=zeros(MUA.Nnodes,1);
dasdh=zeros(MUA.Nnodes,1);
dabdh=zeros(MUA.Nnodes,1);




if contains(UserVar.RunType,"GaussMelting")

    if F.time<150
        ampl=-1;
        sigma_x=25000 ; sigma_y=25000;
        as=ampl.*exp(-((F.x/sigma_x).^2+(F.y/sigma_y).^2));
    else
        as=zeros(MUA.Nnodes,1);
    end

elseif contains(UserVar.RunType,"ThicknessConstrained")

    as=-1; 

else

    error(' which case')

end

end
