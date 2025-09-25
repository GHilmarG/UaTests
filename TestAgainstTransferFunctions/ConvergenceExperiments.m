

%%

LocalClusterThreaded = parcluster("localThread");

for i=1:10
    
    MeshSizeString="MS"+num2str(i*1000/3)+"k" ;



    UserVar.Experiment="NumAna-Nod3-"+MeshSizeString+"-dt0.1-DSx50k-DSy50k-alpha0.05-TI-uvh-IT-theta0.5-uv2hIt1-" ; 
    
    % UserVar=Ua(UserVar) ; 
    % Jobs{i}=batch(LocalClusterThreaded,"Ua",0,{UserVar});
    Jobs{i}=batch("Ua",0,{UserVar});

end
%%