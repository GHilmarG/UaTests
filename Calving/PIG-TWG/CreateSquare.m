

function Square=CreateSquare(Origin,Direction,Width,Length)


%%  Creates a square based on origin, direction, width and length 
%
%
%
%
%%

if nargin==0

    Origin=nan;
    Direction=nan;
    Width=nan;
    Length=nan; 

end

if isnan(Origin)
    Origin=[-1587315.52795031         -483507.453416149] ;
end

if isnan(Direction)
    Direction=[ 0.872569595672596         0.488489816380816] ; 
    Normal=[Direction(2) -Direction(1)] ;
end

if isnan(Width)
    Width=50e3 ;
end

if isnan(Length)
    Length=200e3;
end

p1=Origin-0.5*Width*Normal;
p2=Origin+0.5*Width*Normal;
p3=Origin+Length*Direction+0.5*Width*Normal;
p4=Origin+Length*Direction-0.5*Width*Normal;

Square=[p1 ; p2 ; p3 ; p4 ; p1];



% hold on ;  plot(Square(:,1)/1000,Square(:,2)/1000,color="k",LineStyle="--",LineWidth=2)


end

