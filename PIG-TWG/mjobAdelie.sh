
unset DISPLAY

/home/ghg/MATLAB/R2016b/bin/matlab -nodisplay >& M3-$1.out <<EOF

CurrentDir=pwd; I=strfind(lower(CurrentDir),'ghg')+3;
str=CurrentDir(1:I);
setenv('UaHomeDirectory',[str,'data/Ua/Source'])
setenv('AntarcticGlobalDataSets',[str,'data/Ua/AntarcticGlobalDataSets'])
UaHome=getenv('UaHomeDirectory') ;
addpath(genpath(UaHome),'-begin');

Ua($1)
exit
EOF

