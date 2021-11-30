%%
% 

clearvars
close all
    

TestCase=3;

CtrlVar.PlotXYscale=1;  RunInfo=UaRunInfo;

switch TestCase

    case 1

        coo=[0 -1000 ; 1000 -1000 ; 0 1000 ; 1000 1000 ; -1000 1000 ; -1000 -1000 ; -2000 -1000 ] ;
        con=[1 2 3 ; 2 4 3 ; 1 3 5 ; 1 5 6 ; 6 5 7];

        P1=[-2000 500 ; -1e3 500 ; 1e3 500] ;


    case 2

        

        UserVar=[];
        CtrlVar=Ua2D_DefaultParameters(); %
        CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=1;
        % Note; When creating this mesh using Úa, only the following
        % three lines are required in the Ua2D_InitialUserInput.m
        CtrlVar.MeshSizeMax=100;
        CtrlVar.MeshSizeMin=100;
        CtrlVar.MeshSize=100;


        MeshBoundaryCoordinates=1000*[-1 -1 ; -1 0 ; 0 1 ; 1 0 ; 1 -1 ; 0 0];
        CtrlVar.PlotXYscale=1;
        CtrlVar.MeshBoundaryCoordinates=MeshBoundaryCoordinates;
        % Now generate mesh (When using Úa this is done internally, no such call
        % then needed).


        [UserVar,MUA]=genmesh2d(UserVar,CtrlVar);
        % figure ; PlotMuaMesh(CtrlVar,MUA); drawnow




        coo=MUA.coordinates ;
        con=MUA.connectivity ;
        % con=MUA.connectivity(1:50,:) ;


        P1=[-1000 -500 ; -1e3 500 ; 1e3 500] ;


    case 3

        load TestingInterfaceCalculation.mat

        coo=MUA.coordinates ;
        con=MUA.connectivity;

        P1=1000*[-500 -500 ; -500 500 ; 500 500  ; 500 -500 ; -500 -500] ;

        LSF=zeros(MUA.Nnodes,1)-1 ; 
        x=MUA.coordinates(:,1); y=MUA.coordinates(:,2); 
        inside=x>-500e3 & x<500e3 & y>-500e3 & y< 500e3 ;
        LSF(inside)=1;
end





% polyline 1




FindOrCreateFigure("Mesh")
CtrlVar.PlotLabels=0; CtrlVar.PlotNodes=0;CtrlVar.PlotXYscale=1;

PlotFEmesh(coo,con,CtrlVar);
hold on




Nele=size(con,1);
Nnodes=size(coo,1) ;

EleEdges=[con con(:,1)]; 

P2=NaN(5*Nele,2); 
ii=1;
for I=1:Nele

    P2(ii:ii+3,:)=coo(EleEdges(I,:),:); 
    P2(ii+4,:)=[NaN NaN ]; 
    ii=ii+5 ; 

end
P2(end,:)=[] ; 

hold on
plot(P1(:,1),P1(:,2),'-bo')
hold on
% plot(P2(:,1),P2(:,2),'-go')




LineSegments=NaN(5*Nele,2);
ii=1;
for I=1:Nele
    
    LineSegments(ii,:)   =[EleEdges(I,1) EleEdges(I,2)] ;
    LineSegments(ii+1,:) =[EleEdges(I,2) EleEdges(I,3)] ;
    LineSegments(ii+2,:) =[EleEdges(I,3) EleEdges(I,1)] ;
    LineSegments(ii+3,:) =[NaN  NaN];
    LineSegments(ii+4,:) =[NaN  NaN];
    ii=ii+5; 
end
LineSegments(end-1:end,:)=[] ;










[xc,yc,ii]=polyxpoly(P1(:,1),P1(:,2),P2(:,1),P2(:,2)); 
 Nconstraints=size(xc,1);

plot(xc,yc,'*r')

NodPairs=[LineSegments(ii(:,2),1)  LineSegments(ii(:,2),2)];

