%%
M=importdata('dhdx-GL.dat');

%I=find(M(:,1)<1/diy) ; n=numel(I) ; A=[ones(n,1) M(I,1)] ; sol=A\M(I,2); 
%M(:,2)=M(:,2)-sol(1)-sol(2)*M(:,1);
%M(:,3)=M(:,3)-sol(1)-sol(2)*M(:,1);

figure

diy=365.15;

plot(diy*M(:,1),M(:,2),'+-r')
hold on

%plot(diy*M(:,1),M(:,2)+M(:,3),'r')
%plot(diy*M(:,1),M(:,2)-M(:,3),'r')
xlabel('t (days)') ; ylabel('\Delta L (m)')

rho=920 ; rhow=1030 ; dhdx=-0.001 ; dsdx=[] ; dS=2; dBdx=-0.01;
dL=TidalMigrationDistance(rho,rhow,dhdx,dsdx,dBdx,dS);
[dL.neg dL.pos dL.neg-dL.pos]
[max(M(:,2)) min(M(:,2)) max(M(:,2))-min(M(:,2))]

%%
%figure
figure
diy=365.15;
M=importdata('dsdx-GL.dat');


% gradient through first day
I=find(M(:,1)<1/diy) ; n=numel(I) ; A=[ones(n,1) M(I,1)] ; sol=A\M(I,2); 
M(:,2)=M(:,2)-sol(1)-sol(2)*M(:,1);
M(:,3)=M(:,3)-sol(1)-sol(2)*M(:,1);

%plot(diy*M(:,1),sol(1)+sol(2)*M(:,1),'g') ; hold on



plot(diy*M(:,1),M(:,2),'+-b')
hold on

%plot(diy*M(:,1),M(:,2)+M(:,3),'b')
%plot(diy*M(:,1),M(:,2)-M(:,3),'b')
xlabel('t (days)') ; ylabel('\Delta L (m)')

legend('dh/dx=-0.001','ds/dx=-0.001')


%plot(diy*M(:,1),M(:,1)*0+dL.neg,'r--') ; plot(diy*M(:,1),M(:,1)*0+dL.pos,'r--')


dsdx=-0.001; dhdx=[];
dL=TidalMigrationDistance(rho,rhow,dhdx,dsdx,dBdx,dS);
%plot(diy*M(:,1),M(:,1)*0+dL.neg,'b--') ; plot(diy*M(:,1),M(:,1)*0+dL.pos,'b--')

[dL.neg dL.pos dL.neg-dL.pos]
[max(M(:,2)) min(M(:,2)) max(M(:,2))-min(M(:,2))]

