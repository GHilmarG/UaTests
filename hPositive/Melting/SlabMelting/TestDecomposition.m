load MUA_Antarctica.mat

%%
dM=decomposition(MUA.M);

One=ones(MUA.Nnodes,1)  ;

fprintf('\n----------------------- \n ')
tic
for I=1:10
    sol1=MUA.M\One ;
end
toc

tic
for I=1:10
    sol1=dM\One ;
end
toc
%%