function A=TestDistributedArrays


N=200;
M=12;
K=10; 

%A=zeros(N,N,'distributed') ;
%C=zeros(N,N,'distributed') ;
A=zeros(N,N) ; 
C=ones(N,N) ; 

tic 
%ticBytes(gcp);
parfor (I=1:M,12)
    A=A+Aadd(C,K);
end
A(1,1)
%tocBytes(gcp)
tPar=toc;

A=zeros(N,N) ; 
C=ones(N,N) ; 
tic 
for I=1:M
    A=A+Aadd(C,K);

end
A(1,1)
tSeq=toc ;

fprintf("\n parfor \t\t\t  for \t\t\t speedup \n")
fprintf("%f \t\t\t %f \t\t %f \n",tPar,tSeq,tSeq/tPar)

A=zeros(N,N,'distributed') ; 
C=ones(N,N,'distributed') ; 
tic 
for I=1:M
    A=A+Aadd(C,K);
end
A(1,1)
tDist=toc 



% C=ones(N,N) ;
% tic
% delete(gcp)
% parpool('local',M)
% spmd 
%     A=Aadd(C,K);
%     B = gplus(A,1);
% end
% Total=B{1};
% 
% tDis=toc


end


function C=Aadd(C,K)

for I=1:K
    C=C+C' ;
    %C=sqrtm(C);
end


end
