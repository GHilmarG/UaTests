%%


CtrlVar.Inverse.Iterations=2;
CtrlVar.Restart=0;

CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1000 ;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1000;


UserVar.RunType='Inverse-MatOpt';

%UserVar=Ua(UserVar,CtrlVar) ;

UserVar.MeshResolution=10e3;   % MESH RESOLUTION
c=5; 
for I=1:8
    I

    CtrlVar.Inverse.Regularize.logC.gs=c*10^I;
    job{I}=batch("Ua",1,{UserVar,CtrlVar},"Pool",1) ;
    pause(30)

end

CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1000 ;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1000;

for I=1:8
    I+10

    CtrlVar.Inverse.Regularize.logAGlen.gs=c*10^I ;
    %Ua(UserVar,CtrlVar) ;
    job{I+10}=batch("Ua",1,{UserVar,CtrlVar},"Pool",1) ;
    pause(30)

end



