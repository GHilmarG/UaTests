function [hApprox,RMSerror]=ContructReferenceSolution(CtrlVar,UserVar,MUA,F)



IhAbove=F.h>500;


xStep=(min(F.x(F.h<500))+max(F.x(F.h>500)))/2;


iAbove=F.x<(xStep-10e3) ;
iBelow=F.x>(xStep+10e3) ;

hAbove=mean(F.h(iAbove));
hBelow=mean(F.h(iBelow));

hApprox=F.h;
hApprox(IhAbove)=hAbove;
hApprox(~IhAbove)=hBelow;


FindOrCreateFigure("hApprox")

plot(F.x/1000,F.h,'ob')
hold on
plot(F.x/1000,hApprox,'-r')


dh=F.h-hApprox; 

if ~isfield(MUA,"M")  || isempty(MUA.M)
    MUA.M=MassMatrix2D1dof(MUA);
end


RMSerror= sqrt((dh'*MUA.M*dh)/MUA.Area) ; % Units 

end