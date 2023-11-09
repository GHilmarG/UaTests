

%%
%
%  I keep complete copies of PIG-TWG results files on
%
%  C23000099 in C:\cygwin64\home\pcnj6\Ua\UaTests\Calving\PIG-TWG\ResultsFiles
%
% External drive "UaHomeWScopy" in F:\Runs\Calving\PIG-TWG\ResultsFiles
%
%%
CurDir=pwd;




[~,hostname]=system('hostname') ;
if contains(hostname,"C23000099")
    cd("E:\Runs\Calving\PIG-TWG\ResultsFiles")
else
    cd("d:/Runs/Calving/PIG-TWG/ResultsFiles")
end







Res=["5km","10km","20km"];
Reg=["TWIS","TWISC0","TWISC2","PIGC0"] ;
SL=["Cornford","Weertman"] ;
MR=["MR0","MR4"];
D=["-","-Duvh-"];


Res=["5km","10km","20km"]; Reg=["TWIS"] ; SL=["Cornford","Weertman"] ; MR=["MR4"]; D=["-Duvh-"];

% Name="*P-TWIS-MR0-SM-TM001-Weertman*5km*.mat" ;
% I=1 ; J=1; K=1; L=1;

for L=1:numel(Res)
    for M=1:numel(D)

        for I=1:numel(Reg)
            for J=1:numel(MR)
                for K=1:numel(SL)

                    Name="00*P"+D(M)+Reg(I)+"-"+MR(J)+"-SM-TM001-"+SL(K)+"*"+Res(L)+"*.mat" ;


                    Files=dir(Name);

                    if numel(Files)==0

                        TimeString="-------";

                    else

                        TimeString=extractBefore(Files(end).name,"-");

                    end


                    fprintf("%s: \t  %s \n",Name,TimeString)

                end
            end
        end
        fprintf("\n")
    end
end

cd(CurDir)