P.Anod=NodPairs(:,1) ; P.Bnod=NodPairs(:,2) ; P.Acoo=coo(NodPairs(:,1),:) ; P.Bcoo=coo(NodPairs(:,2),:) ; P.coo=[xc(:) yc(:)] ;
P.APdist=sqrt((P.Acoo(:,1)-P.coo(:,1)).^2+(P.Acoo(:,2)-P.coo(:,2)).^2) ; 
P.BPdist=sqrt((P.Bcoo(:,1)-P.coo(:,1)).^2+(P.Bcoo(:,2)-P.coo(:,2)).^2) ; 
P.ABdist=sqrt((P.Acoo(:,1)-P.Bcoo(:,1)).^2+(P.Acoo(:,2)-P.Bcoo(:,2)).^2) ;
P.nAPdist=P.APdist./P.ABdist;
P.nBPdist=P.BPdist./P.ABdist;



L=zeros(Nconstraints,Nnodes) ;
for i=1:Nconstraints
   L(i,P.Anod(i)) = P.nBPdist(i) ;
   L(i,P.Bnod(i)) = P.nAPdist(i) ;
end



[L,ia,ic]=unique(L,'rows');


if TestCase==1  % this has a know solution, so this must be equal to zeros row

  L*[3 ;3 ; -1 ; -1 ; -1 ; 3 ; 3]

end


FindOrCreateFigure("LSF");
tiledlayout(1,2)
nexttile
PlotMeshScalarVariable(CtrlVar,MUA,LSF);
hold on
plot(P1(:,1),P1(:,2),'-bo')
plot(xc,yc,'+r',LineWidth=1)
[xC,yC]=PlotCalvingFronts(CtrlVar,MUA,LSF,color="w");

[LSF,UserVar,RunInfo]=SignedDistUpdate(UserVar,RunInfo,CtrlVar,MUA,LSF,xc,yc);

nexttile
PlotMeshScalarVariable(CtrlVar,MUA,LSF);
hold on
plot(P1(:,1),P1(:,2),'-bo')
plot(xc,yc,'+r',LineWidth=1)
[xC,yC]=PlotCalvingFronts(CtrlVar,MUA,LSF,color="w");


title("after signed distance calculation")




if TestCase==3

    SubTestCase="-BCsOnNodalLinks-";
    SubTestCase="-BCsOnNodalValues-";

    switch SubTestCase

        case  "-BCsOnNodalValues-"

           CtrlVar.LevelSetInitBCsZeroLevel=true ; 
           CtrlVar.LevelSetReinitializePDist=true;
           CtrlVar.LevelSetFixPointSolverApproach="IFP" ; % ~~IFP = Initial fix point
            F0=UaFields ; F1=F0;
            F0.LSF=LSF ; F1.LSF=LSF ;  l=[];

            F0.c=zeros(MUA.Nnodes,1) ; F1.c=zeros(MUA.Nnodes,1) ;
            F0.ub=zeros(MUA.Nnodes,1) ; F1.ub=zeros(MUA.Nnodes,1) ;
            F0.vb=zeros(MUA.Nnodes,1) ; F1.vb=zeros(MUA.Nnodes,1) ;
            CtrlVar.InfoLevelLinSolve=0; CtrlVar.LinSolveTol=1e-6;
            CtrlVar.LevelSetInfoLevel=1;


            % Now try:
            % 1) as before using (xc,yc) as calculated above, and with modified BCs to fix the level set over all elements that the LSF
            % goes through>



            CtrlVar.LevelSetFABmu.Scale="constant" ;  % can't let the scale depend on velocity if I'm initializing and I want this to give me the distance
            CtrlVar.LevelSetFABmu.Value=1e7;

            [UserVar,RunInfo,LSF,Mask,l,LSFqx,LSFqy]=LevelSetEquationInitialisation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,l) ;

        otherwise

            error("not there yet")
    end


FindOrCreateFigure("LSF2");

PlotMeshScalarVariable(CtrlVar,MUA,LSF);
hold on
plot(P1(:,1),P1(:,2),'-bo')
plot(xc,yc,'+r',LineWidth=1)
[xC,yC]=PlotCalvingFronts(CtrlVar,MUA,LSF,color="w");
title("after LSF solve")




end
