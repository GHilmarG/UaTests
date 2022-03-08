%%


CtrlVar.Inverse.Iterations=500;


CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1000 ;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1000;


UserVar.RunType='Inverse-MatOpt';

%UserVar=Ua(UserVar,CtrlVar) ;

UserVar.MeshResolution=10e3;   % MESH RESOLUTION
c=1; 
% C
for I=1:7   % anything above 8 does not appear to converge I think
    I

    CtrlVar.Inverse.Regularize.logC.gs=c*10^I;
    job{I}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ;
    %Ua(UserVar,CtrlVar) ;
    pause(30)
    
    CtrlVar.Inverse.Regularize.logC.gs=5*c*10^I;
    job{I}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ;
    pause(30)

end

CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1000 ;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1000;

% A
for I=1:10
    I+10

    CtrlVar.Inverse.Regularize.logAGlen.gs=c*10^I ;
    %Ua(UserVar,CtrlVar) ;
    job{I+10}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ;
    pause(30)
    CtrlVar.Inverse.Regularize.logAGlen.gs=5*c*10^I ;
    %Ua(UserVar,CtrlVar) ;
    job{I+10}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ;
    pause(30)

end



