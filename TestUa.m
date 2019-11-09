

% (alpha) 

% results = runtests('TestUa.m') ; table(results)
% 



function tests = TestUa
    
    
    f={@setupOnce,@testCrack,@teardownOnce};
    f={@setupOnce,@testCalvingManuallyDeactivateElements,@teardownOnce};

    % f={@testCalvingModifyThickness};
    f=localfunctions ;
    %f={@setupOnce,@testGaussPeak,@teardownOnce};
    f={@setupOnce,@testMassBalanceFeedback,@teardownOnce};
    
    tests = functiontests(f);
end

function setupOnce(testCase)
    close all
end


function teardownOnce(testCase)
    close all
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
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-6)
    
end


function testCalvingManuallyDeactivateElements(testCase)
    
    cd Calving ;
    UserVar.RunType="-ManuallyDeactivateElements-";
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 40277.0242978501 ;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-6)
    
end


function testFreeSlipBCs(testCase)
    
    cd FreeSlipBCs ;
    UserVar.RunType=[];
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-6)
    
end



function testGaussPeak(testCase)
    
    cd GaussPeak ;
    UserVar.RunType=[];
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-6)
    
end



function testMassBalanceFeedback(testCase)
    
    cd MassBalanceFeedback;
    UserVar.RunType=[];
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-2)
    
end


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
