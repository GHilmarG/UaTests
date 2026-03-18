


function


%%
% Hessian Vector Product
%
% $$
% H x \approx (g(p + \epsilon d) - g(p)) / \epsilon
% $$
%
% For the trust-region-reflective, the input contains the vector/direction $d$ but not the current point $x$.  But the Hinfo
% can be anything that the JGH function returns as third argument, so I guess I need to make sure that JGH returns the current
% point $x$ in its third argument when using this method.
%
%
%%


nVector=size(d,2);

[J,g]=func(p) ;

HVP=d; % just for the dimensions
epsilon=1e-10;

for iVector=1:nVector

    [JPert,gPert]=func(p+epsilon*d(:,iVector));
    dJ=(JPert-J)/J;
    HVP(:,iVector)=-(gPert-g)/epsilon;
    fprintf("Jpert=%g \t J0=%g \t (Jpert-J0)/J0=%g\n",JPert,J,dJ)

end




end