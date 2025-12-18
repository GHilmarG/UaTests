function [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


%%
%
%   [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined);
%
% Defines model geometry and densities
%
%
% As in all other calls:
%
%  s           is upper ice surface
%  b           is lower ice surface
%  B           is bedrock
%  S           is ocean surface
%  rho         ice density
%  rhow        ocean density (water density)
%  g           gravitational acceleration
%
% These fields need to be returned at the nodal coordinates. The nodal
% coordinates are stored in MUA.coordinates
%
% FieldsToBeDefined is a string indicating which return values are required.
%
% If a given variable is contained in that string, then that variable needs to be defined in the call.
% If that variable is not in the sting, the variable does not need to be defined, but it still needs to be returned in the call, but it
% can have any value, for example it can be set to NaN.
%
% Example: If
%
%   FieldsToBeDefined="-s-b-S-B-rho-rhow-g-'
%
% then s, b, S, B, rho, rhow and g all need to be defined.
%
% Typically, in a transient run
%
%   FieldsToBeDefined="-S-B-"
%
% implying that only S and B needed to be defined, and s and b can be set to any
% value, for example s=NaN and b=NaN.
%
%%


persistent Fs Fb FB Frho


if isempty(FB)
    locdir=pwd;
    fprintf('DefineGeometry: loading file: %-s ',UserVar.GeometryAndDensityInterpolants)
    load(UserVar.GeometryAndDensityInterpolants,'FB','Fb','Fs','Frho')
    fprintf(' done \n')
    cd(locdir)
    
end



x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);

if contains(FieldsToBeDefined,'S')
    S=x*0;
else
    S=NaN;
end


if contains(FieldsToBeDefined,'s')
    s=Fs(x,y);
else
    s=NaN;
end

b=NaN; B=NaN;

if contains(FieldsToBeDefined,'b')  || contains(FieldsToBeDefined,'B')
    
    B=FB(x,y);
    b=Fb(x,y);
    
    
end

if contains(FieldsToBeDefined,'rho')
    rho=Frho(x,y);
    rhow=1030;
    g=9.81/1000;
    %  rho g = [Pa/m]   = [kPa/m] /1000  
    %  
    % rhog=1030*9.91/1000; 
    %
    % My independent units are: m, yr, kPa
    
else
    rho=NaN;
    rhow=NaN ;
    g=NaN;
end


end
