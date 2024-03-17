%%
% 

clearvars
close all
    

TestCase=3;

CtrlVar.PlotXYscale=1;  
RunInfo=UaRunInfo;

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
        figure ; PlotMuaMesh(CtrlVar,MUA); drawnow




        coo=MUA.coordinates ;
        con=MUA.connectivity ;
        % con=MUA.connectivity(1:50,:) ;


        P1=[-1000 -500 ; -1e3 500 ; 1e3 500] ;


    case 3

        load TestingInterfaceCalculation.mat
    
         EleSubdivide=1;

         for II=1:EleSubdivide
             [MUA.coordinates,MUA.connectivity]=FE2dRefineMesh(MUA.coordinates,MUA.connectivity);
             MUA=CreateMUA(CtrlVar,MUA.connectivity,MUA.coordinates);
         end


      %   Convergence=[ 0      1552      15555 ; 
      %                 1      1187      4389  ;
      %                 2       9.4      2064  ;
      %                 3       9.4      1552  ;
      %                 4       9.4      442   ; 
      % figure ; plot([1 1/2 1/4 1/8],[15555 4389 2064 1553])


        CtrlVar.PlotXYscale=1000;  
        coo=MUA.coordinates ;
        con=MUA.connectivity;

        P1=1000*[-500 -500 ; -500 500 ; 500 500  ; 500 -500 ; -500 -500] ;


        P1=1000*[-500 -500 ; -500 500 ; 500 500  ; 500 -500 ;  ...
            200 -500 ;  200 -100 ; -200 -100 ; -200 -500 ;   ...
            -500 -500] ;


        LSF=zeros(MUA.Nnodes,1)-1 ; 
        x=MUA.coordinates(:,1); y=MUA.coordinates(:,2); 

        [inside,on] = inpoly2([x y],P1);



        
        LSF(inside)=1;




end





% polyline 1




FindOrCreateFigure("Mesh")
CtrlVar.PlotLabels=0; CtrlVar.PlotNodes=0;

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
plot(P1(:,1)/CtrlVar.PlotXYscale,P1(:,2)/CtrlVar.PlotXYscale,'-bo')
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









% Here I calculate the (xc,yc) intersections, this helps with the distance calculation
% 
[xc,yc,ii]=polyxpoly(P1(:,1),P1(:,2),P2(:,1),P2(:,2)); 
 



Nconstraints=size(xc,1);

plot(xc/CtrlVar.PlotXYscale,yc/CtrlVar.PlotXYscale,'*r')

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
LSFRhs=zeros(size(L,1),1);

if TestCase==1  % this has a know solution, so this must be equal to zeros row

  L*[3 ;3 ; -1 ; -1 ; -1 ; 3 ; 3]

end

% How close is (xC,yC) to P1?
Dist=pdist2([xc(:) yc(:)],P1,'euclidean','Smallest',1) ;
Dist=Dist(:) ;
[min(Dist) max(Dist)]





CtrlVar.PlotNodes=0;


FindOrCreateFigure("LSF");
tiledlayout(2,2)
nexttile
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,LSF/CtrlVar.PlotXYscale);
hold on
plot(P1(:,1)/CtrlVar.PlotXYscale,P1(:,2)/CtrlVar.PlotXYscale,'-bo')
plot(xc/CtrlVar.PlotXYscale,yc/CtrlVar.PlotXYscale,'+r',LineWidth=1)
[xC,yC]=PlotCalvingFronts(CtrlVar,MUA,LSF,color="k",LineStyle="--");
title("LSF before distance solve",Interpreter="latex")
xlabel("$x$ (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex") ; title(cbar,"(km)",Interpreter="latex")


% but why not add in the corner nodes? Appears unlikely to change much, and in fact might cause deviaton
% xc=[xc;P1(:,1)] ;  yc=[yc;P1(:,2)] ; 
[LSF,UserVar,RunInfo]=SignedDistUpdate(UserVar,RunInfo,CtrlVar,MUA,LSF,xc,yc);

nexttile
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,LSF/CtrlVar.PlotXYscale);
hold on
PlotMuaMesh(CtrlVar,MUA,[],'w') ;
plot(P1(:,1)/CtrlVar.PlotXYscale,P1(:,2)/CtrlVar.PlotXYscale,'-bo')
plot(xc/CtrlVar.PlotXYscale,yc/CtrlVar.PlotXYscale,'+r',LineWidth=1)
[xC,yC]=PlotCalvingFronts(CtrlVar,MUA,LSF,color="k",LineStyle="--");
title("after signed distance calculation",Interpreter="latex")
xlabel("$x$ (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex") ; title(cbar,"(km)",Interpreter="latex")





