

%%
ResultsFileDirectory=".\ResultsFiles\" ;

ResultsFile(1)="0000000-MR150-AM0-.mat";
ResultsFile(2)="0000000-MR500-AM0-.mat";

for I=1:2
    load(ResultsFileDirectory+ResultsFile(I))
    UaPlots(CtrlVar,MUA,F,"-uv-",FigureTitle=ResultsFile(I))
    subtitle(ResultsFile(I),Interpreter="latex")
end


%%

Curdir=pwd;

ResultsFileDirectory="C:\Users\pcnj6\OneDrive - Northumbria University - Production Azure AD\Work\Ua\nn_hilmar\res";
cd(ResultsFileDirectory)
Ffiles=dir("F*.mat"); 
MUAfiles=dir("MUA*.mat") ;
CtrlVar=Ua2D_DefaultParameters();

for I=1:numel(Ffiles)

    I
    load(Ffiles(I).name,"F")
    load(MUAfiles(I).name,"MUA")

    CtrlVar.time=F.time;
    UaPlots(CtrlVar,MUA,F,"-uv-")
end

%%
%





%%
