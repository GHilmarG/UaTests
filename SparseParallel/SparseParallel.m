

%%


function SparseParallel(I,J,V,N,M)

if nargin==0
    
    load('PIG-TWG-Sparse.mat','I','J','V','N')
    %load('Ant_uvh-Sparse.mat','I','J','V','N')
    M=N;
end

b=ones(N,1);

A=sparse(I,J,V,N,M);

S=CreateDistributedSparseArray(I,J,V,N,M);

tic
y1=A\b;
toc

tic
y2=SolveDistributedSparseSystem(S,b);
toc

norm(y1-y2)


    function S=CreateDistributedSparseArray(I,J,V,N,M)
        
        Vdist = distributed(V);
        
        spmd
            S=sparse(I,J,Vdist,N,M);
        end
    end


    function y=SolveDistributedSparseSystem(S,b)
        
        spmd
        y = S\b;
        end
    end

end

