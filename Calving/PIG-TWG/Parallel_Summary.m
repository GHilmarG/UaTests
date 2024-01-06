%%

% Processes, spmd, integration nodes with CtrlVar.Parallel.uvAssembly.spmdInt.isOn=true ;

% Amdahl's Law for a problem of a fixed size: https://en.wikipedia.org/wiki/Amdahl%27s_law

DESKTOP-BU2IHIR:


%%
% Nodes=83632,   Ele=664,509 ;
threads  =      [        1               2                  4            8        12          16  ]' ;
seq_BU2IH =     [        5.5            5.2                5.5         5.4        5.5         5.5 ]' ;
seq_C2300 =     [        5.0            5.0                5.0         4.9        5.0         5.0 ]' ; 
seq_DellOffice =[        4.5            4.5                4.5         4.5        4.5         4.5 ]' ; 
SPMD_BU2IH=     [        1.0            2.8                4.3         5.2        5.0         4.1 ]';
SPMD_C2300=     [        1.0            3.5                5.3         6.2        5.9         5.0 ]';
SPMD_DellOffice=[        1.0            2.6                4.0         5.0        4.0         3.9 ]';  % for 12 and 16 nodes, speedup decreases significantly with iterations


T =table(threads,seq_BU2IH,seq_C2300,seq_DellOffice,SPMD_BU2IH,SPMD_C2300,SPMD_DellOffice);  

hold off; figure(10) ; hold off
plot(T.threads,T.SPMD_BU2IH,'or-',DisplayName="Machine with 16 cores")
hold on
plot(T.threads,T.SPMD_DellOffice,'*c-',DisplayName="Machine with 24 cores")
plot(T.threads,T.SPMD_C2300,'+b-',DisplayName="Machine with 32 cores")


leg=legend(Location="best") ; 
xlabel("\# element partitions and threads",Interpreter="latex")
ylabel("speedup",Interpreter="latex");
title("Speedup using parallel spmd assembly over element partitions")
subtitle("86,632 nodes and 166,223 elements",Interpreter="latex")
ylim([1 6.5])
%
% parfeval                                                4.0/?            3.0/?


% Nodes=333,294,  Ele=664,509
threads=        [ 1                 2                  4            8        10        12          16   ]';
seq_BU2IH=      [ 16.5             16.7               16.5        15.7       nan       15.9       16.5  ]';                                      
seq_C2300=      [ 15.7             nan                15.4        16.0       nan       16.3       15.6  ]';
seq_DellOffice= [  13.7           14.5                 nan        14.7       nan       14.1       13.3  ]';
SPMD_BU2IH  =   [   1              1.3                 1.6         4.3       4.5       4.8         4.3  ]';
SPMD_C2300  =   [   1              1.1                 1.2         4.7       4.7       5.2         4.6  ]'; 
SPMD_DellOffice=[0.95              1.4                 1.6         4.8       4.9       5.2         3.5  ]';

% C2300   :     32 Cores, 64 logical. 256 GH of memory, Xeon Gold 6226R,    2.90GHz
% BU2IHIR :     16 cores, 32 logical. 256 GB of memory, Xeon Silver 4208R   2.10GHz
% DellOffice:   24 cores, 48 logical, 128 GB of memory, Xeon E5-2670        2.30GHz

% Emily Hill's workstation is: HP Xeon E5-2699, 22 Cores, 44 logical, 128GB, 2.20 GHz


T =table(threads,seq_BU2IH,seq_C2300,seq_DellOffice,SPMD_BU2IH,SPMD_C2300,SPMD_DellOffice);  

hold off; figure(20) ; hold off
plot(T.threads,T.SPMD_BU2IH,'or-',DisplayName="Machine with 16 cores")
hold on
plot(T.threads,T.SPMD_DellOffice,'*c-',DisplayName="Machine with 24 cores")
plot(T.threads,T.SPMD_C2300,'xb-',DisplayName="Machine with 32 cores")
leg=legend(Location="best") ; 
xlabel("\# element partitons and threads",Interpreter="latex")
ylabel("speedup",Interpreter="latex");
title("Speedup using parallel spmd assembly over element partitions")
subtitle("333,294 nodes and 664,509 elements")
ylim([1 6.5])
%%

%%




-parfeval performance seems to become worse with number of uv iteratations, fetching the data from the threads takes longer and longer event though the arrays sizes are not changing.
-spmd does not suffer from the same performance drop, although possibly it does when using maximum number of workers

-spmd: Building the MUA arrays on workers is much faster using the thread environment as compared to processes 

size(iK) 5984028 


NodesSpeedup=[2425  0.40 ; ...
            5348 0.78 ; ...
            21094  1.43 ; ...
            83632   2.4 ; ...
            333294  2.4];


% Processes, spmd, domain decomposition, with CtrlVar.Parallel.uvAssembly.spmd.isOn=true; 
NodesSpeedup=[2425  0.40 ; ...
            5348 0.78 ; ...
            21094  1.43 ; ...
            83632   2.4 ; ...
            333294  2.4];

NodesSpeedup2=[2425  0.48 ; ...
            5348 0.67 ; ...
            21094  0.94 ; ...
            83632   1.4 ; ...
            333294  1.0];

NodesSpeedup8=[2425  0.67 ; ...
            5348 0.8 ; ...
            21094  1.4 ; ...
            83632   2.9 ; ...
            333294  2.5];

NodesSpeedup16=[2425  0.4 ; ...
            5348 0.9 ; ...
            21094  1.6 ; ...
            83632   2.5 ; ...
            333294  2.4];

NodesSpeedup16Threads=[2425  0.57 ; ...
            5348 1.1 ; ...
            21094  1.0 ; ...
            83632   3.9 ; ...
            333294  3.2];


