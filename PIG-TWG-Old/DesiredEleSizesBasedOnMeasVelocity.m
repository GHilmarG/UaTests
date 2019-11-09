


function EleSizeIndicator=DesiredEleSizesBasedOnMeasVelocity(UserVar,CtrlVar,MUA,s,b,S,B,rho,rhow,AGlen,n,GF)

persistent FuMeas FvMeas

if isempty(FuMeas)
    
    fprintf('Loading interpolants for surface velocity data')
    
    locdir=pwd;
    cd(UserVar.InterpolantsDirectory)
    load SurfVelMeasures990mInterpolants FuMeas FvMeas FerrMeas
    cd(locdir)
    fprintf(' done.\n')
end

uMeas=double(FuMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));
vMeas=double(FvMeas(MUA.coordinates(:,1),MUA.coordinates(:,2)));

EleSizeIndicator=zeros(MUA.Nnodes,1) + CtrlVar.MeshSizeMax ;
speed=sqrt(uMeas.*uMeas+vMeas.*vMeas);
temp=EleSizeIndicator;

Ind=speed>10 & GF.node>0.9 ; temp(Ind)=2*CtrlVar.MeshSizeFastFlow;
Ind=speed>50 & GF.node>0.9 ; temp(Ind)=CtrlVar.MeshSizeFastFlow;

EleSizeIndicator=min(temp,EleSizeIndicator);



end
