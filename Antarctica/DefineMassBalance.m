function [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)

persistent Fas


ab=zeros(MUA.Nnodes,1);
dasdh=zeros(MUA.Nnodes,1);
dabdh=zeros(MUA.Nnodes,1);

if isempty(Fas)
    
    %%
    locdir=pwd;
    
    fprintf('DefineGeometry: loading file: %-s ',UserVar.SurfaceMassBalanceInterpolant)
    load(UserVar.SurfaceMassBalanceInterpolant,'Fas')
    fprintf(' done \n')
    cd(locdir)
end



x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);


as=Fas(x,y);

%OceanNodes=LakeOrOcean(CtrlVar,MUA,GF);
[LakeNodes,OceanNodes]=LakeOrOcean3(CtrlVar,MUA,GF);

ab(OceanNodes)=UserVar.ConstantIceShelfMeltRate; 





end

