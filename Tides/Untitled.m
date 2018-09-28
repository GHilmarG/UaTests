M=importdata('GL.dat');

figure

diy=365.15;

plot(diy*M(:,1),M(:,2),'g')
hold on

plot(diy*M(:,1),M(:,2)+M(:,3),'r')
plot(diy*M(:,1),M(:,2)-M(:,3),'r')