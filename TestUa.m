

% (alpha) 

% results = runtests('TestUa.m') ; table(results)
% 

% To do: All calving test need to be redefined and made including the LSF approach

function tests = TestUa
    
    
    f={@setupOnce,@testCrack,@teardownOnce};
    f={@setupOnce,@testCalvingManuallyDeactivateElements,@teardownOnce};
    
    %f={@setupOnce,@testGaussPeak,@teardownOnce};
    %f={@setupOnce,@testMassBalanceFeedback,@teardownOnce};
    f={@testPIGmeshing};
    
    
    f=localfunctions ;  % all tests
    
    f={@test1dIceShelf} ;                   % results = runtests('TestUa.m') ; table(results)
    f={@test1dIceStream} ;                  % results = runtests('TestUa.m') ; table(results)
    f={@testCalvingModifyThickness} ;        % results = runtests('TestUa.m') ; table(results)
    f={@testFreeSlipBCs,@testGaussPeak,@testMassBalanceFeedback} ;        % results = runtests('TestUa.m') ; table(results)
    % f={@testPIGtransient};
    
    tests = functiontests(f);
end

function setupOnce(testCase)
    close all
end


function teardownOnce(testCase)
    close all
end


function testPIGmeshing(testCase)
    
    cd PIG-TWG\
    UserVar.RunType='TestingMeshOptions'; 
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    % 42368.9157216889   laptop 17 Nov
    expSolution = 56024.4217889207;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-2)
    
end

function testPIGdiagnostic(testCase)
    
    cd PIG-TWG\
    UserVar.RunType='Forward-Diagnostic'; 
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 95982.7181182457;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-2)
    
end

function testPIGtransient(testCase)
    
    cd PIG-TWG\
    UserVar.RunType='Forward-Transient';
    
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 94704.6045393781;
    %  79053.6666394987 % home laptop, 17 Nov, 2019
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-2)
    
end


function testCrack(testCase)
    
    cd Crack
    UserVar=[] ;
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 5034.37163446407;
    verifyEqual(testCase,actSolution,expSolution,'AbsTol',1e-6)
    
end

function test1dIceShelf(testCase)
    
    cd 1dIceShelf ;
    UserVar=[];
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-6)
    
end


function test1dIceStream(testCase)
    
    cd 1dIceStream ;
    UserVar=[];
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-6)
    
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
