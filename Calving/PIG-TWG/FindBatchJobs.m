


% Finds all batch jobs on the local cluster. Writes the diary into a text file, and then displays
% the contents for the diary files. 
% 
%
%



c=parcluster("local");


[pending queued running completed] = findJob(c);

N= numel(running) ;
DiaryFileName=strings(N,1);

for I=1:N    % numel(running)
    DiaryFileName(I)="Diary"+num2str(running(I).ID)+".txt";
    fprintf("%i/%i \t Diary File: %s \n",I,N,DiaryFileName(I))
    diary(running(I),DiaryFileName(I))
end

more on   % turn on paged display

for I=1:N
    fprintf("\n \n #######################################################\n")
    fprintf("%i/%i \t Job ID: %i \n",I,N,running(I).ID)
    type(DiaryFileName(I))
    % to move to next file enter 'q' on the keyborad (this is similar to the unix behaviour of the
    % 'more' command.
end

