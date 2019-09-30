
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

persistent FB Fs Fb


if nargin<5
    FieldsToBeDefined='sbSB';
end

alpha=0 ;


if isempty(FB)

        
        fprintf('Loading Interpolants for s, b and B ') 
        locdir=pwd;
        cd(UserVar.InterpolantsDirectory)
        load FsAntarcticGriddedInterpolant Fs
        %load FhAntarcticGriddedInterpolant Fh
        load FBAntarcticGriddedInterpolant FB
        load FbedAntarcticGriddedInterpolant Fb
        cd(locdir)
        fprintf('done\n')
        

end


x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);


if contains(FieldsToBeDefined,'S')
    S=zeros(MUA.Nnodes,1);
else
    S=NaN;
end

if contains(FieldsToBeDefined,'s')
    s=Fs(x,y);
else
    s=NaN;
end

if contains(FieldsToBeDefined,'b')
    b=Fb(x,y);
else
    b=NaN;
end

if contains(FieldsToBeDefined,'B')
    B=FB(x,y);
else
    B=NaN;
end



end



