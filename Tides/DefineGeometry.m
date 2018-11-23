
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
  
% Defines model geometry

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
alpha=0.;

% surface/thickness slope/gradient: -gamma
% bed slope: -beta
Bgl=-1000; xgl=0; gamma=0.001; beta=0.01;


s=[] ; b=[] ; h=[] ; S=[] ; B=[] ; 
[UserVar,rho,rhow,g]=DefineDensities(UserVar,CtrlVar,MUA,CtrlVar.time,s,b,h,S,B);

S0=0*x;
hgl=rhow*(S0-Bgl)/mean(rho) ;  % rho hgl= rhow*(S-B)
sgl=Bgl+hgl;
B=Bgl-beta*(x-xgl);
%geo='s-B' ;
%geo='B-dhdx';
switch UserVar.geo
    case 'dsdx'
        %% constant surface slope, constant bed slope, and GL at x=0
        
        S=S0;
        s=sgl-gamma*(x-xgl);
        b=B ; I=x>=0 ; b(I)=(rho(I).*s(I)-rhow*S(I))./(rho(I)-rhow);     % rho*(s-b)=rhow*(S-b) ; rho*s -rhow S= b*(rho-rhow)
        
        
    case 'dhdx'
        
        %% constant thickness gradient dhdx=-gamma across grounding line
        %  unequal surface and bed slopes on both sides of grounding line
        
        S=S0;
        h=hgl-gamma*(x-xgl);
        
        [b,s,h,GF]=Calc_bs_From_hBS(CtrlVar,MUA,h,S,B,rho,rhow);
        
        
        
    otherwise
        error('what case')
        
        
end

%figure ; plot(x,s,'b') ; hold on ; plot(x,B,'r') ; plot(x,S,'g') ; plot(x,b,'c') ; legend('s','B','S','b') ; title(CtrlVar.geo);  
%save([CtrlVar.geo,'-Geometry.mat'],'x','s','b','S','B')


t0=1/365.25;
%t0=0;

if CtrlVar.time>t0
    S=S0+2*sin(2*pi*365.25*(CtrlVar.time-t0));
else
    S=S0;
end

end
