

function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
    
persistent FB Fs Fb


if isempty(FB)
    
    load([UserVar.InterpolantDirectory,'/GriddedInterpolants.mat'],'Fs','FB','Fb')
    
end

x=MUA.coordinates(:,1);
y=MUA.coordinates(:,2);


alpha=0; 

B=FB(x,y);
b=B;
s=Fs(x,y);
S=0+x*0 ;


end
