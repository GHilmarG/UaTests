

c=parcluster("local");


[pending queued running completed] = findJob(c);

N= numel(running) ;
DiaryFileName=strings(N,1);

for I=1:N    % numel(running)
    DiaryFileName(I)="Diary"+num2str(running(I).ID)+".txt";
    fprintf("%i/%i \t Diary File: %s \n",I,N,DiaryFileName(I))
    diary(running(I),DiaryFileName(I))
end

more on

for I=1:N
    fprintf("\n \n #######################################################\n")
    fprintf("%i/%i \t Job ID: %i \n",I,N,running(I).ID)
    type(DiaryFileName(I))
end

