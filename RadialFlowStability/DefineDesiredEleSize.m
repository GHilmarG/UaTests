function [UserVar,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened]=...
            DefineDesiredEleSize(UserVar,CtrlVar,MUA,x,y,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened,s,b,S,B,rho,rhow,ub,vb,ud,vd,GF,NodalErrorIndicators)
        
%% FIRST RECOGNIZE FRONT (naive estimate, band is taken around it) WITH MAX(DHDR)
tol=0.01; %the tolerance about the dhdr maximum - for a better contour find
band=0.005; %in [m], the band distance to each size - for distance from Front

[rg,Domain_radius,shelf_width,h0,Bedrock,rho,rhow,g,thinice,ur,n,AGlen]=DefineMyParameters();
%xx=MUA.coordinates(:,1); yy=MUA.coordinates(:,2);
%mx2=MUA.xEle.^2;
%my2=MUA.yEle.^2;

h=s-b; %fist recognize the thickness from the given b and s

%calculate the dhdr with derivatives
[dfdx,dfdy,~,~]=calcFEderivativesMUA(h,MUA,CtrlVar);
[exxNod,eyyNod]=ProjectFintOntoNodes(MUA,dfdx,dfdy);
dhdr=(exxNod.^2+eyyNod.^2).^0.5;

%find the contour line of the tol*maximal dhdr 
[xc,yc]=CalcMuaFieldsContourLine(CtrlVar,MUA,dhdr./max(dhdr),tol);
indexx=find(isnan(xc));
index=indexx(1);
xc_cut=xc(1:index-1);
yc_cut=yc(1:index-1);
xc=xc_cut; yc=yc_cut; %these are not the contour (xc,yc) of the naive front

ID=FindAllNodesWithinGivenRangeFromGroundingLine(CtrlVar,MUA,xc,yc,band) ;
newf=zeros(MUA.Nnodes,1); 
newf(ID)=1.0; %logical nodes list that are in ID
Int=FEintegrate2D(CtrlVar,MUA,newf); %integration values element list

idx=find(Int>0); %index elements list (which to refined?)
newe=zeros(MUA.Nele,1);
newe(idx)=1.0; %logical array of element list to be refined

 clear rr; clear bb; clear ss; clear hh; clear dhdr; 
%%
%rc=mean(sqrt(xc.^2+yc.^2));
%while the interface is still small better to keep all of it fine
%if rc <= rg*2
%    outer_r=rg*2;
%    in_r=rg;
%    ind=((mx2+my2) >= in_r.^2) & ((mx2+my2) <= outer_r.^2); %logical array -- lentgh is number of elements
%else
%    ind=newe;
%end
ind=newe;

%% Now combine with the condition on the size of elements
areasvec=MUA.EleAreas;%length of number of elements
finerfactor=1e-08; %We want to go way below this currently minimal element area  (reference: minimum eleArea in snow3 is 3.5e-07)

ToFine= (areasvec > 2*finerfactor) & (ind); %logical array size of number of elements
ToCoarse=(areasvec < 800*finerfactor) & (~ind); %logical array size of number of elements
ElementsToBeRefined(ToFine)=true; 
ElementsToBeCoarsened(ToCoarse)=true;
clear areasvec; clear ToCoarse; clear ToFine;
 
end
