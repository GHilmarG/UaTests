
    function [UserVar,BCs]=DefineBoundaryConditions(UserVar,CtrlVar,MUA,F,BCs)

%%

switch UserVar.RunType

    case 'inverse_run'

        BCs.vbFixedNode=[]; 
        BCs.ubFixedNode=[]; 
        BCs.ubFixedValue=[];
        BCs.vbFixedValue=[];
    
    case {'spin-up','forward_run'}

        BCs.vbFixedNode=[]; 
        BCs.ubFixedNode=[]; 
        BCs.ubFixedValue=[];
        BCs.vbFixedValue=[];

    otherwise
        x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

        % find nodes along boundary 
        xd=max(x(:)) ; xu=min(x(:)); yl=max(y(:)) ; yr=min(y(:));
        nodesd=find(abs(x-xd)<1e-5); [~,ind]=sort(MUA.coordinates(nodesd,2)); nodesd=nodesd(ind);
        nodesu=find(abs(x-xu)<1e-5); [~,ind]=sort(MUA.coordinates(nodesu,2)); nodesu=nodesu(ind);
        nodesl=find(abs(y-yl)<1e-5); [~,ind]=sort(MUA.coordinates(nodesl,1)); nodesl=nodesl(ind);
        nodesr=find(abs(y-yr)<1e-5); [~,ind]=sort(MUA.coordinates(nodesr,1)); nodesr=nodesr(ind);


        BCs.ubFixedNode=[nodesd;nodesu;nodesl;nodesr];
        BCs.ubFixedValue=BCs.ubFixedNode*0;
        BCs.vbFixedNode=[nodesd;nodesu;nodesl;nodesr]; 
        BCs.vbFixedValue=BCs.vbFixedNode*0;
end

end