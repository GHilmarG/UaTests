

% (alpha) 

% results = runtests('TestUa.m') ; table(results)
% 

function tests = TestUa
    
    
    f={@setupOnce,@testCrack,@teardownOnce};
    f={@setupOnce,@testCalvingManuallyDeactivateElements,@teardownOnce};
    f={@setupOnce,@testCalvingThroughMassBalanceFeedback,@teardownOnce};
    
    %f={@setupOnce,@testGaussPeak,@teardownOnce};
    %f={@setupOnce,@testMassBalanceFeedback,@teardownOnce};
    
    %f={@testPIGmeshing};

    
    %f=localfunctions ;  % all tests
    
    % f={@testCrack}                ;  % OK  11/05/2021
    % f={@testPIGdiagnostic}        ;  % OK  11/05/2021
    % f={@testMassBalanceFeedback}  ;  % OK  11/05/2021
    % f={@test1dIceStream}          ;  % OK  11/05/2021
    % f={@test1dIceShelf}           ;  % OK  11/05/2021
    % f={@testGaussPeak}            ;  % OK  11/05/2021
    % f={@testFreeSlipBCs}          ;  % OK  11/05/2021
    % f={@testCalvingAnalyticalIceShelf};  % OK 11/05/2021
    % f={@testPIGtransient}         ;  % OK 11/05/2021
    
    
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
    expSolution = 56024.4217889207;  % ; 56024.6341690262
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-3)
    
end

function testPIGdiagnostic(testCase)
    
    cd PIG-TWG\
    UserVar.RunType='Forward-Diagnostic'; 
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 95982.7181182457;
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-4)
    
end

function testPIGtransient(testCase)
    
    cd PIG-TWG\
    UserVar.RunType='Forward-Transient';
    
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 94704.6045393781;
    %  79053.6666394987 % home laptop, 17 Nov, 2019
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-2)
    
end


function testCrack(testCase)
    
    cd Crack
    UserVar=[] ;
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 5034.37163446407;
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-6)
    
end

function test1dIceShelf(testCase)
    
    cd 1dIceShelf ;
    UserVar=[];
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-2)
    
end


function test1dIceStream(testCase)
    
    cd 1dIceStream ;
    UserVar=[];
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 2669.7046413036 ; % 2688.16151728403 
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-3)
    
end

function testCalvingAnalyticalIceShelf(testCase)
    
    cd Calving ;
    UserVar.RunType="Test-1dAnalyticalIceShelf-";
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 58890.590773997 ;  
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-3)
    
end



function testCalvingThroughMassBalanceFeedback(testCase)
    
    cd Calving ;

    UserVar.RunType="Test-CalvingThroughMassBalanceFeedback-";
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 10378.4835439273;
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-6)
    
end


function testCalvingManuallyDeactivateElements(testCase)
    
    cd Calving ;
    UserVar.RunType="Test-ManuallyDeactivateElements-";
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = 9904.84631032403 ; 
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-6)
    
end


function testFreeSlipBCs(testCase)
    
    cd FreeSlipBCs ;
    UserVar.RunType=[];
    UserVar=Ua(UserVar) ;
    cd ..
    actSolution= UserVar.Test.Norm.actValue ;
    expSolution = UserVar.Test.Norm.expValue ;
    verifyEqual(testCase,actSolution,expSolution,'RelTol',1e-6)
    
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
