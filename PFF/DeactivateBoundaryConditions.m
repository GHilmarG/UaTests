


function BCsdeactivated=DeactivateBoundaryConditions(UserVar,CtrlVar,MUA,MUAdeactivated,BCs,k,l)

%%
%
% Gets rid of some boundary conditions that were applied to nodes that now have been deactivated following an element
% deactivation.
%
%
%%



FindOrCreateFigure("BCs original"); PlotBoundaryConditions(CtrlVar,MUA,BCs) ;

BCsdeactivated=BoundaryConditions();


if ~isempty(BCs.ubFixedNode)


    ubNodeNumbers=l(BCs.ubFixedNode);                       % new node numbers, but with nan where old nodes were deleted
    ubNodeNumbers=ubNodeNumbers(~isnan(ubNodeNumbers)) ;    % new node numbers


    BCsdeactivated.ubFixedNode=ubNodeNumbers;
    BCsdeactivated.ubFixedValue=ubNodeNumbers+nan;
    % now I need to find what values were given to those nodes previously

    for I=1:numel(BCsdeactivated.ubFixedNode)

        iOld=k(BCsdeactivated.ubFixedNode(I))     ;  % j=k(i) gives old node number j, for for the new node number i
        iFind=find(BCs.ubFixedNode == iOld)        ;  % finding the location of the old node
        BCsdeactivated.ubFixedValue(I)=BCs.ubFixedValue(iFind) ;   % this will fail, if there are more than one BCs for a given node, but this should be sorted out by the user in DefineBCs.

    end


    vbNodeNumbers=l(BCs.vbFixedNode);                       % new node numbers, but with nan where old nodes were deleted
    vbNodeNumbers=vbNodeNumbers(~isnan(vbNodeNumbers)) ;    % new node numbers


    BCsdeactivated.vbFixedNode=vbNodeNumbers;
    BCsdeactivated.vbFixedValue=vbNodeNumbers+nan;
    % now I need to find what values were given to those nodes previously

    for I=1:numel(BCsdeactivated.vbFixedNode)

        iOld=k(BCsdeactivated.vbFixedNode(I))     ;  % j=k(i) gives old node number j, for for the new node number i
        iFind=find(BCs.vbFixedNode == iOld)        ;  % finding the location of the old node
        BCsdeactivated.vbFixedValue(I)=BCs.vbFixedValue(iFind) ;  % this will fail, if there are more than one BCs for a given node, but this should be sorted out by the user in DefineBCs.

    end



    FindOrCreateFigure("BCs after deactivation"); PlotBoundaryConditions(CtrlVar,MUAdeactivated,BCsdeactivated) ;


end








end

