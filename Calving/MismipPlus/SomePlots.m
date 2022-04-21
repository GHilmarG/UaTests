%%


CurDir=pwd ;
cd ResultsFiles\


SubString(1)="-MismipPlus-C-Fq1Fk30Fmin80cmin0Fmax100cmax3000-Ini5-.mat";



TimeStep=0.5;  I=1; 

ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),...
    PlotTimestep=TimeStep,...
    PlotType="-uv-lsf-c-f-mesh-") ;

cd(CurDir)