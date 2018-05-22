
unset DISPLAY

/local/matlab/R2016b/bin/matlab -nodisplay >& M3-$1.out <<EOF

CurrentDir=pwd; I=strfind(lower(CurrentDir),'ghg')+3;
str=CurrentDir(1:I);
setenv('UaHomeDirectory',[str,'Ua/Source'])
setenv('AntarcticGlobalDataSets',[str,'Ua/AntarcticGlobalDataSets'])
UaHome=getenv('UaHomeDirectory') ;
addpath(genpath(UaHome),'-begin');

Ua($1)
exit
EOF

