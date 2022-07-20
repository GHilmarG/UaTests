

%%
% Finds all batch jobs on the local cluster. Writes the diary into a text file, and then displays
% the contents of the diary files.
%
% The ouuput behaviour is similar to that of the Unix 'more' command (uses 'more on')
%
%
%
%  Example: 
% 
%   FindBatchJobs [Ret]
%
%
%%



c=parcluster;


[pending, queued, running, completed] = findJob(c);



N= numel(running) ;
DiaryFileName=strings(N,1);

for I=1:N    % numel(running)
    if running(I).Type=="pool"
        DiaryFileName(I)="Diary"+num2str(running(I).ID)+".txt";
        fprintf("%i/%i \t Diary File: %s \n",I,N,DiaryFileName(I))
        diary(running(I),DiaryFileName(I))
    end
end

more on   % turn on paged display

for I=1:N
    if running(I).Type=="pool"
        fprintf("\n \n \n \n \n #######################################################\n")
        fprintf("%i/%i \t Job ID: %i \n",I,N,running(I).ID)
        type(DiaryFileName(I))
        % to move to next file enter 'q' on the keyborad (this is similar to the unix behaviour of the
        % 'more' command.
    end
end

more off