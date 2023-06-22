


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

% Name="*P-TWIS-MR0-SM-TM001-Weertman*5km*.mat" ;
% I=1 ; J=1; K=1; L=1;

for L=1:3
    for M=1:2

        for I=1:3
            for J=1:2
                for K=1:2

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