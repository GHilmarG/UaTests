cd 1dIceShelf ; clear ; Ua ; cd ..

cd 1dIceStream ; clear  ; Ua ; cd ..

cd ChhotaShigri ; clear ; close all ; Ua ; cd ..

cd Cone ;   clear  ; Ua ; cd ..

% cd Cones ;   clear  ; Ua ; cd ..

cd Crack ; clear ; close all ; Ua ; cd ..

cd FlowLineMountain ;   clear ; Ua ; cd ..

cd FreeSlipBCs ;   clear ; close all ; Ua ; cd ..

cd GaussPeak ;  clear ; Ua ; cd ..

cd IceShelf ; clear ; Ua ; cd .. 

cd('Inverse') ;  clear ; 
UserVar.RunType='IceStream';
Ua(UserVar) ; 
cd ..


cd('Inverse') ;  clear ; 
UserVar.RunType='IceShelf';
Ua(UserVar) ; 
cd ..


cd MassBalanceFeedback ;   clear ; Ua ; cd ..

% cd Melange ; clear ; Ua ; cd ..

cd MismipPlus ; clear ; Ua ; cd ..

%cd PIG-TWG ; clear ; close all ; Ua ; cd ..

cd('mVariable') ;  clear ; close all ; Ua ; cd ..

cd('nVariable') ;  clear ; close all ; Ua ; cd ..

cd('Uniformly Inclined Plane') ;  clear ; Ua ; cd ..

cd WavyChannel ; clear ; close all ; Ua ; cd ..

