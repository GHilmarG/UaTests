function  [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)


x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

% find nodes along boundary for which Dirichlet boundary conditions apply


xd=max(x(:)) ; xu=min(x(:)); yl=max(y(:)) ; yr=min(y(:));

nodesd=find(abs(x-xd)<1e-5); [~,ind]=sort(MUA.coordinates(nodesd,2)); nodesd=nodesd(ind);
nodesu=find(abs(x-xu)<1e-5); [~,ind]=sort(MUA.coordinates(nodesu,2)); nodesu=nodesu(ind);
nodesl=find(abs(y-yl)<1e-5); [~,ind]=sort(MUA.coordinates(nodesl,1)); nodesl=nodesl(ind);
nodesr=find(abs(y-yr)<1e-5); [~,ind]=sort(MUA.coordinates(nodesr,1)); nodesr=nodesr(ind);


ubvbFixedNormalNode=MUA.Boundary.Nodes(MUA.coordinates(MUA.Boundary.Nodes,1)>xu & MUA.coordinates(MUA.Boundary.Nodes,1)<xd);
ubvbFixedNormalValue=ubvbFixedNormalNode*0;



% fixing nodes up, left and right
ubTiedNodeA=[]; ubTiedNodeB=[]; vbTiedNodeA=[]; vbTiedNodeB=[];
vbFixedNode=[nodesu];  vbFixedValue=vbFixedNode*0; ubFixedNode=[nodesu];  ubFixedValue=ubFixedNode*0;
hFixedNode=[nodesu];  hFixedValue=hFixedNode*0+1000;
hTiedNodeA=[]; hTiedNodeB=[];

[vbFixedNode,ind]=unique(vbFixedNode);  vbFixedValue=vbFixedValue(ind);
[ubFixedNode,ind]=unique(ubFixedNode);  ubFixedValue=ubFixedValue(ind);

% duplicate basal boundary conditions onto the deformational ones
udFixedNode=ubFixedNode; udFixedValue=ubFixedValue; vdFixedNode=vbFixedNode; vdFixedValue=vbFixedValue;
udvdFixedNormalNode=ubvbFixedNormalNode; udvdFixedNormalValue=ubvbFixedNormalValue;
udTiedNodeA=ubTiedNodeA ; udTiedNodeB=ubTiedNodeB ;  vdTiedNodeA=vbTiedNodeA ; vdTiedNodeB=vbTiedNodeB ; 


%%

BCs.ubFixedNode=ubFixedNode; BCs.ubFixedValue=ubFixedValue; BCs.vbFixedNode=vbFixedNode; BCs.vbFixedValue=vbFixedValue;
BCs.udFixedNode=udFixedNode; BCs.udFixedValue=udFixedValue; BCs.vdFixedNode=vdFixedNode; BCs.vdFixedValue=vdFixedValue;

BCs.ubTiedNodeA=ubTiedNodeA; BCs.ubTiedNodeB=ubTiedNodeB; BCs.vbTiedNodeA=vbTiedNodeA; BCs.vbTiedNodeB=vbTiedNodeB;
BCs.udTiedNodeA=udTiedNodeA; BCs.udTiedNodeB=udTiedNodeB; BCs.vdTiedNodeA=vdTiedNodeA; BCs.vdTiedNodeB=vdTiedNodeB;

BCs.ubvbFixedNormalNode=ubvbFixedNormalNode; BCs.ubvbFixedNormalValue=ubvbFixedNormalValue;
BCs.udvdFixedNormalNode=udvdFixedNormalNode; BCs.udvdFixedNormalValue=udvdFixedNormalValue;

BCs.hFixedNode=hFixedNode; BCs.hFixedValue=hFixedValue;
BCs.hTiedNodeA=hTiedNodeA; BCs.hTiedNodeB=hTiedNodeB;


end