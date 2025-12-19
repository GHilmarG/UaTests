function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)

% Units are m, kPa, yr. (1Pa = 1kg/ms^2)

rhow=1030;  rho=917; g=9.81/1000;

% Topography
B=zeros(MUA.Nnodes,1); b=B; S=B*0-1e10;

hmean=1000;
s=hmean ;

% switch UserVar.RunType
%     case 'Inverse-MatOpt'
%         load("ScatteredInterpolant_s.mat","Fs")
%         s = Fs(F.x,F.y);
% 
%     case 'Forward-Transient'
%         hmean=1000;
%         s=hmean ;
% 
%     case 'Forward-Diagnostic'
%         hmean=1000;
%         s=hmean ;
% end




