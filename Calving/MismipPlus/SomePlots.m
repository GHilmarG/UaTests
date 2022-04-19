%%


CurDir=pwd ;
cd ResultsFiles\


SubString(1)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-.mat";



TimeStep=1;  I=1; 

ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),...
    PlotTimestep=TimeStep,...
    PlotType="-mesh-speed-B-level set-") ;

cd(CurDir)