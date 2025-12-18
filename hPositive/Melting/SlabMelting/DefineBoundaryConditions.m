

function [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)




% find nodes along boundary for which Dirichlet boundary conditions apply


xd=max(F.x(:)) ; xu=min(F.x(:)); yl=max(F.y(:)) ; yr=min(F.y(:));

nodesd=find(abs(F.x-xd)<1e-5); [~,ind]=sort(MUA.coordinates(nodesd,2)); nodesd=nodesd(ind);
nodesu=find(abs(F.x-xu)<1e-5); [~,ind]=sort(MUA.coordinates(nodesu,2)); nodesu=nodesu(ind);
nodesl=find(abs(F.y-yl)<1e-5); [~,ind]=sort(MUA.coordinates(nodesl,1)); nodesl=nodesl(ind);
nodesr=find(abs(F.y-yr)<1e-5); [~,ind]=sort(MUA.coordinates(nodesr,1)); nodesr=nodesr(ind);


%nodesya=find(abs(x-xd)<1e-5 & abs(y)<1.e-5);
%nodesyb=find(abs(x-xu)<1e-5 & abs(y)<1.e-5);

%% periodic BCs
ubFixedNode=[nodesu;nodesd;nodesl;nodesr] ;  ubFixedValue=ubFixedNode*0;
vbFixedNode=[nodesu;nodesd;nodesl;nodesr] ;  vbFixedValue=vbFixedNode*0;

ubTiedNodeA=[] ;ubTiedNodeB=[];
vbTiedNodeA=[] ;vbTiedNodeB=[];

%vbFixedNode=[nodesya;nodesyb];   vfixedvalue=[0;0];
%vtiedA=[setdiff(nodesu,nodesya);nodesl]; vtiedB=[setdiff(nodesd,nodesyb);nodesr];


%hFixedNode=[nodesu;nodesd;nodesl;nodesr;nodesya];  hfixedvalue=hFixedNode*0+2;
hFixedNode=[];  hFixedValue=[];
hTiedNodeA=[]; hTiedNodeB=[];

%% Thickness constraints

if contains(UserVar.RunType,"ThicknessConstrained")

    r=sqrt(F.x.*F.x+F.y.*F.y) ;
    Ind=find(r<50e3);
    hFixedNode=Ind;  hFixedValue=F.h(Ind);

end

%%

if ~isempty(vbFixedNode)
    [vbFixedNode,ind]=unique(vbFixedNode);  vbFixedValue=vbFixedValue(ind);
end

if ~isempty(ubFixedNode)
    [ubFixedNode,ind]=unique(ubFixedNode);  ubFixedValue=ubFixedValue(ind);
end

if ~isempty(hFixedNode)
    [hFixedNode,ind]=unique(hFixedNode);  hFixedValue=hFixedValue(ind);
end

BCs.ubFixedNode=[] ; % ubFixedNode;
BCs.ubFixedValue=[] ; % ubFixedValue;
BCs.vbFixedNode=[] ; %vbFixedNode;
BCs.vbFixedValue=[]; %vbFixedValue;
BCs.ubTiedNodeA=ubTiedNodeA;
BCs.ubTiedNodeB=ubTiedNodeB;
BCs.vbTiedNodeA=vbTiedNodeA;
BCs.vbTiedNodeB=vbTiedNodeB;
BCs.hFixedNode=hFixedNode;
BCs.hFixedValue=hFixedValue;
BCs.hTiedNodeA=hTiedNodeA;
BCs.hTiedNodeB=hTiedNodeB;

BCs.ubvbFixedNormalNode=ubFixedNode; BCs.ubvbFixedNormalValue=ubFixedValue;
BCs.udvdFixedNormalNode=ubFixedNode; BCs.udvdFixedNormalValue=ubFixedValue;


end
