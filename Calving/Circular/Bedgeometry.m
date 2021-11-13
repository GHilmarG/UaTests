
function [B,UserVar,CtrlVar,MUA,F]=Bedgeometry(UserVar,CtrlVar,MUA,F,DoPlots)


if nargin<5
    DoPlots=false;
end

if nargin == 0

    %%
    R=1000e3 ;
    theta=linspace(0,2*pi,100);
    x=R*cos(theta); y=R*sin(theta) ; x(end)=[] ; y(end )=[];


    UserVar=[];
    CtrlVar=Ua2D_DefaultParameters(); %
    CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
    % Note; When creating this mesh using Úa, only the following
    % three lines are required in the Ua2D_InitialUserInput.m
    CtrlVar.MeshSizeMax=50e3;
    CtrlVar.MeshSizeMin=50e3;
    CtrlVar.MeshSize=10e3 ;

    MeshBoundaryCoordinates=[x(:) y(:)];

    CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
    % Now generate mesh (When using Úa this is done internally, no such call
    % then needed).


    [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
    figure ; PlotMuaMesh(CtrlVar,MUA); drawnow


    F.x= MUA.coordinates(:,1); F.y= MUA.coordinates(:,2);



end



%
% R=800e3 ;
% r=sqrt(F.x.*F.x+F.y.*F.y) ;
% theta=atan2(F.y,F.x);
% Bc=1000; Bl=-3000;
% rc=0;
% l=R -  cos(2*theta).*R/2 ;
% a=Bc - (Bc-Bl)*(r-rc).^2./(R-rc).^2;
% B=1000*cos(3*pi*r./l)+a ;
B=Bfunc(F.x,F.y) ;

if DoPlots


    FindOrCreateFigure("B3") ; PlotMeshScalarVariable(CtrlVar,MUA,B);

    x=linspace(0,1000e3,100) ; y=x*0;
    Bxprofile=Bfunc(x,y);

    FindOrCreateFigure("B: x-profile") ;
    plot(x/1000,Bxprofile) ;
    xlabel("x (km)") ; ylabel("B (m)")

    y=linspace(0,1000e3,100) ; x=y*0;
    Bxprofile=Bfunc(x,y);

    FindOrCreateFigure("B: y-profile") ;
    plot(y/1000,Bxprofile) ;
    xlabel("y (km)") ; ylabel("B (m)")


end


    function B=Bfunc(x,y)



%%   new parameter set 
        R=800e3 ;  
        Bc=900; 
        Bl=-2000;
        Ba=1100;
%%

        r=sqrt(x.*x+y.*y) ;
        theta=atan2(y,x);
        
        
        rc=0;
        l=R -  cos(2*theta).*R/2 ;            % theta-dependent wavelength 
        a=Bc - (Bc-Bl)*(r-rc).^2./(R-rc).^2;  % quadratic term in r
        B=Ba*cos(3*pi*r./l)+a ;               %


    end


return

end

%
% FindOrCreateFigure("Cmesh") ; PlotMeshScalarVariable(CtrlVar,MUA,B) ;
% FindOrCreateFigure("Cmesh surface") ; PlotMeshScalarVariableAsSurface(CtrlVar,MUA,B) ;
%
%
%
% %%
%
%
%
%
%
%
% xd=640e3; xu=0e3 ; yr=0 ; yl=80e3 ;
%
%
% UserVar=[];
% CtrlVar=Ua2D_DefaultParameters(); %
%  CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
% % Note; When creating this mesh using Úa, only the following
% % three lines are required in the Ua2D_InitialUserInput.m
% CtrlVar.MeshSizeMax=10e3;
% CtrlVar.MeshSizeMin=10e3;
% CtrlVar.MeshSize=10e3 ;
%
% MeshBoundaryCoordinates=[xu yr ;  xu yl  ; xd yl ; xd yr ];
%
% CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
% % Now generate mesh (When using Úa this is done internally, no such call
% % then needed).
%
%
% [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
% figure ; PlotMuaMesh(CtrlVar,MUA); drawnow
%
%
%
% F.x= MUA.coordinates(:,1); F.y= MUA.coordinates(:,2);
%
% B=MismBed(F.x,F.y);
%
%
% FindOrCreateFigure("MismBed") ; PlotMeshScalarVariable(CtrlVar,MUA,B) ;
%
%
%
%
% %%
%
% xc=0 ; R=1000e3 ;
% x=linspace(xc,R,100);
% Bc=2000; Bl=-4000;
% l=R ;
% a=Bc - (Bc-Bl)*(x-xc).^2./(l-xc).^2;
% B=a.*cos(2*pi*x/l);
% figure
%
% plot(x/1000,B)
%
% %%
%
%
% R=1000e3 ;
% theta=linspace(0,2*pi,100);
% x=R*cos(theta); y=R*sin(theta) ; x(end)=[] ; y(end )=[];
%
%
% UserVar=[];
% CtrlVar=Ua2D_DefaultParameters(); %
%  CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
% % Note; When creating this mesh using Úa, only the following
% % three lines are required in the Ua2D_InitialUserInput.m
% CtrlVar.MeshSizeMax=50e3;
% CtrlVar.MeshSizeMin=50e3;
% CtrlVar.MeshSize=10e3 ;
%
% MeshBoundaryCoordinates=[x(:) y(:)];
%
% CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
% % Now generate mesh (When using Úa this is done internally, no such call
% % then needed).
%
%
% [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
% figure ; PlotMuaMesh(CtrlVar,MUA); drawnow
%
%
% F.x= MUA.coordinates(:,1); F.y= MUA.coordinates(:,2);
%
%
% r=sqrt(F.x.*F.x+F.y.*F.y) ;
% theta=atan2(F.y,F.x);
% Bc=1000; Bl=-2000;
% rc=0;
% l=R -  cos(2*theta).*R/2 ;
% a=Bc - (Bc-Bl)*(r-rc).^2./(R-rc).^2;
% B=1000*cos(3*pi*r./l)+a ;
%
%
% FindOrCreateFigure("Cmesh") ; PlotMeshScalarVariable(CtrlVar,MUA,B) ;
% FindOrCreateFigure("Cmesh surface") ; PlotMeshScalarVariableAsSurface(CtrlVar,MUA,B) ;
%
%
%
