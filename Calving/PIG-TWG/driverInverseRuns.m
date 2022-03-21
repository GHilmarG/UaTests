%%
Klear
more off
job=cell(100,1);

CtrlVar.Inverse.Iterations=2;


CtrlVar.Inverse.Regularize.logC.ga=1;
CtrlVar.Inverse.Regularize.logC.gs=1000 ;
CtrlVar.Inverse.Regularize.logAGlen.ga=1;
CtrlVar.Inverse.Regularize.logAGlen.gs=1000;


UserVar.RunType='Inverse-MatOpt';
% UserVar.RunType='Inverse-UaOpt';

%UserVar=Ua(UserVar,CtrlVar) ;

UserVar.MeshResolution=10e3;   % MESH RESOLUTION
c=1; 
% C
J=1;
for I=-1:5   % anything above 7 does not appear to converge I think
    I

    CtrlVar.Inverse.Regularize.logC.gs=c*10^I;
    job{J}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ; J=J+1;
    %Ua(UserVar,CtrlVar) ;
    pause(30)
    
    CtrlVar.Inverse.Regularize.logC.gs=5*c*10^I;
    job{J}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ; J=J+1;
    pause(30)

end

CtrlVar.Inverse.Regularize.logC.ga=10;
CtrlVar.Inverse.Regularize.logC.gs=1000 ;
CtrlVar.Inverse.Regularize.logAGlen.ga=10;
CtrlVar.Inverse.Regularize.logAGlen.gs=1000;

% A
for I=-1:5 % all done above 10^7
    I+10

    CtrlVar.Inverse.Regularize.logAGlen.gs=c*10^I ;
    %Ua(UserVar,CtrlVar) ;
    job{J}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ; J=J+1;
    pause(30)
    CtrlVar.Inverse.Regularize.logAGlen.gs=5*c*10^I ;
    %Ua(UserVar,CtrlVar) ;
    job{J}=batch("Ua",0,{UserVar,CtrlVar},"Pool",1) ; J=J+1; 
    pause(30)

end



