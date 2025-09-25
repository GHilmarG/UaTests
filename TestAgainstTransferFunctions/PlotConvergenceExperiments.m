


%%
% Specify the filename
filename = 'Table.csv';

% Read the table from the CSV file
T = readtable(filename);




filteredRows = T(strcmp(T.TimeIntegration, '-uvh-') & T.dt ==0.1, :);

% Display the filtered table
disp(filteredRows);

[MS,ind]=sort(filteredRows.MeshSize); 

figure(100) ; plot(filteredRows.MeshSize(ind),filteredRows.sErrorTimeIntegrated(ind),"o-r") ; 
xlabel("mesh size (km)") ; ylabel("Error measure")

%%