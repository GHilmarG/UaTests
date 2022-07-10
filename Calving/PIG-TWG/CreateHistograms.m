%%

load("CliffCalving1.16 km.mat","CliffHeight","c")


%CliffCalving2.3 km.mat    CliffCalving4.6 km.mat   CliffCalving9.3 km.mat


figure
h1=histogram(CliffHeight);

figure
load("CliffCalving2.3 km.mat","CliffHeight","c")
h2=histogram(CliffHeight);


figure
load("CliffCalving9.3 km.mat","CliffHeight","c")
h4=histogram(CliffHeight);

h1.BinWidth = 20;
h1.Normalization = 'pdf';

h2.BinWidth = 20;
h2.Normalization = 'pdf';

h4.BinWidth = 20;
h4.Normalization = 'pdf';



legend("1.15km","2.3 km","9.3 km")