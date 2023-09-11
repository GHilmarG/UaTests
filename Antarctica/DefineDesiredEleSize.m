function [UserVar,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened ]=...
    DefineDesiredEleSize(UserVar,CtrlVar,MUA,x,y,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened,s,b,S,B,rho,rhow,ub,vb,ud,vd,GF,NodalErrorIndicators)


persistent Fvx Fvy


if isempty(Fvx)
    fprintf('DefineDesiredEleSize: loading file: %-s ... ',UserVar.SurfaceMassBalanceInterpolant)
    load(UserVar.SurfaceVelocityInterpolant,'Fvx','Fvy') ;
    fprintf('... done. /n')
end

Meas.us=double(Fvx(x,y));
Meas.vs=double(Fvy(x,y));

speed=sqrt(Meas.us.*Meas.us+Meas.vs.*Meas.vs);



%% Global Mesh Refinement: Need to return EleSizeDesired
EleSizeIndicator=EleSizeDesired;
Ind=speed>10 & GF.node>0.9 ; EleSizeIndicator(Ind)=3*UserVar.MeshSizeFastFlow;
Ind=speed>50 & GF.node>0.9 ; EleSizeIndicator(Ind)=2*UserVar.MeshSizeFastFlow;
Ind=speed>100 & GF.node>0.9 ; EleSizeIndicator(Ind)=UserVar.MeshSizeFastFlow;

EleSizeDesired=min(EleSizeDesired,EleSizeIndicator);



EleSizeIndicator=EleSizeDesired;
EleSizeIndicator(s<3000)=CtrlVar.MeshSizeMax/2;
EleSizeIndicator(s<2000)=CtrlVar.MeshSizeMax/4;
EleSizeIndicator(s<1500)=CtrlVar.MeshSizeMax/8;
EleSizeIndicator(s<1000)=CtrlVar.MeshSizeMax/10;

EleSizeIndicator(GF.node<0.1)=UserVar.MeshSizeIceShelves;

% I combine new user defined ele-sizes with those given on input  
EleSizeDesired=min(EleSizeDesired,EleSizeIndicator);

%I=x>-1.6896e+06 & x< -1200e3 & y> -1200e3 & y<  -250e3 & (GF.node<0.5);
%EleSizeIndicator=EleSizeDesired;
%EleSizeIndicator(I)=CtrlVar.MeshSizeFastFlow;  % Just setting PIG ice shelf to fine resolution
%EleSizeDesired=min(EleSizeDesired,EleSizeIndicator);


%% Local Mesh Refinement: Need to return ElementsToBeRefined and ElementsToBeCoarsened
% Calculate current element sizes
EleArea=TriAreaFE(MUA.coordinates,MUA.connectivity);
M= Ele2Nodes(MUA.connectivity,MUA.Nnodes);
EleSizeCurrent=sqrt(M*EleArea);  % Elesizes around nodes

eRatio=EleSizeDesired./EleSizeCurrent;
eRatio=Nodes2EleMean(MUA.connectivity,eRatio);

% do not refine a greater number of elements than CtrlVar.MeshRefinementRatio*CurrentNumberOfElements
% at any given refinement step

test=sort(eRatio);
Ratio=0.9;

UserElementsToBeRefined=  eRatio<=test(ceil(numel(eRatio)*CtrlVar.LocalAdaptMeshRatio)) & eRatio<Ratio;
UserElementsToBeCoarsened=(eRatio>=test(floor(numel(eRatio)*CtrlVar.LocalAdaptMeshRatio)) & eRatio>(2.1*Ratio));

ElementsToBeRefined= UserElementsToBeRefined ;
ElementsToBeCoarsened=UserElementsToBeCoarsened; 

%ElementsToBeCoarsened=ElementsToBeCoarsened & ~ElementsToBeRefined ;




end