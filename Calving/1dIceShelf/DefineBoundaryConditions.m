function  BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)
%%
% BCs=DefineBoundaryConditions(UserVar,CtrlVar,MUA,BCs,time,s,b,h,S,B,ub,vb,ud,vd,GF)
%
% BC is a matlab object with the following fields 
%
% BCs = 
% 
%   BoundaryConditions with properties:
% 
%              ubFixedNode: []
%             ubFixedValue: []
%              vbFixedNode: []
%             vbFixedValue: []
%              ubTiedNodeA: []
%              ubTiedNodeB: []
%              vbTiedNodeA: []
%              vbTiedNodeB: []
%      ubvbFixedNormalNode: []
%     ubvbFixedNormalValue: []
%              udFixedNode: []
%             udFixedValue: []
%              vdFixedNode: []
%             vdFixedValue: []
%              udTiedNodeA: []
%              udTiedNodeB: []
%              vdTiedNodeA: []
%              vdTiedNodeB: []
%      udvdFixedNormalNode: []
%     udvdFixedNormalValue: []
%               hFixedNode: []
%              hFixedValue: []
%               hTiedNodeA: []
%               hTiedNodeB: []
%                 hPosNode: []
%                hPosValue: []
%       
%
% see also BoundaryConditions.m
%
%
%%

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);


xd=max(x(:)) ; xu=min(x(:)); yl=max(y(:)) ; yr=min(y(:));
nodesd=find(abs(x-xd)<1e-5); [~,ind]=sort(MUA.coordinates(nodesd,2)); nodesd=nodesd(ind);
nodesu=find(abs(x-xu)<1e-5); [~,ind]=sort(MUA.coordinates(nodesu,2)); nodesu=nodesu(ind);
nodesl=find(abs(y-yl)<1e-5); [~,ind]=sort(MUA.coordinates(nodesl,1)); nodesl=nodesl(ind);
nodesr=find(abs(y-yr)<1e-5); [~,ind]=sort(MUA.coordinates(nodesr,1)); nodesr=nodesr(ind);

BCs.ubFixedNode=nodesu ;
BCs.ubFixedValue=BCs.ubFixedNode*0;
BCs.vbFixedNode=[nodesu;nodesl;nodesr] ;
BCs.vbFixedValue=BCs.vbFixedNode*0;

if contains(UserVar.RunType,"-1dAnalyticalIceShelf-") || contains(UserVar.RunType,"-1dIceShelf-")
    BCs.ubFixedValue=BCs.ubFixedNode*0+300;
    BCs.hFixedNode=nodesu ;
    BCs.hFixedValue=BCs.hFixedNode*0+1000;
end

% if CtrlVar.LevelSetMethod
%      xc=UserVar.xc;
%      BCs.LSFFixedNode=[nodesu;nodesd] ;
%      BCs.LSFFixedValue=xc-x(BCs.LSFFixedNode);
%  end
% 
% 
end