

%%

%LocalClusterThreaded = parcluster("localThread");


parfor i=1:30
    
<<<<<<< HEAD
    MeshSizeString="MS"+num2str(i*1000/7)+"k" ;



    UserVar.Experiment="NumAna-Nod3-"+MeshSizeString+"-dt0.1-DSx50k-DSy50k-alpha0.05-TI-uvh-IT-theta0.5-uv2hIt1-" ; 
=======
    MeshSizeString="MS"+num2str(i/3)+"k" ;
    UserVar=[]; 
    %UserVar.Experiment="NumAna-Nod3-"+MeshSizeString+"-dt0.1-DSx50k-DSy50k-alpha0.05-TI-uvh-IT-theta0.5-uv2hIt1-" ; 
    UserVar.Experiment="NumAna-Nod3-"+MeshSizeString+"-dt0.1-DSx50k-DSy50k-alpha0.05-TI-uv-h-IT-theta0.5-uv2hIt1-" ; 
>>>>>>> 5926bf5 (WO)
    
    Ua(UserVar) ; 
    % Jobs{i}=batch(LocalClusterThreaded,"Ua",0,{UserVar});
    % Jobs{i}=batch("Ua",0,{UserVar});

end
%%