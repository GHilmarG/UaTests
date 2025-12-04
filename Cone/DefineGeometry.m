function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

b=NaN; B=NaN; s=NaN ; S=NaN;

if nargin<4
    FieldsToBeDefined='sbSB';
end

alpha=0 ;

if ~isempty(strfind(FieldsToBeDefined,'S'))
    S=zeros(MUA.Nnodes,1)-1000;
end



if ~isempty(strfind(FieldsToBeDefined,'b'))  || ~isempty(strfind(FieldsToBeDefined,'B')) || ~isempty(strfind(FieldsToBeDefined,'s'))
    
    B=DefineCone(MUA.coordinates(:,1),MUA.coordinates(:,2));
    b=B;
    s=b+100;
    
end




end

