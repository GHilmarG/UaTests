
% 
% results = runtests('TestUa.m')
% table(results)

function tests = TestUa
    %f=localfunctions ; 
    f={@testCrack};
    f={@testCalvingModifyThickness};
    
    tests = functiontests(f);
end

function testCrack(testCase)
    
    cd Crack
    UserVar=[] ;
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-6)
    
end

function test1dIceShelf(testCase)
    
    cd 1dIceShelf ;
    UserVar=[];
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-6)
    
end


function test1dIceStream(testCase)
    
    cd 1dIceStream ;
    UserVar=[];
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-6)
    
end

function testCalvingModifyThickness(testCase)
    
    cd Calving ;
    UserVar.RunType="-ManuallyModifyThickness-";
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 33552.4222224353 ;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-6)
    
end

% 
% cd Calving ; UserVar.RunType="-ManuallyModifyThickness-"; Ua(UserVar)  ; cd ..
% 
% cd Calving ; UserVar.RunType="-ManuallyDeactivateElements-"; Ua(UserVar) ; cd ..
% % cd ChhotaShigri ; clear ; close all ; Ua ; cd ..
% 
% cd Cone ;   clear  ; Ua ; cd ..
% 
% %cd Cones ;   clear  ; Ua ; cd ..
% 
% cd Crack ; clear ; close all ; Ua ; cd ..
% 
% cd FlowLineMountain ;   clear ; Ua ; cd ..
% 
% cd FreeSlipBCs ;   clear ; close all ; Ua ; cd ..
% 
% cd GaussPeak ;  clear ; Ua ; cd ..
% 
% cd IceShelf ; clear ; Ua ; cd .. 
% 
% cd('Inverse') ;  clear ; 
% UserVar.RunType='IceStream';
% Ua(UserVar) ; 
% cd ..
% 
% 
% cd('Inverse') ;  clear ; 
% UserVar.RunType='IceShelf';
% Ua(UserVar) ; 
% cd ..
% 
% 
% cd MassBalanceFeedback ;   clear ; Ua ; cd ..
% 
% % cd Melange ; clear ; Ua ; cd ..
% %%
% cd MismipPlus ; clear ; Ua ; cd ..
% 
% %cd PIG-TWG ; clear ; close all ; Ua ; cd ..
% 
% cd('mVariable') ;  clear ; close all ; Ua ; cd ..
% 
% cd('nVariable') ;  clear ; close all ; Ua ; cd ..
% 
% cd('Uniformly Inclined Plane') ;  clear ; Ua ; cd ..
% 
% cd WavyChannel ; clear ; close all ; Ua ; cd ..
% 
