
lmin = 100 ;
lmax = 2000;
lm=lmax;

Point(1) = {0,0,0,lm};
Point(2) = {10000,0,0,lm};
Point(3) = {10000,10000,0,lm};
Point(4) = {0,10000,0,lm};

Point(5) = {5000,5000,0,lm/10};

// straigt boundaries as lines
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

// curved boundaries as a spline


// define a closed oriented loop
Line Loop(2) ={1,2,3,4};

// define surface
Plane Surface(1) = {2} ;

Mesh.Algorithm = 2 ; 
//
Mesh.CharacteristicLengthMin = lmin ;
Mesh.CharacteristicLengthMax = lmax;
Mesh.CharacteristicLengthExtendFromBoundary = 0 ; 

// define curved boundary as an  attractor
Field[1] = Attractor;
//Field[1].NodesList = {1:4};
Field[1].EdgesList = {1:4};



Field[2] = MathEval;
Field[2].F = Sprintf("(F1/100)^3 + %g", lmin );


Field[10] = Min;
Field[10].FieldsList = {2,100};
Background Field = 10;


// load background scalar field
Include "GmeshScalarField.pos";
Field[100]=PostView;
Field[100].IView=0;







