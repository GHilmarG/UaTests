function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


%%

persistent Fs
persistent Fthk

if isempty(Fs) || isempty(Fthk)
    load('InterpolantF.mat','Fs');
    load('InterpolantF.mat','Fthk');
end

% load('InterpolantF.mat');
s = Fs(F.x, F.y);
thickness = Fthk(F.x, F.y);
% save('thickness.mat','thickness','MUA','CtrlVar');

b=s-thickness;

% ocean surface and bedrock
S=zeros(MUA.Nnodes,1);
B=b;

%figure(1); [~,cbar]=PlotMeshScalarVariable(CtrlVar,MUA,s);
%set(gca,'xtick',[],'xticklable',[]);

%%

rho=917+zeros(MUA.Nnodes,1);
rhow=1000;
g=9.81/1000;

end




