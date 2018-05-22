function[ufixednode,ufixedvalue,vfixednode,vfixedvalue,utiedA,utiedB,vtiedA,vtiedB,hfixednode,hfixedvalue,htiedA,htiedB]=...
     DefineBCs(UserVar,CtrlVar,MUA,time,s,b,h,S,B,ub,vb,ud,vd,GF)
    
    x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
    
    
    
    % find nodes along boundary for which Dirichlet boundary conditions apply
    
    
    xd=max(x(:)) ; xu=min(x(:)); yl=max(y(:)) ; yr=min(y(:));
    
    nodesd=find(abs(x-xd)<1e-5); [~,ind]=sort(MUA.coordinates(nodesd,2)); nodesd=nodesd(ind);
    nodesu=find(abs(x-xu)<1e-5); [~,ind]=sort(MUA.coordinates(nodesu,2)); nodesu=nodesu(ind);
    nodesl=find(abs(y-yl)<1e-5); [~,ind]=sort(MUA.coordinates(nodesl,1)); nodesl=nodesl(ind);
    nodesr=find(abs(y-yr)<1e-5); [~,ind]=sort(MUA.coordinates(nodesr,1)); nodesr=nodesr(ind);
    
    
    %nodesya=find(abs(x-xd)<1e-5 & abs(y)<1.e-5);
    %nodesyb=find(abs(x-xu)<1e-5 & abs(y)<1.e-5);

    %% periodic BCs
    ufixednode=[nodesu;nodesd;nodesl;nodesr] ;  ufixedvalue=ufixednode*0;
    vfixednode=[nodesu;nodesd;nodesl;nodesr] ;  vfixedvalue=vfixednode*0;
    
    utiedA=[] ;utiedB=[];
    vtiedA=[] ;vtiedB=[];
    
    %vfixednode=[nodesya;nodesyb];   vfixedvalue=[0;0];
    %vtiedA=[setdiff(nodesu,nodesya);nodesl]; vtiedB=[setdiff(nodesd,nodesyb);nodesr]; 
    
    
    %hfixednode=[nodesu;nodesd;nodesl;nodesr;nodesya];  hfixedvalue=hfixednode*0+2;
    hfixednode=[];  hfixedvalue=[];
    htiedA=[]; htiedB=[]; 
    
    %%
    
    if ~isempty(vfixednode)
        [vfixednode,ind]=unique(vfixednode);  vfixedvalue=vfixedvalue(ind);
    end
    
    if ~isempty(ufixednode)
        [ufixednode,ind]=unique(ufixednode);  ufixedvalue=ufixedvalue(ind);
    end
    
    if ~isempty(hfixednode)
        [hfixednode,ind]=unique(hfixednode);  hfixedvalue=hfixedvalue(ind);
    end
    
    
    
end
