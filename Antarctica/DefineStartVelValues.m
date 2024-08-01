function [UserVar,ub,vb,ud,vd]=DefineStartVelValues(UserVar,CtrlVar,MUA,BCs,ub,vb,ud,vd,time,s,b,h,S,B,rho,rhow,GF,AGlen,n,C,m)

fprintf('Initial velocities set to zero. \n')


% 
% fprintf('loading velocity interpolants')
% load VelocityInterpolants Fub Fvb Fud Fvd
% fprintf(' done. \n')
% 
% if numel(Fub.Values) == MUA.Nnodes
%     ub=Fub.Values;
%     vb=Fvb.Values;
%     ud=Fud.Values;
%     vd=Fvd.Values;
% else
%     fprintf('Initial velocities on a different grid. Interpolating onto FEmesh')
%     x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
%     ub=Fub(x,y) ;
%     vb=Fvb(x,y) ;
%     ud=Fud(x,y) ;
%     vd=Fvd(x,y) ;
%     fprintf(' done. \n')
%     
% end


end
