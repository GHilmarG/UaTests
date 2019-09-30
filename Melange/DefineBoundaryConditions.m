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
% Example:
%%


x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
xd=max(x(:)) ; xu=min(x(:)); yl=max(y(:)) ; yr=min(y(:));



nodesd=MUA.Boundary.Nodes(abs(x(MUA.Boundary.Nodes)-xd)<1e-5);
nodesu=MUA.Boundary.Nodes(abs(x(MUA.Boundary.Nodes)-xu)<1e-5);
nodesl=MUA.Boundary.Nodes(abs(y(MUA.Boundary.Nodes)-yl)<1e-5);
nodesr=MUA.Boundary.Nodes(abs(y(MUA.Boundary.Nodes)-yr)<1e-5);

switch lower(UserVar.BCs)
    
    case 'periodic'

        
        BCs.ubTiedNodeA=[nodesu;nodesl]; BCs.ubTiedNodeB=[nodesd;nodesr];
        BCs.vbTiedNodeA=[nodesu;nodesl]; BCs.vbTiedNodeB=[nodesd;nodesr];
        
        
    case 'free'
        
        
    case '1hd'
        
        BCs.ubTiedNodeA=[nodesu]; BCs.ubTiedNodeB=[nodesd];
        BCs.hTiedNodeA=[nodesu]; BCs.hTiedNodeB=[nodesd];
        
        BCs.vbFixedNode=[nodesl;nodesr] ;  BCs.vbFixedValue=BCs.vbFixedNode*0;
        
        
end


end