if TestCase==3

    F0=UaFields ; F1=F0;
    F0.LSF=LSF ; F1.LSF=LSF ;  l=[];

    F0.c=zeros(MUA.Nnodes,1) ; F1.c=zeros(MUA.Nnodes,1) ;
    F0.ub=zeros(MUA.Nnodes,1) ; F1.ub=zeros(MUA.Nnodes,1) ;
    F0.vb=zeros(MUA.Nnodes,1) ; F1.vb=zeros(MUA.Nnodes,1) ;
    CtrlVar.InfoLevelLinSolve=0; CtrlVar.LinSolveTol=1e-6;
    CtrlVar.LevelSetInfoLevel=1;



    SubTestCase="-BCsOnNodalLinks-";
    SubTestCase="-BCsOnNodalValues-";

    switch SubTestCase

        case  "-BCsOnNodalValues-"

            CtrlVar.LevelSetInitBCsZeroLevel=true ;
            CtrlVar.LevelSetReinitializePDist=true;
            CtrlVar.LevelSetFixPointSolverApproach="-IFP-FFP-" ; % ~~IFP = Initial fix point


%             %make feasable
%             phi=LSF ;
%             LSF=L\LSFRhs;  % this now feasable,
%             [row,col,val]=find(L) ;
%             phi(col)=LSF(col);  % only use the range
%             LSF=phi ; F0.LSF=LSF ; F1.LSF=LSF;  % make feasable
% 

            % Now try:
            % 1) as before using (xc,yc) as calculated above, and with modified BCs to fix the level set over all elements that the LSF
            % goes through>



            CtrlVar.LevelSetFABmu.Scale="constant" ;  % can't let the scale depend on velocity if I'm initializing and I want this to give me the distance
            CtrlVar.LevelSetFABmu.Value=1e7;
            LSFold=LSF;
            [UserVar,RunInfo,LSF,Mask,l,LSFqx,LSFqy]=LevelSetEquationInitialisation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,l) ;


        case "-BCsOnNodalLinks-"



            % Notes: If I solve the fix-point problem where P=1 and T=L=0
            %        the Hessian is rank deficit (by one)
            %        This will not be solved by adding in the [K L' ; L 0] sysem
            %        So unless an additional Dirichlet BCs is added, no solution is possible.
            %
            %        But P=1, T=1 and L=0 is full rank, so pseudo-stepping is possible

            % not finalized
            % The BCs on nodal values appears incorrect at corners
            % R=(MUA.M\L'*L*LSF )*MUA.Area;
            % figure ; PlotMeshScalarVariable(CtrlVar,MUA,R) ;


            CtrlVar.LevelSetInitBCsZeroLevel=false ;
            CtrlVar.LevelSetReinitializePDist=false;

            %  Add direct BCs


          

            BCs.LSFFixedNode=MUA.Boundary.Nodes; 
            BCs.LSFFixedValue=LSF(MUA.Boundary.Nodes);
            MLC=BCs2MLC(CtrlVar,MUA,BCs);

            % combined 
            L=[L ; MLC.LSFL];
            LSFRhs=[LSFRhs; MLC.LSFRhs] ; 
            LScale=1e6;
            L=LScale*L ; LSFRhs=LScale*LSFRhs ; 
            

            %make feasable
            phi=LSF ;
            LSF=L\LSFRhs;  % this now feasable,
            [row,col,val]=find(L) ;
            phi(col)=LSF(col);  % only use the range
            LSF=phi ; F0.LSF=LSF ; F1.LSF=LSF;  % make feasable

            % only the direct ones
            % L=MLC.LSFL;
            % LSFRhs=MLC.LSFRhs ; 
            % T=[A B' ; B zeros(size(B,1),size(B,1))];
            % rank(full(T),1e-14)  ; % full rank
            %
            
            
            BCs.LSFL=L ;
            BCs.LSFrhs= LSFRhs ; 



            CtrlVar.LevelSetFixPointSolverApproach="-PTS-" ; %"-IFP-FFP-" ; % ~~IFP = Initial fix point
            CtrlVar.LevelSetFABmu.Scale="constant" ;  % can't let the scale depend on velocity if I'm initializing and I want this to give me the distance
            CtrlVar.LevelSetFABmu.Value=1e7;
            LSFold=LSF;
            [UserVar,RunInfo,LSF,Mask,l,LSFqx,LSFqy]=LevelSetEquationInitialisation(UserVar,RunInfo,CtrlVar,MUA,BCs,F0,F1,l) ;


        otherwise

            error("not there yet")
    end


nexttile
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,LSF/CtrlVar.PlotXYscale);
hold on
plot(P1(:,1)/CtrlVar.PlotXYscale,P1(:,2)/CtrlVar.PlotXYscale,'-bo')
plot(xc/CtrlVar.PlotXYscale,yc/CtrlVar.PlotXYscale,'+r',LineWidth=1)
[xC,yC]=PlotCalvingFronts(CtrlVar,MUA,LSF,color="w");
title("LSF after solve ",Interpreter="latex")
xlabel("$x$ (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex") ; title(cbar,"(km)",Interpreter="latex")


nexttile
[~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,(LSF-LSFold)/CtrlVar.PlotXYscale);
hold on
PlotMuaMesh(CtrlVar,MUA,[],'w') ;
hold on
plot(P1(:,1)/CtrlVar.PlotXYscale,P1(:,2)/CtrlVar.PlotXYscale,'-bo')
plot(xc/CtrlVar.PlotXYscale,yc/CtrlVar.PlotXYscale,'or')
plot(xc/CtrlVar.PlotXYscale,yc/CtrlVar.PlotXYscale,'.r')
[xC,yC]=PlotCalvingFronts(CtrlVar,MUA,LSF,color="w");
[xC,yC]=PlotCalvingFronts(CtrlVar,MUA,LSFold,"k--");
title("LSF after solve - LSF before solve",Interpreter="latex")

xlabel("$x$ (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex") ; title(cbar,"(km)",Interpreter="latex")


%%

% load TestingInterfaceCalculationPlots.mat  % this is case 3
% load TestingInterfaceCalculationPlots2.mat  % this is case 3

colormap(othercolor('BuOr_12',1024));
FigLSF=FindOrCreateFigure("LSF Interface Problem") ; 
hold off
tiledlayout(1,2)

for I=1:2
    nexttile
    [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,LSF/CtrlVar.PlotXYscale);
    hold on

    if I==2
        PlotMuaMesh(CtrlVar,MUA,[],'k') ;
    end
    hold on
    plot(P1(:,1)/CtrlVar.PlotXYscale,P1(:,2)/CtrlVar.PlotXYscale,'-og',LineWidth=2,LineStyle='-')
    %plot(xc/CtrlVar.PlotXYscale,yc/CtrlVar.PlotXYscale,'or')
    plot(xc/CtrlVar.PlotXYscale,yc/CtrlVar.PlotXYscale,'or',MarkerSize=7,MarkerFaceColor="r")
    [xC,yC]=PlotCalvingFronts(CtrlVar,MUA,LSF,color="k",LineWidth=2,LineStyle="--");
    %title("LSF after solve - LSF before solve",Interpreter="latex")

    xlabel("$x$ (km)",Interpreter="latex") ; ylabel("$y$ (km)",Interpreter="latex") ; title(cbar,"$\varphi$ (km)",Interpreter="latex")



    if I==2

        for k=1:numel(P.Anod)

            plot([P.Acoo(k,1)  P.Bcoo(k,1)]/1000,[P.Acoo(k,2)  P.Bcoo(k,2)]/1000,color="r",LineWidth=2)
            hold on
        end
    end

    if I==2
        Dist=120;
        axis([410 410+Dist 410 410+Dist])
    end


    if I==1
        lg=legend('','Prescribed $\varphi_0$ polygon corners','Calculated $\varphi_0$ edge values','$\varphi=0$ level-set curve');
    else
        lg=legend('','','Prescribed $\varphi_0$ polygon corners','Calculated $\varphi_0$ edge values','$\varphi=0$ level-set curve',"crossing edges",...
            Location="southwest");
        %    lg=legend('','','Prescribed $\varphi_0$ polygon corners','Calculated $\varphi_0$ edge values','$\varphi=0$ level-set curve');
    end
    set(lg,'Interpreter','latex');

    caxis([-350 350])
    title("")
    FigLSF.Position=[800 600 1360 666];
end



%%

end
